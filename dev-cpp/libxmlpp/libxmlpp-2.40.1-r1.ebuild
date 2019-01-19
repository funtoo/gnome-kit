# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"
GNOME_ORG_MODULE="${PN/pp/++}"

inherit autotools gnome2

DESCRIPTION="C++ wrapper for the libxml2 XML parser library"
HOMEPAGE="http://libxmlplusplus.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT="2.6"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="doc"

RDEPEND="
	>=dev-libs/libxml2-2.7.7
	>=dev-cpp/glibmm-2.32
"
DEPEND="${RDEPEND}
	>=dev-cpp/mm-common-0.9
	virtual/pkgconfig
"

pkg_setup() {
	export CFLAGS="-std=c++11 $CFLAGS"
	export CXXFLAGS="-std=c++11 $CXXFLAGS"
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-glibmm2.58.patch
	epatch "${FILESDIR}"/${P}-glib-threads.patch
	epatch "${FILESDIR}"/${P}-glib2.58.patch
	./autogen.sh || die "autogen failed"
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	ECONF_SOURCE="${S}" gnome2_src_configure \
		$(use_enable doc documentation)
}

multilib_src_install() {
	gnome2_src_install
}
