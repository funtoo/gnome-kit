# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"

inherit gnome2 meson virtualx

DESCRIPTION="Network-related giomodules for glib"
HOMEPAGE="https://git.gnome.org/browse/glib-networking/"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="+gnome +libproxy smartcard +ssl install_test test"

RDEPEND="
	>=dev-libs/glib-2.55.1:2
	gnome? ( gnome-base/gsettings-desktop-schemas )
	libproxy? ( >=net-libs/libproxy-0.4.11-r1:= )
	smartcard? (
		>=app-crypt/p11-kit-0.18.4
		>=net-libs/gnutls-3:=[pkcs11] )
	ssl? (
		app-misc/ca-certificates
		>=net-libs/gnutls-3:= )
"
DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.19.4
	>=virtual/pkgconfig-0-r1
	test? ( sys-apps/dbus[X] )
"

src_prepare() {
	default
	# Disable SSLv3 requiring fallback test, which fails with net-libs/gnutls[-sslv3], bug 595952
	# https://bugzilla.gnome.org/show_bug.cgi?id=782853
	sed -i -e '/\/tls\/connection\/fallback\/SSL/d' "${S}"/tls/tests/connection.c || die
	sed -i -e "s:top_inc:top_inc, include_directories('..'):" "${S}"/tls/tests/meson.build

	if ! use install_test; then
	sed -i -e "/install:/d" "${S}"/tls/tests/meson.build
	sed -i -e "/install_dir: installed_tests_/d" "${S}"/tls/tests/meson.build
	sed -i -e "/install:/d" "${S}"/proxy/tests/meson.build
	sed -i -e "/install_dir: installed_tests_/d" "${S}"/proxy/tests/meson.build
	fi
}

src_configure() {
	local emesonargs=(
		-Doption=disable-static
		-Dca_certificates_path="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt
		-Dlibproxy_support=$(usex libproxy true false)
		-Dgnome_proxy_support=$(usex gnome true false)
		-Dpkcs11_support=$(usex smartcard true false)
		-Dinstalled_tests=$(usex install_test true false)
		-Dstatic_modules=false
	)
	meson_src_configure
}

src_test() {
	# XXX: non-native tests fail if glib-networking is already installed.
	# have no idea what's wrong. would appreciate some help.
	virtx emake check
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
}

pkg_postinst() {
	gnome2_pkg_postinst

	gnome2_giomodule_cache_update || die "Update GIO modules cache failed (for ${ABI})"
}

pkg_postrm() {
	gnome2_pkg_postrm

	gnome2_giomodule_cache_update || die "Update GIO modules cache failed (for ${ABI})"
}
