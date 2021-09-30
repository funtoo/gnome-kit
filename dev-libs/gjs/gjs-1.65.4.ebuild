# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome3 pax-utils virtualx flag-o-matic meson

DESCRIPTION="Javascript bindings for GNOME"
HOMEPAGE="https://wiki.gnome.org/Projects/Gjs"

LICENSE="MIT || ( MPL-1.1 LGPL-2+ GPL-2+ )"
SLOT="0"
KEYWORDS="*"

IUSE="+cairo elibc_glibc examples gtk readline test"

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	>=dev-libs/gobject-introspection-1.62.0:=

	sys-libs/readline:0
	dev-lang/spidermonkey:68
	virtual/libffi
	cairo? ( x11-libs/cairo[X] )
	gtk? ( x11-libs/gtk+:3 )
	elibc_glibc? ( dev-util/sysprof )
"

DEPEND="${RDEPEND}
	gnome-base/gnome-common
	sys-devel/gettext
	virtual/pkgconfig
	test? ( sys-apps/dbus )
"

src_prepare() {
	gnome3_src_prepare
}

src_configure() {
	# FIXME: add systemtap/dtrace support, like in glib:2
	# FIXME: --enable-systemtap installs files in ${D}/${D} for some reason
	# XXX: Do NOT enable coverage, completely useless for portage installs
	append-cxxflags -std=c++14
	local emesonargs=(
		-Dsystemtap=false
		-Ddtrace=false
		-Dprofiler=$(usex elibc_glibc enabled disabled)
		-Dreadline=$(usex readline enabled disabled)
		-Dcairo=$(usex cairo enabled disabled)
		-Dskip_dbus_tests=$(usex test false true)
		-Dinstalled_tests=false
		-Dskip_gtk_tests=$(usex gtk false true)
	)

	meson_src_configure
}

src_test() {
	virtx emake check
}

src_install() {
	meson_src_install

	if use examples; then
		insinto /usr/share/doc/"${PF}"/examples
		doins "${S}"/examples/*
	fi

	# Required for gjs-console to run correctly on PaX systems
	pax-mark mr "${ED}/usr/bin/gjs-console"
}
