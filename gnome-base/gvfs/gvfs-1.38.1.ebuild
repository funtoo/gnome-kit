# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"
GNOME2_EAUTORECONF="yes"
inherit gnome-meson systemd

DESCRIPTION="Virtual filesystem implementation for gio"
HOMEPAGE="https://wiki.gnome.org/Projects/gvfs"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="afp archive bluray cdda dnssd elogind fuse google gnome-keyring gnome-online-accounts gphoto2 gtk +http ios mtp nfs policykit samba systemd test +udev udisks"
REQUIRED_USE="
	cdda? ( udev )
	elogind? ( !systemd udisks )
	google? ( gnome-online-accounts )
	mtp? ( udev )
	udisks? ( udev )
	systemd? ( !elogind udisks )
"

# Tests with multiple failures, this is being handled upstream at:
# https://bugzilla.gnome.org/700162
RESTRICT="test"

RDEPEND="
	app-crypt/gcr:=
	>=dev-libs/glib-2.51:2
	dev-libs/libxml2:2
	net-misc/openssh
	afp? ( >=dev-libs/libgcrypt-1.2.2:0= )
	archive? ( app-arch/libarchive:= )
	bluray? ( media-libs/libbluray:= )
	dnssd? ( >=net-dns/avahi-0.6 )
	elogind? ( >=sys-auth/elogind-229:0= )
	fuse? ( >=sys-fs/fuse-2.8.0:0 )
	gnome-keyring? ( app-crypt/libsecret )
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.7.1:= )
	google? (
		>=dev-libs/libgdata-0.17.7:=[crypt,gnome-online-accounts]
		>=net-libs/gnome-online-accounts-3.17.1:= )
	gphoto2? ( >=media-libs/libgphoto2-2.5.0:= )
	gtk? ( >=x11-libs/gtk+-3.0:3 )
	http? ( >=net-libs/libsoup-2.42:2.4 )
	ios? (
		>=app-pda/libimobiledevice-1.2:=
		>=app-pda/libplist-1:= )
	mtp? (
		>=dev-libs/libusb-1.0.21
		>=media-libs/libmtp-1.1.12 )
	nfs? ( >=net-fs/libnfs-1.9.8 )
	policykit? (
		sys-auth/polkit
		sys-libs/libcap )
	samba? ( >=net-fs/samba-4[client] )
	systemd? ( >=sys-apps/systemd-206:0= )
	udev? (
		cdda? ( dev-libs/libcdio-paranoia )
		>=virtual/libgudev-147:=
		virtual/libudev:= )
	udisks? ( >=sys-fs/udisks-1.97:2 )
"
DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
	dev-util/gdbus-codegen
	dev-util/gtk-doc-am
	test? (
		>=dev-python/twisted-core-12.3.0
		|| (
			net-analyzer/netcat
			net-analyzer/netcat6 ) )
	!udev? ( >=dev-libs/libgcrypt-1.2.2:0 )
"
# libgcrypt.m4, provided by libgcrypt, needed for eautoreconf, bug #399043
# test dependencies needed per https://bugzilla.gnome.org/700162

PATCHES=(
	"${FILESDIR}"/${PN}-1.30.2-sysmacros.patch #580234
)

src_prepare() {
	gnome-meson_src_prepare
}

src_configure() {
	gnome-meson_src_configure \
		-Ddbus_service_dir="${EPREFIX}"/usr/share/dbus-1/services \
		-Dsystemduserunitdir=no \
		-Dtmpfilesdir=no \
		-Dgdu=false \
		-Dgcr=true \
		-Dman=true \
		$(meson_use policykit admin) \
		$(meson_use ios afc) \
		$(meson_use afp afp) \
		$(meson_use archive archive) \
		$(meson_use cdda cdda)\
		$(meson_use dnssd dnssd)\
		$(meson_use gnome-online-accounts goa) \
		$(meson_use google google) \
		$(meson_use gphoto2 gphoto2) \
		$(meson_use http http) \
		$(meson_use mtp mtp) \
		$(meson_use nfs nfs) \
		$(meson_use samba smb) \
		$(meson_use udisks udisks2) \
		$(meson_use bluray bluray) \
		$(meson_use fuse fuse) \
		$(meson_use udev gudev) \
		$(meson_use gnome-keyring keyring) \
		$(meson_use elogind logind) \
		$(meson_use mtp libusb)
}
