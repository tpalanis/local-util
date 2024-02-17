#!/bin/sh

echo "-- merge to local started"
HOME_FOLDER=/c/Users/selva
PROJECT_BASE_FOLDER=$HOME_FOLDER/Documents/code/etogrow
cd $PROJECT_BASE_FOLDER || exit

for dir in */; do
    if [ -d "$dir" ] && [ "$dir" != "*-lib*" ]; then
        GIT_REPO="$dir"
        echo "$EB2""$GIT_REPO"
        EB2="- ----"
        EB3="- ------"
        cd $PROJECT_BASE_FOLDER/"$GIT_REPO" || exit
        if [ "$GIT_REPO" == "*-lib*" ]; then
            GIT_BRANCH=eto-develop
        else
            GIT_BRANCH=eto-develop
        fi
        UPSTREAM=${1:-'@{u}'}

        LOCAL=$(git rev-parse @)
        #BBREMOTE=$(git rev-parse "$UPSTREAM")
        BASE=$(git merge-base @ "$UPSTREAM")

        git -c core.quotepath=false -c log.showSignature=false fetch origin --recurse-submodules=no --progress --prune
        echo "$EB3""Fetched"
        git -c core.quotepath=false -c log.showSignature=false fetch origin develop:develop --recurse-submodules=no --progress --prune
        echo "$EB3""Merged develop into develop"
        echo "$EB3""Merged eto-develop into eto-develop"
        git -c core.quotepath=false -c log.showSignature=false merge develop --no-edit
        echo "$EB3""Merged develop into eto-develop"

        LOCAL=$(git rev-parse @)
        BASE=$(git merge-base @ "$UPSTREAM")
        GIT_HUB_REMOTE=$(git rev-parse origin/eto-develop)

        echo "$EB3""$BASE"
        echo "$EB3""$GIT_HUB_REMOTE"
        echo "$EB3""$LOCAL"

        if [ "$GIT_HUB_REMOTE" != "$BASE" ] || [ "$GIT_HUB_REMOTE" != "$LOCAL" ]; then
            echo "$EB3""Need to push"
            git -c core.quotepath=false -c log.showSignature=false push --progress --porcelain origin refs/heads/$GIT_BRANCH:$GIT_BRANCH
            echo "$EB3""Pushed"
        else
            echo "$EB3""GH Remote already has the latest"
        fi
    fi
    cd $PROJECT_BASE_FOLDER || exit
done
echo "-- merge to local ended"