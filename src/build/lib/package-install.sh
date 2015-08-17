#!/usr/bin/env bash

# require installer
user_message "Adding the installer package 'magento-hackathon/magento-composer-installer:~3.0@stable'..." 2
RESULT=$(cd "$PACKAGE_DIR" && composer require \
    magento-hackathon/magento-composer-installer:~3.0@stable \
    --no-update \
    $VERBOSITY_PARAM \
    $INTERACTION_PARAM \
    2>&1)
# show result
echo "$RESULT"

hasError=$(echo "$RESULT" | grep -E "(failed|fatal|Error|Exception|Problem)" 2>&1)
if [ "$hasError" ] ; then
    # stop if error
    die "Package requiring failed."
fi

user_message "Adding the package '$PACKAGE'..." 1

# Require target package
RESULT=$(cd "$PACKAGE_DIR" && composer require "$PACKAGE" \
    --no-update \
    $VERBOSITY_PARAM \
    $INTERACTION_PARAM \
    2>&1)

# Show result
echo "$RESULT"

hasError=$(echo "$RESULT" | grep -E "(failed|fatal|Error|Exception|Problem)" 2>&1)
if [ "$hasError" ] ; then
    # stop if error
    die "Package requiring failed."
fi
# Require target package
COMPOSER_PROCESS_TIMEOUT=600
RESULT=$(cd "$PACKAGE_DIR" && \
    COMPOSER_PROCESS_TIMEOUT=$COMPOSER_PROCESS_TIMEOUT \
    composer update $VERBOSITY_PARAM \
    $INTERACTION_PARAM \
    2>&1)
# show result
echo "$RESULT"

hasError=$(echo "$RESULT" | grep -E "(failed|fatal|Error|Exception|Problem)" 2>&1)
if [ "$hasError" ] ; then
    # stop if error
    die "Package requiring failed."
fi
# Check if module didn't get updates
notInstalled=$(echo "$RESULT" | grep -E "(Nothing to install or update)" 2>&1)
if [ "$notInstalled" ] && [ "$PACKAGE_INSTALL_RUN" != "true" ] ; then
    # stop if error
    die "Nothing to install or update."
fi
