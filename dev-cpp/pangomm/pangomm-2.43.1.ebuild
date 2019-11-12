# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_EAUTORECONF="yes"

inherit gnome2

DESCRIPTION="C++ interface for pango"
HOMEPAGE="https://www.gtkmm.org"

LICENSE="LGPL-2.1+"
SLOT="2.44"
KEYWORDS=""
IUSE="doc"

COMMON_DEPEND="
	>=x11-libs/pango-1.44.7
	>=dev-cpp/glibmm-2.63.1
	>=dev-cpp/cairomm-1.15.5:1
	>=dev-libs/libsigc++-2.3.2:2
	dev-cpp/mm-common
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	doc? (
		media-gfx/graphviz
		dev-libs/libxslt
		app-doc/doxygen )
"
RDEPEND="${COMMON_DEPEND}
	!<dev-cpp/gtkmm-2.13:2.4
"

PATCHES=( "${FILESDIR}/${P}-glibmm-2.62.patch" )

pkg_setup() {
	export CFLAGS="-std=c++17 $CFLAGS"
	export CXXFLAGS="-std=c++17 $CXXFLAGS"
}

src_configure() {
	ECONF_SOURCE="${S}" gnome2_src_configure \
		$(use_enable doc documentation)
}

src_install() {
	gnome2_src_install
}
