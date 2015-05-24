#!/usr/bin/env bash
# Main rebuild script
REBUILD_START=$(date +%s)

echo "Cleaning up..."
if [ "$MAGENTO_REFRESH" = "true" ] ; then
    echo "Copying Magento source files..."
    rm -rf "$PROJECT_DIR"/*
    cp -rl "$MAGENTO_DIR"/* "$PROJECT_DIR"/
else
    echo "Removing package files..."
    extra=""
    if [ "$INSTALL_RUN" = "false" ] ; then
        # Ignore removing media, var, app/etc/local.xml when no re-installing
        extra="! -path './media/*' ! -path './var/*' ! -path './app/etc/local.xml'"
    fi
    cd $PROJECT_DIR && find . -maxdepth 1 $extra -type f -print0 |
        grep -Fxvz -f <(cd "$MAGENTO_DIR" && find . -type f $extra) |
        xargs -0 echo rm
fi

if [ -f ~/.mageinstall/build/after-clean.sh ] ; then
    . ~/.mageinstall/build/after-clean.sh
fi

echo "Installing the package '$PACKAGE'..."
RESULT=$(cd "$PACKAGE_DIR" && composer require "$PACKAGE" 2>&1)

# show result
echo "$RESULT"

hasError=$(echo "$RESULT" | grep -e "failed" 2>&1)
if [ "$hasError" ] ; then
    # stop if error
    exit 1
fi
hasError=$(echo "$RESULT" | grep -e "Error" 2>&1)
if [ "$hasError" ] ; then
    # stop if error
    exit 1
fi

sh ~/.composer/vendor/bin/mageinstall -p "$PROJECT"

END=$(date +%s)
DIFF=$(( $END - $REBUILD_START ))
echo "Rebuild time: $DIFF seconds."
