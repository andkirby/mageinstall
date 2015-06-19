#!/usr/bin/env bash
# Main rebuild script
REBUILD_START=$(date +%s)

. "$SRC_DIR/lib/function.sh"

. "$SRC_DIR"/build/lib/project-clean-up.sh

# generate composer.json for a package
. "$SRC_DIR"/build/lib/build-package-composer-json.sh

. "$SRC_DIR"/build/lib/install-integrator.sh

# install package w/o deploying
. "$SRC_DIR"/build/lib/package-install.sh

# Deploying
. "$SRC_DIR"/build/lib/make-deploy-composer-json.sh
. "$SRC_DIR"/build/lib/package-deploy.sh

binDir=$(cd $SRC_DIR/../bin/; pwd)
if [ "$INSTALL_RUN" = "true" ] ; then
    bash "$binDir/"mageshell install -p "$PROJECT"
else
    bash "$binDir/"mageshell install -p "$PROJECT" -S
fi

END=$(date +%s)
DIFF=$(( $END - $REBUILD_START ))
echo "Rebuild time: $DIFF seconds."
