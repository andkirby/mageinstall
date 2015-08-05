#!/usr/bin/env bash
composer -V >/dev/null 2>&1 || die "Looks like composer was not installed in the system."
