#!/usr/bin/env bash
# ======= Install Sample SQL Data =======
if [ true = "$SAMPLE_DATA_SQL_RUN" ] && [ -d "$SAMPLE_DATA_DIR/sample" ]
then
    echo "Installing sample data SQL files..."
    for SQL_FILE in $SAMPLE_DATA_DIR/sample/*.sql; do
        $DB_CONNECT_COMMAND -h$DB_HOST $DB_NAME < $SQL_FILE
        echo "Added to DB SQL file: $SQL_FILE..."
    done
else
    echo "Skipped adding sample SQL data."
fi

# ======= Install Sample Data files =======
if [ true = "$SAMPLE_DATA_MEDIA_RUN" ] && [ -d "$SAMPLE_DATA_DIR/sample" ]
then
    echo "Copying sample data files..."
    if [ "$INSTALL_RUN" = "true" ] && [ -f "$SAMPLE_DATA_DIR/sample"/app/etc/local.xml ] ; then
        echo "Notice: You going to copy 'local.xml' file. Installation will be ignored."
        INSTALL_RUN=false
    fi

    for i in "$SAMPLE_DATA_DIR/sample"/* ; do
        if [ -d "$i" ]; then
            DIR=$(basename "$i")
            echo "Copying directory sample/$DIR..."
            if [ -d "$PROJECT_DIR/$DIR/" ]; then
                cp -Rf $i/* $PROJECT_DIR/$DIR/
            else
                cp -Rf $i $PROJECT_DIR/
            fi
        fi
    done
else
    echo "Skipped copying sample data files."
fi
