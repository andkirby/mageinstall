#!/usr/bin/env bash
#install composer-command-integrator
RESULT=$(cd "$PACKAGE_DIR" && composer show -i magento-hackathon/composer-command-integrator 2>&1)
hasError=$(echo "$RESULT" | grep -E "(failed|fatal|Error)" 2>&1)
if [ "$hasError" ] ; then
    # stop if error
    exit 1
fi
notFound=$(echo "$RESULT" | grep "magento-hackathon/composer-command-integrator not found" 2>&1)
if [ "$notFound" ] ; then
    RESULT=$(cd "$PACKAGE_DIR" && composer require magento-hackathon/composer-command-integrator:@stable)
    echo "$RESULT"
    hasError=$(echo "$RESULT" | grep -E "(failed|fatal|Error)" 2>&1)
    if [ "$hasError" ] ; then
        # stop if error
        exit 1
    fi
fi
