#!/bin/sh
SRC_DIR=$(cd `dirname "${BASH_SOURCE[0]}"` && cd .. && pwd)
cd "$SRC_DIR"

if [ ! -f ~/.mageinstall/params.sh ] ; then
    echo "Error: You have to initialize install params. Try 'mageshell install init'."
    exit 1
fi

# load functions
. "$SRC_DIR/lib/function.sh"

# include default params
. "$SRC_DIR/install/params.sh.dist"

# get CLI options
. "$SRC_DIR/build/lib/getopt.sh"

# include custom params
. "$SRC_DIR/install/load-params.sh"

if [ -f ~/.mageinstall/build/params.sh ] ; then
    . ~/.mageinstall/build/params.sh
fi

if [ ! -f ~/.mageinstall/build/composer.json ] ; then
    . "$SRC_DIR/build/lib/default-composer-json.sh"
fi

# init package dir
if [ -z "$PACKAGE_DIR" ] ; then
    PACKAGE_DIR=${PROJECT_DIR%/}"-package"
fi
if [ ! -d "$PACKAGE_DIR" ] ; then
    mkdir -p "$PACKAGE_DIR"
fi
if [ ! -d "$PACKAGE_DIR" ] ; then
    echo "Error: Cannot create directory '$PACKAGE_DIR'."
fi

# check Magento dir
if [ ! -d "$MAGENTO_DIR" ] ; then
    echo "Error: Magento directory '$MAGENTO_DIR' not found."
fi
if [ ! -f "$MAGENTO_DIR/app/Mage.php" ] ; then
    echo "Error: Directory '$MAGENTO_DIR' does not contain Magento scripts."
fi

# generate composer.json for a package
. "$SRC_DIR/build/lib/build-package-composer-json.sh"
