#!/usr/bin/env bash
# include custom params
if [ -f $(cd ~; pwd)"/.mageinstall/params.sh" ] ; then
    . ~/.mageinstall/params.sh
else
    . set-params.sh
    echo "Please run install script again."
    exit 1
fi
# reset param into boolean
. tools/set-boolean.sh

# include addintional params
if [ -f "~/params-protected.sh" ]
then
    . params-protected.sh
else
    . params-protected.sh.dist
fi

if [ -z "$PROJECT" ] ; then
   echo "Please set project name."
   exit 1
fi

if [ -z "$ADMIN_EMAIL" ] ; then
   echo "Please set admin email."
   exit 1
fi
if [ ! -d "$PROJECT_DIR" ] ; then
    echo "Directory $PROJECT_DIR does not exist."
    exit 1
fi
