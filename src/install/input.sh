#!/usr/bin/env bash
# (POSIX shell syntax)

# parse extra install actions
while :
do
    case $1 in
        init)
            shift 1
            script="set-params.sh"
            break
            ;;
        test)
            shift 1
            script="params-test.sh"
            ;;
        *)  # no more options. Stop while loop
            script="run.sh"
            break
            ;;
    esac
done

. "$SRC_DIR/install/$script"
