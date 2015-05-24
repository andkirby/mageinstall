#!/bin/sh
OLD_DIR=$(pwd)
SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
cd "$SCRIPT_DIR"
. ../lib/function.sh
# include default params
. params.sh.dist

# get options from command line
. tools/getopt.sh

# load parameters
. load-params.sh

# ================= Code =================
echo "Go to directory $PROJECT_DIR..."

. magento-clean-up.sh

. magento-init-db.sh

. magento-sample-data.sh

. magento-install.sh

. magento-config.sh

# Import products
. "$SCRIPT_DIR"/tools/import.sh

cd "$OLD_DIR"
