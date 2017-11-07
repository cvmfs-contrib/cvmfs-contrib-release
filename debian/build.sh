#!/bin/sh

set -e

#
# This script used for package creation and debugging
#

PKG=cvmfs-contrib-release

usage() {
  echo "Sample script that builds the $PKG debian package from source"
  echo "Usage: $0"
  exit 1
}

if [ $# -ne 0 ]; then
  usage
fi

workdir=/tmp/build-$PKG
srctree=$(readlink --canonicalize ../..)

if [ "$(ls -A $workdir 2>/dev/null)" != "" ]; then
  echo "$workdir must be empty"
  exit 2
fi

echo -n "creating workspace in $workdir... "
mkdir -p ${workdir}/tmp ${workdir}/src ${workdir}/result
echo "done"

echo -n "copying source tree to $workdir/tmp... "
cp -R $srctree/* ${workdir}/tmp
echo "done"

echo -n "initializing build environment... "
mkdir ${workdir}/src/$PKG
cp -R $srctree/* ${workdir}/src/$PKG
mkdir ${workdir}/src/$PKG/debian
cp -R ${workdir}/tmp/debian/* ${workdir}/src/$PKG/debian
echo "done"

echo -n "figuring out version number from rpm packaging... "
upstream_version="`sed -n 's/^Version: //p' ../rpm/$PKG.spec`"
upstream_release="`sed -n 's/^Release: \([^%]*\).*/\1/p' ../rpm/$PKG.spec`"
echo "done: $upstream_version.$upstream_release"

echo "building..."
cd ${workdir}/src/$PKG
dch -v $upstream_version.$upstream_release -M "set upstream version number"

cd debian
pdebuild --buildresult ${workdir}/result -- --save-after-exec --debug

echo "Results are in ${workdir}/result"
