#!/bin/bash
SRC_DIR=$(cd `dirname "${BASH_SOURCE[0]}"` && cd .. && pwd)
cd "$SRC_DIR"


. "$SRC_DIR/lib/function.sh"


# include default params
. "$SRC_DIR/install/"params.sh.dist

# load user parameters
. "$SRC_DIR/install/"load-user-params.sh

# get options from command line
. "$SRC_DIR/install/"lib/getopt.sh

# load parameters
. "$SRC_DIR/install/"load-params.sh

# load project specific parameters
. "$SRC_DIR/install/"load-project-params.sh

# ================= Code =================
user_message "Magento Installation." 0

user_message "Go to directory $PROJECT_DIR..." 2

. "$SRC_DIR/install/"magento-clean-up.sh

. "$SRC_DIR/install/"magento-init-db.sh

. "$SRC_DIR/install/"magento-sample-data.sh

. "$SRC_DIR/install/"magento-permissions.sh

. "$SRC_DIR/install/"magento-install.sh

. "$SRC_DIR/install/"magento-config.sh

# Import products
. "$SRC_DIR/install/"lib/import.sh
