

# Reset-Branch

Resets a Git branch to a specific commit.
## Syntax

    Reset-Branch [-Branch] <Branch> [-Commit] <Commit> [-GitUserName] <String> [-GitUserEmail] <String> [<CommonParameters>]


## Description

Resets a Git branch to a specific commit. This is done by checking out the branch with --force option first
and reset to commit with --hard option. This implies, that all changes on top of the provided commit are 
definitely lost. 
This can be dangerous if the branch and commits on top of the provided one are already pushed to some remote repos.





## Parameters

    
    -Branch <Branch>
_The branch to reset.
Use GitLib2Sharp to provide an object of type Branch._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 1 | true |  | false | false |


----

    
    
    -Commit <Commit>
_The commit the branch should be reset to.
Use GitLib2Sharp to provide an object of type Commit._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 2 | true |  | false | false |


----

    
    
    -GitUserName <String>
_The users name that is used to reset the branch._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 3 | true |  | false | false |


----

    
    
    -GitUserEmail <String>
_The users email that is used to reset the branch._

| Position | Required | Default value | Accept pipeline input | Accept wildchard characters |
| -------- | -------- | ------------- | --------------------- | --------------------------- |
| 4 | true |  | false | false |


----

    

## Examples

### -------------------------- EXAMPLE 1 --------------------------
    Reset-Branch -Branch 'object of LibGit2Sharp.Branch' -Commit 'object of LibGit2Sharp.Commit' -GitUserName firstname.lastname -GitUserEmail firstname.lastname@domain.com































