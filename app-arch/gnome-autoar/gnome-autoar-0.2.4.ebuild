# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome3 vala

DESCRIPTION="Automatic archives creating and extracting library"
HOMEPAGE="https://git.gnome.org/browse/gnome-autoar"

LICENSE="LGPL-2+ GPL-2+"
SLOT="0"
IUSE="gtk +introspection vala"
REQUIRED_USE="vala? ( introspection )"

KEYWORDS="*"

RDEPEND="
	>=app-arch/libarchive-3.2.0
	>=dev-libs/glib-2.62.2:2
	gtk? ( >=x11-libs/gtk+-3.24.12:3[introspection?] )
	introspection? ( >=dev-libs/gobject-introspection-1.62.0:= )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.14
	gnome-base/gnome-common
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_prepare() {
	use vala && vala_src_prepare
	gnome3_src_prepare
}

src_configure() {
	gnome3_src_configure \
		--disable-static \
		$(use_enable introspection) \
		$(use_enable vala) \
		$(use_enable gtk)
}
