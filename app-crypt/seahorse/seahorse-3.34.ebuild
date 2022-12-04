# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2 meson vala

DESCRIPTION="A GNOME application for managing encryption keys"
HOMEPAGE="https://wiki.gnome.org/Apps/Seahorse"

LICENSE="GPL-2+ FDL-1.1+"
SLOT="0"
KEYWORDS="*"

IUSE="doc zeroconf"

COMMON_DEPEND="
	>=app-crypt/gcr-3.11.91:=
	>=app-crypt/gnupg-2.0.12
	>=app-crypt/gpgme-1
	>=app-crypt/libsecret-0.16
	app-crypt/p11-kit
	>=dev-libs/glib-2.62.2:2
	>=net-libs/libsoup-2.33.92:2.4
	net-misc/openssh
	>=x11-libs/gtk+-3.24.12:3
	x11-misc/shared-mime-info
	net-nds/openldap:=
	dev-libs/libpwquality
	zeroconf? ( >=net-dns/avahi-0.6:= )
"
DEPEND="${COMMON_DEPEND}
	$(vala_depend)
	app-text/yelp-tools
	dev-util/gdbus-codegen
	>=dev-util/intltool-0.35
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
"
# Need seahorse-plugins git snapshot
RDEPEND="${COMMON_DEPEND}
	!<app-crypt/seahorse-plugins-2.91.0_pre20110114
"

src_prepare() {
	# https://bugs.funtoo.org/browse/FL-10709
	# This is a hack to make app-crypt/seahorse-3.34 work with Funtoo's newer GNUPG Suite
	# Specifically app-crypt/gnupg-2.3.7 and newer, which is currently an autogen kit-fixups core-kit package
	# This workaround allows gnome-kit-sources/3.36-prime packages to be usable with Funtoo next and
	# 1.4-prime stage3 builds.
	# Eventually when gnome-base/gnome is fully upgraded, we should pull in app-crypt/seahorse 43.0 or newer
	# These newer versions of app-crypt/seahorse support newer versions of app-crypt/gnupg respectively
	# Upstream app-crypt/seahorse Change logs for reference: https://gitlab.gnome.org/GNOME/seahorse/-/tags
	sed -i -e "s|'2.2.0'|'2.2.0', '2.3.7'|g"  meson.build
	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dhelp=$(usex doc true false)
		-Dpgp-support=true
		-Dcheck-compatible-gpg=true
		-Dpkcs11-support=true
		-Dhkp-support=true
		-Dkeyservers-support=true
		-Dldap-support=true
		-Dkey-sharing=$(usex zeroconf true false)
	)

	meson_src_configure
}
