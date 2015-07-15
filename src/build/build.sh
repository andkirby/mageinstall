#!/usr/bin/env bash
# Main rebuild script
REBUILD_START=$(date +%s)

. "$SRC_DIR/lib/function.sh"

. "$SRC_DIR"/build/lib/project-clean-up.sh

# generate composer.json for a package
. "$SRC_DIR"/build/lib/build-package-composer-json.sh

# install package w/o deploying
. "$SRC_DIR"/build/lib/package-install.sh

binDir=$(cd $SRC_DIR/../bin/; pwd)
if [ "$PACKAGE_INSTALL_RUN" = "true" ] ; then
    bash "$binDir/"mageshell install -p "$PROJECT"
else
    echo "Ignore installing."
    bash "$binDir/"mageshell install -p "$PROJECT" -S
fi

END=$(date +%s)
DIFF=$(( $END - $REBUILD_START ))
echo "Rebuild time: $DIFF seconds."
