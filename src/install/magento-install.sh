#!/usr/bin/env bash

cd "$PROJECT_DIR"
# ======== Install Magento ========
if [ "$INSTALL_RUN" = true ]
then
    # Set permissions
    # Set owner for all files
    if [ ! -z "${PROJECT_DIR_OWNER}" ] ; then
        echo "Changing project directory owner to '$PROJECT_DIR_OWNER'..."
        chown -R $PROJECT_DIR_OWNER $PROJECT_DIR
    fi

    echo "Changing media/etc/var directory permissions to '$MEDIA_DIR_PERMISSIONS'..."
    chmod -R $MEDIA_DIR_PERMISSIONS $PROJECT_DIR/media
    chmod $MEDIA_DIR_PERMISSIONS    $PROJECT_DIR/app/etc/
    chmod -R $MEDIA_DIR_PERMISSIONS $PROJECT_DIR/var

    if [ ! -z "$MEDIA_DIR_OWNER" ] ; then
        echo "Changing media/etc/var directory owner to '$MEDIA_DIR_OWNER'..."
        chown -R $MEDIA_DIR_OWNER $PROJECT_DIR/media
        chown $MEDIA_DIR_OWNER    $PROJECT_DIR/app/etc/
        chown -R $MEDIA_DIR_OWNER $PROJECT_DIR/var
    fi

    echo "Start installing Magento..."
    if [ ! -f "$PROJECT_DIR/install.php" ] ; then
        die "There are no Magento files."
    fi

    START=$(date +%s)
    RESULT=$($PHP_BIN -f "$SRC_DIR"/install/lib/install.php -- \
            "$PROJECT_DIR" \
            --license_agreement_accepted "yes" \
            --locale "en_US" \
            --timezone "America/Los_Angeles" \
            --default_currency "USD" \
            --db_host "$DB_HOST" \
            --db_name "$DB_NAME" \
            --db_user "$DB_USER" \
            --db_pass "$DB_PASSWORD" \
            --url "http://$PROJECT_DOMAIN/" \
            --use_rewrites "$USE_REWRITES" \
            --use_secure "yes" \
            --secure_base_url "$PROTOCOL_SECURED://$PROJECT_DOMAIN/" \
            --use_secure_admin "yes" \
            --admin_firstname "Admin" \
            --admin_lastname "MageInstall" \
            --admin_email "$ADMIN_EMAIL" \
            --admin_username "$ADMIN_USERNAME" \
            --admin_password "$ADMIN_PASSWORD" \
            --skip_url_validation "yes" 2>&1)

    END=$(date +%s)
    DIFF=$(( $END - $START ))

    echo "$RESULT";
    TEST=$(echo $RESULT | grep "SUCCESS" 2>&1);
    if [ "$TEST" ] ; then
        echo "Magento has been installed for domain http://$PROJECT_DOMAIN/."
        echo "Installing took $DIFF seconds."
    else
        echo "Magento installation failed."
        exit 1
    fi
fi
