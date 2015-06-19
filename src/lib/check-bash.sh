#!/usr/bin/env bash

if [ -z "$(ps -p $$ | grep " bash")" ] ; then
    die "Sorry, this script can be run only with 'bash'."
fi
