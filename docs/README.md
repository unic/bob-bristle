<div class="chapterlogo"><img src="./Bristle.jpg" /></div>

# Bristle

Bristle finishes releases and hotfixes by merging them according to GitFlow and pushes the result back to the origin.

Releases and Hotfixes are merged to the master and develop branch. Furthermore the master-branch merge-commit 
is tagged with the version information. After a successfull merge, the intermediate Release or Hotfix branch is 
removed in order to have a clean repository afterwards.

Bristle is thought to be used on Teamcity, but is designed to do its proper work as well on the client side on a local 
Git-repository.

## Preconditions

In order to let Bristle do its cleanup stuff after all other members of the Bob-crew, you should be familiar with Git repositories, the GitFlow workflow and SemVer specification.

Bristle checks a lot on consistency and is not willing to work if only one little thing could be wrong. All these things need to be fullfilled:

* Work is only possible in the root of a Git repository. There is no possibility to provide one, you must sit on it.
* The current branch is a release or hotfix branch and the Head is not detached.
* A develop branch must exist (otherwise the repo is not following GitFlow).
* On no involved branches are local modifications and all are up to date.
* All involved branches have a remote branch on the origin.
* The version does not exist as a tag, yet.
* The version follows SemVer.

In all other cases, Bristle is snoobish and reverts all actions that might have possibly happen. Nothing is pushed to the 
origin and it's your own duty to reach the point Bristle is satisfied enough to start working again.