#!/usr/bin/env bash

# require installer
echo "Adding the installer package 'magento-hackathon/magento-composer-installer:~3.0@stable'..."
RESULT=$(cd "$PACKAGE_DIR" && composer require magento-hackathon/magento-composer-installer:~3.0@stable --no-update $VERBOSITY_PARAM 2>&1)
# show result
echo "$RESULT"

hasError=$(echo "$RESULT" | grep -E "(failed|fatal|Error|Exception|Problem)" 2>&1)
if [ "$hasError" ] ; then
    # stop if error
    die "Package requiring failed."
fi

echo "Adding the package '$PACKAGE'..."

# Require target package
cd "$PACKAGE_DIR" && composer require --no-update "$PACKAGE" $VERBOSITY_PARAM

# Show result
echo "$RESULT"

hasError=$(echo "$RESULT" | grep -E "(failed|fatal|Error|Exception|Problem)" 2>&1)
if [ "$hasError" ] ; then
    # stop if error
    die "Package requiring failed."
fi
# Require target package
RESULT=$(cd "$PACKAGE_DIR" && composer update $VERBOSITY_PARAM 2>&1)
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
