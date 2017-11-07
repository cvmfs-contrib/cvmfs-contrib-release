Name:           cvmfs-contrib-release
Version:        1.2
# The release_prefix macro is used in the OBS prjconf, don't change its name
%define release_prefix 1
Release:        %{release_prefix}%{?dist}
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

Requires:       redhat-release >= %{rhel}

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
mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/yum.repos.d
bash -c "install -m 644 <(sed 's/{rhel}/%{rhel}/' rpm/cvmfs-contrib.repo) \
    $RPM_BUILD_ROOT%{_sysconfdir}/yum.repos.d/cvmfs-contrib.repo"

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%config(noreplace) /etc/yum.repos.d/*
/etc/pki/rpm-gpg/*


%changelog
* Tue Nov 07 2017 Dave Dykstra <dwd@fnal.gov>> - 1.2-1
- Use a common signing key

* Fri Nov 03 2017 Dave Dykstra <dwd@fnal.gov>> - 1.1-1
- Add contrib-testing repo, disabled by default

* Fri Nov 03 2017 Dave Dykstra <dwd@fnal.gov>> - 1.0-2
- Define %release_prefix for OBS. see
    https://en.opensuse.org/openSUSE:Build_Service_prjconf#Release

* Fri Nov 03 2017 Dave Dykstra <dwd@fnal.gov>> - 1.0-1
- Initial creation
