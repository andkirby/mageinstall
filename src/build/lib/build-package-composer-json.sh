#!/usr/bin/env bash

# generate package composer.json file
userDir=$(cd ~; pwd)
json=$($PHP_BIN "$SRC_DIR"/build/lib/generate-composer-json.php \
    -p$PROJECT_DIR \
    -F$userDir/.mageinstall/build/composer.json)
hasError=$(echo $json | grep "Error:" 2>&1);
if [ "$hasError" ] ; then
    echo "$json"
    exit 1
fi

echo "$json" > $PACKAGE_DIR/composer.json
