<#
.SYNOPSIS


.DESCRIPTION


.PARAMETER Branch

.EXAMPLE


.EXAMPLE

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
