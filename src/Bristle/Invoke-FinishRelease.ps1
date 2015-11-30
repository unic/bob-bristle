<#
.SYNOPSIS
Finishes a release or hotfix by merging as described in GitFlow.

.DESCRIPTION
Merges the release or hotfix branch to the master and develop branch and tags the master branch with 
the version information through branch naming based on conventions supported by GitVersion or (optionally) 
through a parameter.

Preconditions are:
- The current branch is a release or hotfix branch and the Head is not detached.
- There exists a develop branch (otherwise the repo is not following GitFlow).
- On no involved branches are local modifications and all are up to date.
- All involved branches have a remote branch on an origin repository.
- The Version does not exists yet as tag.
- the Version follows SemVer.
In all other cases, all possibly happend actions are reverted and nothing is pushed to the remote
origin repository.

.PARAMETER $GitUserName
The users name that is used for the Git actions.

.PARAMETER $GitUserEmail
The users email that is used for the Git actions.

.PARAMETER $GitPassword
The users password used for the Git actions. 

.PARAMETER $Version
Optionally a version in a SemVer format.
If not provided, the version is extracted from the current branch name.

.EXAMPLE
Invoke-FinishRelease -GitUserName firstname.lastname -GitUserEmail firstname.lastname@domain.com -GitPassword userpassword

.EXAMPLE
Invoke-FinishRelease -GitUserName firstname.lastname -GitUserEmail firstname.lastname@domain.com -GitPassword userpassword -Version 2.7.5
#>
function Invoke-FinishRelease
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string] $GitUserName,
        [Parameter(Mandatory=$true)]
        [string] $GitUserEmail,
        [Parameter(Mandatory=$true)]
        [string] $GitPassword,
        [string] $Version
    )
    Process
    {
        # Options used during git operations
        $checkoutOptions = New-Object LibGit2Sharp.CheckoutOptions
        $mergeOptions = New-Object LibGit2Sharp.MergeOptions
        $mergeOptions.FastForwardStrategy = [LibGit2Sharp.FastForwardStrategy]::NoFastFoward
        $pushOptions = New-Object LibGit2Sharp.PushOptions
        $pushOptions.CredentialsProvider = {
            param($url, $usernameFromUrl, $types)
            # Inspect params if you want
            $remoteOriginCredentials = New-Object LibGit2Sharp.UsernamePasswordCredentials
            $remoteOriginCredentials.Username = $GitUserName
            $remoteOriginCredentials.Password = $GitPassword
            return $remoteOriginCredentials 
        }
        $signature = New-Object LibGit2Sharp.Signature($GitUserName, $GitUserEmail, [DateTimeOffset]::Now)

        # Get current repository
        $repoDir = Resolve-Path .
        $repo = New-Object LibGit2Sharp.Repository $repoDir, $null

        # Get and analyze current branch
        $currentBranch = $repo.Branches | where { $_.IsCurrentRepositoryHead -eq $true} 
        
        if ($currentBranch.GetType().Name -ne "Branch") {
            Throw "Current Head is not pointing to a specific branch"
        }
        
        if (($repo.Branches | where { $_.Name -eq "develop" }) -eq $null) {
            Throw "There is no develop branch. This repository seems not to follow GitFlow."
        }
        
        if (-not (Test-ReleaseHotfixBranch -Branch $currentBranch.Name)) {
            Throw "Not on a release or hotfix branch. Current branch can not be finished. (Current Branch: $($currentBranch.Name))"
        }
        
        Write-Output "[Status] Current branch is: $($currentBranch.Name)"

        if (-not (Test-BranchUpToDate -Branch $currentBranch)) {
            Throw "Branch is not actual compared to origin. Update your repository first. Nothing was done. (Current Branch: $($currentBranch.Name))"
        }
        
        # Get and analyze provided versions
        # TODO: refactor to separate function and add some tests on the version parsing.
        $releaseVersion = $Version
        if ($Version -eq $null -or $Version -eq "") {
            $currentBranchVersion = $currentBranch.Name.Substring($currentBranch.Name.LastIndexOf("/") + 1)
    
            if ($currentBranchVersion -NotMatch "^\d+\.\d+(\.\d+)??$") {
                Throw "Current Version extracted from branch is not a SemVer version string. (Current Branch: $($currentBranch.Name), Version: $currentBranchVersion)"
            }
            
            $releaseVersion = $currentBranchVersion
        }
        else {
            if ($releaseVersion -NotMatch "^\d+\.\d+(\.\d+)??$") {
                Throw "Version provided is not a SemVer version string. (Version: $releaseVersion)"
            } 
        }
        

        Write-Output "[Status] Version is: $releaseVersion"
                
        # Get and analyze current tags
        $versionTag = $repo.Tags | where { $_.Name -eq $releaseVersion }   
        
        if ($versionTag -ne $null) {
            Throw "Current Version exists already as tag. (Version: $releaseVersion)"
        }   
          
        # Perform merge actions
        Write-Output "   [Action] Switch to master branch"
        $masterBranch = $repo.Checkout("master", $checkoutOptions, $null)
        
        if (-not (Test-BranchUpToDate -Branch $masterBranch)) {
            Throw "Branch is not latest commit compared to origin. Update your repository first. Nothing was done. (Current Branch: $($masterBranch.Name))"
        }

        Write-Output "   [Action] Merge branch '$currentBranch' to master"
        $latestMasterCommit = $masterBranch.Tip
        $masterMergeResult = $repo.Merge($currentBranch, $signature, $mergeOptions)
        if ($masterMergeResult.Status -eq [LibGit2Sharp.MergeStatus]::Conflicts) {
            Write-Output "[Status] Merge conflict while merging to master"
            Reset-Branch -Branch $masterBranch -Commit $latestMasterCommit -GitUserName $GitUserName -GitUserEmail $GitUserEmail
            
            throw "Error during master merge: Conflict occured. Merge reset."
        }
        
        $masterMergeCommit = $masterMergeResult.Commit
        
        if ($masterMergeResult.Status -eq [LibGit2Sharp.MergeStatus]::UpToDate) {
            $masterMergeCommit = $latestMasterCommit
        }
        
        Write-Output "   [Action] Tag master branch with version tag '$releaseVersion'"
        $releaseTag = $repo.Tags.Add($releaseVersion, $masterMergeCommit)
        
        Write-Output "   [Action] Switch to develop branch"
        $developBranch = $repo.Checkout("develop", $checkoutOptions, $null)
        if (-not (Test-BranchUpToDate -Branch $developBranch)) {
            Reset-Branch -Branch $masterBranch -Commit $latestMasterCommit -GitUserName $GitUserName -GitUserEmail $GitUserEmail
            Write-Output "   [Reset Action] Remove Tag '$($releaseTag.Name)'"
            $repo.Tags.Remove($releaseTag)
           
            Throw "Branch is not actual compared to origin. Update your repository first. Merges reset. (Current Branch: $($developBranch.Name))"
        }

        Write-Output "   [Action] Merge branch '$currentBranch' to develop"
        $latestDevelopCommit = $developBranch.Tip
        $developMergeResult = $repo.Merge($currentBranch, $signature, $mergeOptions)
        
        if ($developMergeResult.Status -eq [LibGit2Sharp.MergeStatus]::Conflicts) {
            Write-Output "[Status] Conflict during while merging to develop"
            Reset-Branch -Branch $developBranch -Commit $latestDevelopCommit -GitUserName $GitUserName -GitUserEmail $GitUserEmail
            Reset-Branch -Branch $masterBranch -Commit $latestMasterCommit -GitUserName $GitUserName -GitUserEmail $GitUserEmail
            Write-Output "   [Reset Action] Remove Tag '$($releaseTag.Name)'"
            $repo.Tags.Remove($releaseTag)
            
            throw "Error during develop merge: Conflict occured. Merges reset."
        }
        
        # Push to origin
        $remoteOrigin = $repo.Network.Remotes["origin"]
        
        $pushRefSpecs = New-Object System.Collections.Generic.List[string]
        $pushRefSpecs.Add($masterBranch.CanonicalName)
        $pushRefSpecs.Add($developBranch.CanonicalName)
        $pushRefSpecs.Add($releaseTag.CanonicalName)
        
        $pushRefSpecs | % { 
            Write-Output "   [Action] Push ref '$_' to origin"
            $repo.Network.Push($remoteOrigin, $_, $pushOptions, $signature) 
        }
        
        Write-Output "   [Action] Remove branch '$($currentBranch.Name)' from repository"
        $repo.Branches.Remove($currentBranch)
        
        $remoteCurrentBranch = $repo.Branches | where { $_.Name -eq "origin/$($currentBranch.Name)" } 
        
        Write-Output "   [Action] Remove remote branch '$($remoteCurrentBranch.Name)' from repository"
        $repo.Network.Push($remoteOrigin, ":$($currentBranch.CanonicalName)", $pushOptions, $signature)
    }
}
