#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

sed -i.bak '/^$/d' "$1"      # Remove empty lines
sed -i.bak '/^\/\//d' "$1"  # Remove lines that start with //

# -i.bak creates a backup file with .bak extension. You can remove that option if you don't want a backup.
