# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_MIN_API_VERSION=${VALA_MIN_API_VERSION:-0.44}
VALA_USE_DEPEND="vapigen"

inherit gnome2 meson vala

DESCRIPTION="A simple GObject game controller library."
HOMEPAGE="https://gitlab.gnome.org/aplazas/libmanette"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="*"
IUSE=""

COMMON_DEPEND="
	>=dev-libs/glib-2.56.0
	dev-libs/libgudev
	dev-libs/libevdev
"

DEPEND="${COMMON_DEPEND}
	${vala_depend}
"

src_prepare() {
	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	meson_src_configure
}
