#!/usr/bin/env bash
# Main rebuild script
REBUILD_START=$(date +%s)

. "$SRC_DIR"/build/lib/project-clean-up.sh

. "$SRC_DIR"/build/lib/install-integrator.sh

. "$SRC_DIR"/build/lib/package-install.sh

binDir=$(cd $SRC_DIR/../bin/; pwd)
bash "$binDir/"mageshell install -p "$PROJECT" -i "$INSTALL_RUN" "$INSTALL_PARAMS"

END=$(date +%s)
DIFF=$(( $END - $REBUILD_START ))
echo "Rebuild time: $DIFF seconds."
