# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2 meson vala

DESCRIPTION="JSON RPC GLIB"
HOMEPAGE="https://wiki.gnome.org/Projects/JsonGlib"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"

IUSE="doc +introspection"

RDEPEND="
	>=dev-libs/glib-2.58.0:2
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
"
DEPEND="${RDEPEND}
	~app-text/docbook-xml-dtd-4.1.2
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=dev-util/gtk-doc-am-1.20
	>=sys-devel/gettext-0.18
	virtual/pkgconfig
"

src_prepare() {
	default
	vala_src_prepare
}
