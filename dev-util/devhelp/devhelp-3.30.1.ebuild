# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
# gedit-3.8 is python3 only, this also per:
# https://bugzilla.redhat.com/show_bug.cgi?id=979450
PYTHON_COMPAT=( python3_{4,5,6,7} )

inherit gnome-meson python-single-r1 toolchain-funcs

DESCRIPTION="An API documentation browser for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Devhelp"

LICENSE="GPL-2+"
SLOT="0/3-3" # subslot = 3-(libdevhelp-3 soname version)
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="doc gedit +introspection"
REQUIRED_USE="gedit? ( ${PYTHON_REQUIRED_USE} )"

COMMON_DEPEND="
	>=dev-libs/glib-2.38:2[dbus]
	>=x11-libs/gtk+-3.20:3
	>=net-libs/webkit-gtk-2.6.0:4
	introspection? ( >=dev-libs/gobject-introspection-1.30:= )
"
RDEPEND="${COMMON_DEPEND}
	gedit? (
		${PYTHON_DEPS}
		app-editors/gedit[introspection,python,${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		x11-libs/gtk+[introspection] )
	gnome-base/gsettings-desktop-schemas
"
DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	>=dev-util/gtk-doc-am-1.25
	virtual/pkgconfig
	>=x11-libs/amtk-5.0
"
pkg_setup() {
	use gedit && python-single-r1_pkg_setup
}

src_prepare() {
	gnome-meson_src_prepare
}

src_configure() {
	gnome-meson_src_configure \
		$(meson_use doc gtk_doc)
}
