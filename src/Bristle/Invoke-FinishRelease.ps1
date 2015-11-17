<#
.SYNOPSIS


.DESCRIPTION


.PARAMETER Branch

.EXAMPLE


.EXAMPLE

#>
function Invoke-FinishRelease
{
    [CmdletBinding()]
    Param(
        #[Parameter(Mandatory=$true)]
        [string] $Branch
    )
    Process
    {

        $repoDir = Resolve-Path .
        $repo = New-Object LibGit2Sharp.Repository $repoDir, $null

        [GitVersion.Logger]::SetLoggers([Action[string]]{},[Action[string]]{},[Action[string]]{})

        $gitFilesystem = new-object GitVersion.Helpers.FileSystem

        $gitVersionConfig = [GitVersion.ConfigurationProvider]::Provide($repoDir, $gitFilesystem)
        $ctx = New-Object GitVersion.GitVersionContext $repo, $gitVersionConfig

$ctx
        $versionFinder = New-Object GitVersion.GitVersionFinder
        $Version = $versionFinder.FindVersion($ctx).ToString("j")
$Version
    }
}
