$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "Test-ReleaseHotfixBranch" {
    Context "When providing release branch" {
        It "Should return true" {
           Test-ReleaseHotfixBranch "release/0.1"| Should Be $true
        }
    }
    Context "When providing hotfix branch" {
        It "Should return true" {
        Test-ReleaseHotfixBranch "hotfix/0.1.1"| Should Be $true
        }
    }
    Context "When providing hotfix branch" {
        It "Should return true" {
            Test-ReleaseHotfixBranch "refs/heads/hotfix/0.1.1"| Should Be $true
        }
    }
    Context "When providing develop branch" {
        It "Should return false" {
            Test-ReleaseHotfixBranch "develop"| Should Be $false
        }
    }
}
