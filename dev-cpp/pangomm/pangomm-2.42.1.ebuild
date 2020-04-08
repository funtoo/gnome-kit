# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="C++ interface for pango"
HOMEPAGE="https://www.gtkmm.org"

LICENSE="LGPL-2.1+"
SLOT="1.4"
KEYWORDS="*"
IUSE="doc"

COMMON_DEPEND="
	>=x11-libs/pango-1.44.7
	=dev-cpp/glibmm-2.62.0*
	>=dev-cpp/cairomm-1.12.0:0
	>=dev-libs/libsigc++-2.3.2:2
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
