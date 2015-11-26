<#
.SYNOPSIS
Resets a git branch to a specific commit.

.DESCRIPTION
Resets a git branch to a specific commit. This is done by first checkout the branch with --force option
and reset to commit with --hard option. This implies, that all changes on top of the provided commit are 
definitely lost. 
This can be dangerous if the branch and commits on top of the provided one are already pushed to some remote repos.

.PARAMETER Branch
The branch to reset.
Use GitLib2Sharp for providing an object of type Branch.

.PARAMETER Commit
The Commit the branch should be reseted to.
Use GitLib2Sharp for providing an object of type Commit.

.PARAMETER GitUserName
The username that is used for the resetting action.

.PARAMETER GitUserEmail
The user email that is used for the resetting action.

.EXAMPLE
Reset-Branch -Branch 'object of LibGit2Sharp.Branch' -Commit 'object of LibGit2Sharp.Commit' -GitUserName firstname.lastname -GitUserEmail firstname.lastname@domain.com
#>
function Reset-Branch
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [LibGit2Sharp.Branch] $Branch,
        [Parameter(Mandatory=$true)]
        [LibGit2Sharp.Commit] $Commit,
        [Parameter(Mandatory=$true)]
        [string] $GitUserName,
        [Parameter(Mandatory=$true)]
        [string] $GitUserEmail
    )
    Process
    {
        # Options used during git operations
        $checkoutOptions = New-Object LibGit2Sharp.CheckoutOptions
        $checkoutOptions.CheckoutModifiers = [LibGit2Sharp.CheckoutModifiers]::Force
        $signature = New-Object LibGit2Sharp.Signature($GitUserName, $GitUserEmail, [DateTimeOffset]::Now)

        Write-Output "   [Reset Action] Switch to branch '$($Branch.Name)'"
        $repo = $Branch.Repository
        $newBranch = $repo.Checkout($Branch.Name, $checkoutOptions, $null)

        Write-Output "   [Reset Action] reset branch '$($newBranch.Name)' to commit '$($Commit.Id)'"
        $repo.Reset([LibGit2Sharp.ResetMode]::Hard, $Commit, $signature, "")
    }
}
