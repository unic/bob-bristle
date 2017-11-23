

# Test-BranchUpToDate

Tests wether a Git branch is up to date and has no local modifications.
## Syntax

    Test-BranchUpToDate [-Branch] <Branch> [<CommonParameters>]


## Description

Test-BranchUpToDate checks if the branch is in sync with it's remote branch and has no local modifications.
This happens by checking the tracking details aheadby, behindby and its status not allowed to have
added, missing, removed, staged or renamed files.





## Parameters

    
    -Branch <Branch>
_The Git branch to analyze. 
Use LibGit2Sharp to provide an object of type Branch._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 1 | true |  | false | false |


----

    

## Examples

### -------------------------- EXAMPLE 1 --------------------------
    Test-BranchUpToDate -Branch 'object of LibGit2Sharp.Branch'































