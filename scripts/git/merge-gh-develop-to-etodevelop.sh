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
        echo "$EB2""$GIT_REPO"
        EB2="- ----"
        EB3="- ------"
        cd $PROJECT_BASE_FOLDER/"$GIT_REPO" || exit

        git -c core.quotepath=false -c log.showSignature=false fetch origin --recurse-submodules=no --progress --prune
        CURRENT_BRANCH=$(git symbolic-ref --short HEAD)
        if [ "$CURRENT_BRANCH" != "$TARGET_BRANCH_NAME" ]; then
          git checkout "${TARGET_BRANCH_NAME}"
        fi

        UPSTREAM=${1:-'@{u}'}
        LOCAL=$(git rev-parse @)
        #BBREMOTE=$(git rev-parse "$UPSTREAM")
        BASE=$(git merge-base @ "$UPSTREAM")

        git -c core.quotepath=false -c log.showSignature=false fetch origin "${SOURCE_BRANCH_NAME}":"${SOURCE_BRANCH_NAME}" --recurse-submodules=no --progress --prune
        git -c core.quotepath=false -c log.showSignature=false merge "${SOURCE_BRANCH_NAME}" --no-edit

        LOCAL=$(git rev-parse @)
        BASE=$(git merge-base @ "$UPSTREAM")
        GIT_HUB_REMOTE=$(git rev-parse origin/"${TARGET_BRANCH_NAME}")

        if [ "$GIT_HUB_REMOTE" != "$BASE" ] || [ "$GIT_HUB_REMOTE" != "$LOCAL" ]; then
            git -c core.quotepath=false -c log.showSignature=false push --progress --porcelain origin refs/heads/"${TARGET_BRANCH_NAME}":"${TARGET_BRANCH_NAME}"
            echo "$EB3""Pushed"
        else
            echo "$EB3""GH Remote already has the latest"
        fi
    fi
    cd $PROJECT_BASE_FOLDER || exit
done
echo "-- merge to local ended"