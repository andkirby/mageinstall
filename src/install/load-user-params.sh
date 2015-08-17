#!/usr/bin/env bash

# include custom params
if [ -f $(cd ~; pwd)"/.mageinstall/params.sh" ] ; then
    . ~/.mageinstall/params.sh
else
    . "$SRC_DIR/install/"set-params.sh
    die "Please run install script again."
fi
