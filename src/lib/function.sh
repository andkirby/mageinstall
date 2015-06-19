#!/bin/sh
# Boolean function
function setBoolean {
    local v
    if (( $# != 2 )); then
     echo "Error: Improper setBoolean() usage" 1>&2; exit 1 ;
    fi

    case "$2" in
        TRUE | true | yes | YES | 1) v=true ;;
        FALSE | false | no | NO | 0 | "") v=false ;;
        *) echo "Error: Unknown boolean value \"$2\". Please use 'true|false' or 'yes|no' or '1|0' or '' for 'false'." 1>&2; exit 1 ;;
    esac

    eval $1=$v
}
