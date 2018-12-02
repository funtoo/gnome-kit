# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{3_4,3_5,3_6,3_7} )
VALA_USE_DEPEND="vapigen"

inherit gnome2 python-any-r1 vala

DESCRIPTION="An HTTP library implementation in C"
HOMEPAGE="https://wiki.gnome.org/Projects/libsoup"

LICENSE="LGPL-2+"
SLOT="2.4"
KEYWORDS="*"

IUSE="debug gssapi +introspection samba ssl test vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.34.3:2
	>=dev-libs/libxml2-2.9.1-r4:2
	>=dev-db/sqlite-3.8.2:3
	>=net-libs/glib-networking-2.38.2[ssl?]
	gssapi? ( virtual/krb5 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
	samba? ( net-fs/samba )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=dev-util/intltool-0.35
	>=dev-util/gtk-doc-am-1.20
	>=net-libs/libpsl-0.20.0
	sys-devel/gettext
	>=virtual/pkgconfig-0-r1
	test? ( >=dev-libs/glib-2.40:2 )
	vala? ( $(vala_depend) )
"
#	test? (	www-servers/apache[ssl,apache2_modules_auth_digest,apache2_modules_alias,apache2_modules_auth_basic,
#		apache2_modules_authn_file,apache2_modules_authz_host,apache2_modules_authz_user,apache2_modules_dir,
#		apache2_modules_mime,apache2_modules_proxy,apache2_modules_proxy_http,apache2_modules_proxy_connect]
#		dev-lang/php[apache2,xmlrpc]
#		net-misc/curl
#		net-libs/glib-networking[ssl])"

src_prepare() {
	if ! use test; then
		# don't waste time building tests (bug #226271)
		sed 's/^\(SUBDIRS =.*\)tests\(.*\)$/\1\2/' -i Makefile.am Makefile.in \
			|| die "sed failed"
	fi

	# FIXME: workaround upstream not respecting --without-apache-httpd
	sed -e '/check: start-httpd/d' \
		-i tests/Makefile.am tests/Makefile.in || die

	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	# FIXME: we need addpredict to workaround bug #324779 until
	# root cause (bug #249496) is solved
	addpredict /usr/share/snmp/mibs/.index
	# Disable apache tests until they are usable on Gentoo, bug #326957
	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		--disable-static \
		--disable-tls-check \
		--without-gnome \
		--without-apache-httpd \
		$(usex debug --enable-debug=yes ' ') \
		$(use_with gssapi) \
		$(use_enable introspection) \
		$(use_enable vala) \
		$(use_with samba ntlm-auth '${EPREFIX}'/usr/bin/ntlm_auth)

		# fix gtk-doc
		ln -s "${S}"/docs/reference/html docs/reference/html || die
}

src_install() {
	gnome2_src_install
}
