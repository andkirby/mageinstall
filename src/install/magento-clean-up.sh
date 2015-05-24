#!/usr/bin/env bash

cd "$PROJECT_DIR"
# ======= Clean Up var Directory =======
echo "Cleaning up cache files and config file..."
if [ "$INSTALL_RUN" = true ] || ( [ "$SAMPLE_DATA_SQL_RUN" = true ] && [ -d "$SAMPLE_DATA_DIR" ] ) ; then
    rm -rf var/full_page_cache
    rm -rf var/cache
    rm -rf var/lock
    rm -rf var/log
fi
rm -rf var/session
if [ "$INSTALL_RUN" = true ] ; then
    rm -rf app/etc/local.xml
fi
rm -rf media/catalog/product/cache
echo "Clean up done."
