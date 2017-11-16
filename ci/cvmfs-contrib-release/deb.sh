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

# sanity checks
[ ! -d ${CVMFS_SOURCE_LOCATION}/debian ]   || die "source directory seemed to be built before (${CVMFS_SOURCE_LOCATION}/debian exists)"
[ ! -f ${CVMFS_SOURCE_LOCATION}/Makefile ] || die "source directory seemed to be built before (${CVMFS_SOURCE_LOCATION}/Makefile exists)"

echo "switching to the debian source directory..."
cd ${CVMFS_SOURCE_LOCATION}/debian

echo "running the debian package build..."
debuild --no-tgz-check -us -uc # -us -uc == skip signing
mv ${CVMFS_SOURCE_LOCATION}/../cvmfs-config-release_* ${CVMFS_RESULT_LOCATION}/

echo "switching back to the source directory..."
cd ${CVMFS_SOURCE_LOCATION}

