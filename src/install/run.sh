#!/bin/sh
OLD_DIR=$(pwd)
SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
cd "$SCRIPT_DIR"
. tools/function.sh
# include default params
. params.sh.dist

# get options from command line
. tools/getopt.sh

# include custom params
if [ -f $(cd ~; pwd)"/.mageinstall/params.sh" ]
then
    . ~/.mageinstall/params.sh
else
    . init.sh
    echo "Please run install script again."
    exit 1
fi
# reset param into boolean
. tools/set-boolean.sh

# include addintional params
if [ -f "~/params-protected.sh" ]
then
    . params-protected.sh
else
    . params-protected.sh.dist
fi

# ================= Code =================
if [ -z "$PROJECT" ]
then
   echo "Please set project name."
   exit 1
fi

if [ -z "$ADMIN_EMAIL" ]
then
   echo "Please set admin email."
   exit 1
fi


echo "Go to directory $PROJECT_DIR..."
if [ ! -d "$PROJECT_DIR" ]
then
    echo "Directory $PROJECT_DIR does not exist."
    exit 1
fi

cd "$PROJECT_DIR"

# ======= Clean Up var Directory =======
echo "Cleaning up cache files and config file..."
if [ "$INSTALL_RUN" = true ] || ( [ "$SAMPLE_DATA_SQL_RUN" = true ] && [ -d "$SAMPLE_DATA_DIR" ] ) ; then
    rm -rf var/full_page_cache
    rm -rf var/cache
    rm -rf var/lock
    rm -rf var/log
fi
rm -rf var/session
if [ "$INSTALL_RUN" = true ]
then
    rm -rf app/etc/local.xml
fi
rm -rf media/catalog/product/cache
echo "Clean up done."

# ======= Set DB connect command =======
DB_CONNECT_COMMAND="$MYSQL_BIN -u$DB_USER -h$DB_HOST"
if [ "$DB_PASSWORD" ]
then
    DB_CONNECT_COMMAND="$DB_CONNECT_COMMAND -p$DB_PASSWORD"
fi

# ======= Refreate DB =======
if [ "$INSTALL_RUN" = true ] || ( [ "$SAMPLE_DATA_SQL_RUN" = true ] && [ -d "$SAMPLE_DATA_DIR" ] )
then
    $DB_CONNECT_COMMAND -h$DB_HOST -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;"
    has_tables=$($DB_CONNECT_COMMAND -h$DB_HOST -D$DB_NAME -e "SHOW TABLES;")
    if [ ! -z "$has_tables" ] ; then
        echo "Drop tables in database '$DB_NAME'..."
        $DB_CONNECT_COMMAND -h$DB_HOST -e "
            USE \`$DB_NAME\`;
            SET FOREIGN_KEY_CHECKS = 0;
            SELECT DATABASE() FROM DUAL INTO @current_dbname;
            SET @tables = '';
            SET SESSION group_concat_max_len = 1000000;
            SELECT GROUP_CONCAT(table_schema, '.', table_name) INTO @tables
              FROM information_schema.tables
              WHERE table_schema = @current_dbname; -- specify DB name here.
            SET @tables = CONCAT('DROP TABLE ', @tables);
            PREPARE stmt FROM @tables;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET FOREIGN_KEY_CHECKS = 1;" 2>&1
        echo "Database refreshed."
    fi
fi

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

# ======== Install Magento ========
if [ "$INSTALL_RUN" = true ]
then
    # Set permissions
    chmod -R $MEDIA_DIR_PERMISSIONS $PROJECT_DIR/media
    chmod $MEDIA_DIR_PERMISSIONS    $PROJECT_DIR/app/etc/
    chmod -R $MEDIA_DIR_PERMISSIONS $PROJECT_DIR/var

    if [ ! -z "$MEDIA_DIR_OWNER" ] ; then
        chown -R $MEDIA_DIR_OWNER $PROJECT_DIR/media
        chown $MEDIA_DIR_OWNER    $PROJECT_DIR/app/etc/
        chown -R $MEDIA_DIR_OWNER $PROJECT_DIR/var
    fi

    echo "Start installing Magento..."
    if [ ! -f "$PROJECT_DIR/install.php" ] ; then
        echo "Error: There are no Magento files."
        exit 1
    fi

    START=$(date +%s)
    RESULT=$($PHP_BIN -f "$SCRIPT_DIR"/tools/install.php -- \
            "$PROJECT_DIR" \
            --license_agreement_accepted "yes" \
            --locale "en_US" \
            --timezone "America/Los_Angeles" \
            --default_currency "USD" \
            --db_host "$DB_HOST" \
            --db_name "$DB_NAME" \
            --db_user "$DB_USER" \
            --db_pass "$DB_PASSWORD" \
            --url "http://$PROJECT_DOMAIN/" \
            --use_rewrites "$USE_REWRITES" \
            --use_secure "yes" \
            --secure_base_url "$PROTOCOL_SECURED://$PROJECT_DOMAIN/" \
            --use_secure_admin "yes" \
            --admin_firstname "Admin" \
            --admin_lastname "MageInstall" \
            --admin_email "$ADMIN_EMAIL" \
            --admin_username "$ADMIN_USERNAME" \
            --admin_password "$ADMIN_PASSWORD" \
            --skip_url_validation "yes" 2>&1)

    END=$(date +%s)
    DIFF=$(( $END - $START ))

    echo "$RESULT";

    exit 1
    TEST=$(echo $RESULT | grep "SUCCESS" 2>&1);
    if [ "$TEST" ] ; then
        echo "Magento has been installed for domain http://$PROJECT_DOMAIN/."
        echo "Installing took $DIFF seconds."
    else
        echo "Magento installation failed."
        exit 1
    fi
fi

# Add configuration into Magento instance
if [ "$SAMPLE_DATA_CONFIG_RUN" = true ] && [ -d "$SAMPLE_DATA_DIR" ]
then
    for FILE_INI in "$SAMPLE_DATA_DIR"/*.csv; do
        echo "Applying configuration from file $FILE_INI..."
        $PHP_BIN -f "$SCRIPT_DIR"/tools/config.php "$FILE_INI"
    done
fi

# Import products
. "$SCRIPT_DIR"/tools/import.sh

cd "$OLD_DIR"