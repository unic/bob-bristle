<#
.SYNOPSIS
Returns true if the provided branch is a release or hotfix branch.

.DESCRIPTION
Returns true if the provided branch is a release or hotfix branch.

.PARAMETER Branch
The branch name to test.

.EXAMPLE
Test-ReleaseHotfixBranch -Branch refs/heads/release/0.1

.EXAMPLE
Test-ReleaseHotfixBranch -Branch develop

#>
function Test-ReleaseHotfixBranch
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string] $Branch
    )
    Process
    {
        $Branch = $Branch -replace "refs/heads/"

        $Branch -like "release/*" -or
        $Branch -like "hotfix/*"
    }
}
