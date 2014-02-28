#!/bin/sh
#SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
## include params
#if [ -f $SCRIPT_DIR"/params.sh" ]
#then
#    . $SCRIPT_DIR/params.sh
#else
#    . $SCRIPT_DIR/params.sh.dist
#fi
#
## include addintional params
#if [ -f $SCRIPT_DIR"/params-protected.sh" ]
#then
#    . $SCRIPT_DIR/params-protected.sh
#else
#    . $SCRIPT_DIR/params-protected.sh.dist
#fi

# ================= Code =================
# Import products
if [ "$IMPORT_RUN" ] && [ "$IMPORT_RUN" != 0 ] && [ -d "$IMPORT_DIR" ]
then
    FILE_CSV=""
    for FILE_CSV in $IMPORT_DIR/*.csv; do
        echo "Importing products file $FILE_CSV..."
        php -f "$SCRIPT_DIR/import.php" "\"$PROJECT_DIR\"" "\"$FILE_CSV\""
    done

    if [ "$FILE_CSV" ] # check if any file participated in the importing
    then
        echo "Reindexing..."
        php -f $PROJECT_DIR/shell/indexer.php reindexall
    fi
fi

