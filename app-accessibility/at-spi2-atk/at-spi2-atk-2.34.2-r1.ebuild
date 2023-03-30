# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"

inherit gnome2 meson

DESCRIPTION="Gtk module for bridging AT-SPI to Atk"
HOMEPAGE="https://wiki.gnome.org/Accessibility"

LICENSE="LGPL-2+"
SLOT="2"
KEYWORDS="*"

IUSE="test"

COMMON_DEPEND="
	>=app-accessibility/at-spi2-core-2.31.2
	>=dev-libs/atk-2.31.90
	>=dev-libs/glib-2.62.2:2
	>=sys-apps/dbus-1.5
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-extra/at-spi-1.32.0-r1
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	test? ( >=dev-libs/libxml2-2.9.1 )
"

src_prepare() {
	gnome2_src_prepare
}

src_configure() {
	meson_src_configure
}

src_compile() { meson_src_compile; }
src_install() { meson_src_install; }
