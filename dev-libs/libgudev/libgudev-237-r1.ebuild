# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2 meson

DESCRIPTION="GObject bindings for libudev"
HOMEPAGE="https://wiki.gnome.org/Projects/libgudev"
SRC_URI="https://download.gnome.org/sources/libgudev/${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0/0"
KEYWORDS="*"
IUSE="introspection"

RDEPEND="
	>=dev-libs/glib-2.38.0:2
	>=virtual/libudev-199:=
	introspection? ( >=dev-libs/gobject-introspection-1.31.1 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_feature introspection)
		-Dgtk_doc=false
		-Dtests=disabled
		-Dvapi=disabled
	)
	meson_src_configure
}
