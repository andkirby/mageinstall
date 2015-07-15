#!/usr/bin/env bash

# reset param into boolean
. "$SRC_DIR/install/lib/set-boolean.sh"

# include addintional params
if [ -f "~/params-protected.sh" ]
then
    . "$SRC_DIR/install/params-protected.sh"
else
    . "$SRC_DIR/install/params-protected.sh.dist"
fi

if [ -z "$ignoreValidateProjectParams" ] ; then
    if [ -z "$PROJECT" ] ; then
       echo "Please set project name."
       exit 1
    fi

    if [ ! -d "$PROJECT_DIR" ] ; then
        echo "Directory $PROJECT_DIR does not exist."
        exit 1
    fi
fi

if [ -z "$ADMIN_EMAIL" ] ; then
   echo "Please set admin email."
   exit 1
fi
