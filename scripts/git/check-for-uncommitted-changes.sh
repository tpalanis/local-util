#!/bin/sh

echo "-- check for uncommitted changes started"

EB1="- --"
EB2="- ----"
EB3="- ------"
err=0

# List of folders to iterate over
folders=(
"/c/Users/selva/Documents/code/sync-bb-sp2-to-gh-spd"
 "/c/Users/selva/Documents/code/etogrow"
 "/c/Users/selva/Documents/code/bqindev"
 "/c/Users/selva/Documents/code/bqincustom")

# Loop through each folder in the list
for folder in "${folders[@]}"; do
    echo "Processing $folder..."

    # Check if the uncommitted change exists
    PROJECT_BASE_FOLDER=$folder
    cd $PROJECT_BASE_FOLDER || exit

    for dir in */; do
        if [ -d "$dir" ]; then
            GIT_REPO="$dir"
            cd $PROJECT_BASE_FOLDER/$GIT_REPO

            if [[ $folder == "/c/Users/selva/Documents/code/etogrow" ]]; then
                GIT_BRANCH=eto-develop
            elif [[ $folder == "/c/Users/selva/Documents/code/bqindev" ]]; then
                GIT_BRANCH=seldev-develop
            elif [[ $folder == "/c/Users/selva/Documents/code/bqincustom" ]]; then
                GIT_BRANCH=custom-develop
            else
              if [[ $GIT_REPO == *-lib* ]]; then
                  GIT_BRANCH=main
              else
                  GIT_BRANCH=develop
              fi
            fi

            CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
            if [[ "$GIT_BRANCH" == "$CURRENT_BRANCH" ]]; then
                echo "Current branch is $CURRENT_BRANCH" > /dev/null 2>&1
            else
                echo "$EB2""$GIT_REPO""$GIT_BRANCH"" - Current branch $CURRENT_BRANCH is not $GIT_BRANCH"
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
                echo >&2 "$EB2""$GIT_REPO""$GIT_BRANCH"" has uncommitted changes."
            fi
            # end of script - - check if there are any uncommitted changes

        fi
        cd $PROJECT_BASE_FOLDER
    done
done

if [ $err = 1 ]
then
    exit 1
fi

echo "-- check for uncommitted changes completed"