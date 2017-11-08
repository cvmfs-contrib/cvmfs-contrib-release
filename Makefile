#!/usr/bin/make -f

# This make file takes care of 'installing' the cvmfs-contrib apt repository
# and the associated gpg public key

all: # nothing to build

install:
	mkdir -p ${DESTDIR}/etc/apt/sources.list.d
        echo "deb http://download.opensuse.org/repositories/home:/cvmfs:/contrib/$NAMEVER ./" >${DESTDIR}/etc/apt/sources.list.d/cvmfs-contrib.list
        echo "# deb http://download.opensuse.org/repositories/home:/cvmfs:/contrib-testing/$NAMEVER ./" >>${DESTDIR}/etc/apt/sources.list.d/cvmfs-contrib.list
	mkdir -p ${DESTDIR}/etc/apt/trusted.gpg.d
	cp obs-signing-key.pub ${DESTDIR}/etc/apt/trusted.gpg.d/cvmfs-contrib.gpg
