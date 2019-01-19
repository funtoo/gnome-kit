# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME_ORG_MODULE="${PN/pp/++}"

inherit autotools gnome2

DESCRIPTION="C++ wrapper for the libxml2 XML parser library"
HOMEPAGE="http://libxmlplusplus.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT="3.0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="doc"

RDEPEND="
	>=dev-libs/libxml2-2.7.7
	>=dev-cpp/glibmm-2.32
"
DEPEND="${RDEPEND}
	>=dev-cpp/mm-common-0.9
	virtual/pkgconfig
"

src_prepare() {
	default
	eapply "${FILESDIR}"/glibmm.patch
	./autogen.sh || die "autogen failed"
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	ECONF_SOURCE="${S}" gnome2_src_configure \
		$(use_enable doc documentation)
}

src_install() {
	gnome2_src_install
}
