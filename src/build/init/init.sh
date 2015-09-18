#!/usr/bin/env bash

# Get parameters from user

while true; do
    . "$SRC_DIR/build/init/params/read.sh"

    # Write default composer.json file
    echo "Default composer.json:"
    echo "$json"

    dialog_yes_no result 'Is everything correct?'
    if [ -z "${result}" ]; then
        dialog_yes_no result 'Set parameters again?' 'y'
        if [ -z "${result}" ]; then
            die 'Interrupted.'
        else
            # Repeat settign parameters
            continue
        fi
    else
        break
    fi
done

. "$SRC_DIR/build/init/params/write.sh"
`
