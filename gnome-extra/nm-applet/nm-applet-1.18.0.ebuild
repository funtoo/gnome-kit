# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
GNOME_ORG_MODULE="network-manager-applet"

inherit gnome3

DESCRIPTION="GNOME applet for NetworkManager"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager"

LICENSE="GPL-2+"
SLOT="0"
IUSE="ayatana +introspection +gnome-keyring +modemmanager +policykit selinux teamd"
KEYWORDS="*"

RDEPEND="
	>=net-libs/libnma-1.8.27
	>=app-crypt/libsecret-0.18
	>=dev-libs/glib-2.62.2:2[dbus]
	>=dev-libs/dbus-glib-0.88
	>=sys-apps/dbus-1.4.1
	>=x11-libs/gtk+-3.24.12:3[introspection?]
	>=x11-libs/libnotify-0.7.0

	app-text/iso-codes
	>=net-misc/networkmanager-1.7:=[introspection?,modemmanager?,teamd?]
	net-misc/mobile-broadband-provider-info

	ayatana? (
		dev-libs/libappindicator:3
		>=dev-libs/libdbusmenu-16.04.0 )
	dev-libs/gobject-introspection:=
	virtual/freedesktop-icon-theme
	virtual/libgudev:=
	>=app-crypt/gcr-3.14:=[gtk]
	gnome-keyring? ( >=app-crypt/libsecret-0.18 )
	modemmanager? ( net-misc/modemmanager )
	policykit? ( >=sys-auth/polkit-0.96-r1 )
	selinux? ( sys-libs/libselinux )
	teamd? ( >=dev-libs/jansson-2.7 )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.0
	>=dev-util/intltool-0.50.1
	virtual/pkgconfig
"

PDEPEND="virtual/notification-daemon" #546134

src_configure() {
	local myconf=(
		--with-appindicator=$(usex ayatana ubuntu no)
		--disable-lto
		--disable-ld-gc
		--disable-more-warnings
		--disable-static
		--localstatedir=/var
		$(use_with modemmanager wwan)
		$(use_with selinux)
		$(use_with teamd team)
	)
	gnome3_src_configure "${myconf[@]}"
}
