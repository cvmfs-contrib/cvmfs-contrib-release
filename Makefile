#!/usr/bin/make -f

# This make file takes care of 'installing' the cvmfs-contrib apt repository
# and the associated gpg public key

all: # nothing to build

install:
	mkdir -p ${DESTDIR}/etc/apt/sources.list.d
	NAMEVER="`./getosnamever.sh`"; (echo "deb http://download.opensuse.org/repositories/home:/cvmfs:/contrib/$$NAMEVER ./"; echo "# deb http://download.opensuse.org/repositories/home:/cvmfs:/contrib/$$NAMEVER ./") >${DESTDIR}/etc/apt/sources.list.d/cvmfs-contrib.list
	mkdir -p ${DESTDIR}/etc/apt/trusted.gpg.d
	cp cvmfs-contrib.gpg ${DESTDIR}/etc/apt/trusted.gpg.d/
