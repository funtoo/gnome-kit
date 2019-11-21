# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2 meson

DESCRIPTION="Library providing GLib serialization and deserialization for the JSON format"
HOMEPAGE="https://wiki.gnome.org/Projects/JsonGlib"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"

IUSE="+doc debug +introspection"

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	introspection? ( >=dev-libs/gobject-introspection-1.62.0:= )
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
	# Do not touch CFLAGS with --enable-debug=yes
	sed -e 's/CFLAGS -g/CFLAGS/' -i "${S}"/configure || die
	gnome2_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_use doc)
		$(meson_use introspection)
	)

	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
}
