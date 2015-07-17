#!/usr/bin/env bash

cd "$PROJECT_DIR"
cleaned=false
# ======= Clean Up var Directory =======
if [ "$INSTALL_RUN" = true ] || [ "$CLEAR_CACHE" = true ] || ( [ "$SAMPLE_DATA_SQL_RUN" = true ] && [ -d "$SAMPLE_DATA_DIR" ] ) ; then
    echo "Cleaning up cache files..."
    rm -rf var/full_page_cache
    rm -rf var/cache
    rm -rf var/lock
    rm -rf var/log

    # clean up product images cache
    rm -rf media/catalog/product/cache

    # clean up JS & CSS cache
    rm -rf media/js/*
    rm -rf media/css/*

    rm -rf var/session

    cleaned=true
fi
if [ "$INSTALL_RUN" = true ] ; then
    echo "Removing local.xml..."
    rm -rf app/etc/local.xml
    cleaned=true
fi
if [ "$cleaned" = true ] ; then
    echo "Clean up done."
fi
