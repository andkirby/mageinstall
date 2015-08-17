#!/usr/bin/env bash

if [ -f ~/.mageinstall/build/before-clean.sh ] ; then
    . ~/.mageinstall/build/before-clean.sh
fi
if [ "$REFRESH_ALL" = "true" ] || [ ! -f "$PROJECT_DIR/app/Mage.php" ] ; then
    echo "Cleaning up..."
    echo "Cleaning up $PACKAGE_DIR..."
    rm -rf "$PACKAGE_DIR"/*
    echo "Cleaning up $PROJECT_DIR..."
    rm -rf "$PROJECT_DIR"/*

    echo "Copying Magento source files..."
    if [ ${COPY_METHOD} = "symlink" ] ; then
        echo "Notice: copying will use symlink."
        cp -rl "$MAGENTO_DIR"/* "$PROJECT_DIR"/
    else
        cp -r "$MAGENTO_DIR"/* "$PROJECT_DIR"/
    fi
    echo 'Cleaning up completed.'
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
