#!/bin/sh

# Dialog answer keys
[ -z ${DIALOG_YES_ANSWER} ] && DIALOG_YES_ANSWER='y'
[ -z ${DIALOG_NO_ANSWER} ] && DIALOG_NO_ANSWER='n'
readonly ${DIALOG_YES_ANSWER}
readonly ${DIALOG_NO_ANSWER}

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
    if (($# != 2)); then
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
    if [ -z ${verbosity} ]; then
        verbosity=${VERBOSITY_MODE['off']}
    fi

    echo "Error: ${1}"

    # show backtrace
    if [ ${verbosity} = ${VERBOSITY_MODE['debug']} ]; then
        local frame=0
        while caller "$frame"; do
            ((frame ++));
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

    if [ -z ${min_verbosity} ]; then
        min_verbosity=${VERBOSITY_MODE['off']}
    fi

    if [ -z ${verbosity} ]; then
        verbosity=${VERBOSITY_MODE['off']}
    fi

    if [ ${verbosity} -ge ${min_verbosity} ]; then
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
    if [ -z "${2}" ]; then
        die "Code: ${status}" ${status}
    fi
    exit ${status}
}

# Simple yes/no dialog question\
#
# e.g.: $(dialog_yes_no 'Would like repeat?' 'n' 3)
#
# string    Result variable name
# string question
# string default
# int mistakes_count = 3
# string yes_answer = 'y'
# string no_answer = 'n'
function dialog_yes_no {
    local question default max_mistakes_count mistakes_count \
        value \
        max_mistakes_count_default \
        yes_answer \
        no_answer
    local ___result

    if [ $# -lt 2 ]; then
        die "Improper dialog_yes_no() usage";
    fi

    # set question
    question=$2

    # default answer on empty input
    default="$3"

    # set yes/no answers
    yes_answer=$5
    no_answer=$6
    [ -z ${yes_answer} ] && yes_answer=${DIALOG_YES_ANSWER}
    [ -z ${no_answer} ] && no_answer=${DIALOG_NO_ANSWER}

    if [ -n "${default}" ]; then
        if [ "${default}" != "${no_answer}" ] && [ "${default}" != "${yes_answer}" ]; then
            die 'Default value does not mutch with answers.'
        fi
    fi

    # max mistakes
    value=$(( $4 + 0 ))
    max_mistakes_count=3 # default value
    max_mistakes_count=$(( 0 != ${value} ? ${value} : ${max_mistakes_count} ))

    mistake=0
    while true
    do
        [ ${mistake} -ge ${max_mistakes_count} ] && die 'Max mistakes succeed.'

        if [ -n "${default}" ]; then
            printf "${question} (${yes_answer}|${no_answer}) [${default}] : "
        else
            printf "${question} (${yes_answer}|${no_answer}) : "
        fi
        read answer

        [ -z ${answer} ] && answer=${default}

        case ${answer} in
            ${yes_answer})
                ___result=1
                break
            ;;
            ${no_answer})
                ___result=''
                break
            ;;
            *)
                ((mistake ++));
                continue
            ;;
        esac
    done

    eval $1=${___result}
}
