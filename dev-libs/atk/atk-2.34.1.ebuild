# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2 meson

DESCRIPTION="GTK+ & GNOME Accessibility Toolkit"
HOMEPAGE="https://wiki.gnome.org/Accessibility"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="+introspection nls"

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	introspection? ( >=dev-libs/gobject-introspection-1.62.0:= )
"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	dev-util/gtk-doc-am
	>=virtual/pkgconfig-0-r1
	nls? ( >=sys-devel/gettext-0.19.2 )
"

src_configure() {
	local emesonargs=(
		$(meson_use introspection)
	)

	meson_src_configure
}

src_compile() { meson_src_compile; }

src_install() { meson_src_install; }
