# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit gnome2 

DESCRIPTION="GObject wrapper for the oVirt REST API"
HOMEPAGE="https://github.com/GNOME/libgovirt"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="*"
IUSE="+introspection nls"

RDEPEND="
	introspection? ( >=dev-libs/gobject-introspection-1.62.0:= )"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
    net-libs/rest
    dev-libs/glib
	>=dev-util/intltool-0.40.0
	virtual/pkgconfig"

src_prepare() {
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable introspection) \
		$(use_enable nls)
}
