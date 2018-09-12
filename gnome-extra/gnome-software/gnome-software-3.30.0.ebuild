# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 )

inherit gnome-meson python-any-r1 virtualx

DESCRIPTION="Gnome install & update software"
HOMEPAGE="https://wiki.gnome.org/Apps/Software"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="gnome spell test udev"

RDEPEND="
	>=app-admin/packagekit-base-1.1.0
	app-crypt/libsecret
	dev-db/sqlite:3
	>=dev-libs/appstream-glib-0.6.7:0
	>=dev-libs/glib-2.46:2
	>=dev-libs/json-glib-1.1.1
	>=gnome-base/gsettings-desktop-schemas-3.11.5
	>=net-libs/libsoup-2.51.92:2.4
	sys-auth/polkit
	>=x11-libs/gdk-pixbuf-2.31.5
	>=x11-libs/gtk+-3.20:3
	gnome? ( >=gnome-base/gnome-desktop-3.17.92:3= )
	spell? ( app-text/gtkspell:3 )
	udev? ( virtual/libgudev )
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.2
	dev-libs/libxslt
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-util/dogtail[${PYTHON_USEDEP}]') )
"
# test? ( dev-util/valgrind )

python_check_deps() {
	use test && has_version "dev-util/dogtail[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	gnome-meson_src_prepare
}

src_configure() {
	# FIXME: investigate limba and firmware update support
	gnome-meson_src_configure \
		-Denable-man=true \
		-Denable-packagekit=true \
		-Denable-polkit=true \
		-Denable-shell-extensions=true \
		-Denable-firmware=false \
		-Denable-limba=false \
		-Denable-rpm-ostree=false \
		-Denable-flatpak=false \
		-Denable-fwupd=false \
		-Denable-steam=false \
		-Denable-odrs=false \
		-Denable-ubuntuone=false \
		-Denable-ubuntu-reviews=false \
		-Denable-webapps=false \
		-Denable-snap=false \
		-Denable-external-appstream=false \
		-Denable-valgrind=false \
		$(meson_use gnome enable-gnome-desktop) \
		$(meson_use spell enable-gspell) \
		$(meson_use test enable-tests) \
		$(meson_use udev enable-gudev)
}

src_test() {
	virtx emake check TESTS_ENVIRONMENT="dbus-run-session"
}
