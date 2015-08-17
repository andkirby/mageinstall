#!/usr/bin/env bash
# Main rebuild script
REBUILD_START=$(date +%s)

. "$SRC_DIR/lib/function.sh"

. "$SRC_DIR/build/lib/check-composer.sh"

. "$SRC_DIR"/build/lib/project-clean-up.sh

# generate composer.json for a package
. "$SRC_DIR"/build/lib/build-package-composer-json.sh

# install package w/o deploying
. "$SRC_DIR"/build/lib/package-install.sh

binDir=$(cd $SRC_DIR/../bin/; pwd)
if [ "$PACKAGE_INSTALL_RUN" = "true" ] ; then
    echo "Installing..."
    bash "$binDir/"mageshell install -p "$PROJECT" ${VERBOSITY_PARAM}
else
    echo "Installation will be ignored. Clear cache only."
    bash "$binDir/"mageshell install -p "$PROJECT" -S -a 1 ${VERBOSITY_PARAM}
fi

END=$(date +%s)
DIFF=$(( $END - $REBUILD_START ))
echo "Rebuild time: $DIFF seconds."
