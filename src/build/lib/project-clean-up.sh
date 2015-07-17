#!/usr/bin/env bash
echo "Cleaning up..."

if [ -f ~/.mageinstall/build/before-clean.sh ] ; then
    . ~/.mageinstall/build/before-clean.sh
fi
if [ "$MAGENTO_REFRESH" = "true" ] || [ ! -f "$PROJECT_DIR/app/Mage.php" ] ; then
    echo "Copying Magento source files..."
    rm -rf "$PACKAGE_DIR"/*
    rm -rf "$PROJECT_DIR"/*
    cp -rl "$MAGENTO_DIR"/* "$PROJECT_DIR"/
elif [ "$PACKAGE_INSTALL_RUN" = "true" ] ; then
    echo "Clean up project directory..."
    filesToRemove=$(cd "$PROJECT_DIR" && find . -type f -print0 |
        grep -Fxvz -f <(cd "$MAGENTO_DIR" && find . -type f) |
        xargs -0 rm 2>&1)
    cd "$PROJECT_DIR" && find . -empty -type d -delete
    echo 'Cleaning up completed.'
fi

if [ -f ~/.mageinstall/build/after-clean.sh ] ; then
    . ~/.mageinstall/build/after-clean.sh
fi
