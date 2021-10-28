# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome3 virtualx meson

DESCRIPTION="Network-related giomodules for glib"
HOMEPAGE="https://git.gnome.org/browse/glib-networking/"

LICENSE="LGPL-2+"
SLOT="0"
#TODO: ssl flag is not used anyhow but other packages wants glib-networking with SSL
IUSE="+gnome +libproxy smartcard +ssl"
KEYWORDS="*"

RDEPEND="
	>=dev-libs/glib-2.70.0-r1:2
	gnome? ( gnome-base/gsettings-desktop-schemas )
	libproxy? ( >=net-libs/libproxy-0.4.11-r1:= )
	smartcard? (
		>=app-crypt/p11-kit-0.18.4
		>=net-libs/gnutls-3:=[pkcs11] )
	app-misc/ca-certificates
	>=net-libs/gnutls-3:=[pkcs11]
"

DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.19.4
	>=virtual/pkgconfig-0-r1
	>=dev-util/meson-0.46.0
"

src_configure() {
	local emesonargs=(
		-Dgnutls=enabled
		-Dopenssl=$(usex ssl enabled disabled)
		$(meson_feature libproxy)
		$(meson_feature gnome gnome_proxy)
		-Dinstalled_tests=false
		-Dstatic_modules=false
	)
	meson_src_configure
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
