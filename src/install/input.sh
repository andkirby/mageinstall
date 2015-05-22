#!/usr/bin/env bash
# (POSIX shell syntax)

SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
cd "$SCRIPT_DIR"

# parse extra install actions
while :
do
    case $1 in
        init)
            shift 1
            script="init.sh"
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

bash "$SCRIPT_DIR/$script" $@
