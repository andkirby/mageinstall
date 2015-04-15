#!/bin/sh
OLD_DIR=$(pwd)
SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
cd "$SCRIPT_DIR"
. tools/function.sh
# include default params
. params.sh.dist
# include custom params
if [ -f $(cd ~; pwd)"/.mageinstall_params.sh" ]
then
    . ~/.mageinstall_params.sh
else
    . init.sh
    echo "Please run install script again."
    exit 1
fi

# get options from command line
. tools/getopt.sh
# reset param into boolean
. tools/set-boolean.sh

# include addintional params
if [ -f "params-protected.sh" ]
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
if [ "$INSTALL_RUN" = true ] || [ "$SAMPLE_DATA_SQL_RUN" = true ] && [ -d "$SAMPLE_DATA_DIR" ] ; then
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
if [ "$INSTALL_RUN" = true ] || [ "$SAMPLE_DATA_SQL_RUN" = true ] && [ -d "$SAMPLE_DATA_DIR" ]
then
    echo "Refresh database '$DB_NAME'..."
    $DB_CONNECT_COMMAND -h$DB_HOST -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;"
    $DB_CONNECT_COMMAND -h$DB_HOST -e "
SET FOREIGN_KEY_CHECKS = 0;
SET @tables = NULL;
SELECT GROUP_CONCAT(table_schema, '.', table_name) INTO @tables
  FROM information_schema.tables
  WHERE table_schema = 'database_name'; -- specify DB name here.

SET @tables = CONCAT('DROP TABLE ', @tables);
PREPARE stmt FROM @tables;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
SET FOREIGN_KEY_CHECKS = 1;"
    echo "Database refreshed."
fi

# ======= Install Sample Data =======
if [ true = "$SAMPLE_DATA_SQL_RUN" ] && [ -d "$SAMPLE_DATA_DIR/sample" ]
then
    echo "Installing sample data SQL files..."
    for SQL_FILE in $SAMPLE_DATA_DIR/sample/*.sql; do
        $DB_CONNECT_COMMAND -h$DB_HOST $DB_NAME < $SQL_FILE
        echo "Added to DB SQL file: $SQL_FILE..."
    done
else
    echo "Skipped adding sample data."
fi
if [ "$SAMPLE_DATA_MEDIA_RUN" = true ] && [ -d "$SAMPLE_DATA_DIR/sample/" ] ; then
    echo "Installing sample data files..."
    for i in "$SAMPLE_DATA_DIR/sample/*" ; do
        if [ -d "$i" ]; then
            DIR=$(basename "$i")
            cp -Rf $SAMPLE_DATA_DIR/sample/$DIR/* $PROJECT_DIR/$DIR/
        fi
    done
fi
# Set permissions to media
chmod -R 777 $PROJECT_DIR/media

# ======== Install Magento ========
if [ "$INSTALL_RUN" = true ]
then
    echo "Start installing Magento..."
    START=$(date +%s)
    $PHP_BIN -f "$PROJECT_DIR"/install.php -- \
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
            --admin_firstname "ad" \
            --admin_lastname "min" \
            --admin_email "$ADMIN_EMAIL" \
            --admin_username "$ADMIN_USERNAME" \
            --admin_password "$ADMIN_PASSWORD" \
            --skip_url_validation "yes"
    END=$(date +%s)
    DIFF=$(( $END - $START ))
    echo "Magento has been installed for domain http://$PROJECT_DOMAIN/."
    echo "Installing took $DIFF seconds."
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
