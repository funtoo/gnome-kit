# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME3_LA_PUNT="yes"
PYTHON_COMPAT=( python3+ )

inherit fcaps gnome3 pam python-any-r1 virtualx

DESCRIPTION="Password and keyring managing daemon"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeKeyring"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
IUSE="+caps pam selinux +ssh-agent test"
KEYWORDS="*"

# Replace gkd gpg-agent with pinentry[gnome-keyring] one, bug #547456
RDEPEND="
	>=app-crypt/gcr-3.27.90:=[gtk]
	>=dev-libs/glib-2.62.2:2
	app-misc/ca-certificates
	>=dev-libs/libgcrypt-1.2.2:0=
	sys-libs/libcap-ng
	pam? ( virtual/pam )
	selinux? ( sec-policy/selinux-gnome )
	>=app-crypt/gnupg-2.0.28:=
	ssh-agent? ( net-misc/openssh )
"
DEPEND="${RDEPEND}
	>=app-eselect/eselect-pinentry-0.5
	app-text/docbook-xml-dtd:4.3
	dev-libs/libxslt
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? ( ${PYTHON_DEPS} )
"
PDEPEND="app-crypt/pinentry[gnome-keyring]" #570512

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	# Disable stupid CFLAGS with debug enabled
	sed -e 's/CFLAGS="$CFLAGS -g"//' \
		-e 's/CFLAGS="$CFLAGS -O0"//' \
		-i configure.ac configure || die

	gnome3_src_prepare
}

src_configure() {
	gnome3_src_configure \
		$(use_with caps libcap-ng) \
		$(use_enable pam) \
		$(use_with pam pam-dir $(getpam_mod_dir)) \
		$(use_enable selinux) \
		$(use_enable ssh-agent) \
		--enable-doc
}

src_test() {
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/schema" || die
	GSETTINGS_SCHEMA_DIR="${S}/schema" virtx emake check
}

src_install() {
	default
	# See FL-8892: disabling caps entirely allows connections to keyring with glib-2.67.2+.
	fcaps -r ${D}/usr/bin/gnome-keyring-daemon
}

pkg_postinst() {
	if [ "$(/sbin/getcap $ROOT/usr/bin/gnome-keyring-daemon)" != "" ]; then
		warn "gnome-keyring-daemon has enhanced capabilities and this will prevent it from connecting to dbus!"
	fi
	gnome3_pkg_postinst

	if ! [[ $(eselect pinentry show | grep "pinentry-gnome3") ]] ; then
		ewarn "Please select pinentry-gnome3 as default pinentry provider:"
		ewarn " # eselect pinentry set pinentry-gnome3"
	fi
}
