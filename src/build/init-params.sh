#!/usr/bin/env bash

# init package dir
if [ -z "$PACKAGE_DIR" ] ; then
    PACKAGE_DIR=${PROJECT_DIR%/}"-package"
fi
if [ ! -d "$PACKAGE_DIR" ] ; then
    mkdir -p "$PACKAGE_DIR"
fi
if [ ! -d "$PACKAGE_DIR" ] ; then
    echo "Error: Cannot create directory '$PACKAGE_DIR'."
    exit 1
fi

# check Magento dir
if [ -z "$MAGENTO_DIR" ] ; then
    echo "Error: Parameter -m|--magento-source-dir is required."
    exit 1
fi
if [ ! -d "$MAGENTO_DIR" ] ; then
    echo "Error: Magento directory '$MAGENTO_DIR' not found."
    exit 1
fi
if [ ! -f "$MAGENTO_DIR/app/Mage.php" ] ; then
    echo "Error: Directory '$MAGENTO_DIR' does not contain Magento scripts."
    exit 1
fi
# check package
if [ -z "$PACKAGE" ] ; then
    echo "Error: Package is required (-g | --package). Composer format 'vendor/pkg_name:version'. Version is optional."
    exit 1
fi
# check Magento files refreshing
if [ "$MAGENTO_REFRESH" = "true" ] && [ "$INSTALL_RUN" = "false" ] ; then
    echo "Error: Magento files cannot be refreshed without installing."
    exit 1
fi
