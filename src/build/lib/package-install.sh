#!/usr/bin/env bash

#install required installer version
echo "Installing the package 'magento-hackathon/magento-composer-installer:~3.0@stable'..."
RESULT=$(cd "$PACKAGE_DIR" && composer require magento-hackathon/magento-composer-installer:~3.0@stable 2>&1)
# show result
echo "$RESULT"

hasError=$(echo "$RESULT" | grep -E "(failed|fatal|Error|Exception|Problem)" 2>&1)
if [ "$hasError" ] ; then
    # stop if error
    die "Package requiring failed."
fi

# Install target package
echo "Installing the package '$PACKAGE'..."
RESULT=$(cd "$PACKAGE_DIR" && composer require "$PACKAGE" 2>&1)
# show result
echo "$RESULT"

hasError=$(echo "$RESULT" | grep -E "(failed|fatal|Error|Exception|Problem)" 2>&1)
if [ "$hasError" ] ; then
    # stop if error
    die "Package requiring failed."
fi
# Check if module didn't get updates
notInstalled=$(echo "$RESULT" | grep -E "(Nothing to install or update)" 2>&1)
if [ "$notInstalled" ] ; then
    # stop if error
    die "Nothing to install or update."
fi
