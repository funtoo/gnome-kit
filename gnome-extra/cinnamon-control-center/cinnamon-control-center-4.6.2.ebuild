# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME3_LA_PUNT="yes" # gmodule is used, which uses dlopen
GNOME3_EAUTORECONF="yes"

inherit gnome3

DESCRIPTION="Cinnamons's main interface to configure various aspects of the desktop"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/"
SRC_URI="https://github.com/linuxmint/cinnamon-control-center/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+colord debug input_devices_wacom +networkmanager +modemmanager"
REQUIRED_USE="modemmanager? ( networkmanager )"
KEYWORDS="*"

# False positives caused by nested configure scripts
QA_CONFIGURE_OPTIONS=".*"

COMMON_DEPEND="
	dev-libs/dbus-glib
	>=dev-libs/glib-2.31:2
	dev-libs/libxml2:2
	>=gnome-base/libgnomekbd-2.91.91:0=
	>=gnome-extra/cinnamon-desktop-4.6:0=
	>=gnome-extra/cinnamon-menus-4.4:0=
	>=gnome-extra/cinnamon-settings-daemon-4.4:0=
	media-libs/fontconfig
	networkmanager? (
		>=net-misc/networkmanager-1.2.0:=[modemmanager?]
		>=gnome-extra/nm-applet-1.2.0
		modemmanager? ( >=net-misc/modemmanager-0.7 )
	)
	>=sys-auth/polkit-0.103
	>=x11-libs/gdk-pixbuf-2.23.0:2
	>=x11-libs/gtk+-3.4.1:3
	>=x11-libs/libnotify-0.7.3:0=
	x11-libs/libX11
	>=x11-libs/libxklavier-5.1
	colord? ( >=x11-misc/colord-0.1.14:0= )
	input_devices_wacom? (
		>=dev-libs/libwacom-0.7
		>=x11-libs/gtk+-3.8:3
		>=x11-libs/libXi-1.2 )
"
# <gnome-color-manager-3.1.2 has file collisions with g-c-c-3.1.x
# libgnomekbd needed only for gkbd-keyboard-display tool
RDEPEND="${COMMON_DEPEND}
	app-admin/openrc-settingsd
	x11-themes/adwaita-icon-theme
	colord? ( >=gnome-extra/gnome-color-manager-3 )
	input_devices_wacom? ( gnome-extra/cinnamon-settings-daemon[input_devices_wacom] )
"
DEPEND="${COMMON_DEPEND}
	app-text/iso-codes
	sys-devel/autoconf-archive
	x11-base/xorg-proto
"
BDEPEND="
	dev-util/glib-utils
	>=dev-util/intltool-0.40.1
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

src_configure() {
	gnome3_src_configure \
		--disable-maintainer-mode \
		--enable-compile-warnings=minimum \
		--disable-static \
		--disable-onlineaccounts \
		$(use_enable colord color) \
		$(usex debug --enable-debug=yes ' ') \
		$(use_enable input_devices_wacom wacom) \
		$(use_enable networkmanager) \
		$(use_enable modemmanager)
}
