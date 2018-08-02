# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GCONF_DEBUG="no"
VALA_USE_DEPEND="vapigen"

inherit gnome-meson vala

DESCRIPTION="Library and tool for working with Microsoft Cabinet (CAB) files"
HOMEPAGE="https://wiki.gnome.org/msitools"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~*"

IUSE="doc +introspection test +vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.22:2
	sys-libs/zlib
	introspection? ( >=dev-libs/gobject-introspection-0.9.4:= )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.14
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_prepare() {
	gnome-meson_src_prepare
	use vala && vala_src_prepare
}

src_configure() {
	gnome-meson_src_configure \
		$(meson_use introspection introspection) \
		$(meson_use doc docs) \
		$(meson_use test tests)
}
