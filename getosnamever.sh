#!/bin/sh
# Get the OS name and version.  Assumes /etc/os-release exists.  Only
#  tested in Debian-based systems.

. /etc/os-release
BASENAME="`echo "$NAME"|awk '{print $1}'`"
BASEVER="`echo "$VERSION_ID"|cut -d. -f1`"
case "$BASENAME" in
    Ubuntu) SUBVER="04";;
    *)      SUBVER="0";;
esac
echo "${BASENAME}_${BASEVER}.${SUBVER}"
