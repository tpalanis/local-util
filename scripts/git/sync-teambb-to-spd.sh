#!/bin/sh

echo "sync started"
./merge-from-teambb-to-local.sh
./push-from-local-to-ghspd.sh
echo "sync ended"