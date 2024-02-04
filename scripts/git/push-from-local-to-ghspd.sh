#!/bin/sh

echo "-- push started"
HOME_FOLDER=/c/Users/selva
PROJECT_BASE_FOLDER=$HOME_FOLDER/Documents/code/sync-bb-sp2-to-gh-spd
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
        #echo $EB3$BASE

        GHREMOTE=$(git rev-parse github-spd/$GIT_BRANCH)
        #echo $EB3$GHREMOTE
        echo $EB2$GIT_REPO"("$GIT_BRANCH")"
        if [ $GHREMOTE != $BASE ]; then
            echo $EB3"Need to push"
            if [ $GIT_REPO == "survey-be-lib" ]; then
                #git lfs push --all github-spd $GIT_BRANCH
                echo $EB3"Ignored"
            else
                git -c core.quotepath=false -c log.showSignature=false push --progress --porcelain github-spd refs/heads/$GIT_BRANCH:$GIT_BRANCH
                echo $EB3"Pushed"
            fi
        else
            echo $EB3"GH Remote already has the latest"
        fi
    fi
    cd $PROJECT_BASE_FOLDER
done
echo "-- push ended"