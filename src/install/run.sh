#!/bin/bash
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
full_start=$(date +%s)
user_message "Magento Installation." 0

user_message "Go to directory $PROJECT_DIR..." 2

# TODO document this feature
# Run custom shell script from sample data directory
# TODO Add a parameter to prevent this action
. "$SRC_DIR/install/"custom-start.sh

. "$SRC_DIR/install/"magento-clean-up.sh

. "$SRC_DIR/install/"magento-init-db.sh

. "$SRC_DIR/install/"magento-sample-data.sh

. "$SRC_DIR/install/"magento-permissions.sh

. "$SRC_DIR/install/"magento-install.sh

. "$SRC_DIR/install/"magento-config.sh

# Import products
. "$SRC_DIR/install/"lib/import.sh

. "$SRC_DIR/install/"custom-end.sh

end=$(date +%s)
diff=$(( $end - ${full_start} ))
user_message "Time (whole install): $diff seconds." 0
