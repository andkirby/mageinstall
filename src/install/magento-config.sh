#!/usr/bin/env bash

# Add sample data configuration into Magento instance
if [ "$SAMPLE_DATA_CONFIG_RUN" = true ] && [ -d "$SAMPLE_DATA_DIR" ]
then
    for FILE_INI in "$SAMPLE_DATA_DIR"/*.csv; do
        if [ ${FILE_INI} = "$SAMPLE_DATA_DIR"/*.csv ] ; then
            break
        fi
        user_message "Applying configuration from file $FILE_INI..." 1
        $PHP_BIN -f "$SRC_DIR/install/lib/config.php" "$FILE_INI"
    done
fi

# Add project configuration into Magento instance
if [ "$PROJECT_CONFIG_RUN" = true ] && [ -d "$PROJECT_CONFIG_DIR" ]
then
    for FILE_INI in $(find $PROJECT_CONFIG_DIR -name "*.csv" | sort); do
        if [ ${FILE_INI} = "*.csv" ] ; then
            break
        fi
        user_message "Applying configuration from file $FILE_INI..." 1
        $PHP_BIN -f "$SRC_DIR/install/lib/config.php" "$FILE_INI"
    done
fi
