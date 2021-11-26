Name:      harbour-logbook
Summary:   A QML GUI to visualise Buteo sync logs
Version:   1.0
Release:   1
License:   BSD
URL:       https://github.com/dcaliste/harbour-logbook
Source0:   %{name}-%{version}.tar.bz2
Requires:  buteo-syncfw-qml-plugin >= 0.10.15
Requires:  nemo-qml-plugin-calendar-qt5 >= 0.6.27
Requires:  sailfish-components-calendar-qt5 >= 1.0.32
Requires:  libsailfishapp-launcher
BuildArch: noarch

%description
An application to browse the sync log from Buteo.

%prep
%setup -q -n %{name}-%{version}

%install
rm -rf %{buildroot}

mkdir -p %{buildroot}%{_datadir}/harbour-logbook/qml
install -m 644 -p qml/harbour-logbook.qml %{buildroot}%{_datadir}/harbour-logbook/qml
install -m 644 -p qml/SyncResultItem.qml %{buildroot}%{_datadir}/harbour-logbook/qml
install -m 644 -p qml/SyncResultPage.qml %{buildroot}%{_datadir}/harbour-logbook/qml
install -m 644 -p qml/SyncErrorLabel.qml %{buildroot}%{_datadir}/harbour-logbook/qml
install -m 644 -p qml/SyncItemListView.qml %{buildroot}%{_datadir}/harbour-logbook/qml
install -m 644 -p qml/CaldavResultListView.qml %{buildroot}%{_datadir}/harbour-logbook/qml
mkdir -p %{buildroot}%{_datadir}/applications
desktop-file-install --dir %{buildroot}%{_datadir}/applications %{name}.desktop

%files
%defattr(-,root,root,-)
%{_datadir}/applications/%{name}.desktop
%{_datadir}/%{name}
