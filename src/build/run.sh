#!/bin/sh

# generate composer.json for a package
skipDefaultComposerJson="true"
. "$SRC_DIR/build/set-params.sh"

. "$SRC_DIR/build/init-params.sh"

# building
. "$SRC_DIR/build/build.sh"
