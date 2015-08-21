#!/usr/bin/env bash

if [ -f ~/.mageinstall/build/before-clean.sh ] ; then
    . ~/.mageinstall/build/before-clean.sh
fi
if [ "$REFRESH_ALL" = "true" ] || [ ! -f "$PROJECT_DIR/app/Mage.php" ] ; then
    user_message "Cleaning up..." 1
    user_message "Cleaning up $PACKAGE_DIR..." 2
    rm -rf "$PACKAGE_DIR"/*
    user_message "Cleaning up $PROJECT_DIR..." 2
    rm -rf "$PROJECT_DIR"/*

    user_message "Copying Magento source files..." 1
    if [ ${COPY_METHOD} = "symlink" ] ; then
        user_message "Notice: copying will use symlink." 2
        cp -rl "$MAGENTO_DIR"/* "$PROJECT_DIR"/
    else
        cp -r "$MAGENTO_DIR"/* "$PROJECT_DIR"/
    fi
    user_message 'Cleaning up completed.' 1
elif [ "$PACKAGE_INSTALL_RUN" = "true" ] ; then
    user_message "Clean up project directory..." 1

    set +e # possible error, just show it
    # TODO remove enabling errors
    filesToRemove=$(cd "$PROJECT_DIR" && find . -type f -print0 |
        grep -Fxvz -f <(cd "$MAGENTO_DIR" && find . -type f) |
        xargs -0 rm 2>&1)
    set -e #enable errors back

    cd "$PROJECT_DIR" && find . -empty -type d -delete
    user_message 'Cleaning up completed.' 1
fi

if [ -f ~/.mageinstall/build/after-clean.sh ] ; then
    . ~/.mageinstall/build/after-clean.sh
fi
