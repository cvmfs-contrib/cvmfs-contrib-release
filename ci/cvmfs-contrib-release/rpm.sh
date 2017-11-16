#!/bin/sh

#
# This script builds the cvmfs-release RPM for CernVM-FS.
#

set -e

SCRIPT_LOCATION=$(cd "$(dirname "$0")"; pwd)

if [ $# -lt 2 ]; then
  echo "Usage: $0 <CernVM-FS source directory> <build result location>"
  echo "This script builds the CernVM-FS release RPM package"
  exit 1
fi

CVMFS_SOURCE_LOCATION="$1"
CVMFS_RESULT_LOCATION="$2"

echo "preparing the build environment in ${CVMFS_RESULT_LOCATION}..."
for d in BUILD RPMS SOURCES SRPMS TMP; do
  mkdir ${CVMFS_RESULT_LOCATION}/${d}
done

echo "copying the files to be packaged in place..."
version=$(cat ${CVMFS_SOURCE_LOCATION}/rpm/cvmfs-contrib-release.spec | grep ^Version: | awk '{print $2}')
(cd ${CVMFS_SOURCE_LOCATION} && \
  git archive -v --prefix cvmfs-contrib-release-${version}/ --format tar HEAD \
  | gzip -c > ${CVMFS_RESULT_LOCATION}/SOURCES/cvmfs-contrib-release-${version}.tar.gz)

echo "switching to ${CVMFS_RESULT_LOCATION}..."
cd $CVMFS_RESULT_LOCATION

# Make RPM
echo "Building cvmfs-release..."
rpmbuild --define "%_topdir $CVMFS_RESULT_LOCATION"        \
         --define "%_tmppath ${CVMFS_RESULT_LOCATION}/TMP" \
         -ba ${CVMFS_SOURCE_LOCATION}/rpm/cvmfs-contrib-release.spec
