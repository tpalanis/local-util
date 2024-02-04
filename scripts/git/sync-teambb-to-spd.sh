#!/bin/sh

echo "sync started"
/c/Users/selva/Documents/ndev/scripts/merge-from-teambb-to-local.sh
/c/Users/selva/Documents/ndev/scripts/push-from-local-to-ghspd.sh
echo "sync ended"