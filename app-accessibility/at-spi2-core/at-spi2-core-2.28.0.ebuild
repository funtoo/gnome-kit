# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"

inherit gnome2 meson multilib-minimal

DESCRIPTION="D-Bus accessibility specifications and registration daemon"
HOMEPAGE="https://wiki.gnome.org/Accessibility"

LICENSE="LGPL-2+"
SLOT="2"
KEYWORDS="*"

IUSE="X +introspection locale"

# x11-libs/libSM is needed until upstream #719808 is solved either
# making the dep unneeded or fixing their configure
# Only libX11 is optional right now
RDEPEND="
	>=dev-libs/glib-2.36:2[${MULTILIB_USEDEP}]
	>=sys-apps/dbus-1[${MULTILIB_USEDEP}]
	x11-libs/libSM[${MULTILIB_USEDEP}]
	x11-libs/libXi[${MULTILIB_USEDEP}]
	x11-libs/libXtst[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.9.6:= )
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXi[${MULTILIB_USEDEP}]
		x11-libs/libXtst[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.9
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"

src_prepare() {
	default
	PATCHES=(
		# disable teamspaces test since that requires Novell.ICEDesktop.Daemon
		"${FILESDIR}/${PN}-2.0.2-disable-teamspaces-test.patch"
	)

	if ! use locale; then
		sed -i -e "s/^\([[:space:]]*\)subdir('po')/#\1subdir('po')/" "${S}"/meson.build
	fi
}

multilib_src_configure() {
	local emesonargs=(
		-D enable-introspection=$(usex introspection yes no)
		-D enable-x11=$(usex X yes no)
		-D enable_docs=false
	)
	meson_src_configure
}

multilib_src_compile() { meson_src_compile; }
multilib_src_install() { meson_src_install; }
