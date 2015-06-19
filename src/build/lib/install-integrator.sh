#!/usr/bin/env bash
#install composer-command-integrator
RESULT=$(cd "$PACKAGE_DIR" && composer require magento-hackathon/composer-command-integrator:@stable 2>&1)
echo "$RESULT"
hasError=$(echo "$RESULT" | grep -E "(failed|fatal|Error)" 2>&1)
if [ "$hasError" ] ; then
    # stop if error
    exit 1
fi
