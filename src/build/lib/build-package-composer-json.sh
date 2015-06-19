#!/usr/bin/env bash

echo "Refreshing composer.json file..."
#set repository URLs
repositories=""
for i in "${PACKAGE_COMPOSER_URL[@]}"
do
    repositories="$repositories -c$i "
done

# generate package composer.json file
userDir=$(cd ~; pwd)
json=$($PHP_BIN "$SRC_DIR"/build/lib/generate-composer-json.php \
    -p$PROJECT_DIR \
    -s$PACKAGE_MINIMUM_STABILITY \
    -dnone \
    $repositories \
    -F$userDir/.mageinstall/build/composer.json)
hasError=$(echo $json | grep "Error:" 2>&1);
if [ "$hasError" ] ; then
    echo "$json"
    exit 1
fi

echo "$json" > $PACKAGE_DIR/composer.json
if [ -f $PACKAGE_DIR/composer.lock ] ; then
    rm -f $PACKAGE_DIR/composer.lock
fi
