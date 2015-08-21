#!/bin/sh

# set verbosity modes
declare -A VERBOSITY_MODE
VERBOSITY_MODE['silent']=-1
VERBOSITY_MODE['off']=0
VERBOSITY_MODE['on']=1
VERBOSITY_MODE['very']=2
VERBOSITY_MODE['debug']=3
readonly VERBOSITY_MODE

# Set boolean value to a variable
function setBoolean {
    local v
    if (( $# != 2 )); then
        die "Improper setBoolean() usage";
    fi

    case "$2" in
        TRUE | true | yes | YES | 1) v=true ;;
        FALSE | false | no | NO | 0 | "") v=false ;;
        *) die "Unknown boolean value \"$2\". Please use 'true|false' or 'yes|no' or '1|0' or '' for 'false'.";
            ;;
    esac

    eval $1=$v
}

# Show message and exit
function die {
    local error_code verbosity

    verbosity=${VERBOSITY_LEVEL}
    if [ -z ${verbosity} ] ; then
        verbosity=${VERBOSITY_MODE['off']}
    fi

    echo "Error: ${1}"

    # show backtrace
    if [ ${verbosity} = ${VERBOSITY_MODE['debug']} ] ; then
        local frame=0
        while caller "$frame"; do
            ((frame++));
        done
    fi

    error_code=1
    if [ "${2}" ] && [ ${2} -ge 1 ]; then
        error_code=${2}
    fi
    exit ${error_code}
}

# Show user message based upon verbosity level
function user_message {
    local min_verbosity message verbosity

    verbosity=${VERBOSITY_LEVEL}
    message=${1}
    min_verbosity=${2}

    if [ -z ${min_verbosity} ] ; then
        min_verbosity=${VERBOSITY_MODE['off']}
    fi

    if [ -z ${verbosity} ] ; then
        verbosity=${VERBOSITY_MODE['off']}
    fi

    if [ ${verbosity} -ge ${min_verbosity} ] ; then
        printf "${message}\n"
    fi
}

# Function to check status code of executed command
function check_status {
    local status
    status=$1
    if [ ${status} = 0 ]; then
        return
    elif [ ${status} = 130 ]; then
        die "Exit." 130
    elif [ -z "${status}" ]; then
        die "Status code is not set."
    fi
    if [ -z "${2}" ] ; then
        die "Code: ${status}" ${status}
    fi
    exit ${status}
}
