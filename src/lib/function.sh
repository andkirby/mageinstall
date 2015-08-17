#!/bin/sh
# Boolean function
function setBoolean {
    local v
    if (( $# != 2 )); then
        die "Improper setBoolean() usage" 1>&2;
    fi

    case "$2" in
        TRUE | true | yes | YES | 1) v=true ;;
        FALSE | false | no | NO | 0 | "") v=false ;;
        *) die "Unknown boolean value \"$2\". Please use 'true|false' or 'yes|no' or '1|0' or '' for 'false'." 1>&2;
            ;;
    esac

    eval $1=$v
}

function die {
    echo "Error: $*"
    echo "$VERBOSITY_VERY_VERY"
    if [ "$VERBOSITY_VERY_VERY" = "true" ] ; then
        local frame=0
        while caller "$frame"; do
            ((frame++));
        done
    fi
    exit 1
}

function user_message {
    local level message
    message=${1}
    level=${2}
    if [ -z ${level} ] ; then
        level=0
    fi
    if [ ${VERBOSITY_LEVEL} -ge ${level} ] ; then
        printf "${message}\n"
    fi
}
