Name:           cvmfs-contrib-release
Version:        1.13
# The release_prefix macro is used in the OBS prjconf, don't change its name
%define release_prefix 1
# %{?dist} is left off intentionally; this rpm works on multiple OS releases
Release:        %{release_prefix}
Summary:        CernVM FileSystem Contrib packages yum repository configuration

Group:          System Environment/Base
License:        GPL
URL:            http://github.com/cvmfs/cvmfs-contrib-release

# download with:
# $ curl -L -o cvmfs-contrib-release-%{version}.tar.gz \
#   https://github.com/cvmfs/cvmfs-contrib-release/archive/v%{version}.tar.gz

Source:         %{name}-%{version}.tar.gz

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildArch:      noarch

Requires:       /usr/bin/lsb_release

%description
This package contains the CernVM FileSystem Contrib packages
repository configuration for yum.

%prep
%setup

%install
rm -rf $RPM_BUILD_ROOT

#GPG Key
mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/pki/rpm-gpg
install -pm 644 obs-signing-key.pub \
    $RPM_BUILD_ROOT%{_sysconfdir}/pki/rpm-gpg/RPM-GPG-KEY-CVMFS-CONTRIB

# yum
# Enable the same rpm to be installed on multiple OS versions by
#   installing all possible .repo files in /usr/share and symlinking
#   the right one in place.  Only the major OS release number can
#   be used, so can't use $releasevar inside .repo file.
mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/yum.repos.d
mkdir -p $RPM_BUILD_ROOT%{_datarootdir}/%{name}
for RHEL in 6 7 8; do
  # make it mode 444 so hopefully admins won't accidentally edit it
  #  without breaking the symlink and making a copy
  bash -c "install -m 444 <(sed s/{rhel}/$RHEL/ rpm/cvmfs-contrib.repo) \
      $RPM_BUILD_ROOT%{_datarootdir}/%{name}/cvmfs-contrib-el$RHEL.repo"
done
# this is just because a default is needed for %ghost files; the real
#   one is installed in the %post rule
ln -s %{_datarootdir}/%{name}/cvmfs-contrib-el%{rhel}.repo $RPM_BUILD_ROOT%{_sysconfdir}/yum.repos.d/cvmfs-contrib.repo

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%dir %{_sysconfdir}/yum.repos.d
%ghost %{_sysconfdir}/yum.repos.d/cvmfs-contrib.repo
%{_sysconfdir}/pki/rpm-gpg/*
%{_datarootdir}/%{name}

%post
REPO="%{_sysconfdir}/yum.repos.d/cvmfs-contrib.repo"
if [ -L $REPO ]; then
    rm $REPO
fi
if [ ! -e $REPO ]; then
    ln -s %{_datarootdir}/%{name}/cvmfs-contrib-el`lsb_release -rs|cut -d. -f1`.repo %{_sysconfdir}/yum.repos.d/cvmfs-contrib.repo
fi

%changelog
* Fri Mar 26 2021 Dave Dykstra <dwd@fnal.gov>> - 1.13-1
- Add 'x' prefix on Ubuntu repository download directories.
- Add Ubuntu_20.04 support to debian release.

* Mon Oct 19 2020 Dave Dykstra <dwd@fnal.gov>> - 1.12-1
- Add el8 support.

* Wed Feb 05 2020 Dave Dykstra <dwd@fnal.gov>> - 1.11-1
- Add cvmfs-contrib-egi and cvmfs-contrib-egi-testing yum repos, disabled by
  default.

* Mon Jan 13 2020 Dave Dykstra <dwd@fnal.gov>> - 1.10-1
- Update cvmfs-contrib.gpg with the new gpg key too.

* Sat Jan 11 2020 Dave Dykstra <dwd@fnal.gov>> - 1.9-1
- Replace expired gpg key.  This one expires 2022-03-22.

* Tue Oct 01 2019 Dave Dykstra <dwd@fnal.gov>> - 1.8-1
- Change Debian_10.0 to Debian_10

* Wed Sep 25 2019 Dave Dykstra <dwd@fnal.gov>> - 1.7-1
- Include Debian_10.0 in the Debian packaging, and remove Ubuntu_17.04
- Fall back to a previous OS version when a version is not supported

* Thu Sep 27 2018 Dave Dykstra <dwd@fnal.gov>> - 1.6-1
- Add Ubuntu_18.04

* Wed Jul 18 2018 Dave Dykstra <dwd@fnal.gov>> - 1.5-1
- Add a comment referring to download.opensuse.org as a browsable alternate

* Mon Mar 19 2018 Dave Dykstra <dwd@fnal.gov>> - 1.4-1
- Change repo urls to downloadcontent.opensuse.org to avoid problems
  with some mirrors referenced by download.opensuse.org.

* Wed Nov 08 2017 Dave Dykstra <dwd@fnal.gov>> - 1.3-1
- Make this rpm installable on both el6 & el7 by having both versions of
  the .repo file available and symlinking to the right one at install
  time.

* Tue Nov 07 2017 Dave Dykstra <dwd@fnal.gov>> - 1.2-1
- Use a common signing key

* Fri Nov 03 2017 Dave Dykstra <dwd@fnal.gov>> - 1.1-1
- Add contrib-testing repo, disabled by default

* Fri Nov 03 2017 Dave Dykstra <dwd@fnal.gov>> - 1.0-2
- Define %release_prefix for OBS. see
    https://en.opensuse.org/openSUSE:Build_Service_prjconf#Release

* Fri Nov 03 2017 Dave Dykstra <dwd@fnal.gov>> - 1.0-1
- Initial creation
