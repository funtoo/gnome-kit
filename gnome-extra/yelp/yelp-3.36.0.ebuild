# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME3_LA_PUNT="yes"

inherit autotools gnome3

DESCRIPTION="Help browser for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Yelp"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE=""

RDEPEND="
	app-arch/bzip2:=
	>=app-arch/xz-utils-4.9:=
	dev-db/sqlite:3=
	>=dev-libs/glib-2.62.2:2
	>=dev-libs/libxml2-2.6.5:2
	>=dev-libs/libxslt-1.1.4
	>=gnome-extra/yelp-xsl-3.32.0
	>=net-libs/webkit-gtk-2.19.2:4
	>=x11-libs/gtk+-3.24.12:3
	x11-themes/adwaita-icon-theme
"
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	>=dev-util/gtk-doc-am-1.13
	>=dev-util/intltool-0.41.0
	dev-util/itstool
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

src_prepare() {
	# Fix compatibility with Gentoo's sys-apps/man
	# https://bugzilla.gnome.org/show_bug.cgi?id=648854
	eapply "${FILESDIR}"/${PN}-3.20.0-man-compatibility.patch

	eautoreconf
	gnome3_src_prepare
}

src_configure() {
	gnome3_src_configure \
		--disable-static \
		--enable-bz2 \
		--enable-lzma \
		APPSTREAM_UTIL=""
}

src_install() {
	gnome3_src_install
	exeinto /usr/libexec/
	doexe "${S}"/libyelp/yelp-groff
}
