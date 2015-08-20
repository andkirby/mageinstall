#!/bin/sh
# (POSIX shell syntax)

OLD_DIR=$(pwd)
SRC_DIR=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
cd "$SRC_DIR"

. head.sh
. lib/function.sh
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
            script="build/input.sh"
            break
            ;;
        install)
            shift 1
            script="install/input.sh"
            break
            ;;
        -l | --silent)
            VERBOSITY_LEVEL=-1
            VERBOSITY_PARAM="-l"
            shift 1
            ;;
        -v)
            VERBOSITY_LEVEL=1
            VERBOSITY_PARAM="-v"
            shift 1
            ;;
        -vv)
            VERBOSITY_LEVEL=2
            VERBOSITY_PARAM="-vv"
            shift 1
            ;;
        -vvv)
            VERBOSITY_LEVEL=3
            VERBOSITY=true
            VERBOSITY_PARAM="-vvv"
            shift 1
            ;;
        *)  # no more options. Stop while loop
            die "Unknown action '$action'. Please use help: mageshell --help"
            ;;
    esac
done
bash "$SRC_DIR/$script" $@

