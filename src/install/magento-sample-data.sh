#!/usr/bin/env bash
# ======= Install Sample SQL Data =======
if [ true = "$SAMPLE_DATA_SQL_RUN" ] && [ -d "$SAMPLE_DATA_DIR/sample" ]
then
    user_message "Installing sample data SQL files..." 1
    for SQL_FILE in $SAMPLE_DATA_DIR/sample/*.sql; do
        $DB_CONNECT_COMMAND -h$DB_HOST $DB_NAME < $SQL_FILE
        user_message "Added to DB SQL file: $SQL_FILE..." 2
    done
else
    echo "Skipped adding sample SQL data."
fi

# ======= Install Sample Data files =======
if [ true = "$SAMPLE_DATA_MEDIA_RUN" ] && [ -d "$SAMPLE_DATA_DIR/sample" ]
then
    user_message "Copying sample data files..." 1
    if [ "$INSTALL_RUN" = "true" ] && [ -f "$SAMPLE_DATA_DIR/sample"/app/etc/local.xml ] ; then
        user_message "Notice: You going to copy 'local.xml' file. Installation will be ignored." 2
        INSTALL_RUN=false
    fi

    for i in "$SAMPLE_DATA_DIR/sample"/* ; do
        if [ -d "$i" ]; then
            DIR=$(basename "$i")
            user_message "Copying directory sample/$DIR..." 2
            if [ -d "$PROJECT_DIR/$DIR/" ]; then
                cp -Rf $i/* $PROJECT_DIR/$DIR/
            else
                cp -Rf $i $PROJECT_DIR/
            fi
        fi
    done
else
    user_message "Skipped copying sample data files." 1
fi
