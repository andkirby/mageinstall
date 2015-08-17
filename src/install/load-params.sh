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
       die "Please set project name."
    fi

    if [ ! -d "$PROJECT_DIR" ] ; then
        die "Directory $PROJECT_DIR does not exist."
    fi
fi

if [ -z "$ADMIN_EMAIL" ] ; then
   die "Please set admin email."
fi
