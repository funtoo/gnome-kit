# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome3 virtualx meson

DESCRIPTION="Network-related giomodules for glib"
HOMEPAGE="https://git.gnome.org/browse/glib-networking/"

LICENSE="LGPL-2+"
SLOT="0"
#TODO: ssl flag is not used anyhow but other packages wants glib-networking with SSL
IUSE="+gnome +libproxy smartcard test +ssl"
KEYWORDS="*"

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	gnome? ( gnome-base/gsettings-desktop-schemas )
	libproxy? ( >=net-libs/libproxy-0.4.11-r1:= )
	smartcard? (
		>=app-crypt/p11-kit-0.18.4
		>=net-libs/gnutls-3:=[pkcs11] )
	app-misc/ca-certificates
	>=net-libs/gnutls-3:=
"

DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.19.4
	>=virtual/pkgconfig-0-r1
	>=dev-util/meson-0.46.0
	test? ( sys-apps/dbus[X] )
"

src_prepare() {
	default
	# Disable SSLv3 requiring fallback test, which fails with net-libs/gnutls[-sslv3], bug 595952
	# https://bugzilla.gnome.org/show_bug.cgi?id=782853
	sed -i -e '/\/tls\/connection\/fallback\/SSL/d' "${S}"/tls/tests/connection.c || die
}

src_configure() {
	local emesonargs=(
		-Dopenssl=$(usex ssl enabled disabled)
		-Dlibproxy=$(usex libproxy enabled disabled)
		-Dgnome_proxy=$(usex gnome enabled disabled)
	)

	meson_src_configure
}

src_test() {
	# XXX: non-native tests fail if glib-networking is already installed.
	# have no idea what's wrong. would appreciate some help.
	virtx emake check
}

src_install() {
	meson_src_install
}

pkg_postinst() {
	gnome3_pkg_postinst

	gnome3_giomodule_cache_update || die "Update GIO modules cache failed (for ${ABI})"
}

pkg_postrm() {
	gnome3_pkg_postrm

	gnome3_giomodule_cache_update || die "Update GIO modules cache failed (for ${ABI})"
}
