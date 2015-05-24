#!/usr/bin/env bash
#install a package
echo "Installing the package '$PACKAGE'..."
RESULT=$(cd "$PACKAGE_DIR" && composer require "$PACKAGE" 2>&1)
# show result
echo "$RESULT"

hasError=$(echo "$RESULT" | grep -E "(failed|fatal|Error|Exception)" 2>&1)
if [ "$hasError" ] ; then
    # stop if error
    exit 1
fi

# redeploy package if it wasn't updated
notUpdated=$(echo "$RESULT" | grep "Nothing to install" 2>&1)
if [ "$notUpdated" ] ; then
   cd $PACKAGE_DIR && $PHP_BIN ./vendor/bin/composerCommandIntegrator.php magento-module-deploy
fi
