# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome-meson multilib-minimal

DESCRIPTION="GTK+ & GNOME Accessibility Toolkit"
HOMEPAGE="https://wiki.gnome.org/Accessibility"

LICENSE="LGPL-2+"
SLOT="1"
KEYWORDS="*"

IUSE="doc +introspection nls"

RDEPEND="
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.6.7:= )
"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	dev-util/gtk-doc-am
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	nls? ( >=sys-devel/gettext-0.19.2 )
"

PATCHES=("${FILESDIR}/${P}-enum.patch")

src_prepare() {
	gnome-meson_src_prepare
}

multilib_src_configure() {
	gnome-meson_src_configure \
		-Dintrospection=$(multilib_native_usex introspection true false) \
		$(meson_use doc docs)
}

multilib_src_install() {
	gnome-meson_src_install
}
