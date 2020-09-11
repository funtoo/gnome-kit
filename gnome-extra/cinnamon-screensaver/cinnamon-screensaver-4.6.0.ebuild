# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3+ )

inherit meson gnome3-utils python-r1 xdg

DESCRIPTION="Screensaver for Cinnamon"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/"
SRC_URI="https://github.com/linuxmint/cinnamon-screensaver/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="debug xinerama"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
KEYWORDS="*"

COMMON_DEPEND="
	>=dev-libs/glib-2.37.3:2[dbus]
	>=x11-libs/gtk+-3.1.4:3[introspection]
	>=gnome-extra/cinnamon-desktop-4.4:0=
	>=gnome-base/gsettings-desktop-schemas-0.1.7
	>=dev-libs/dbus-glib-0.78

	sys-apps/dbus
	sys-libs/pam
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	x11-themes/adwaita-icon-theme

	${PYTHON_DEPS}

	xinerama? ( x11-libs/libXinerama )
"

RDEPEND="${COMMON_DEPEND}
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/setproctitle[${PYTHON_USEDEP}]
		dev-python/xapp[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	' 'python3*')
	sys-auth/elogind
"
DEPEND="${COMMON_DEPEND}
	dev-util/gdbus-codegen
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
	x11-base/xorg-proto
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.6.0-python-build.patch
	"${FILESDIR}"/${PN}-4.6.0-xinerama.patch
)

pkg_setup() {
	python_setup
}

src_prepare() {
	xdg_src_prepare
	python_fix_shebang src
}

src_configure() {
	local emesonargs=(
		$(meson_use debug)
		$(meson_use xinerama)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	python_optimize "${ED}"/usr/share/cinnamon-screensaver/
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome3_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome3_schemas_update
}
