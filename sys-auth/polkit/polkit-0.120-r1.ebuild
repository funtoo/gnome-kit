# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson pam pax-utils systemd user xdg-utils

DESCRIPTION="Policy framework for controlling privileges for system-wide services"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/polkit https://gitlab.freedesktop.org/polkit/polkit"
SRC_URI="https://www.freedesktop.org/software/${PN}/releases/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
# Causing some breakages -- see FL-9355
KEYWORDS="-*"
IUSE="elogind examples gtk +introspection kde pam selinux +spidermonkey test"

BDEPEND="
	app-text/docbook-xml-dtd:4.1.2
	app-text/docbook-xsl-stylesheets
	dev-libs/glib
	dev-libs/gobject-introspection-common
	dev-libs/libxslt
	dev-util/glib-utils
	sys-devel/gettext
	virtual/pkgconfig
	introspection? ( dev-libs/gobject-introspection )
"
DEPEND="
	spidermonkey? ( dev-lang/spidermonkey:78[-debug] )
	!spidermonkey? ( dev-lang/duktape )
	dev-libs/glib:2
	dev-libs/expat
	elogind? ( sys-auth/elogind )
	pam? (
		sys-auth/pambase
		sys-libs/pam
	)
"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-policykit )
"
PDEPEND="
	gtk? ( || (
		>=gnome-extra/polkit-gnome-0.105
		>=lxde-base/lxsession-0.5.2
	) )
	kde? ( kde-plasma/polkit-kde-agent )
	!elogind? ( sys-auth/consolekit[policykit] )
"

DOCS=( docs/TODO HACKING NEWS README )

PATCHES=(
	"${FILESDIR}/polkit-0.119-elogind.patch"
	"${FILESDIR}/polkit-0.120-meson.patch"
	"${FILESDIR}/polkit-0.120-duktape.patch"
	"${FILESDIR}/polkit-0.120-CVE-2021-4043.patch"
	"${FILESDIR}/polkit-0.120-CVE-2021-4115.patch"
)

QA_MULTILIB_PATHS="
	usr/lib/polkit-1/polkit-agent-helper-1
	usr/lib/polkit-1/polkitd"

pkg_setup() {
	local u=polkitd
	local g=polkitd
	local h=/var/lib/polkit-1

	enewgroup ${g}
	enewuser ${u} -1 -1 ${h} ${g}
	esethome ${u} ${h}
}

src_prepare() {
	default

	sed -i -e 's|unix-group:wheel|unix-user:0|' src/polkitbackend/*-default.rules || die #401513
}

src_configure() {
	xdg_environment_reset

	local emesonargs=(
		--localstatedir="${EPREFIX}"/var
		-Dauthfw="$(usex pam pam shadow)"
		-Dexamples=false
		-Dgtk_doc=false
		-Dman=true
		-Dsession_tracking="$(usex elogind 'libelogind' 'ConsoleKit')"
		-Dsystemdsystemunitdir="$(systemd_get_systemunitdir)"
		-Djs_engine="$(usex spidermonkey 'mozjs' 'duktape')"
		$(meson_use introspection)
		$(meson_use test tests)
		$(usex pam "-Dpam_module_dir=$(getpam_mod_dir)" '')
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile

	# Required for polkitd on hardened/PaX due to spidermonkey's JIT
	pax-mark mr src/polkitbackend/.libs/polkitd test/polkitbackend/.libs/polkitbackendjsauthoritytest
}

src_install() {
	meson_src_install

	if use examples ; then
		docinto examples
		dodoc src/examples/{*.c,*.policy*}
	fi

	diropts -m 0700 -o polkitd
	keepdir /usr/share/polkit-1/rules.d

	# meson does not install required files with SUID bit. See
	#  https://bugs.gentoo.org/816393
	# Remove the following lines once this has been fixed by upstream
	# (should be fixed in next release: https://gitlab.freedesktop.org/polkit/polkit/-/commit/4ff1abe4a4c1f8c8378b9eaddb0346ac6448abd8)
	fperms u+s /usr/bin/pkexec
	fperms u+s /usr/lib/polkit-1/polkit-agent-helper-1
}

pkg_postinst() {
	chmod 0700 "${EROOT}"/{etc,usr/share}/polkit-1/rules.d
	chown polkitd "${EROOT}"/{etc,usr/share}/polkit-1/rules.d
}
