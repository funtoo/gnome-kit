# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME3_LA_PUNT="yes"

inherit flag-o-matic gnome3 meson

DESCRIPTION="A window navigation construction kit"
HOMEPAGE="https://developer.gnome.org/libwnck/stable/"

LICENSE="LGPL-2+"
SLOT="3"
KEYWORDS="*"

IUSE="doc +introspection startup-notification tools"

RDEPEND="
	x11-libs/cairo[X]
	>=x11-libs/gtk+-3.24.12:3[introspection?]
	>=dev-libs/glib-2.62.2:2
	x11-libs/libX11
	x11-libs/libXres
	x11-libs/libXext
	introspection? ( >=dev-libs/gobject-introspection-1.62.0:= )
	startup-notification? ( x11-libs/startup-notification )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.9
	>=sys-devel/gettext-0.19.4
	>=dev-util/meson-0.50.0
	virtual/pkgconfig
"
# eautoreconf needs
#	sys-devel/autoconf-archive

src_configure() {
	# Don't collide with SLOT=1
	local emesonargs=(
		-Dintrospection=$(usex introspection enabled disabled)
		-Dstartup_notification=$(usex startup-notification enabled disabled)
		$(meson_use tools install_tools)
		$(meson_use doc gtk_doc)
	)

	meson_src_configure
}

post_src_install() {
	if ! use startup-notification; then
		# fix pkgconfig file to be correct.
		sed -i -e 's/ libstartup-notification-1.0//g' ${D}/usr/lib*/pkgconfig/libwnck-3.0.pc || die
	fi
}

