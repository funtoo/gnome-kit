# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2 multilib-minimal meson

DESCRIPTION="GTK+ & GNOME Accessibility Toolkit"
HOMEPAGE="https://wiki.gnome.org/Accessibility"

LICENSE="LGPL-2+"
SLOT="1"
KEYWORDS="*"

IUSE="+introspection doc"

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

src_prepare() {
	gnome2_src_prepare

	# Building out of sources fails, https://bugzilla.gnome.org/show_bug.cgi?id=752507
	multilib_copy_sources
}

multilib_src_configure() {
	local emesonargs=(
		-Dintrospection=$(usex introspection true false)
		-Ddocs=$(usex introspection true false)
	)

	meson_src_configure
}

multilib_src_install() {
	meson_src_install
}
