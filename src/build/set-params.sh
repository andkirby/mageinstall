#!/usr/bin/env bash

if [ ! -f ~/.mageinstall/params.sh ] ; then
    die "You have to initialize install params. Try 'mageshell install init'."
fi

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

# load params
. "$SRC_DIR/install/load-user-params.sh"
. "$SRC_DIR/install/load-params.sh"

if [ "$skipDefaultComposerJson" != "true" ] || [ ! -f ~/.mageinstall/build/composer.json ] ; then
    . "$SRC_DIR/build/lib/default-composer-json.sh"
fi

