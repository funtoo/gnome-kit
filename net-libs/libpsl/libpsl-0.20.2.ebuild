# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4..7} )

inherit autotools python-single-r1 ltprune

DESCRIPTION=""
HOMEPAGE=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="doc man nls static-libs rpath +icu -idn -idn2"
GITHUB_REPO="$PN"
GITHUB_USER="rockdaboot"
SRC_URI="https://github.com/${GITHUB_USER}/${PN}/releases/download/libpsl-${PV}/libpsl-${PV}.tar.gz"
REQUIRED_USE="^^ ( idn2 icu idn )"
DEPEND="sys-devel/gettext
	virtual/pkgconfig
	sys-devel/libtool
	doc? ( dev-util/gtk-doc )
	man? ( dev-libs/libxslt )
	idn2? ( net-dns/libidn2[static-libs?] )
	idn? ( net-dns/libidn[static-libs?] )
	icu? ( dev-libs/icu[static-libs?] )
"
RDEPEND="$DEPEND"
PDEPEND=""

src_prepare() {
	default
	if ! use doc ; then
		## this copies ./autogen.sh
		rm -f gtk-doc.make
		echo "EXTRA_DIST =" >gtk-doc.make || die
		echo "CLEANFILES =" >>gtk-doc.make || die
	fi
	eautoreconf
}

src_configure() {
    local idna_lib
    if use idn2; then
        idna_lib=libidn2
    elif use icu; then
        idna_lib=libicu
    else
        idna_lib=libidn
    fi
	local myeconfargs=(
		--disable-cfi
		--disable-ubsan
		--disable-asan
		--enable-runtime=$idna_lib
		--enable-builtin=$idna_lib
		$(use_enable doc gtk-doc)
		$(use_enable doc gtk-doc-html)
		$(use_enable doc gtk-doc-pdf)
		$(use_enable man)
		$(use_enable static-libs static)
		$(use_enable nls)
		$(use_enable rpath)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	exeinto /usr/libexec
	doexe src/psl-make-dafsa

	prune_libtool_files
}