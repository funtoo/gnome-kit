# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils gnome3

DESCRIPTION="Library for the Desktop Menu fd.o specification"
HOMEPAGE="https://git.gnome.org/browse/gnome-menus"

LICENSE="GPL-2+ LGPL-2+"
SLOT="3"
KEYWORDS="*"

IUSE="+introspection test"

COMMON_DEPEND="
	>=dev-libs/glib-2.62.2:2
	introspection? ( >=dev-libs/gobject-introspection-1.62.0:= )
"
# Older versions of slot 0 install the menu editor and the desktop directories
RDEPEND="${COMMON_DEPEND}
	!<gnome-base/gnome-menus-3.0.1-r1:0
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
	test? ( dev-libs/gjs )
"

src_prepare() {
	# Don't show KDE standalone settings desktop files in GNOME others menu
	epatch "${FILESDIR}/${PN}-3.32.0-ignore_kde_standalone.patch"

	gnome3_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"

	# Do NOT compile with --disable-debug/--enable-debug=no
	# It disables api usage checks
	gnome3_src_configure \
		$(use_enable introspection) \
		--disable-static
}