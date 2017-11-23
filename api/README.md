# Bristle - API

##  Invoke-FinishRelease
Finishes a release or hotfix by merging as described in GitFlow.    
    
    Invoke-FinishRelease [-GitUserName] <String> [-GitUserEmail] <String> [-GitPassword] <String> [[-Version] <String>] [<CommonParameters>]


 [Read more](Invoke-FinishRelease.md)
##  Reset-Branch
Resets a Git branch to a specific commit.    
    
    Reset-Branch [-Branch] <Branch> [-Commit] <Commit> [-GitUserName] <String> [-GitUserEmail] <String> [<CommonParameters>]


 [Read more](Reset-Branch.md)
##  ResolvePath
    ResolvePath [[-PackageId] <Object>] [[-RelativePath] <Object>]


 [Read more](ResolvePath.md)
##  Test-BranchUpToDate
Tests wether a Git branch is up to date and has no local modifications.    
    
    Test-BranchUpToDate [-Branch] <Branch> [<CommonParameters>]


 [Read more](Test-BranchUpToDate.md)
##  Test-ReleaseHotfixBranch
Returns true if the provided branch is a release or hotfix branch.    
    
    Test-ReleaseHotfixBranch [-Branch] <String> [<CommonParameters>]


 [Read more](Test-ReleaseHotfixBranch.md)

