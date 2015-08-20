#!/usr/bin/env bash

if [ -z "$(ps -p $$ | grep " bash")" ] ; then
    echo "Sorry, this script can be run only with 'bash'."
    exit 1
fi
