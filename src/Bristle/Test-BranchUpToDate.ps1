<#
.SYNOPSIS
Tests weather a git branch is up to date and has no local modifications.

.DESCRIPTION
Test-BranchUpToDate checks if the branch is in sync with it's remote branch and has no local modifications.
This happens by checking the tracking details aheadby, behindby and its status not allowed to be dirty.

.PARAMETER Branch
The git branch to analyze. 
Use LibGit2Sharp to provide an object of type Branch.

.EXAMPLE
Test-BranchUpToDate -Branch <object of LibGit2Sharp.Branch>
#>
function Test-BranchUpToDate
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [LibGit2Sharp.Branch] $Branch
    )
    Process
    {
        $returnValue = $true
        
        if ($Branch.TrackingDetails.AheadBy -ne 0 -or $Branch.TrackingDetails.BehindBy -ne 0) {
            Write-Host "[Test-Branch] Branch is not actual compared to origin. Update your repository first. (Current Branch: $($Branch.Name))"
            $returnValue = $false
        }
        
        if ($Branch.Repository.RetrieveStatus($null).IsDirty) {
            Write-Host "[Test-Branch] Branch contains local modifications. Update your branch first. (Current Branch: $($Branch.Name))"
            $returnValue = $false
        }
        
        $returnValue
    }
}
