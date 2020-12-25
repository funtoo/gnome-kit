# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit meson pax-utils virtualx

DESCRIPTION="Linux Mint's fork of gjs for Cinnamon"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/"
SRC_URI="https://github.com/linuxmint/cjs/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT || ( MPL-1.1 LGPL-2+ GPL-2+ )"
SLOT="0"
IUSE="+cairo examples readline test"
KEYWORDS="*"
RESTRICT="test"

RDEPEND="
	dev-lang/spidermonkey:78
	>=dev-libs/glib-2.42:2
	>=dev-libs/gobject-introspection-1.41.4:=
	readline? ( sys-libs/readline:0= )
	dev-libs/libffi:0=
	cairo? ( x11-libs/cairo[X,glib] )
	x11-libs/gtk+:3
"
DEPEND="${RDEPEND}
	sys-devel/autoconf-archive
	test? ( sys-apps/dbus )
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	# TODO: more to add and test here
	local emesonargs=(
		-Dsystemtap=false
		-Ddtrace=false
		$(meson_feature cairo)
		$(meson_feature readline)
	)
	meson_src_configure
}

src_test() {
	virtx emake check
}

post_src_install() {
	if use examples; then
		docinto examples
		dodoc "${S}"/examples/*
	fi

	# Required for cjs-console to run correctly on PaX systems
	pax-mark mr "${ED}/usr/bin/cjs-console"
}
