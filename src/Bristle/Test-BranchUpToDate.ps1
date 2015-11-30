<#
.SYNOPSIS
Tests wether a Git branch is up to date and has no local modifications.

.DESCRIPTION
Test-BranchUpToDate checks if the branch is in sync with it's remote branch and has no local modifications.
This happens by checking the tracking details aheadby, behindby and its status not allowed to have
added, missing, removed, staged or renamed files.

.PARAMETER Branch
The Git branch to analyze. 
Use LibGit2Sharp to provide an object of type Branch.

.EXAMPLE
Test-BranchUpToDate -Branch 'object of LibGit2Sharp.Branch'
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
            Write-Host "[Test-Branch] Branch is not latest commit compared to origin. Update your repository first. (Current Branch: $($Branch.Name))"
            $returnValue = $false
        }
        
        $statusEntry = $Branch.Repository.RetrieveStatus($null)
        
        if ($statusEntry.Added.Count -ne 0 -or
                    $statusEntry.Missing.Count -ne 0 -or
                    $statusEntry.RenamedInIndex.Count -ne 0 -or
                    $statusEntry.Ignored.Count -ne 0 -or
                    $statusEntry.Modified.Count -ne 0 -or
                    $statusEntry.RenamedInWorkDir.Count -ne 0 -or
                    $statusEntry.Removed.Count -ne 0 -or
                    $statusEntry.Staged.Count -ne 0) {
            Write-Host "[Test-Branch] Branch contains local modifications. Update your branch first. (Current Branch: $($Branch.Name))"
            $returnValue = $false
        }
        
        $returnValue
    }
}
