#!/bin/sh
# (POSIX shell syntax)


OLD_DIR=$(pwd)
SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
cd "$SCRIPT_DIR"

. head.sh

script=""
while :
do
    case $1 in
        -h | --help)
            # Show some help
            out=$(cat ../doc/shell/logo)"\n"$(cat ../doc/shell/help)"\n"
            echo -e "$out"
            exit 0 # This is not an error, User asked help. Don't do "exit 1"
            ;;
        build)
            action="$1"
            shift 1
            script="build/build.sh"
            break
            ;;
        install)
            action="$1"
            shift 1
            script="install/install.sh"
            break
            ;;
        *)  # no more options. Stop while loop
            echo "Error: Please set an action."
            break
            ;;
    esac
done

if [ "$action" = "install" ] ; then
    # todo move this block into install/install.sh
    # parse extra install actions
    while :
    do
        case $1 in
            init)
                shift 1
                script="install/init.sh"
                ;;
            test)
                shift 1
                script="install/params-test.sh"
                ;;
            *)  # no more options. Stop while loop
                break
                ;;
        esac
    done
fi

bash "$SCRIPT_DIR/$script" $@

