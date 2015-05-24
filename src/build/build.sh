#!/usr/bin/env bash
# Main rebuild script
REBUILD_START=$(date +%s)

echo "Cleaning up..."
if [ "$MAGENTO_REFRESH" = "true" ] || [ ! -f "$PROJECT_DIR/app/Mage.php" ] ; then
    echo "Copying Magento source files..."
    rm -rf "$PROJECT_DIR"/*
    cp -rl "$MAGENTO_DIR"/* "$PROJECT_DIR"/
else
    echo "Removing package files..."
    if [ "$INSTALL_RUN" = "false" ] ; then
        # Ignore removing media, var, app/etc/local.xml when no re-installing
        filesToRemove=$(cd "$PROJECT_DIR" && find . -type f \
                ! -regex '\./media/.*' ! -regex '\./var/.*' \
                ! -regex '\./app/etc/local\.xml' -print0 |
            grep -Fxvz -f <(cd "$MAGENTO_DIR" && find . -type f) |
            xargs -0 rm 2>&1)
    else
        filesToRemove=$(cd "$PROJECT_DIR" && find . -type f -print0 |
            grep -Fxvz -f <(cd "$MAGENTO_DIR" && find . -type f) |
            xargs -0 rm 2>&1)

    fi
    echo 'Cleaning up completed.'

fi

if [ -f ~/.mageinstall/build/after-clean.sh ] ; then
    . ~/.mageinstall/build/after-clean.sh
fi

. "$SRC_DIR"/build/lib/install-integrator.sh

#install a package
echo "Installing the package '$PACKAGE'..."
RESULT=$(cd "$PACKAGE_DIR" && composer require "$PACKAGE" 2>&1)
# show result
echo "$RESULT"

hasError=$(echo "$RESULT" | grep -E "(failed|fatal|Error)" 2>&1)
if [ "$hasError" ] ; then
    # stop if error
    exit 1
fi

# redeploy package if it wasn't updated
notUpdated=$(echo "$RESULT" | grep "Nothing to install" 2>&1)
if [ "$notUpdated" ] ; then
   cd $PACKAGE_DIR && $PHP_BIN ./vendor/bin/composerCommandIntegrator.php magento-module-deploy
fi

binDir=$(cd $SRC_DIR/../bin/; pwd)
sh "$binDir/"mageshell install -p "$PROJECT"

END=$(date +%s)
DIFF=$(( $END - $REBUILD_START ))
echo "Rebuild time: $DIFF seconds."
