#!/bin/sh
OLD_DIR=$(pwd)
SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
cd "$SCRIPT_DIR"

. tools/function.sh

if [ "$SKIP_LOAD" != true ] ; then
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
fi

echo "PROJECT=""$PROJECT"
echo "DB_HOST=""$DB_HOST"
echo "DB_USER=""$DB_USER"
echo "DB_PASSWORD=""$DB_PASSWORD"
echo "DB_NAME=""$DB_NAME"
echo "PROJECT_DOMAIN_MASK=""$PROJECT_DOMAIN_MASK"
echo "PROJECT_DOMAIN=""$PROJECT_DOMAIN"
echo "PROTOCOL_SECURED=""$PROTOCOL_SECURED"
echo "USE_REWRITES=""$USE_REWRITES"
echo "ADMIN_USERNAME=""$ADMIN_USERNAME"
echo "ADMIN_PASSWORD=""$ADMIN_PASSWORD"
echo "ADMIN_EMAIL=""$ADMIN_EMAIL"
echo "INSTALL_RUN=""$INSTALL_RUN"
echo "IMPORT_RUN=""$IMPORT_RUN"
echo "SAMPLE_DATA_SQL_RUN=""$SAMPLE_DATA_SQL_RUN"
echo "SAMPLE_DATA_MEDIA_RUN=""$SAMPLE_DATA_MEDIA_RUN"
echo "SAMPLE_DATA_CONFIG_RUN=""$SAMPLE_DATA_CONFIG_RUN"
echo "MYSQL_BIN=""$MYSQL_BIN"
echo "PHP_BIN=""$PHP_BIN"

cd "$OLD_DIR"
