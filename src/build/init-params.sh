#!/usr/bin/env bash

# init package dir
if [ -z "$PACKAGE_DIR" ] ; then
    PACKAGE_DIR=${PROJECT_DIR%/}"-package"
fi
if [ ! -d "$PACKAGE_DIR" ] ; then
    mkdir -p "$PACKAGE_DIR"
fi
if [ ! -d "$PACKAGE_DIR" ] ; then
    die "Cannot create directory '$PACKAGE_DIR'."
fi
if [ ! -d "$PROJECT_DIR" ] ; then
    mkdir -p "$PROJECT_DIR"
fi
if [ ! -d "$PROJECT_DIR" ] ; then
    die "Cannot create directory '$PROJECT_DIR'."
fi

# check Magento dir
if [ -z "$MAGENTO_DIR" ] ; then
    die "Parameter -m|--magento-source-dir is required."
fi
if [ ! -d "$MAGENTO_DIR" ] ; then
    die "Magento directory '$MAGENTO_DIR' not found."
fi
if [ ! -f "$MAGENTO_DIR/app/Mage.php" ] ; then
    die "Directory '$MAGENTO_DIR' does not contain Magento scripts."
fi
# check package
if [ -z "$PACKAGE" ] ; then
    die "Package is required (-g | --package). Composer format 'vendor/pkg_name:version'. Version is optional."
fi
# check Magento files refreshing
if [ "$REFRESH_ALL" = "true" ] && [ "$PACKAGE_INSTALL_RUN" = "false" ] ; then
    die "Magento files cannot be refreshed without installing."
fi
# set prefer stable to TRUE by default
if [ -z "$PACKAGE_PREFER_STABLE" ] ; then
    PACKAGE_PREFER_STABLE=true
fi
# set timeout for composer processes (need more higher to clone big repositories)
if [ -z "$COMPOSER_PROCESS_TIMEOUT" ] ; then
    COMPOSER_PROCESS_TIMEOUT=600
fi
