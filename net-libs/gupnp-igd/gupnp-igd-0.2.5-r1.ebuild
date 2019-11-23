# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org xdg-utils

DESCRIPTION="Library to handle UPnP IGD port mapping for GUPnP"
HOMEPAGE="http://gupnp.org"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"
IUSE="+introspection"

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	>=net-libs/gssdp-0.14.7
	>=net-libs/gupnp-0.20.10
	introspection? ( >=dev-libs/gobject-introspection-1.62.0:= )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.10
	sys-devel/gettext
	>=virtual/pkgconfig-0-r1
"

# The only existing test is broken
RESTRICT="test"

multilib_src_configure() {
	xdg_environment_reset

	# python is old-style bindings; use introspection and pygobject instead
	ECONF_SOURCE=${S} \
	econf \
		--disable-static \
		--disable-gtk-doc \
		--disable-python \
		$(use_enable introspection)

	ln -s "${S}"/doc/html doc/html || die
}
