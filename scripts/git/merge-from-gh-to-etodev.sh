#!/bin/sh

echo "-- merge to local started"
HOME_FOLDER=/c/Users/selva
PROJECT_BASE_FOLDER=$HOME_FOLDER/Documents/code/etogrow
cd $PROJECT_BASE_FOLDER
GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519_gh-spd-tpselvan-gmail-com-np"
for dir in */; do
    if [ -d "$dir" ]; then
        GIT_REPO="$dir"
        EB1="- --"
        EB2="- ----"
        EB3="- ------"
        cd $PROJECT_BASE_FOLDER/$GIT_REPO
        if [[ $GIT_REPO == *-lib* ]]; then
            GIT_BRANCH=main
        else
            GIT_BRANCH=develop
        fi
        UPSTREAM=${1:-'@{u}'}

        LOCAL=$(git rev-parse @)
        BBREMOTE=$(git rev-parse "$UPSTREAM")
        BASE=$(git merge-base @ "$UPSTREAM")

        #echo $EB3$LOCAL
        #echo $EB3$BBREMOTE
        #echo $EB3$BASE

            git -c core.quotepath=false -c log.showSignature=false fetch origin --recurse-submodules=no --progress --prune
            echo $EB3"Fetched"
            git -c core.quotepath=false -c log.showSignature=false fetch origin develop:develop --recurse-submodules=no --progress --prune
            echo $EB3"Merged develop into develop"
            echo $EB3"Merged eto-develop into eto-develop"
            git -c core.quotepath=false -c log.showSignature=false merge develop
            echo $EB3"Merged develop into eto-develop"

        echo $EB2$GIT_REPO"("$GIT_BRANCH")"
        if [ $LOCAL = $BBREMOTE ]; then
            echo $EB3" - Local already has the latest"
        elif [ $LOCAL = $BASE ]; then
            git -c core.quotepath=false -c log.showSignature=false fetch origin --recurse-submodules=no --progress --prune
            echo $EB3"Fetched"
            git -c core.quotepath=false -c log.showSignature=false fetch origin develop:develop --recurse-submodules=no --progress --prune
            echo $EB3"Merged develop into develop"
            echo $EB3"Merged eto-develop into eto-develop"
            git -c core.quotepath=false -c log.showSignature=false merge develop
            echo $EB3"Merged develop into eto-develop"
        elif [ $BBREMOTE = $BASE ]; then
            echo $EB3"Need to push"
        else
            echo $EB3"Diverged"
        fi
    fi
    cd $PROJECT_BASE_FOLDER
    break
done
echo "-- merge to local ended"