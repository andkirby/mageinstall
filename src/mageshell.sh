#!/bin/sh
# (POSIX shell syntax)

SRC_DIR=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
readonly SRC_DIR
cd "$SRC_DIR"

. lib/function.sh
. lib/check-bash.sh

if [ -z $1 ] ; then
    . help.sh
fi

while :
do
    case "$1" in
        -h | --help)
            . help.sh
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
            VERBOSITY_LEVEL=${VERBOSITY_MODE['silent']}
            VERBOSITY_PARAM="-l"
            shift 1
            ;;
        -v)
            VERBOSITY_LEVEL=${VERBOSITY_MODE['on']}
            VERBOSITY_PARAM="-v"
            shift 1
            ;;
        -vv)
            VERBOSITY_LEVEL=${VERBOSITY_MODE['very']}
            VERBOSITY_PARAM="-vv"
            shift 1
            ;;
        -vvv)
            VERBOSITY_LEVEL=${VERBOSITY_MODE['debug']}
            VERBOSITY_PARAM="-vvv"
            shift 1
            ;;
        *)  # no more options. Stop while loop
            die "Unknown action '$1'. Please use help: mageshell --help"
            ;;
    esac
done

. head.sh

user_message "Opening ${script}..." 3
. ${SRC_DIR}/${script}

