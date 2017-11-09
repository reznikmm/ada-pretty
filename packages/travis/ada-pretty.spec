%undefine _hardened_build
%define _gprdir %_GNAT_project_dir

Name:       ada-pretty
Version:    0.1.0
Release:    git%{?dist}
Summary:    An Ada library to pretty print Ada sources
Group:      Development/Libraries
License:    MIT
URL:        https://github.com/reznikmm/ada-pretty
### Direct download is not availeble
Source0:    ada-pretty.tar.gz
BuildRequires:   gcc-gnat
BuildRequires:   fedora-gnat-project-common  >= 3 
BuildRequires:   matreshka-devel
BuildRequires:   gprbuild

# gprbuild only available on these:
ExclusiveArch: %GPRbuild_arches

%description
Ada Pretty Printer Library

This project provides an ability to generate nice formated Ada sources from
your program. Instead of a plenty of Put_Line statements you just create
desired Ada constructions in form of a tree and then print it in a file.

%package devel

Group:      Development/Libraries
License:    MIT
Summary:    Devel package for Ada Pretty
Requires:       %{name}%{?_isa} = %{version}-%{release}
Requires:   fedora-gnat-project-common  >= 2

%description devel
Devel package for Ada Pretty

%prep 
%setup -q -n %{name}

%build
make  %{?_smp_mflags} GPRBUILD_FLAGS="%Gnatmake_optflags"

%install
rm -rf %{buildroot}
make install DESTDIR=%{buildroot} LIBDIR=%{_libdir} PREFIX=%{_prefix} GPRDIR=%{_gprdir} BINDIR=%{_bindir}

%post     -p /sbin/ldconfig
%postun   -p /sbin/ldconfig

%files
%doc LICENSE
%dir %{_libdir}/%{name}
%{_libdir}/%{name}/libadapretty.so.%{version}
%{_libdir}/libadapretty.so.%{version}

%files devel
%doc README.md
%{_libdir}/%{name}/libadapretty.so
%{_libdir}/libadapretty.so
%{_libdir}/%{name}/*.ali
%{_includedir}/%{name}
%{_gprdir}/ada_pretty.gpr
%{_gprdir}/manifests/ada_pretty


%changelog
* Thu Nov  9 2017 Maxim Reznik <reznikmm@gmail.com> - 0.1.0-git
- Initial package
