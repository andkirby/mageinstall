#!/usr/bin/env bash

cd "$PROJECT_DIR"
# ======== Set permissions to Magento ========

# Set owner for all files
if [ ! -z "${PROJECT_DIR_OWNER}" ] ; then
    echo "Changing project directory owner to '$PROJECT_DIR_OWNER'..."
    chown -R $PROJECT_DIR_OWNER $PROJECT_DIR
fi

# Set permissions for media/etc/var directories
if [ -n "$MEDIA_DIR_PERMISSIONS" ] ; then
    echo "Changing media/etc/var directory permissions to '$MEDIA_DIR_PERMISSIONS'..."
    chmod -R $MEDIA_DIR_PERMISSIONS $PROJECT_DIR/media
    chmod $MEDIA_DIR_PERMISSIONS    $PROJECT_DIR/app/etc/
    chmod -R $MEDIA_DIR_PERMISSIONS $PROJECT_DIR/var
fi

# Set owner for media/etc/var directories
if [ ! -z "$MEDIA_DIR_OWNER" ] ; then
    echo "Changing media/etc/var directory owner to '$MEDIA_DIR_OWNER'..."
    chown -R $MEDIA_DIR_OWNER $PROJECT_DIR/media
    chown $MEDIA_DIR_OWNER    $PROJECT_DIR/app/etc/
    chown -R $MEDIA_DIR_OWNER $PROJECT_DIR/var
fi
