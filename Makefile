#!/usr/bin/make -f

# This make file takes care of 'installing' the cvmfs-contrib apt repository
# and the associated gpg public key

all: # nothing to build

install:
	mkdir -p ${DESTDIR}/usr/share/cvmfs-contrib-release
	for OSVER in Ubuntu_14.04 Ubuntu_16.04 Ubuntu_18.04 Ubuntu_20.04 Debian_8.0 Debian_9.0 Debian_10 Debian_11; do \
	    case $$OSVER in \
		Ubuntu*) REPO="x$$OSVER";; \
		*) REPO="$$OSVER";; \
	    esac; \
	    (echo "# Do not edit.  Remove symlink and make a copy in /etc/apt/sources.list.d"; \
	    echo "# browsable alternate at http://download.opensuse.org/repositories/home:/cvmfs:/contrib/$$REPO ./"; \
	    echo "deb http://downloadcontent.opensuse.org/repositories/home:/cvmfs:/contrib/$$REPO ./"; \
	    echo "# browsable alternate at http://download.opensuse.org/repositories/home:/cvmfs:/contrib-testing/$$REPO ./"; \
	    echo "# deb http://downloadcontent.opensuse.org/repositories/home:/cvmfs:/contrib-testing/$$REPO ./"; \
	    ) >${DESTDIR}/usr/share/cvmfs-contrib-release/cvmfs-contrib-$$OSVER.list; \
	done
	mkdir -p ${DESTDIR}/etc/apt/trusted.gpg.d
	cp cvmfs-contrib.gpg ${DESTDIR}/etc/apt/trusted.gpg.d/
	mkdir -p ${DESTDIR}/etc/apt/sources.list.d
