
EAPI=7

inherit gnome.org ltprune

DESCRIPTION="Provides a standard configuration setup for installing PKCS#11"
HOMEPAGE="https://p11-glue.github.io/p11-glue/p11-kit.html https://github.com/p11-glue/p11-kit"
SRC_URI="https://github.com/p11-glue/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="+asn1 debug +libffi +trust"
REQUIRED_USE="trust? ( asn1 )"

RDEPEND="asn1? ( >=dev-libs/libtasn1-3.4 )
	libffi? ( >=dev-libs/libffi-3.0.0 )
	trust? ( app-misc/ca-certificates )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/gtk-doc"

pkg_setup() {
	# disable unsafe tests, bug#502088
	export FAKED_MODE=1
}

src_prepare() {
	if [[ ${CHOST} == *-solaris2.* && ${CHOST##*-solaris2.} -lt 11 ]] ; then
		# Solaris 10 and before doesn't know about XPG7 (XOPEN_SOURCE=700)
		# drop to XPG6 to make feature_tests.h happy
		sed -i -e '/define _XOPEN_SOURCE/s/700/600/' common/compat.c || die
		# paths.h isn't available, oddly enough also not used albeit included
		sed -i -e '/#include <paths.h>/d' trust/test-trust.c || die
		# we don't have SUN_LEN here
		sed -i -e 's/SUN_LEN \(([^)]\+)\)/strlen (\1->sun_path)/' \
			p11-kit/server.c || die
	fi
	default
}

src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable trust trust-module) \
		$(use_with trust trust-paths ${EPREFIX}/etc/ssl/certs/ca-certificates.crt) \
		$(use_enable debug) \
		$(use_with libffi) \
		$(use_with asn1 libtasn1)

	# re-use provided documentation
	ln -s "${S}"/doc/manual/html doc/manual/html || die
}

src_install() {
	default
	einstalldocs
	prune_libtool_files --modules
}
