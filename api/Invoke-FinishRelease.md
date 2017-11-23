

# Invoke-FinishRelease

Finishes a release or hotfix by merging as described in GitFlow.
## Syntax

    Invoke-FinishRelease [-GitUserName] <String> [-GitUserEmail] <String> [-GitPassword] <String> [[-Version] <String>] [<CommonParameters>]


## Description

Merges the release or hotfix branch to the master and develop branch and tags the master branch with
the version information based on the branch naming convention <major>.<minor>.<patch> or (optionally)
through a parameter with the same SemVer convention.

Preconditions are:
* Work is only possible in the root of a Git repository. There is no possibility to provide one, you must sit on it.
* The current branch is a release or hotfix branch and the Head is not detached.
* A develop branch must exist (otherwise the repo is not following GitFlow).
* On no involved branches are local modifications and all are up to date.
* All involved branches have a remote branch on the origin.
* The version does not exist as a tag, yet.
* The version follows SemVer.





## Parameters

    
    -GitUserName <String>

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 1 | true |  | false | false |


----

    
    
    -GitUserEmail <String>

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 2 | true |  | false | false |


----

    
    
    -GitPassword <String>

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 3 | true |  | false | false |


----

    
    
    -Version <String>

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 4 | false |  | false | false |


----

    

## Examples

### -------------------------- EXAMPLE 1 --------------------------
    Invoke-FinishRelease -GitUserName firstname.lastname -GitUserEmail firstname.lastname@domain.com -GitPassword userpassword






























### -------------------------- EXAMPLE 2 --------------------------
    Invoke-FinishRelease -GitUserName firstname.lastname -GitUserEmail firstname.lastname@domain.com -GitPassword userpassword -Version 2.7.5































