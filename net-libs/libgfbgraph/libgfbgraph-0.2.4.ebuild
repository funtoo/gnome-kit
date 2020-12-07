# Distributed under the terms of the GNU General Public License v2

EAPI="7"
GNOME_ORG_MODULE="gfbgraph"

inherit autotools gnome3

DESCRIPTION="A GObject library for Facebook Graph API"
HOMEPAGE="https://git.gnome.org/browse/libgfbgraph/"

LICENSE="LGPL-2.1+"
SLOT="0.2"
KEYWORDS="*"
IUSE="+introspection"

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	dev-libs/json-glib[introspection?]
	net-libs/libsoup:2.4[introspection?]
	net-libs/gnome-online-accounts
	net-libs/rest:0.7[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1.62.0:= )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.14
	virtual/pkgconfig
"

# FIXME: most tests seem to fail
RESTRICT="test"

src_prepare() {
	eautoreconf
	default
}

src_configure() {
	gnome3_src_configure \
		--disable-static \
		$(use_enable introspection)
}

src_install() {
	gnome3_src_install
	# Remove files installed in the wrong place
	# Also, already done by portage
	# https://bugzilla.gnome.org/show_bug.cgi?id=752581
	rm -rf "${ED}"/usr/doc
}
