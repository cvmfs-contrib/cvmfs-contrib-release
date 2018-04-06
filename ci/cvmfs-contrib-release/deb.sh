#!/bin/sh

#
# This script builds the cvmfs-config-release package for debian.
#

set -e

SCRIPT_LOCATION=$(cd "$(dirname "$0")"; pwd)

die() {
  local msg="$1"
  echo "$msg"
  exit 1
}

if [ $# -lt 2 ]; then
  echo "Usage: $0 <CernVM-FS source directory> <build result location>"
  echo "This script builds the default CernVM-FS debian configuration package"
  exit 1
fi

CVMFS_SOURCE_LOCATION="$1"
CVMFS_RESULT_LOCATION="$2"

echo "switching to the debian source directory..."
cd ${CVMFS_SOURCE_LOCATION}/debian

# read the version number from the rpm spec file
PKG="`sed -n 's/^Source: //p' control`"
SPECFILE="../rpm/$PKG.spec"
RPMREL="$(grep '^%define release_prefix' $SPECFILE | awk '{print $3}')"
if [ -z "$RPMREL" ]; then
    RPMREL="$(grep '^Release:' $SPECFILE | awk '{print $2}' | cut -d% -f1)"
fi
VERSION="$(grep ^Version: $SPECFILE | awk '{print $2}').$RPMREL"
echo "setting version number to $VERSION"
dch -v $VERSION -M "bumped version number"

echo "running the debian package build..."
debuild --no-lintian --no-tgz-check -us -uc # -us -uc == skip signing
mv ${CVMFS_SOURCE_LOCATION}/../cvmfs-contrib-release_* ${CVMFS_RESULT_LOCATION}/

echo "switching back to the source directory..."
cd ${CVMFS_SOURCE_LOCATION}

