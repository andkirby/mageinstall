#!/bin/sh
# (POSIX shell syntax)
. "$SRC_DIR/lib/function.sh"
params=(\
INSTALL_RUN \
IMPORT_RUN \
CLEAR_CACHE \
SAMPLE_DATA_CONFIG_RUN \
SAMPLE_DATA_SQL_RUN \
SAMPLE_DATA_MEDIA_RUN\
)

for key in "${params[@]}" ; do
    setBoolean "$key" ${!key}
done
