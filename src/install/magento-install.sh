#!/usr/bin/env bash

cd "$PROJECT_DIR"
# ======== Install Magento ========
if [ "$INSTALL_RUN" = true ]
then
    user_message "Start installing Magento..." 0
    if [ ! -f "$PROJECT_DIR/install.php" ] ; then
        die "There are no Magento files."
    fi

    start=$(date +%s)
    result=$($PHP_BIN -f "$SRC_DIR"/install/lib/install.php -- \
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

    status=$?

    end=$(date +%s)
    diff=$(( $end - $start ))

    # show result
    user_message "$result" 0

    if [ ${status} != 0 ] ; then
        die "Magento installation failed."
    fi
    user_message "Magento has been installed for domain http://$PROJECT_DOMAIN/." 0
    user_message "Installing took $diff seconds." 0
fi
