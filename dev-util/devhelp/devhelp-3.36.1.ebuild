# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3+ )

inherit gnome3 python-single-r1 toolchain-funcs meson

DESCRIPTION="An API documentation browser for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Devhelp"

LICENSE="GPL-2+"
SLOT="0/3-1" # subslot = 3-(libdevhelp-3 soname version)
KEYWORDS="*"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="
	>=dev-libs/glib-2.62.2:2[dbus]
	>=x11-libs/gtk+-3.24.12:3
	>=net-libs/webkit-gtk-2.20:4
	>=gui-libs/amtk-5.0.0
"
RDEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	app-editors/gedit[introspection,python,${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+[introspection]
	gnome-base/gsettings-desktop-schemas
"
DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	>=dev-util/intltool-0.40
	gnome-base/gnome-common
	virtual/pkgconfig
"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	gnome3_src_prepare
}
