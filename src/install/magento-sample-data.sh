#!/usr/bin/env bash
used=''
# Run php script before
if [ true = "$SAMPLE_DATA_SQL_RUN" ] && [ -d "$PROJECT_DIR/shell/.mageinstall/install/sample-data/before/" ] ; then
    user_message "Running PHP scripts before sample data step..." 0
    user_message "Target directory shell/.mageinstall/install/sample-data/before." 2
    for php_file in "$PROJECT_DIR/shell/.mageinstall/install/sample-data/before/*.php"; do
        user_message "Running ${php_file}..." 2
        ${PHP_BIN} -f ${php_file}
    done
fi

# ======= Install Sample SQL Data =======
if [ true = "$SAMPLE_DATA_SQL_RUN" ] && [ -d "$SAMPLE_DATA_DIR/sample" ]
then
    used=1
    user_message "Installing sample data SQL files..." 0
    for SQL_FILE in $SAMPLE_DATA_DIR/sample/*.sql; do
        $DB_CONNECT_COMMAND -h$DB_HOST $DB_NAME < $SQL_FILE
        user_message "Added to DB SQL file: $SQL_FILE..." 2
    done
else
    user_message "Skipped adding sample SQL data." 1
fi

# ======= Install Sample Data files =======
if [ true = "$SAMPLE_DATA_MEDIA_RUN" ] && [ -d "$SAMPLE_DATA_DIR/sample" ]
then
    used=1
    user_message "Copying sample data files..." 0
    if [ "$INSTALL_RUN" = "true" ] && [ -f "$SAMPLE_DATA_DIR/sample"/app/etc/local.xml ] ; then
        user_message "Notice: You going to copy 'local.xml' file. Installation will be ignored." 1
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

# Run php script after
if [ "$used" ] && [ -d "$PROJECT_DIR/shell/.mageinstall/install/sample-data/after/" ] ; then
    user_message "Running PHP scripts after sample data step..." 0
    user_message "Target directory shell/.mageinstall/install/sample-data/after." 2
    for php_file in "$PROJECT_DIR/shell/.mageinstall/install/sample-data/after/*.php"; do
        user_message "Running ${php_file}..." 2
        ${PHP_BIN} -f ${php_file}
    done
fi
