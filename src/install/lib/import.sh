#!/bin/sh
# ================= Code =================
# Import products
if [ "$IMPORT_RUN" = true ] && [ -d "$IMPORT_DIR" ]
then
#    if [ -d "$IMPORT_DIR/media" ] ; then
#        if [ -d "$PROJECT_DIR/media/import" ] ; then
#            mkdir "$PROJECT_DIR/media/import"
#        fi
#        cp "$IMPORT_DIR/media/*" "$PROJECT_DIR/media/import"
#    fi

    RESULT=""
    user_message "$SAMPLE_DATA_DIR/scripts/import-categories.sh" 2
    if [ -d "$SAMPLE_DATA_DIR/scripts" ] && [ -f "$SAMPLE_DATA_DIR/scripts/import-categories.sh" ]
    then
        . "$SAMPLE_DATA_DIR/scripts/import-categories.sh"
        REINDEX_ALL_RUN="1"
    fi

    user_message "$SAMPLE_DATA_DIR/scripts/import-products-before.sh" 2
    if [ -d "$SAMPLE_DATA_DIR/scripts" ] && [ -f "$SAMPLE_DATA_DIR/scripts/import-products-before.sh" ]
    then
        . "$SAMPLE_DATA_DIR/scripts/import-products-before.sh"
        REINDEX_ALL_RUN="1"
    fi

    FILE_CSV=""
    for FILE_CSV in $IMPORT_DIR/*.csv; do
        user_message "Importing products file $FILE_CSV..." 2
        $PHP_BIN -f "$SCRIPT_DIR/lib/import.php" "\"$PROJECT_DIR\"" "\"$FILE_CSV\""
        REINDEX_ALL_RUN="1"
    done

    user_message "$SAMPLE_DATA_DIR/scripts/import-products-after.sh" 2
    if [ -d "$SAMPLE_DATA_DIR/scripts" ] && [ -f "$SAMPLE_DATA_DIR/scripts/import-products-after.sh" ]
    then
        . "$SAMPLE_DATA_DIR/scripts/import-products-after.sh"
        REINDEX_ALL_RUN="1"
    fi

    if [ "$REINDEX_ALL_RUN" ] # check if any file participated in the importing
    then
        user_message "Reindexing..." 1
        output=$($PHP_BIN -f $PROJECT_DIR/shell/indexer.php reindexall 2>&1)
        user_message ${output} 2
    fi
fi

