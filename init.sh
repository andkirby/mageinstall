#!/bin/sh
SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
cd "$SCRIPT_DIR"

. params.sh.dist

echo "Initialize your parameters."
logicParams=(\
"SERVER_TYPE|Have you several Magento projects or the one project on the server? m - multiple, s - singe.|m" \
"DB_NAME:Database name" \
)
params=(\
"DB_HOST:Database hostname" \
"DB_USER:Database username" \
"DB_PASSWORD:Database password" \
"PROJECT_DOMAIN_MASK:Domain pattert. Use %HOST% to put project name automaticaly" \
"PROTOCOL_SECURED:Sectured protocol. Use 'https' if you do not have HTTPS (http|https)" \
"USE_REWRITES:Use Apache URL rewrites (yes|no)" \
"ADMIN_USERNAME:Admin username" \
"ADMIN_PASSWORD:Admin passwowrd" \
"ADMIN_EMAIL:Admin email" \
"INSTALL_RUN:Run Magento installation (yes|no)" \
"IMPORT_RUN:Run Magento importing products (yes|no)" \
"SAMPLE_DATA_CONFIG_RUN:Run importing configuration files (yes|no)" \
"SAMPLE_DATA_SQL_RUN:Run importing sample data SQL files (yes|no)" \
"SAMPLE_DATA_MEDIA_RUN:Run importing sample data media files (yes|no)" \
)
SERVER_TYPE='m'
printf "Branch name for production releases: m - multiple, s - singe [$SERVER_TYPE]:"
read answer
SERVER_TYPE=$answer;
if [ SERVER_TYPE = "s" ] ; then
    printf "Database name: []"
    read DB_NAME
    PROJECT_DOMAIN_MASK="project-%HOST%.example.com"
fi
nonDefault=""
for item in "${params[@]}"; do
    IFS=':' read -ra ADDR <<< "$item"
    key=${ADDR[0]}
    comment=${ADDR[1]}
    default=${!key}
    printf "$comment : [$default]"
    read answer
    ${key}=answer

    if [ "$default" != "$answer" ] ; then
        nonDefault="$nonDefault:$key"
    fi
done

echo nonDefault

SKIP_LOAD=true

. params-debug.sh
