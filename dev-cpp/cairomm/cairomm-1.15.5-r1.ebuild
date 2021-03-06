# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="C++ bindings for the Cairo vector graphics library"
HOMEPAGE="https://www.cairographics.org/cairomm/"
SRC_URI="https://www.cairographics.org/releases/${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="1"
KEYWORDS="*"

IUSE="aqua doc +svg X"

RESTRICT="mirror"

RDEPEND="
	>=x11-libs/cairo-1.16.0[aqua=,svg=,X=]
	dev-libs/libsigc++:3=
	>=dev-libs/libsigc++-2.99.1:3
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		dev-libs/libxslt
		media-gfx/graphviz )
"

pkg_setup() {
    export CFLAGS="-std=c++17 $CFLAGS"
    export CXXFLAGS="-std=c++17 $CXXFLAGS"
}

src_prepare() {
	# don't waste time building examples because they are marked as "noinst"
	sed -i 's/^\(SUBDIRS =.*\)examples\(.*\)$/\1\2/' Makefile.in || die

	# don't waste time building tests
	# they require the boost Unit Testing framework, that's not in base boost
	sed -i 's/^\(SUBDIRS =.*\)tests\(.*\)$/\1\2/' Makefile.in || die

	gnome2_src_prepare
}

src_configure() {
	ECONF_SOURCE="${S}" gnome2_src_configure \
		--disable-tests \
		$(use_enable doc documentation)
}

src_install() {
	gnome2_src_install
}
