#!/usr/bin/env bash
# (POSIX shell syntax)

SRC_DIR=$(cd `dirname "${BASH_SOURCE[0]}"` && cd .. && pwd)
cd "$SRC_DIR"

# parse extra install actions
while :
do
    case $1 in
        init)
            shift 1
            script="set-params.sh"
            break
            ;;
        *)  # no more options. Stop while loop
            script="build.sh"
            break
            ;;
    esac
done

bash "$SRC_DIR/build/$script" $@
