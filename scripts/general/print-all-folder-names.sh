#!/bin/sh

echo "printing all folder names"
for dir in */; do
    if [ -d "$dir" ]; then
        echo "$dir"
    fi
done