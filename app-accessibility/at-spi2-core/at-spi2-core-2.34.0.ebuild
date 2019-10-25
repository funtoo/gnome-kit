# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"

inherit gnome2 meson

DESCRIPTION="D-Bus accessibility specifications and registration daemon"
HOMEPAGE="https://wiki.gnome.org/Accessibility"

LICENSE="LGPL-2+"
SLOT="2"
KEYWORDS="*"

IUSE="X +introspection"

# x11-libs/libSM is needed until upstream #719808 is solved either
# making the dep unneeded or fixing their configure
# Only libX11 is optional right now
RDEPEND="
	>=dev-libs/glib-2.36:2
	>=sys-apps/dbus-1
	x11-libs/libSM
	x11-libs/libXi
	x11-libs/libXtst
	introspection? ( >=dev-libs/gobject-introspection-0.9.6:= )
	X? (
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXtst
	)
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.9
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	# disable teamspaces test since that requires Novell.ICEDesktop.Daemon
	"${FILESDIR}/${PN}-2.0.2-disable-teamspaces-test.patch"
)

src_configure() {
	local emesonargs=(
		-Denable-xevie=false
		-Denable-introspection=$(usex introspection yes no)
		-Denable-x11=$(usex X yes no)
	)

	meson_src_configure
}

src_compile() { meson_src_compile; }
src_install() { meson_src_install; }
