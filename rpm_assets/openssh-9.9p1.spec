Name:       openssh
Version:    %{_version}
Release:    1%{?dist}
Summary:    Simplest RPM package

License:    MIT
Source0:    openssh-%{_version}.tar.gz

BuildArch:  noarch

%description
This is a test RPM package, which does nothing.

%prep
%setup -q 

%build
./configure --prefix=/opt
make

%install
make install

%files
/opt

%changelog