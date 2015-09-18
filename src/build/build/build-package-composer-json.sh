#!/usr/bin/env bash

user_message "Refreshing composer.json file..." 1
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
    -d$PACKAGE_DEPLOY_STRATEGY \
    -f$PACKAGE_DEPLOY_FORCE \
    -t$PACKAGE_PREFER_STABLE \
    $repositories \
    -F$userDir/.mageinstall/build/composer.json)
hasError=$(echo $json | grep "Error:" 2>&1);
if [ "$hasError" ] ; then
    die "$json"
fi

echo "$json" > $PACKAGE_DIR/composer.json
