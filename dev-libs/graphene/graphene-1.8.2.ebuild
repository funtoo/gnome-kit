# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2 meson multilib-minimal

DESCRIPTION="A thin layer of types for graphic libraries"
HOMEPAGE="http://ebassi.github.io/graphene/"

LICENSE="MIT/X11"
SLOT="0"
KEYWORDS="~*"

#IUSE="debug +introspection"
IUSE="introspection"

#	>=dev-libs/glib-2.37.6:2[${MULTILIB_USEDEP}]
RDEPEND="
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
"

#	~app-text/docbook-xml-dtd-4.1.2
#	app-text/docbook-xsl-stylesheets
#	dev-libs/libxslt
#	>=dev-util/gtk-doc-am-1.20
#	>=sys-devel/gettext-0.18
DEPEND="${RDEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"

src_prepare() {
	default

	# decouple gobject-types and gobject-introspection
	eapply "${FILESDIR}"/${PN}-1.8.0-gobject.patch

	gnome2_src_prepare
}

meson_multilib_native_use() {
	if multilib_is_native_abi && use "$1"; then
		echo true
	else
		echo false
	fi
}

multilib_src_configure() {
	local emesonargs=(
		-D gtk-doc=false
		-D arm-neon=false
		-D introspection=$(meson_multilib_native_use introspection)
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install
}
