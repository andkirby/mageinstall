#!/usr/bin/env bash

cd "$PROJECT_DIR"
# ======== Set permissions to Magento ========

user_message "Set permissions to files..." 1
# Set owner for all files
if [ ! -z "${PROJECT_DIR_OWNER}" ] ; then
    user_message "Changing project directory owner to '$PROJECT_DIR_OWNER'..." 2
    chown -R $PROJECT_DIR_OWNER $PROJECT_DIR
fi

# Set permissions for media/etc/var directories
if [ -n "$MEDIA_DIR_PERMISSIONS" ] ; then
    user_message "Changing media/etc/var directory permissions to '$MEDIA_DIR_PERMISSIONS'..." 2
    chmod -R $MEDIA_DIR_PERMISSIONS $PROJECT_DIR/media
    chmod $MEDIA_DIR_PERMISSIONS    $PROJECT_DIR/app/etc/
    if [ -f $PROJECT_DIR/app/etc/local.xml ]; then
        chmod $MEDIA_DIR_PERMISSIONS    $PROJECT_DIR/app/etc/local.xml
    fi
    chmod -R $MEDIA_DIR_PERMISSIONS $PROJECT_DIR/var
fi

# Set owner for media/etc/var directories
if [ ! -z "$MEDIA_DIR_OWNER" ] ; then
    user_message "Changing media/etc/var directory owner to '$MEDIA_DIR_OWNER'..." 2

    chown -R $MEDIA_DIR_OWNER $PROJECT_DIR/media
    chown $MEDIA_DIR_OWNER    $PROJECT_DIR/app/etc/
    if [ -f $PROJECT_DIR/app/etc/local.xml ]; then
        chown $MEDIA_DIR_OWNER    $PROJECT_DIR/app/etc/local.xml
    fi
    chown -R $MEDIA_DIR_OWNER $PROJECT_DIR/var
fi
