# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2

DESCRIPTION="Scalable Vector Graphics (SVG) rendering library"
HOMEPAGE="https://wiki.gnome.org/Projects/LibRsvg"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

IUSE="+introspection tools"

RDEPEND="
	>=dev-libs/glib-2.34.3:2
	>=x11-libs/cairo-1.12.14-r4
	>=x11-libs/pango-1.36.3
	>=dev-libs/libxml2-2.9.1-r4:2
	>=dev-libs/libcroco-0.6.8-r1
	>=x11-libs/gdk-pixbuf-2.30.7:2[introspection?]
	|| ( >=dev-lang/rust-1.27.0 >=dev-lang/rust-bin-1.27.0 )
	introspection? ( >=dev-libs/gobject-introspection-0.10.8:= )
"
DEPEND="${RDEPEND}
	dev-libs/gobject-introspection-common
	>=dev-util/gtk-doc-am-1.13
	>=virtual/pkgconfig-0-r1
	virtual/cargo
"

src_prepare() {
	local build_dir

	eautoreconf
	gnome2_src_prepare
}

src_configure() {

	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		--disable-static \
		--enable-vala=no \
		$(use_enable introspection) \
		$(use_enable tools) \
		--enable-pixbuf-loader
	ln -s "${S}"/doc/html doc/html || die
}

src_compile() {
	# causes segfault if set, see bug #411765
	unset __GL_NO_DSO_FINALIZER
	gnome2_src_compile
}

src_install() {
	gnome2_src_install
}

pkg_postinst() {
	# causes segfault if set, see bug 375615
	unset __GL_NO_DSO_FINALIZER
	gnome2_pkg_postinst
}

pkg_postrm() {
	# causes segfault if set, see bug 375615
	unset __GL_NO_DSO_FINALIZER
	gnome2_pkg_postrm
}
