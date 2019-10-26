# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 meson

DESCRIPTION="Collection of GSettings schemas for GNOME desktop"
HOMEPAGE="https://git.gnome.org/browse/gsettings-desktop-schemas"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE=""
KEYWORDS="*"

RDEPEND="
	>=dev-libs/glib-2.58:2
	!<gnome-base/gdm-3.8
	media-fonts/source-pro
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.50.1
	sys-devel/gettext
	virtual/pkgconfig
	dev-libs/gobject-introspection:=
"

