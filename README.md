# cvmfs-contrib-release
Rpm &amp; Debian source for the cvmfs-contrib-release package

Whenever there's a new Debian or Ubuntu OS to support, update Makefile.
Whenever there's a new RHEL OS to support, update
rpm/cvmfs-contrib-release.spec.

Update the rpm package first, and then run debian/obsupdate.sh to make
the `.dsc` file needed for building on the OpenSUSE Build System,
before committing the update to git.
