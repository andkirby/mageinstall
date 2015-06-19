#!/usr/bin/env bash

echo "Prepare composer.json file for deploying..."

# generate package composer.json file with set deploy strategy
userDir=$(cd ~; pwd)
json=$($PHP_BIN "$SRC_DIR"/build/lib/generate-composer-json.php \
    -d$PACKAGE_DEPLOY_STRATEGY \
    -F$PACKAGE_DIR/composer.json)
hasError=$(echo $json | grep "Error:" 2>&1);
if [ "$hasError" ] ; then
    echo "$json"
    exit 1
fi

echo "$json" > $PACKAGE_DIR/composer.json
