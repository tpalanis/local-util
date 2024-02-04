#!/bin/sh

echo "-- merge to local started"
HOMEFOLDER=/c/Users/selva
PROJBASEFOLDER=$HOMEFOLDER/Documents/code/sync-bb-sp2-to-gh-spd
cd $PROJBASEFOLDER
GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519_bb-bqin-sp-beamteq-com-np"
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
		#echo $EB3$BBREMOTE
		#echo $EB3$BASE


		echo $EB2$GITREPO"("$GITBRANCH")"
		if [ $LOCAL = $BBREMOTE ]; then
			echo $EB3" - Local already has the latest"
		elif [ $LOCAL = $BASE ]; then
			#git -c core.quotepath=false -c log.showSignature=false fetch https://username:password@bitbucket.org/beamteq/$GITREPO.git $GITBRANCH --recurse-submodules=no --progress --prune
			git -c core.quotepath=false -c log.showSignature=false fetch origin --recurse-submodules=no --progress --prune
			echo $EB3"Fetched"
			git -c core.quotepath=false -c log.showSignature=false merge origin/$GITBRANCH --no-stat -v
			echo $EB3"Merged"
		elif [ $BBREMOTE = $BASE ]; then
			echo $EB3"Need to push"
		else
			echo $EB3"Diverged"
		fi
	fi
	cd cd $PROJBASEFOLDER
done
echo "-- merge to local ended"