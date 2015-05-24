#!/usr/bin/env bash
# Add configuration into Magento instance
if [ "$SAMPLE_DATA_CONFIG_RUN" = true ] && [ -d "$SAMPLE_DATA_DIR" ]
then
    for FILE_INI in "$SAMPLE_DATA_DIR"/*.csv; do
        echo "Applying configuration from file $FILE_INI..."
        $PHP_BIN -f "$SCRIPT_DIR"/lib/config.php "$FILE_INI"
    done
fi
