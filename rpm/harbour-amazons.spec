#!/usr/bin/env rpmlint

Name:       harbour-amazons

%bcond_with harbour
%define orgname arc676.amazons
%define appname GameOfTheAmazons
%define keepstatic 1

%undefine __cmake_in_source_build

Summary:    Game of the Amazons
Version:    1.3.3
Release:    0
Group:      Applications
License:    GPLv3 and CC-BY-NC-SA-4.0
URL:        https://github.com/Arc676/Amazons-Linux
Source0:    %{name}-%{version}.tar.bz2

# we need this if we rely on sailfishapp features in the .pro file (like installing qml)
BuildRequires:  pkgconfig(sailfishapp)
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(Qt5DBus)

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
PackageIcon: %{url}/raw/master/icons/%{name}.svg
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
#sed -i 's@${CMAKE_SOURCE_DIR}/plugins/Amazons/backend/libamazons.a@amazons@' plugins/Amazons/CMakeLists.txt ||:
sed -i '/^set(QT_IMPORTS_DIR.*/d' plugins/Amazons/CMakeLists.txt ||:
sed -i '/^set(QT_IMPORTS_DIR.*/d' CMakeLists.txt ||:
sed -i '/^set(CMAKE_INSTALL_PREFIX.*/d' CMakeLists.txt ||:
sed -i '/^set(DATA_DIR.*/d' CMakeLists.txt ||:
sed -i '/^add_subdirectory(po)/d' CMakeLists.txt ||:

%build
%cmake -Wno-dev \
       -DCMAKE_INSTALL_PREFIX=%{_prefix} \
       -DQT_IMPORTS_DIR=%{_datadir}/%{name}/lib/ \
       -DDATA_DIR=%{_datadir}/%{name} \
        %nil
%cmake_build -j 1

%install
%cmake_install

install -Dpm644 %{__cmake_builddir}/amazons.desktop %{buildroot}%{_datadir}/applications/%{name}.desktop
install -d %{buildroot}%{_datadir}/%{name}/qml/
ln -s Main.qml %{buildroot}%{_datadir}/%{name}/qml/%{name}.qml


# Edit the main .desktop file for Sailjail
 desktop-file-edit  \
 --set-key=Exec \
 --set-value="sailfish-qml %{name}" \
 --set-name="Game Of The Amazons" \
 --set-icon=%{name} \
 --set-key=X-Nemo-Application-Type \
 --set-value=silica-qt5 \
 --set-key=X-Nemo-Single-Instance \
 --set-value=yes \
 --remove-key=X-Lomiri-Touch \
 %{buildroot}%{_datadir}/applications/%{name}.desktop

printf '\n\n[X-Sailjail]\nOrganizationName=%{orgname}\nApplicationName=%{appname}\nPermissions=Audio\n' \
     >> %{buildroot}%{_datadir}/applications/%{name}.desktop

# generate some icons
install -Dpm644 icons/%{name}.svg %{buildroot}%{_datadir}/icons/hicolor/scalable/apps/%{name}.svg
for size in 86 108 128 172 256 512; do
install -d %{buildroot}%{_datadir}/icons/hicolor/${size}x${size}/apps/
sailfish_svg2png -z 1.0 -f rgba -s 1 1 1 1 1 1 ${size} %{buildroot}%{_datadir}/icons/hicolor/scalable/apps/ %{buildroot}%{_datadir}/icons/hicolor/${size}x${size}/apps/
done

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop


# do not package documentation:
rm -rf %{buildroot}%{_docdir}
rm -rf %{buildroot}%{_mandir}

%files
#%%{_bindir}/*
%{_datadir}/applications/*.desktop
%{_datadir}/icons/*/*/apps/*
%exclude %{_datadir}/icons/*/scalable/apps/*
%dir %{_datadir}/%{name}
#%%dir %{_datadir}/%{name}/translations
#%%{_datadir}/%{name}/translations/*.qm
%{_datadir}/%{name}/qml/
%{_datadir}/%{name}/lib/
%exclude %{_datadir}/%{name}/amazons.apparmor
%exclude %{_datadir}/%{name}/amazons.desktop
%exclude %{_prefix}/manifest.json
%exclude %{_datadir}/%{name}/assets


