# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome3 xdg-utils meson

DESCRIPTION="GNOME webbrowser based on Webkit"
HOMEPAGE="https://wiki.gnome.org/Apps/Web"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"

IUSE="test"

COMMON_DEPEND="
	>=dev-libs/glib-2.62.2:2[dbus]
	>=x11-libs/gtk+-3.24.12:3
	>=net-libs/webkit-gtk-2.25.0:4=
	>=x11-libs/cairo-1.16.0
	>=app-crypt/gcr-3.5.5:=[gtk]
	>=x11-libs/gdk-pixbuf-2.39.2:2
	>=gnome-base/gnome-desktop-3.34.1:3=
	dev-libs/icu:=
	>=dev-libs/json-glib-1.2.0
	>=x11-libs/libnotify-0.5.1:=
	>=app-crypt/libsecret-0.14
	>=net-libs/libsoup-2.48:2.4
	>=dev-libs/libxml2-2.6.12:2
	>=dev-libs/libxslt-1.1.7
	dev-db/sqlite:3
	>=app-text/iso-codes-0.35
	>=gnome-base/gsettings-desktop-schemas-0.0.1
"
# epiphany-extensions support was removed in 3.7; let's not pretend it still works
RDEPEND="${COMMON_DEPEND}
	x11-themes/adwaita-icon-theme
	!www-client/epiphany-extensions
"
# paxctl needed for bug #407085
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	dev-libs/appstream-glib
	sys-apps/paxctl
	dev-libs/libhandy
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	# https://bugzilla.gnome.org/show_bug.cgi?id=778495
	#append-cflags -std=gnu11

	# firefox sync storage is not quite ready in 3.24; deps on hogweed/nettle
	local emesonargs=(
		-Ddeveloper_mode=false
		-Dunit_tests=$(usex test enabled disabled)
	)

	meson_src_configure
}

pkg_postinst() {
	gnome3_schemas_update
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome3_schemas_update
        xdg_desktop_database_update
        xdg_icon_cache_update
}
