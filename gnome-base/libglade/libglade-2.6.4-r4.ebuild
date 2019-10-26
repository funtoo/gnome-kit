# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

GCONF_DEBUG="no"
GNOME_TARBALL_SUFFIX="bz2"
GNOME2_LA_PUNT="yes"

PYTHON_COMPAT=( python2_7 pypy )
PYTHON_REQ_USE='xml(+)'

inherit autotools eutils gnome2 python-single-r1 virtualx

DESCRIPTION="Library to construct graphical interfaces at runtime"
HOMEPAGE="https://library.gnome.org/devel/libglade/stable/"

LICENSE="LGPL-2"
SLOT="2.0"
KEYWORDS="*"
IUSE="static-libs test tools"
REQUIRED_USE="tools? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=">=dev-libs/glib-2.34.3:2
	>=x11-libs/gtk+-2.24.23:2
	>=dev-libs/atk-2.10.0
	>=dev-libs/libxml2-2.9.1-r4
	tools? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1"
RDEPEND="${RDEPEND}"

pkg_setup() {
	use tools && python-single-r1_pkg_setup
}

src_prepare() {
	# patch to stop make install installing the xml catalog
	# because we do it ourselves in postinst()
	epatch "${FILESDIR}"/Makefile.in.am-2.4.2-xmlcatalog.patch

	# patch to not throw a warning with gtk+-2.14 during tests, as it triggers abort
	epatch "${FILESDIR}/${PN}-2.6.3-fix_tests-page_size.patch"

	# Fails with gold due to recent changes in glib-2.32's pkg-config files
	epatch "${FILESDIR}/${P}-gold-glib-2.32.patch"

	# Needed for solaris, else gcc finds a syntax error in /usr/include/signal.h
	epatch "${FILESDIR}/${P}-enable-extensions.patch"

	sed -i -e 's:-D[A-Z_]*DISABLE_DEPRECATED:$(NULL):g' \
		glade/Makefile.am glade/Makefile.in || die

	if ! use test; then
		sed 's/ tests//' -i Makefile.am Makefile.in || die "sed failed"
	fi

	gnome2_src_prepare
	AT_NOELIBTOOLIZE=yes eautoreconf
}

src_configure() {
	if ! use tools; then
		export am_cv_pathless_PYTHON=none
	fi

	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		$(use_enable static-libs static)

	ln -s "${S}"/doc/html doc/html || die
}

src_test() {
	Xemake check || die "make check failed"
}

src_install() {
	dodir /etc/xml
	gnome2_src_install

	local DOCS=( AUTHORS ChangeLog NEWS README )
	einstalldocs
}

pkg_postinst() {
	echo ">>> Updating XML catalog"
	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "system" \
		"https://glade.gnome.org/glade-2.0.dtd" \
		"${EPREFIX}"/usr/share/xml/libglade/glade-2.0.dtd /etc/xml/catalog
	gnome2_pkg_postinst
}

pkg_postrm() {
	gnome2_pkg_postrm
	echo ">>> removing entries from the XML catalog"
	"${EPREFIX}"/usr/bin/xmlcatalog --noout --del \
		"${EPREFIX}"/usr/share/xml/libglade/glade-2.0.dtd /etc/xml/catalog
}
