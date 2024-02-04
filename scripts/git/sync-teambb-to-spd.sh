#!/bin/sh

echo "sync started"
/c/Users/selva/Documents/local-util/scripts/git/merge-from-teambb-to-local.sh
/c/Users/selva/Documents/local-util/scripts/git/push-from-local-to-ghspd.sh
echo "sync ended"