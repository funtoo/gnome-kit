# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools gnome.org xdg

DESCRIPTION="Library to handle UPnP IGD port mapping for GUPnP"
HOMEPAGE="http://gupnp.org"

LICENSE="LGPL-2.1+"
SLOT="0/1.2"
KEYWORDS="*"
IUSE="+introspection"

RDEPEND="
	>=dev-libs/glib-2.64.2:2
	net-libs/gssdp:1.2=
	net-libs/gupnp:1.2=
	introspection? ( >=dev-libs/gobject-introspection-1.62.0:= )
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.10
	sys-devel/gettext
	>=virtual/pkgconfig-0-r1
"

# The only existing test is broken
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PV}-gupnp-1.2.patch # needs eautoreconf, https://gitlab.gnome.org/GNOME/gupnp-igd/merge_requests/1
)

src_prepare() {
	xdg_src_prepare
	eautoreconf
}

src_configure() {
	# python is old-style bindings; use introspection and pygobject instead
	ECONF_SOURCE=${S} \
	econf \
		--disable-static \
		--disable-gtk-doc \
		--disable-python \
		$(use_enable introspection)

	ln -s "${S}"/doc/html doc/html || die
}
