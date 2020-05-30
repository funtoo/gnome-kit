# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Generic Cascading Style Sheet (CSS) parsing and manipulation toolkit"
HOMEPAGE="https://git.gnome.org/browse/libcroco/"

LICENSE="LGPL-2"
SLOT="0.6"
KEYWORDS="*"
IUSE="test"

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	>=dev-libs/libxml2-2.9.1-r4
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=virtual/pkgconfig-0-r1
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.12-CVE-2017-7960.patch
	"${FILESDIR}"/${PN}-0.6.12-CVE-2017-7961.patch
)

src_prepare() {
	if ! use test; then
		# don't waste time building tests
		sed 's/^\(SUBDIRS .*\=.*\)tests\(.*\)$/\1\2/' -i Makefile.am Makefile.in \
			|| die "sed failed"
	fi

	gnome2_src_prepare
}

src_configure() {
	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		--disable-static \
		$([[ ${CHOST} == *-darwin* ]] && echo --disable-Bsymbolic)

	ln -s "${S}"/docs/reference/html docs/reference/html || die
}

src_install() {
	gnome2_src_install

	einstalldocs
}
