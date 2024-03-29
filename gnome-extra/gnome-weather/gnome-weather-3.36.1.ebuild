# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2+ )

inherit gnome3 python-any-r1 virtualx meson

DESCRIPTION="A weather application for GNOME"
HOMEPAGE="https://wiki.gnome.org/Design/Apps/Weather"

LICENSE="GPL-2+ LGPL-2+ MIT CC-BY-3.0 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="*"

IUSE="test"

RDEPEND="
	>=app-misc/geoclue-2.3.1:2.0
	>=dev-libs/gjs-1.43.3
	>=dev-libs/glib-2.62.2:2
	>=dev-libs/gobject-introspection-1.62.0:=
	>=dev-libs/libgweather-3.17.2:=
	gnome-base/gsettings-desktop-schemas
	>=x11-libs/gtk+-3.24.12:3
"
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	>=dev-util/intltool-0.26
	virtual/pkgconfig
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-util/dogtail[${PYTHON_USEDEP}]') )
"

src_prepare() {
	sed -i -e "/'appdata'\,/d" data/meson.build
	gnome3_src_prepare
}

python_check_deps() {
	use test && has_version "dev-util/dogtail[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_test() {
	virtx emake check TESTS_ENVIRONMENT="dbus-run-session"
}
