#!/usr/bin/env bash

echo "$json" > ~/.mageinstall/build/composer.json

# Write ~/.mageinstall/build/composer.json
user_message "Writing parameters into ~/.mageinstall/build/params.sh..." 1
( IFS=$'\n'; echo "${filledParams[*]}" ) > ~/.mageinstall/build/params.sh



