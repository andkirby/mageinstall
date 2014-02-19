#!/bin/sh

# Input params
PROJECT="$1"
DB_HOST="localhost"
DB_USER="root"
DB_PASSWORD=""
DB_NAME=$(echo $PROJECT | tr . _)
ROOT="/web"
SAMPLE_DATA_DIR="$ROOT/sample_data/$PROJECT"
PROTOCOL_SECURED="https"
PROJECT_DOMAIN_MASK="%HOST%.cc"
PROTOCOL_SECURED="https"
ADMIN_USERNAME="admin"
ADMIN_PASSWORD="qweqwe1"
ADMIN_EMAIL="$2"
USE_REWRITES="yes" # Use Apache rewrites

# ======= Not desirable to change ========

# Set project domain
PROJECT_DOMAIN=$(echo $PROJECT_DOMAIN_MASK | tr "%HOST%" $PROJECT )

# Set Database name
DB_NAME=$(echo $PROJECT | tr . _)

# Save current path to variable
CUR_DIR=$(pwd)

# Set default DB host
if [ ! "$DB_HOST" ]
then
    DB_HOST="localhost"
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


echo "Go to directory $ROOT/$PROJECT..."
if [ ! -d "$ROOT/$PROJECT" ]
then
    echo "Directory $ROOT/$PROJECT doen not exist."
    exit 1
fi

cd "$ROOT/$PROJECT"

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
        cp -Rf $SAMPLE_DATA_DIR/media $ROOT/$PROJECT/

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
echo "Installing took $DIFF seconds."

cd "$OLD_DIR"

