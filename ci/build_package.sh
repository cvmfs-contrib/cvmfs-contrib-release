#!/bin/sh

#
# This script builds a package that fits the current platform using custom build
# scripts for each package type and package. It depends on the following
# build script convention:
#
#   * build scripts must be placed in sub directories of ci/
#   * it must be named after the package it builds (i.e. rpm.sh builds an RPM)
#   * the first two arguments must be 1:SOURCE_LOCATION and 2:BUILD_DESTINATION
#     * optional arguments can follow and are passed through by this script
#   * it must be an executable script
#

set -e

SCRIPT_LOCATION=$(cd "$(dirname "$0")"; pwd)

if [ $# -lt 3 ]; then
  echo "Usage: $0 <source directory> <build result location> [<optional parameters>]"
  exit 1
fi

CVMFS_SOURCE_LOCATION="$1"
CVMFS_BUILD_LOCATION="$2"
CVMFS_PACKAGE_NAME=cvmfs-contrib-release
shift 2

die() {
  local msg="$1"
  echo "$msg"
  exit 1
}

get_package_type() {
  which dpkg > /dev/null 2>&1 && echo "deb" && return 0
  which rpm  > /dev/null 2>&1 && echo "rpm" && return 0
  return 1
}


# build the invocation string and print it for debugging reasons
args=""
while [ $# -gt 0 ]; do
  if echo "$1" | grep -q "[[:space:]]"; then
    args="$args \"$1\""
  else
    args="$args $1"
  fi
  shift 1
done

build_script="${SCRIPT_LOCATION}/${CVMFS_PACKAGE_NAME}/$(get_package_type).sh"
command_tmpl="$build_script ${CVMFS_SOURCE_LOCATION} ${CVMFS_BUILD_LOCATION} $args"
echo "++ $command_tmpl"

# check if the requested build script is available
[ -f $build_script ] || die "build script doesn't exist"
[ -x $build_script ] || die "build script is not executable"

# run the build script
echo "switching to $CVMFS_BUILD_LOCATION..."
cd "$CVMFS_BUILD_LOCATION"
$command_tmpl
