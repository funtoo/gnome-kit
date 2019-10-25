# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools gnome2

DESCRIPTION="Compiler for the GObject type system"
HOMEPAGE="https://wiki.gnome.org/Projects/Vala"

LICENSE="LGPL-2.1"
SLOT="0.46"
KEYWORDS="*"
IUSE="test"

COMMON_DEPEND="
	>=dev-libs/glib-2.32:2
	>=dev-libs/vala-common-${PV}
"

RDEPEND="
	!dev-lang/vala:0.38
	${COMMON_DEPEND}
"

DEPEND="${COMMON_DEPEND}
	!${CATEGORY}/${PN}:0
	dev-libs/libxslt
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc
	>=media-gfx/graphviz-2.40.1
	test? (
		dev-libs/dbus-glib
		>=dev-libs/glib-2.26:2
		dev-libs/gobject-introspection )
"

src_configure() {
	# weasyprint enables generation of PDF from HTML
	gnome2_src_configure \
		--disable-unversioned \
		VALAC=: \
		WEASYPRINT=:
}

src_install() {
	default
	find "${D}" -name "*.la" -delete || die
}
