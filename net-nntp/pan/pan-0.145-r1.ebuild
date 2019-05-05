# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 eutils

DESCRIPTION="A newsreader for GNOME"
HOMEPAGE="http://pan.rebelbase.com/"
SRC_URI="http://pan.rebelbase.com/download/releases/${PV}/source/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="dbus gnome-keyring libnotify spell ssl"

RDEPEND="
	>=dev-libs/glib-2.26:2
	dev-libs/gmime:2.6
	>=sys-libs/zlib-1.2.0
	>=x11-libs/gtk+-3:3
	gnome-keyring? ( >=gnome-base/libgnome-keyring-3.2 )
	libnotify? ( >=x11-libs/libnotify-0.4.1:0= )
	spell? (
		app-text/enchant:2
		>=app-text/gtkspell-3:3 )
	ssl? ( >=net-libs/gnutls-3:0= )
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
"

src_prepare() {
	eapply ${FILESDIR}/enchant-2.2.patch
	default
}

src_configure() {
	# Wait for webkitgtk4 support
	# gmime:3.0 support claimed to be experimental still in 0.145, waiting with it until it's not experimental anymore or we work towards removing :2.6
	# funtoo fix: move over to gtk3 and gtkspell3, as well as enchant-2.2+
	gnome2_src_configure \
		--with-yelp-tools \
		--with-gtk3 \
		--without-gmime30 \
		--without-webkit \
		$(use_with dbus) \
		$(use_enable gnome-keyring gkr) \
		$(use_with spell gtkspell) \
		$(use_enable libnotify) \
		$(use_with ssl gnutls)
}
