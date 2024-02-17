#!/bin/sh

echo "-- merge to local started"
HOME_FOLDER=/c/Users/selva
PROJECT_BASE_FOLDER=$HOME_FOLDER/Documents/code/etogrow
cd $PROJECT_BASE_FOLDER
GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519_gh-spd-tpselvan-gmail-com-np"
for dir in */; do
    if ([ -d "$dir" ] && [[ "$dir" != *-lib* ]]); then
        # if [ "$dir" == "common-service-be/" ]; then
          # continue
        # fi
        GIT_REPO="$dir"
        echo $EB2$GIT_REPO
        EB1="- --"
        EB2="- ----"
        EB3="- ------"
        cd $PROJECT_BASE_FOLDER/$GIT_REPO
        if [[ $GIT_REPO == *-lib* ]]; then
            GIT_BRANCH=eto-develop
        else
            GIT_BRANCH=eto-develop
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
        git -c core.quotepath=false -c log.showSignature=false merge develop --no-edit
        echo $EB3"Merged develop into eto-develop"

        LOCAL=$(git rev-parse @)
        BASE=$(git merge-base @ "$UPSTREAM")
        GHREMOTE=$(git rev-parse origin/eto-develop)

        echo $EB3$BASE
        echo $EB3$GHREMOTE
        echo $EB3$LOCAL

        if ([ $GHREMOTE != $BASE ] || [ $GHREMOTE != $LOCAL ]); then
            echo $EB3"Need to push"
            git -c core.quotepath=false -c log.showSignature=false push --progress --porcelain origin refs/heads/$GIT_BRANCH:$GIT_BRANCH
            echo $EB3"Pushed"
        else
            echo $EB3"GH Remote already has the latest"
        fi
    fi
    cd $PROJECT_BASE_FOLDER
done
echo "-- merge to local ended"