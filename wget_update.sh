#!/bin/sh
SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
wget --no-check-certificate https://github.com/andkirby/mageinstall/archive/master.tar.gz -O $SCRIPT_DIR"/master.tar.gz"
tar -xvzf $SCRIPT_DIR"/master.tar.gz" mageinstall-master
bash -c "cp -R "$SCRIPT_DIR"/mageinstall-master/* "$SCRIPT_DIR
bash -c "rm -rf "$SCRIPT_DIR"/mageinstall-master"
bash -c "rm -rf "$SCRIPT_DIR"/master.tar.gz"
