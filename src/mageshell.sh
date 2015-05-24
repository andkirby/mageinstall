#!/bin/sh
# (POSIX shell syntax)

OLD_DIR=$(pwd)
SRC_DIR=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
cd "$SRC_DIR"

. head.sh
. lib/check-bash.sh

action="$1"
if [ -z "$action" ] ; then
    action="-h"
fi

script=""
while :
do
    case "$action" in
        -h | --help)
            # Show some help
            out=$(cat $SRC_DIR/../doc/shell/logo)"\n"$(cat $SRC_DIR/../doc/shell/help)"\n"
            echo -e "$out"
            exit 0 # This is not an error, User asked help. Don't do "exit 1"
            ;;
        build)
            shift 1
            script="build/build.sh"
            break
            ;;
        install)
            shift 1
            script="install/input.sh"
            break
            ;;
        *)  # no more options. Stop while loop
            echo "Error: Unknown action '$action'. Please use help: mageshell --help"
            exit 1
            ;;
    esac
done
bash "$SRC_DIR/$script" $@

