#!/usr/bin/make -f

# This make file takes care of 'installing' the cvmfs-contrib apt repository
# and the associated gpg public key

all: # nothing to build

install:
	mkdir -p ${DESTDIR}/usr/share/cvmfs-contrib-release
	for OSVER in Ubuntu_14.04 Ubuntu_16.04 Ubuntu_18.04 Debian_8.0 Debian_9.0 Debian_10.0; do \
	    (echo "# Do not edit.  Remove symlink and make a copy in /etc/apt/sources.list.d"; \
	    echo "# browsable alternate at http://download.opensuse.org/repositories/home:/cvmfs:/contrib/$$OSVER ./"; \
	    echo "deb http://downloadcontent.opensuse.org/repositories/home:/cvmfs:/contrib/$$OSVER ./"; \
	    echo "# browsable alternate at http://download.opensuse.org/repositories/home:/cvmfs:/contrib-testing/$$OSVER ./"; \
	    echo "# deb http://downloadcontent.opensuse.org/repositories/home:/cvmfs:/contrib-testing/$$OSVER ./"; \
	    ) >${DESTDIR}/usr/share/cvmfs-contrib-release/cvmfs-contrib-$$OSVER.list; \
	done
	mkdir -p ${DESTDIR}/etc/apt/trusted.gpg.d
	cp cvmfs-contrib.gpg ${DESTDIR}/etc/apt/trusted.gpg.d/
	mkdir -p ${DESTDIR}/etc/apt/sources.list.d
