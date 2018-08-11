# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome-meson

DESCRIPTION="GLib geocoding library that uses the Yahoo! Place Finder service"
HOMEPAGE="https://git.gnome.org/browse/geocode-glib"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="*"

IUSE="+introspection test"

RESTRICT="test"

RDEPEND="
	>=dev-libs/glib-2.34:2
	>=dev-libs/json-glib-0.99.2[introspection?]
	gnome-base/gvfs[http]
	>=net-libs/libsoup-2.42:2.4[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.6.3:= )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.13
	>=sys-devel/gettext-0.18
	virtual/pkgconfig
	test? ( sys-apps/dbus )
"

src_configure() {
	gnome-meson_src_configure \
		-Denable-introspection=$(usex introspection true false) \
		-Denable-installed-tests=$(usex test true false) \
		-Denable-gtk-doc=true
}

src_compile() {
	export MAKEOPTS="-j1"
	gnome-meson_src_compile
}

src_install() {
        export MAKEOPTS="-j1"
        gnome-meson_src_install
}
