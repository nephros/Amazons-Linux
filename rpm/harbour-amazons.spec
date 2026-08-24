#!/usr/bin/env rpmlint

Name:       harbour-amazons

%bcond_with harbour
# %%define orgname org.example.sailfish
# %%define appname AppTemplate
# %%define pkgname %%{name}
# %%define servicebase %%{orgname}.%%{appname}
# %%define desktopsrc %%SOURCE1

Summary:    Game of the Amazons
Version:    1.3.3
Release:    0
Group:      Applications
License:    GPLv3
URL:        https://github.com/Arc676/Amazons-Linux
Source0:    %{name}-%{version}.tar.bz2

# we need this if we rely on sailfishapp features in the .pro file (like installing qml)
BuildRequires:  pkgconfig(sailfishapp)

BuildRequires:  qt5-qttools-linguist
BuildRequires:  cmake

BuildRequires:  sailfish-svg2png
BuildRequires:  qml-rpm-macros
BuildRequires:  desktop-file-utils


%description
%{summary}.

%if "0%{?_chum}"
Title: Game of the Amazons
Type: desktop-application
DeveloperName: Alessandro Vinciguerra
PackagedBy: nephros
Categories:
 - Games
Custom:
  Repo: %{url}
  PackagingRepo: https://github.com/nephros/Amazons-Linux.git
# GitHub:
PackageIcon: %{url}/master/icons/%{name}.svg
# Codeberg:
PackageIcon: https://github.com/Arc676/Amazons-Linux/raw/master/assets/logo.png
Screenshots:
 - https://open-store.io/screenshots/amazons.arc676-screenshot-58b02077-af02-4080-8558-fd5269730829.png
 - https://open-store.io/screenshots/amazons.arc676-screenshot-d12f82ef-9471-4cf7-a868-8edb68cab52c.png
 - https://open-store.io/screenshots/amazons.arc676-screenshot-63443e81-f795-4727-93fe-12957350b272.png
 - https://open-store.io/screenshots/amazons.arc676-screenshot-459c66ba-85f0-490a-bc54-321e69412ffc.png
 - https://open-store.io/screenshots/amazons.arc676-screenshot-5c1e2bd9-c0ca-4abd-beba-dc6238f0dd0e.png
Links:
  Homepage: %{url}
  Bugtracker: https://github.com/nephros/Amazons-Linux.git
%endif


%prep
%autosetup -p1 -n %{name}-%{version}

%build
%cmake 
%cmake_build

%make_build

%install
%cmake_install

# generate some icons
#for size in 86 108 128 172 256 512 1024; do
#install -d %%{buildroot}%%{_datadir}/icons/hicolor/${size}x${size}/apps/
#sailfish_svg2png -z 1.0 -f rgba -s 1 1 1 1 1 1 ${size} %%{buildroot}%%{_datadir}/icons/hicolor/scalable/apps/ %%{buildroot}%%{_datadir}/icons/hicolor/${size}x${size}/apps/
#done

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop


# do not package documentation:
rm -rf %{buildroot}%{_docdir}
rm -rf %{buildroot}%{_mandir}

%files
%{_bindir}/*
%{_datadir}/applications/*.desktop
%{_datadir}/icons/*/*/apps/*
%dir %{_datadir}/%{name}
%dir %{_datadir}/%{name}/translations
%{_datadir}/%{name}/translations/*.qm
%{_datadir}/%{name}/qml/


