#!/bin/bash
FILENAME=$1
PASS=$2
DATE=`date '+%Y.%m.%d_%H:%M:%S'` # backup date

if [[ -z "$FILENAME" && -z "$PASS" ]]; then
    echo "Usage: sh encrypt.sh <name of file> <password>"
    exit;
fi

echo "Encrypting...."

openssl des3 -salt -in "$FILENAME" -out $DATE"_"$FILENAME".des3" -pass pass:"$PASS"

EXT="${FILENAME##*.}"
if [ $EXT == "sqlite3" ]
then
    # dumping database - Sqlite
    sqlite3 $FILENAME .dump > dump.save
    openssl des3 -salt -in dump.save -out $DATE"_"$FILENAME"_dump.des3" -pass pass:"$PASS"
    sqlite3 $FILENAME .sch > sch.save;
    openssl des3 -salt -in sch.save -out $DATE"_"$FILENAME"_sch.des3" -pass pass:"$PASS"
    rm *.save
fi

if [ $EXT == "postgresql"]
    pg_dump $FILENAME > dump.save
    openssl des3 -salt -in dump.save -out $DATE"_"$FILENAME"_dump.des3" -pass pass:"$PASS"
fi

zip -r $DATE"_"$FILENAME.zip *.des3
echo "ZIP DONE !"
rm *.des3
echo "End encrypting !"