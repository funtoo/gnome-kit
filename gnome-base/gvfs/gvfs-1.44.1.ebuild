# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson bash-completion-r1 gnome3 systemd

DESCRIPTION="Virtual filesystem implementation for gio"
HOMEPAGE="https://wiki.gnome.org/Projects/gvfs"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="afp archive bluray cdda elogind fuse google gnome-keyring gnome-online-accounts gphoto2 +http ios nfs policykit +sftp systemd test +udev +udisks zeroconf samba +mtp"
REQUIRED_USE="
	cdda? ( udev )
	elogind? ( !systemd udisks )
	google? ( gnome-online-accounts )
	mtp? ( udev )
	udisks? ( udev )
	systemd? ( !elogind udisks )
"

RDEPEND="
	app-crypt/gcr:=
	>=dev-libs/glib-2.62.2:2
	sys-apps/dbus
	dev-libs/libxml2:2
	afp? ( >=dev-libs/libgcrypt-1.2.2:0= )
	archive? ( app-arch/libarchive:= )
	bluray? ( media-libs/libbluray )
	fuse? ( >=sys-fs/fuse-2.8.0 )
	elogind? ( >=sys-auth/elogind-229:0= )
	gnome-keyring? ( app-crypt/libsecret )
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.36:= )
	google? (
		>=dev-libs/libgdata-0.17.3:=[crypt,gnome-online-accounts]
		>=net-libs/gnome-online-accounts-3.36:= )
	gphoto2? ( >=media-libs/libgphoto2-2.5.0:= )
	http? ( >=net-libs/libsoup-2.42:2.4 )
	ios? (
		>=app-pda/libimobiledevice-1.2:=
		>=app-pda/libplist-1:= )
	mtp? ( >=media-libs/libmtp-1.1.12 )
	nfs? ( >=net-fs/libnfs-1.9.7 )
	policykit? (
		>=sys-auth/polkit-0.114
		sys-libs/libcap )
	samba? ( >=net-fs/samba-4.5.10[client] )
	sftp? ( net-misc/openssh )
	systemd? ( >=sys-apps/systemd-206:0= )
	udev? (
		cdda? ( dev-libs/libcdio-paranoia )
		virtual/libgudev:= )
	udisks? ( >=sys-fs/udisks-1.97:2 )
	zeroconf? ( >=net-dns/avahi-0.6 )
"

DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
	dev-util/gtk-doc-am
	test? (
		>=dev-python/twisted-core-12.3.0
		|| (
			net-analyzer/netcat
			net-analyzer/netcat6 ) )
"
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-1.30.2-sysmacros.patch #580234
)

src_prepare() {
	sed -i -e '/policy,/d' daemon/meson.build
	gnome3_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dgcr=true
		-Dsystemduserunitdir="$(usex systemd $(systemd_get_userunitdir) no)"
		$(usex systemd "" -Dtmpfilesdir=no)
		$(meson_use mtp)
		$(meson_use afp)
		$(meson_use archive)
		$(meson_use bluray)
		$(meson_use cdda)
		$(meson_use fuse)
		$(meson_use gnome-online-accounts goa)
		$(meson_use gnome-keyring keyring)
		$(meson_use google)
		$(meson_use gphoto2)
		$(meson_use http)
		$(meson_use ios afc)
		$(meson_use nfs)
		$(meson_use policykit admin)
		$(meson_use systemd logind)
		$(meson_use udev gudev)
		$(meson_use udisks udisks2)
		$(meson_use samba smb)
		$(meson_use sftp)
		$(meson_use zeroconf dnssd)
	)

	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
}
