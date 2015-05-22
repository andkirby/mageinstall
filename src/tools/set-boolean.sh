#!/bin/sh
# (POSIX shell syntax)
. tools/function.sh
params=(\
INSTALL_RUN \
IMPORT_RUN \
SAMPLE_DATA_CONFIG_RUN \
SAMPLE_DATA_SQL_RUN \
SAMPLE_DATA_MEDIA_RUN\
)

for key in "${params[@]}" ; do
    setBoolean "$key" ${!key}
done
