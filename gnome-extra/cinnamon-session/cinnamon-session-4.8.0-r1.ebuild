# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit meson gnome3-utils xdg

DESCRIPTION="Cinnamon session manager"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/"
SRC_URI="https://github.com/linuxmint/cinnamon-session/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ FDL-1.1+ LGPL-2+"
SLOT="0"
KEYWORDS="*"
IUSE="doc ipv6"

COMMON_DEPEND="
	>=dev-libs/glib-2.70.0-r1:2=
	media-libs/libcanberra
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3:3
	x11-libs/cairo
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXcomposite
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/pango[X]
	>=x11-libs/xapps-1.0.4
	virtual/opengl
	sys-auth/elogind[policykit]
"

RDEPEND="${COMMON_DEPEND}
	>=gnome-extra/cinnamon-desktop-4.8
"
DEPEND="${COMMON_DEPEND}"
BDEPEND="
	>=dev-util/intltool-0.40.6
	virtual/pkgconfig
	doc? (
		app-text/xmlto
		dev-libs/libxslt )
"

src_configure() {
	local emesonargs=(
		-Dgconf=false
		$(meson_use doc docbook)
		$(meson_use ipv6)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome3_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome3_schemas_update
}
