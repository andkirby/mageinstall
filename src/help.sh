#!/bin/sh
# (POSIX shell syntax)

# Show some help
out=$(cat $SRC_DIR/../doc/shell/logo)"\n"$(cat $SRC_DIR/../doc/shell/help)"\n"
echo -e "$out"
exit 0 # This is not an error, User asked help. Don't do "exit 1"
