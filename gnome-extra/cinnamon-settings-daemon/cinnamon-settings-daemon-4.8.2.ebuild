# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME3_LA_PUNT="yes"

inherit gnome3 virtualx meson

DESCRIPTION="Cinnamon's settings daemon"
OMEPAGE="https://projects.linuxmint.com/cinnamon/"
SRC_URI="https://github.com/linuxmint/cinnamon-settings-daemon/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"
IUSE="+colord cups debug elogind input_devices_wacom smartcard"
RESTRICT=test

# udev is non-optional since lots of plugins, not just gudev, pull it in
RDEPEND="
	>=dev-libs/glib-2.38:2
	dev-libs/libgudev:=
	>=gnome-base/libgnomekbd-3.6
	=gnome-extra/cinnamon-desktop-4.8*:0=
	media-libs/fontconfig
	>=media-libs/lcms-2.2:2
	media-libs/libcanberra:0=[gtk3]
	>=sys-apps/dbus-1.1.2
	>=sys-auth/polkit-0.97
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.9.10:3
	>=x11-libs/libnotify-0.7.3:0=
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	>=x11-libs/libxklavier-5.0
	>=sys-power/upower-0.9.11

	colord? ( >=x11-misc/colord-0.1.27:= )
	cups? (
		>=net-print/cups-1.4[dbus]
		app-admin/system-config-printer
		net-print/cups-pk-helper )
	input_devices_wacom? (
		>=dev-libs/libwacom-0.7
		>=gnome-base/librsvg-2.36.2
		x11-drivers/xf86-input-wacom
		x11-libs/libXtst )
	smartcard? ( >=dev-libs/nss-3.11.2 )
	elogind? (
		sys-auth/elogind:0=
	)
"
DEPEND="${RDEPEND}
	dev-libs/libxml2:2
	x11-base/xorg-proto
"
BDEPEND="
	dev-util/glib-utils
	dev-util/gdbus-codegen
	>=dev-util/intltool-0.37.1
	virtual/pkgconfig
"

src_prepare() {
	gnome3_src_prepare

	# Disable broken test
	sed -e '/g_test_add_func ("\/color\/edid/d' \
		-i plugins/color/gcm-self-test.c || die
}

src_configure() {
	local emesonargs=(
		-Duse_gudev=enabled
		-Duse_polkit=enabled
		$(meson_use debug)
		$(meson_feature elogind use_logind)
		$(meson_use colord use_color)
		$(meson_feature cups use_cups)
		$(meson_feature smartcard enable_smartcard)
	)
	meson_src_configure
}

src_test() {
	virtx emake check
}
