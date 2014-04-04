#!/bin/sh
# ================= Code =================
# Import products
if [ "$IMPORT_RUN" = true ] && [ -d "$IMPORT_DIR" ]
then
    FILE_CSV=""
    for FILE_CSV in $IMPORT_DIR/*.csv; do
        echo "Importing products file $FILE_CSV..."
        $PHP_BIN -f "$SCRIPT_DIR/tools/import.php" "\"$PROJECT_DIR\"" "\"$FILE_CSV\""
    done

    if [ "$FILE_CSV" ] # check if any file participated in the importing
    then
        echo "Reindexing..."
        $PHP_BIN -f $PROJECT_DIR/shell/indexer.php reindexall
    fi
fi

