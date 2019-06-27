# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
VALA_USE_DEPEND="vapigen"

inherit autotools eutils gnome2 vala

DESCRIPTION="Scalable Vector Graphics (SVG) rendering library"
HOMEPAGE="https://wiki.gnome.org/Projects/LibRsvg"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="*"

IUSE="+introspection tools vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.34.3:2
	>=x11-libs/cairo-1.15.12
	>=x11-libs/pango-1.36.3
	>=dev-libs/libxml2-2.9.1-r4:2
	>=dev-libs/libcroco-0.6.8-r1
	>=x11-libs/gdk-pixbuf-2.30.7:2[introspection?]
	>=virtual/rust-1.32.0
	introspection? ( >=dev-libs/gobject-introspection-0.10.8:= )
	tools? ( >=x11-libs/gtk+-3.10.0:3 )
"
DEPEND="${RDEPEND}
	dev-libs/gobject-introspection-common
	dev-libs/vala-common
	>=dev-util/gtk-doc-am-1.13
	>=virtual/pkgconfig-0-r1
	virtual/cargo
	vala? ( $(vala_depend) )
"
# >=gtk-doc-am-1.13, gobject-introspection-common, vala-common needed by eautoreconf

# Rust does not know the *-pc-* variants of target triples, but these ones.
CHOST_amd64=x86_64-unknown-linux-gnu
CHOST_x86=i686-unknown-linux-gnu
CHOST_arm64=aarch64-unknown-linux-gnu

src_prepare() {
	local build_dir

	eautoreconf

	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	# --disable-tools even when USE=tools; the tools/ subdirectory is useful
	# only for librsvg developers
	ECONF_SOURCE=${S} \
	cross_compiling=yes \
	gnome2_src_configure \
		--build=${CHOST_default} \
		--disable-static \
		--disable-tools \
		$(use_enable introspection) \
		$(use_with tools gtk3) \
		$(use_enable vala) \
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
