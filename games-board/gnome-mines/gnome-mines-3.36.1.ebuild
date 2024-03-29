# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome3 vala meson

DESCRIPTION="Clear hidden mines from a minefield"
HOMEPAGE="https://wiki.gnome.org/Apps/Mines"

LICENSE="GPL-3+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="*"

IUSE=""

COMMON_DEPEND="
	>=dev-libs/glib-2.62.2:2
	dev-libs/libgnome-games-support:1
	>=gnome-base/librsvg-2.32.0:2
	>=x11-libs/gtk+-3.24.12:3
"
RDEPEND="${COMMON_DEPEND}
	!<x11-themes/gnome-themes-standard-3.14
"
DEPEND="${COMMON_DEPEND}
	$(vala_depend)
	app-text/yelp-tools
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	sed -i -e "s|('desktop-file',|(|g"  -e "s|('appdata-file',|(|g" data/meson.build
	gnome3_src_prepare
	vala_src_prepare
}
