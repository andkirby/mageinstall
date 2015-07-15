#!/usr/bin/env bash
#install a package
echo "Installing the package 'magento-hackathon/magento-composer-installer:~3.0@stable'..."
RESULT=$(cd "$PACKAGE_DIR" && composer require magento-hackathon/magento-composer-installer:~3.0@stable 2>&1)
# show result
echo "$RESULT"

hasError=$(echo "$RESULT" | grep -E "(failed|fatal|Error|Exception|Problem)" 2>&1)
if [ "$hasError" ] ; then
    # stop if error
    die "Package requiring failed."
fi

echo "Installing the package '$PACKAGE'..."
RESULT=$(cd "$PACKAGE_DIR" && composer require "$PACKAGE" 2>&1)
# show result
echo "$RESULT"

hasError=$(echo "$RESULT" | grep -E "(failed|fatal|Error|Exception|Problem)" 2>&1)
if [ "$hasError" ] ; then
    # stop if error
    die "Package requiring failed."
fi
