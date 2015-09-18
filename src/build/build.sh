#!/usr/bin/env bash
# Main rebuild script
REBUILD_START=$(date +%s)

. "$SRC_DIR/build/lib/check-composer.sh"

. "$SRC_DIR"/build/build/project-clean-up.sh

# generate composer.json for a package
. "$SRC_DIR"/build/build/build-package-composer-json.sh

# install package w/o deploying
. "$SRC_DIR"/build/build/package-install.sh

binDir=$(cd $SRC_DIR/../bin/; pwd)
if [ "$PACKAGE_INSTALL_RUN" = "true" ] ; then
    user_message "Installing..." 0
    bash "$binDir/"mageshell install -p "$PROJECT" ${VERBOSITY_PARAM}
else
    user_message "Installation will be ignored. Clear cache only." 0
    bash "$binDir/"mageshell install -p "$PROJECT" -S --clear-cache 1 ${VERBOSITY_PARAM}
fi

END=$(date +%s)
DIFF=$(( $END - $REBUILD_START ))
user_message "Rebuild time: $DIFF seconds." 0
