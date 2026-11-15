# Prebuilt Flutter bundle repackaged as an RPM. Nothing is compiled here.
%global debug_package %{nil}
# Do not strip or otherwise post-process the prebuilt binaries.
%global __os_install_post %{nil}
%global __strip /bin/true
%global _build_id_links none
# The bundle ships its own libraries; keep them out of automatic deps.
%global __requires_exclude_from ^/opt/invoice-desk/.*$
%global __provides_exclude_from ^/opt/invoice-desk/.*$

# Passed by scripts/package_linux.sh from pubspec.yaml.
%{!?pkgversion: %global pkgversion 0.2.0}

Name:           invoice-desk
Version:        %{pkgversion}
Release:        1
Summary:        Bilingual (Arabic/English) desktop invoicing for freelancers
License:        LicenseRef-Proprietary AND OFL-1.1
URL:            https://github.com/omarmaarouf18/invoice-desk
Source0:        invoice-desk-%{version}-linux-x64.tar.gz
ExclusiveArch:  x86_64

Requires:       gtk3
Requires:       hicolor-icon-theme

%description
Invoice Desk keeps every client and invoice in one offline SQLite database,
with an Arabic right-to-left interface, bilingual invoices and vector PDF
export. User data lives in the home directory and is never touched by
installing, upgrading or removing this package.

%prep
%setup -q -n invoice-desk-%{version}-linux-x64

%install
install -d %{buildroot}/opt/invoice-desk
cp -a invoice_desk lib data %{buildroot}/opt/invoice-desk/
install -d %{buildroot}%{_bindir}
ln -s /opt/invoice-desk/invoice_desk %{buildroot}%{_bindir}/invoice-desk
install -Dm 0644 invoice-desk.desktop \
  %{buildroot}%{_datadir}/applications/invoice-desk.desktop
install -Dm 0644 invoice-desk.png \
  %{buildroot}%{_datadir}/icons/hicolor/256x256/apps/invoice-desk.png

%post
if [ -x %{_bindir}/update-desktop-database ]; then
  %{_bindir}/update-desktop-database -q %{_datadir}/applications || :
fi
if [ -x %{_bindir}/gtk-update-icon-cache ]; then
  touch --no-create %{_datadir}/icons/hicolor || :
  %{_bindir}/gtk-update-icon-cache -q %{_datadir}/icons/hicolor || :
fi

%postun
if [ -x %{_bindir}/update-desktop-database ]; then
  %{_bindir}/update-desktop-database -q %{_datadir}/applications || :
fi
if [ -x %{_bindir}/gtk-update-icon-cache ]; then
  touch --no-create %{_datadir}/icons/hicolor || :
  %{_bindir}/gtk-update-icon-cache -q %{_datadir}/icons/hicolor || :
fi

%files
/opt/invoice-desk
%{_bindir}/invoice-desk
%{_datadir}/applications/invoice-desk.desktop
%{_datadir}/icons/hicolor/256x256/apps/invoice-desk.png

%changelog
* Sun Nov 15 2026 Omar Maarouf <omarmaarouf18@users.noreply.github.com> - 0.2.0-1
- Contracts and quotes from a clause library, with amendments, variables,
  annexes, milestone invoices and an Arabic contract PDF (schema v3)

* Sun Nov 15 2026 Omar Maarouf <omarmaarouf18@users.noreply.github.com> - 0.1.1-1
- Client deletion with Undo, archiving, and a backup before deleting a
  client together with their invoices (database schema v2)

* Sun Nov 15 2026 Omar Maarouf <omarmaarouf18@users.noreply.github.com> - 0.1.0-1
- First RPM of Invoice Desk.
