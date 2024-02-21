#!/bin/sh

echo "-- push team to github started"
EB1="- --"
EB2="- ----"
EB3="- ------"
HOME_FOLDER=/c/Users/selva
PROJECT_BASE_FOLDER=$HOME_FOLDER/Documents/code/sync-bb-sp2-to-gh-spd
SOURCE_BRANCH_NAME=develop
cd $PROJECT_BASE_FOLDER

for dir in */; do
    if ([ -d "$dir" ] && [[ "$dir" != *-lib* ]]); then
        GIT_REPO="$dir"
        echo $EB2$GIT_REPO
        cd $PROJECT_BASE_FOLDER/$GIT_REPO
        if [[ $GIT_REPO == *-lib* ]]; then
            GIT_BRANCH=main
        else
            GIT_BRANCH=develop
        fi

        # start of script - check if there are any uncommitted changes
        git update-index -q --ignore-submodules --refresh
        err=0

        # Disallow unstaged changes in the working tree
        if ! git diff-files --quiet --ignore-submodules --
        then
            echo >&2 "cannot $1: you have unstaged changes."
            git diff-files --name-status -r --ignore-submodules -- >&2
            err=1
        fi

        # Disallow uncommitted changes in the index
        if ! git diff-index --cached --quiet HEAD --ignore-submodules --
        then
            echo >&2 "cannot $1: your index contains uncommitted changes."
            git diff-index --cached --name-status -r --ignore-submodules HEAD -- >&2
            err=1
        fi

        if [ $err = 1 ]
        then
            echo >&2 "Please commit or stash them."
            exit 1
        fi
        # end of script - - check if there are any uncommitted changes

        UPSTREAM=${1:-'@{u}'}
        LOCAL=$(git rev-parse @)
        BBREMOTE=$(git rev-parse "$UPSTREAM")
        BASE=$(git merge-base @ "$UPSTREAM")

        GHREMOTE=$(git rev-parse github-spd/$GIT_BRANCH) || true

        #LOCAL_CHANGE_COUNT=$(git rev-list --count $GIT_BRANCH..github-spd/$GIT_BRANCH)
        if [ "${GHREMOTE}" == "${BBREMOTE}" ]; then
            echo $EB3"GH Remote already has the latest" > /dev/null 2>&1
        else
            git -c core.quotepath=false -c log.showSignature=false push --progress --porcelain github-spd refs/heads/$GIT_BRANCH:$GIT_BRANCH > /dev/null 2>&1
            echo $EB3"Pushed"
        fi
      echo $EB3"GH Remote has the latest - ""$GIT_REPO""${GIT_BRANCH}"
    fi
    cd $PROJECT_BASE_FOLDER
done
echo "-- push team to github ended"