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
