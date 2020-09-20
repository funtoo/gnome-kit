# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME3_LA_PUNT="yes"
PYTHON_COMPAT=( python3+ )
VALA_MIN_API_VERSION="0.26"
VALA_USE_DEPEND="vapigen"

inherit gnome3 meson python-single-r1 vala virtualx

DESCRIPTION="A text editor for the GNOME desktop"
HOMEPAGE="https://wiki.gnome.org/Apps/Gedit"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"

IUSE="+introspection vala"

KEYWORDS="*"

COMMON_DEPEND="
	>=app-text/gspell-1.8.1
	>=dev-libs/glib-2.62.2:2[dbus]
	>=dev-libs/libpeas-1.14.1[gtk]
	>=dev-libs/libxml2-2.5.0:2
	gnome-base/gsettings-desktop-schemas
	gnome-base/gvfs

	>=gui-libs/tepl-4.4.0
	>=x11-libs/gtksourceview-4[introspection?]
	>=x11-libs/gtk+-3.24.12:3[introspection?]
	x11-libs/libX11

	introspection? ( >=dev-libs/gobject-introspection-1.62.0:= )

	${PYTHON_DEPS}
	$(python_gen_cond_dep '
	dev-python/pycairo[${PYTHON_USEDEP}]
	>=dev-python/pygobject-3:3[cairo,${PYTHON_USEDEP}]
	dev-libs/libpeas[python,${PYTHON_USEDEP}]
	')
"
RDEPEND="${COMMON_DEPEND}
	x11-themes/adwaita-icon-theme
"
DEPEND="${COMMON_DEPEND}
	${vala_depend}
	app-text/docbook-xml-dtd:4.1.2
	app-text/yelp-tools
	>=dev-util/gtk-doc-am-1
	>=dev-util/intltool-0.50.1
	>=sys-devel/gettext-0.18
	virtual/pkgconfig
"

src_prepare() {
	vala_src_prepare
	gnome3_src_prepare
}
