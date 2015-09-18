#!/usr/bin/env bash

COMPOSER_VERBOSITY_PARAM=""
if [ ${VERBOSITY_COMPOSER} = "true" ] ; then
    VERBOSITY_PARAM=${COMPOSER_VERBOSITY_PARAM}
fi

# require installer
user_message "Adding the installer package 'magento-hackathon/magento-composer-installer:~3.0@stable'..." 2
result=$(cd "$PACKAGE_DIR" && composer require \
    magento-hackathon/magento-composer-installer:~3.0@stable \
    --no-update \
    $COMPOSER_VERBOSITY_PARAM \
    $INTERACTION_PARAM \
    2>&1)
status=$?
# show result
user_message "$result" 0

if [ ${status} != 0 ] ; then
    # stop if error
    die "Package requiring failed."
fi

user_message "Adding the package '$PACKAGE'..." 1

# Require target package
result=$(cd "$PACKAGE_DIR" && composer require "$PACKAGE" \
    --no-update \
    $COMPOSER_VERBOSITY_PARAM \
    $INTERACTION_PARAM \
    2>&1)

status=$?
# show result
user_message "$result" 0

if [ ${status} != 0 ] ; then
    # stop if error
    die "Package requiring failed."
fi
# Require target package
COMPOSER_PROCESS_TIMEOUT=600
result=$(cd "$PACKAGE_DIR" && \
    COMPOSER_PROCESS_TIMEOUT=$COMPOSER_PROCESS_TIMEOUT \
    composer update $COMPOSER_VERBOSITY_PARAM \
    $INTERACTION_PARAM \
    2>&1)
status=$?
# show result
user_message "$result" 0

if [ ${status} != 0 ] ; then
    # stop if error
    die "Package requiring failed."
fi
# Check if module didn't get updates
notInstalled=$(echo "$result" | grep -E "(Nothing to install or update)" 2>&1)
if [ "$notInstalled" ] && [ "$PACKAGE_INSTALL_RUN" != "true" ] ; then
    # stop if error
    die "Nothing to install or update."
fi
