<#
.SYNOPSIS


.DESCRIPTION


.PARAMETER Branch

.EXAMPLE


.EXAMPLE

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
