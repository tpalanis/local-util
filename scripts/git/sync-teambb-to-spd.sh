#!/bin/sh

echo "sync started"
./check-for-uncommitted-changes.sh && \
./merge-from-teambb-to-local.sh && \
./push-from-local-to-ghspd.sh && \
./merge-gh-develop-to-etodevelop.sh && \
./merge-gh-develop-to-seldev.sh
echo "sync ended"