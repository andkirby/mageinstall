#!/usr/bin/env bash
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

if [ -f ~/.mageinstall/build/params.sh ] ; then
    . ~/.mageinstall/build/params.sh
fi

# get CLI options
. "$SRC_DIR/build/lib/getopt.sh"

# ignore validating project variables
# TODO remove hack
ignoreValidateProjectParams='1'

# include custom params
. "$SRC_DIR/install/load-params.sh"

if [ "$skipDefaultComposerJson" != "true" ] || [ ! -f ~/.mageinstall/build/composer.json ] ; then
    . "$SRC_DIR/build/lib/default-composer-json.sh"
fi

