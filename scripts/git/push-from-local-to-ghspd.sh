#!/bin/sh

echo "-- push started"
HOMEFOLDER=/c/Users/selva
PROJBASEFOLDER=$HOMEFOLDER/Documents/code/sync-bb-sp2-to-gh-spd
cd $PROJBASEFOLDER
GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519_gh-spd-tpselvan-gmail-com-np"
for dir in */; do
    if [ -d "$dir" ]; then
		GITREPO="$dir"
		EB1="- --"
		EB2="- ----"
		EB3="- ------"
		cd $PROJBASEFOLDER/$GITREPO
		if [[ $GITREPO == *-lib* ]]; then
			GITBRANCH=main
		else
			GITBRANCH=develop
		fi
		UPSTREAM=${1:-'@{u}'}
			
		LOCAL=$(git rev-parse @)
		BBREMOTE=$(git rev-parse "$UPSTREAM")
		BASE=$(git merge-base @ "$UPSTREAM")
		
		#echo $EB3$LOCAL
		#echo $EB3$BASE
		
		GHREMOTE=$(git rev-parse github-spd/$GITBRANCH)
		#echo $EB3$GHREMOTE
		echo $EB2$GITREPO"("$GITBRANCH")"
		if [ $GHREMOTE != $BASE ]; then
			echo $EB3"Need to push"
			if [ $GITREPO == "survey-be-lib" ]; then
				#git lfs push --all github-spd $GITBRANCH
				echo $EB3"Ignored"
			else
				git -c core.quotepath=false -c log.showSignature=false push --progress --porcelain github-spd refs/heads/$GITBRANCH:$GITBRANCH
				echo $EB3"Pushed"
			fi
		else
			echo $EB3"GH Remote already has the latest"
		fi
	fi
	cd $PROJBASEFOLDER
done
echo "-- push ended"