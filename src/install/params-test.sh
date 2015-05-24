#!/bin/sh
SCRIPT_DIR=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
cd "$SCRIPT_DIR"

. ../lib/function.sh

params=(\
--project:PROJECT \
-p:PROJECT \
--db-host:DB_HOST \
-H:DB_HOST \
--db-user:DB_USER \
-u:DB_USER \
--db-password:DB_PASSWORD \
-P:DB_PASSWORD \
--db-name:DB_NAME \
-n:DB_NAME \
--domain:PROJECT_DOMAIN \
-d:PROJECT_DOMAIN \
--secured-protocol:PROTOCOL_SECURED:http \
--secured-protocol:PROTOCOL_SECURED:https \
-s:PROTOCOL_SECURED:http \
-s:PROTOCOL_SECURED:https \
--use-rewrites:USE_REWRITES:no \
-r:USE_REWRITES:no \
--use-rewrites:USE_REWRITES:yes \
-r:USE_REWRITES:yes \
--admin-username:ADMIN_USERNAME \
--admin-password:ADMIN_PASSWORD \
--admin-email:ADMIN_EMAIL \
--install-run:INSTALL_RUN:yes:boolean \
--install-run:INSTALL_RUN:no:boolean \
-i:INSTALL_RUN:yes:boolean \
-i:INSTALL_RUN:no:boolean \
--import-run:IMPORT_RUN:yes:boolean \
--import-run:IMPORT_RUN:no:boolean \
-I:IMPORT_RUN:yes:boolean \
-I:IMPORT_RUN:no:boolean \
--config-run:SAMPLE_DATA_CONFIG_RUN:yes:boolean \
--config-run:SAMPLE_DATA_CONFIG_RUN:no:boolean \
-c:SAMPLE_DATA_CONFIG_RUN:yes:boolean \
-c:SAMPLE_DATA_CONFIG_RUN:no:boolean \
--sample-data-sql-run:SAMPLE_DATA_SQL_RUN:yes:boolean \
--sample-data-sql-run:SAMPLE_DATA_SQL_RUN:no:boolean \
-q:SAMPLE_DATA_SQL_RUN:yes:boolean \
-q:SAMPLE_DATA_SQL_RUN:no:boolean \
--sample-data-media-run:SAMPLE_DATA_MEDIA_RUN:yes:boolean \
--sample-data-media-run:SAMPLE_DATA_MEDIA_RUN:no:boolean \
-m:SAMPLE_DATA_MEDIA_RUN:yes:boolean \
-m:SAMPLE_DATA_MEDIA_RUN:no:boolean )

for item in "${params[@]}"; do
    IFS=':' read -ra ADDR <<< "$item"
    key=${ADDR[0]}
    param=${ADDR[1]}
    value=${ADDR[2]}
    expectedValue=${ADDR[3]}

    testValue="$param""testvalue"
    checkValue="$testValue"
    #set custom param value
    if [ "$value" ] ; then
        testValue="$value"
        checkValue="$testValue"

        #set boolean value
        if [ "${ADDR[3]}" = "boolean" ] ; then
            setBoolean testValue "$value"
            checkValue="$testValue"
        fi
    fi
    expected="$param=$testValue"

    cmd="bash $SCRIPT_DIR/params-debug.sh $key $testValue"
    result=$(eval "$cmd | grep \"\$param=$checkValue\"")

    if [ "${result}" = "${expected}" ] ; then
        echo "OK $key $param"
    else
        echo "FAILED $key $param"
        echo "Expected : ${expected}"
        echo "Actual   : ${result}"
        exit 1
    fi
done
