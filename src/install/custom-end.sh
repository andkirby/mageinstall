#!/usr/bin/env bash

cd "$PROJECT_DIR"
# Run php script before
if [ -f "$SAMPLE_DATA_DIR/scripts/install/post-install.sh" ] ; then
    user_message "Running post-install.sh..." 1
    . "$SAMPLE_DATA_DIR/scripts/install/post-install.sh"
fi
