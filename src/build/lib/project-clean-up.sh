#!/usr/bin/env bash
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
