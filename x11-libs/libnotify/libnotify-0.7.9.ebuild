# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome.org meson xdg-utils

DESCRIPTION="A library for sending desktop notifications"
HOMEPAGE="https://git.gnome.org/browse/libnotify"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"
IUSE="+introspection test"

RDEPEND="
	app-eselect/eselect-notify-send
	>=dev-libs/glib-2.62.2:2
	x11-libs/gdk-pixbuf:2
	introspection? ( >=dev-libs/gobject-introspection-1.62.0:= )
"
DEPEND="${RDEPEND}
	>=dev-libs/gobject-introspection-common-1.32
	>=dev-util/gtk-doc-am-1.14
	app-text/docbook-xsl-ns-stylesheets
	virtual/pkgconfig
	test? ( x11-libs/gtk+:3 )
"
PDEPEND="virtual/notification-daemon"

src_prepare() {
	default
	xdg_environment_reset
}

src_configure() {
	local emesonargs=( \
		-Dgtk_doc=false \
		-Dintrospection=$(usex introspection enabled disabled) \
		-Ddocbook_docs=disabled \
		-Dtests=$(usex test true false)
	)

	meson_src_configure

	# work-around gtk-doc out-of-source brokedness
	ln -s "${S}"/docs/reference/html docs/reference/html || die
}

src_install() {
	meson_src_install
	default

	mv "${ED}"/usr/bin/{,libnotify-}notify-send || die #379941
}

pkg_postinst() {
	eselect notify-send update ifunset
}

pkg_postrm() {
	eselect notify-send update ifunset
}
