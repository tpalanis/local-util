#!/bin/sh

echo "-- merge to local started"
HOME_FOLDER=/c/Users/selva
PROJECT_BASE_FOLDER=$HOME_FOLDER/Documents/code/sync-bb-sp2-to-gh-spd
# shellcheck disable=SC2164
cd $PROJECT_BASE_FOLDER
GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519_bb-bqin-sp-beamteq-com-np"
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


        echo $EB2$GIT_REPO"("$GIT_BRANCH")"
        if [ $LOCAL = $BBREMOTE ]; then
            echo $EB3" - Local already has the latest"
        elif [ $LOCAL = $BASE ]; then
            git -c core.quotepath=false -c log.showSignature=false fetch origin --recurse-submodules=no --progress --prune
            echo $EB3"Fetched"
            git -c core.quotepath=false -c log.showSignature=false merge origin/$GIT_BRANCH --no-stat -v
            echo $EB3"Merged"
        elif [ $BBREMOTE = $BASE ]; then
            echo $EB3"Need to push"
        else
            echo $EB3"Diverged"
        fi
    fi
    cd $PROJECT_BASE_FOLDER
done
echo "-- merge to local ended"