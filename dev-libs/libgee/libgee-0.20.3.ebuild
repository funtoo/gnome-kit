# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2

DESCRIPTION="GObject-based interfaces and classes for commonly used data structures"
HOMEPAGE="https://wiki.gnome.org/Projects/Libgee"

LICENSE="LGPL-2.1+"
SLOT="0.8/2"
KEYWORDS="*"
IUSE="+introspection"

# FIXME: add doc support, requires valadoc
RDEPEND="
	>=dev-libs/glib-2.62.2:2
	introspection? ( >=dev-libs/gobject-introspection-1.62.0:= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		$(use_enable introspection)
		VALAC="$(type -P false)"
}
