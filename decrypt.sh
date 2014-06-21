#!/bin/bash
# decrypt.sh - a script to decrypt files using openssl

FNAME=$1

if [[ -z "$FNAME" ]]; then
    echo "decrypt.sh <name of file>"
    echo "  - decrypt.sh is a script to decrypt des3 encrypted files"
    exit;
fi
openssl des3 -d -salt -in "$FNAME" -out "${FNAME%.[^.]*}"