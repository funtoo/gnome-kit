# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome-meson

DESCRIPTION="An easy-to-use application that will help you to discover what to cook today"
HOMEPAGE="https://wiki.gnome.org/Apps/Recipes"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~*"

IUSE="+spell +archive +sound"

RDEPEND="
	>=sys-devel/gettext-0.19.7
	spell? ( app-text/gspell )
	archive? ( app-arch/gnome-autoar )
	sound? ( media-libs/libcanberra )
	>=dev-libs/glib-2.42
	>=x11-libs/gtk+-3.22
	net-libs/gnome-online-accounts
"

RDEPEND="
	>=dev-util/meson-0.36
	$DEPEND
"

src_prepare() {
	cd "${S}"/subprojects
	rm -rf libgd
	git clone https://git.gnome.org/browse/libgd
	cd "${S}"
	rm -rf build

	gnome-meson_src_prepare
}

src_configure() {
	gnome-meson_src_configure \
		-Denable-autoar=$(usex archive yes no) \
		-Denable-gspell=$(usex spell yes no) \
		-Denable-canberra=$(usex sound yes no)
}
