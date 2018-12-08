# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils gnome.org gnome-meson xdg

DESCRIPTION="Cooking recipe application"
HOMEPAGE="https://wiki.gnome.org/Apps/Recipes"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"
IUSE="autoar gspell"

RDEPEND="
	dev-libs/glib:2
	media-libs/libcanberra
	net-libs/libsoup:2.4
	>=x11-libs/gtk+-3.22:3
	>=dev-libs/json-glib-1
	>=net-libs/rest-0.7
	net-libs/gnome-online-accounts
	autoar? ( app-arch/gnome-autoar )
	gspell? ( >=app-text/gspell-1 )
"
DEPEND="${RDEPEND}
	dev-util/meson
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dautoar=$(usex autoar yes no)
		-Dgspell=$(usex gspell yes no)
		-Dcanberra=yes
	)
	gnome-meson_src_configure
}

pkg_postinst() {
	gnome2_schemas_update
	gnome2_icon_cache_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
	gnome2_icon_cache_update
	xdg_pkg_postrm
}
