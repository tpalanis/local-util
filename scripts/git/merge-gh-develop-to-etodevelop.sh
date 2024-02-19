#!/bin/sh

echo "-- merge develop to eto-develop started"
HOME_FOLDER=/c/Users/selva
PROJECT_BASE_FOLDER=$HOME_FOLDER/Documents/code/etogrow
SOURCE_BRANCH_NAME=develop
TARGET_BRANCH_NAME=eto-develop
cd $PROJECT_BASE_FOLDER || exit

for dir in */; do
    if [ -d "$dir" ] && [ "$dir" != "*-lib*" ]; then
        GIT_REPO="$dir"
        echo "$GIT_REPO"
        EB2="- ----"
        EB3="- ------"
        cd $PROJECT_BASE_FOLDER/"$GIT_REPO" || exit

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

        # prepare source branch
        git fetch origin > /dev/null 2>&1
        git checkout "${SOURCE_BRANCH_NAME}" > /dev/null 2>&1
        git pull > /dev/null 2>&1

        # prepare target branch
        CURRENT_BRANCH=$(git symbolic-ref --short HEAD)
        if [ "$CURRENT_BRANCH" != "$TARGET_BRANCH_NAME" ]; then
          git checkout "${TARGET_BRANCH_NAME}" > /dev/null 2>&1
        fi
        git pull > /dev/null 2>&1

        UPSTREAM=${1:-'@{u}'}
        LOCAL=$(git rev-parse @)
        #BBREMOTE=$(git rev-parse "$UPSTREAM")
        BASE=$(git merge-base @ "$UPSTREAM")

        git branch --merged | grep "${SOURCE_BRANCH_NAME}" > /dev/null 2>&1
        if [ "$?" -eq "0" ]; then
            echo "is completely merged to both master and development" > /dev/null 2>&1
        else
            git -c core.quotepath=false -c log.showSignature=false merge "${SOURCE_BRANCH_NAME}" --no-edit
        fi

        LOCAL=$(git rev-parse @)
        BASE=$(git merge-base @ "$UPSTREAM")
        GIT_HUB_REMOTE=$(git rev-parse origin/"${TARGET_BRANCH_NAME}")

        if [ "$GIT_HUB_REMOTE" != "$BASE" ] || [ "$GIT_HUB_REMOTE" != "$LOCAL" ]; then
            git -c core.quotepath=false -c log.showSignature=false push --progress --porcelain origin refs/heads/"${TARGET_BRANCH_NAME}":"${TARGET_BRANCH_NAME}"
            echo "$EB3""Pushed"
        fi
        echo "$EB3""GH Remote has the latest - ""$GIT_REPO"
    fi
    cd $PROJECT_BASE_FOLDER || exit
done
echo "-- merge to local ended"