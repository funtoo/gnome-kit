# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME3_LA_PUNT="yes"
VALA_USE_DEPEND="vapigen"

inherit gnome3 vala virtualx meson

DESCRIPTION="Library for aggregating people from multiple sources"
HOMEPAGE="https://wiki.gnome.org/Projects/Folks"

LICENSE="LGPL-2.1+"
SLOT="0/25" # subslot = libfolks soname version
KEYWORDS="*"

# TODO: --enable-profiling
# Vala isn't really optional, https://bugzilla.gnome.org/show_bug.cgi?id=701099
IUSE="bluetooth eds +telepathy test tracker utils zeitgeist"
REQUIRED_USE="bluetooth? ( eds )"

COMMON_DEPEND="
	$(vala_depend)
	>=dev-libs/glib-2.62.2:2
	dev-libs/dbus-glib
	>=dev-libs/gobject-introspection-1.62.0:=
	>=dev-libs/libgee-0.10:0.8[introspection]
	dev-libs/libxml2
	sys-libs/ncurses:0=
	sys-libs/readline:0=

	bluetooth? ( >=net-wireless/bluez-5 )
	eds? ( >=gnome-extra/evolution-data-server-3.13.90:=[vala] )
	telepathy? ( >=net-libs/telepathy-glib-0.19.9[vala] )
	tracker? ( >=app-misc/tracker-1:0= )
	zeitgeist? ( >=gnome-extra/zeitgeist-0.9.14 )
"
# telepathy-mission-control needed at runtime; it is used by the telepathy
# backend via telepathy-glib's AccountManager binding.
RDEPEND="${COMMON_DEPEND}
	net-im/telepathy-mission-control
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.50.0
	>=dev-util/meson-0.51.0
	sys-devel/gettext
	virtual/pkgconfig
	test? (
		sys-apps/dbus
		bluetooth? (
			>=gnome-extra/evolution-data-server-3.9.1
			>=dev-libs/glib-2.62.2:2 )
	)
	bluetooth? (
		dev-python/dbusmock
	)
"

src_prepare() {
	vala_src_prepare
	gnome3_src_prepare
}

src_configure() {
	# Rebuilding docs needs valadoc, which has no release
	local emesonargs=(
		$(meson_use bluetooth bluez_backend)
		$(meson_use eds eds_backend)
		$(meson_use eds ofono_backend)
		$(meson_use telepathy telepathy_backend)
		$(meson_use tracker tracker_backend)
		$(meson_use utils inspect_tool)
		$(meson_use test installed_tests)
		$(meson_use zeitgeist)
		-Dimport_tool=true
		-Ddocs=false
	)

	meson_src_configure
}

src_test() {
	dbus-launch virtx emake check
}
