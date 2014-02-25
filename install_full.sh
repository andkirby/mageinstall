#!/bin/sh
SCRIPT_DIR=$(dirname $0)
# include params
if [ -f $SCRIPT_DIR"/params.sh" ]
then
    . $SCRIPT_DIR/params.sh
else
    . $SCRIPT_DIR/params.sh.dist
fi

# include addintional params
if [ -f $SCRIPT_DIR"/params-protected.sh" ]
then
    . $SCRIPT_DIR/params-protected.sh
else
    . $SCRIPT_DIR/params-protected.sh.dist
fi

# ================= Code =================
if [ -z "$PROJECT" ]
then
   echo "Please set project name."
   exit 1
fi

if [ -z "$ADMIN_EMAIL" ]
then
   echo "Please set your email as a second parameter."
   exit 1
fi


echo "Go to directory $PROJECT_DIR..."
if [ ! -d "$PROJECT_DIR" ]
then
    echo "Directory $PROJECT_DIR doen not exist."
    exit 1
fi

cd "$PROJECT_DIR"

# ======= Clean Up var Directory =======
echo "Cleaning up cache files and config file..."
rm -rf var/full_page_cache
rm -rf var/cache
rm -rf var/lock
rm -rf var/log
rm -rf var/session
rm -rf app/etc/local.xml
rm -rf media/catalog/product/cache
echo "Clean up done."

# ======= Set DB connect command =======
DB_CONNECT_COMMAND="mysql -u$DB_USER -h$DB_HOST"
if [ "$DB_PASSWORD" ]
then
    DB_CONNECT_COMMAND="$DB_CONNECT_COMMAND -p$DB_PASSWORD"
fi

# ======= (Re)create DB =======
echo "(Re)creating database '$DB_NAME'..."
$DB_CONNECT_COMMAND -h$DB_HOST -e "DROP DATABASE IF EXISTS \`$DB_NAME\`;"
$DB_CONNECT_COMMAND -h$DB_HOST -e "CREATE DATABASE \`$DB_NAME\`;"
echo "Database (re)created."

# ======= Install Sample Data =======
if [ -d "$SAMPLE_DATA_DIR" ]
then
    echo "Trying install sample data..."
    for f in $SAMPLE_DATA_DIR/*.sql; do
        SQL_FILE="$f"
        $DB_CONNECT_COMMAND $DB_NAME < $SQL_FILE
        echo "Sample data added to DB."
        break
    done
    if [ "$SAMPLE_DATA_DIR/media" ]
    then
        cp -Rf $SAMPLE_DATA_DIR/media $PROJECT_DIR/

        # Set permissions
        chmod -R 777 media
    else
        echo "Skipped coping media files."
    fi
else
    echo "Skipped adding sample data."
fi

# ======== Install Magento ========
echo "Start installing Magento..."
START=$(date +%s)

php -f install.php -- \
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
echo "Magento has been installed. Installing took $DIFF seconds."

for FILE_INI in $SAMPLE_DATA_DIR/*.ini; do
    php -f config.php $FILE_INI
    echo "Applied configuration from file $FILE_INI"
done

cd "$OLD_DIR"

