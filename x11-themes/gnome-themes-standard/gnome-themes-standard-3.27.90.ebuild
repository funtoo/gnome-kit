# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools gnome.org gnome2-utils

DESCRIPTION="Standard Themes for GNOME Applications"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-themes-standard/"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE=""
KEYWORDS="*"

# Depend on gsettings-desktop-schemas-3.4 to make sure 3.2 users don't lose
# their default background image
RDEPEND="
	>=gnome-base/gsettings-desktop-schemas-3.4
"
DEPEND="
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	# Leave build of gtk+:2 engine to x11-themes/gtk-engines-adwaita
	"${FILESDIR}"/${PN}-3.22.2-exclude-engine.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-static \
		--disable-gtk2-engine \
		--disable-gtk3-engine \
		GTK_UPDATE_ICON_CACHE=$(type -P true)
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
