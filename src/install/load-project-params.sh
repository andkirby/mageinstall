#!/usr/bin/env bash

# include custom params
if [ -f $(cd ~; pwd)"/.mageinstall/$PROJECT/params.sh" ] ; then
    . ~/.mageinstall/$PROJECT/params.sh
fi
