#!/bin/sh

echo "-- merge develop to seldev started"

EB1="- --"
EB2="- ----"
EB3="- ------"
HOME_FOLDER=/c/Users/selva
PROJECT_BASE_FOLDER=$HOME_FOLDER/Documents/code/bqinseldev
SOURCE_BRANCH_NAME=develop
TARGET_BRANCH_NAME=seldev-develop
cd $PROJECT_BASE_FOLDER || exit

#mvn install:install-file -Dfile=$PROJECT_BASE_FOLDER/../sync-bb-sp2-to-gh-spd/all-be-lib/bt-common-util-be-0.0.1-SNAPSHOT.jar \
#    -DgroupId=com.beamteq.common -DartifactId=common-util-be -Dversion=0.0.1-SNAPSHOT -Dpackaging=jar /dev/null 2>&1
#mvn install:install-file -Dfile=$PROJECT_BASE_FOLDER/../sync-bb-sp2-to-gh-spd/all-be-lib/bt-common-service-be-0.0.1-SNAPSHOT.jar \
#    -DgroupId=com.beamteq.common -DartifactId=common-service-be -Dversion=0.0.1-SNAPSHOT -Dpackaging=jar /dev/null 2>&1
#mvn install:install-file -Dfile=$PROJECT_BASE_FOLDER/../sync-bb-sp2-to-gh-spd/all-be-lib/cms-be-0.0.1-SNAPSHOT.jar \
#    -DgroupId=com.beamteq.cms -DartifactId=cms-be -Dversion=0.0.1-SNAPSHOT -Dpackaging=jar /dev/null 2>&1
#mvn install:install-file -Dfile=$PROJECT_BASE_FOLDER/../sync-bb-sp2-to-gh-spd/all-be-lib/ecommerce-be-0.0.1-SNAPSHOT.jar \
#    -DgroupId=com.beamteq.ecom -DartifactId=ecom-be -Dversion=0.0.1-SNAPSHOT -Dpackaging=jar /dev/null 2>&1
#mvn install:install-file -Dfile=$PROJECT_BASE_FOLDER/../sync-bb-sp2-to-gh-spd/all-be-lib/matrimony-be-0.0.1-SNAPSHOT.jar \
#    -DgroupId=com.beamteq.matrim -DartifactId=matrimony-be -Dversion=0.0.1-SNAPSHOT -Dpackaging=jar /dev/null 2>&1
#mvn install:install-file -Dfile=$PROJECT_BASE_FOLDER/../sync-bb-sp2-to-gh-spd/all-be-lib/survey-0.0.1-SNAPSHOT.jar \
#    -DgroupId=com.beamteq.survey -DartifactId=survey-be -Dversion=0.0.1-SNAPSHOT -Dpackaging=jar /dev/null 2>&1

for dir in */; do
    if [ -d "$dir" ] && [ "$dir" != "*-lib*" ] && [ "$dir" != ".idea" ]; then
        GIT_REPO="$dir"
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

        git checkout "${SOURCE_BRANCH_NAME}" > /dev/null 2>&1
        git fetch > /dev/null 2>&1
        git pull > /dev/null 2>&1
        SOURCE_VERSION=$(git rev-parse @)

        git checkout "${TARGET_BRANCH_NAME}" > /dev/null 2>&1
        git fetch > /dev/null 2>&1
        git pull > /dev/null 2>&1
        TARGET_VERSION=$(git rev-parse @)

        UPSTREAM=${1:-'@{u}'}
        LOCAL=$(git rev-parse @)
        GHREMOTE=$(git rev-parse "$UPSTREAM")
        BASE=$(git merge-base @ "$UPSTREAM")

        echo "$EB2""$GIT_REPO""$TARGET_BRANCH_NAME"

        if [[ "$SOURCE_VERSION" == "$TARGET_VERSION" ]]; then
            echo "$EB3""${SOURCE_BRANCH_NAME}"" is already merged to ""${TARGET_BRANCH_NAME}" > /dev/null 2>&1
        else
            git -c core.quotepath=false -c log.showSignature=false merge "${SOURCE_BRANCH_NAME}" --no-edit \
                > /dev/null 2>&1
            echo "$EB3""${SOURCE_BRANCH_NAME}"" into ""${TARGET_BRANCH_NAME}"" - MERGED "
        fi

        LOCAL=$(git rev-parse @)
        BASE=$(git merge-base @ "$UPSTREAM")
        GIT_HUB_REMOTE=$(git rev-parse origin/"${TARGET_BRANCH_NAME}")

        if [ "$GIT_HUB_REMOTE" != "$BASE" ] || [ "$GIT_HUB_REMOTE" != "$LOCAL" ]; then
            git -c core.quotepath=false -c log.showSignature=false push --progress --porcelain origin \
                refs/heads/"${TARGET_BRANCH_NAME}":"${TARGET_BRANCH_NAME}" > /dev/null 2>&1
            echo "$EB3""${TARGET_BRANCH_NAME}"" - PUSHED"
        fi
        echo "$EB3""Finished - ""$GIT_REPO" > /dev/null 2>&1
    fi
    if [[ $GIT_REPO == *"-be/" ]]; then
      # mvn install -Dmaven.test.skip=true > /dev/null 2>&1
      echo "$EB3""${SOURCE_BRANCH_NAME}"" mvn  - INSTALLED " > /dev/null 2>&1
    else
      echo "Not a BE folder - ""$GIT_REPO" > /dev/null 2>&1
    fi
    cd $PROJECT_BASE_FOLDER || exit
done
echo "-- merge to local ended"