# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit gnome2 toolchain-funcs

DESCRIPTION="Internationalized text layout and rendering library"
HOMEPAGE="https://www.pango.org/"
SRC_URI+=" https://dev.gentoo.org/~leio/distfiles/${P}-patchset.tar.xz"

LICENSE="LGPL-2+ FTL"
SLOT="0"
KEYWORDS="*"

IUSE="X +introspection test"

RDEPEND="
	>=media-libs/harfbuzz-1.4.2:=[glib(+),truetype(+)]
	>=dev-libs/glib-2.62.2:2
	>=media-libs/fontconfig-2.12.92:1.0=
	>=media-libs/freetype-2.5.0.1:2=
	>=x11-libs/cairo-1.16.0-r4:=[X?]
	>=dev-libs/fribidi-0.19.7
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
	X? (
		>=x11-libs/libXrender-0.9.8
		>=x11-libs/libX11-1.6.2
		>=x11-libs/libXft-2.3.1-r1
	)
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.20
	virtual/pkgconfig
	test? ( media-fonts/cantarell )
	X? ( x11-base/xorg-proto )
	!<=sys-devel/autoconf-2.63:2.5
"

PATCHES=(
	"${WORKDIR}"/patches/ # bug fix cherry-picks from master by 20190216; each patch has commit id of origin/master included and will be part of 1.43.1/1.44
	"${FILESDIR}"/${PV}-CVE-2019-1010238.patch
)

src_prepare() {
	gnome2_src_prepare
	# This should be updated if next release fails to pre-generate the manpage as well, or src_prepare removed if is properly generated
	# https://gitlab.gnome.org/GNOME/pango/issues/270
	cp -v "${FILESDIR}"/${PV}-pango-view.1.in "${S}/utils/pango-view.1.in" || die
}

src_configure() {
	tc-export CXX

	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		--with-cairo \
		$(use_enable introspection) \
		$(use_with X xft) \
		"$(usex X --x-includes="${EPREFIX}/usr/include" "")" \
		"$(usex X --x-libraries="${EPREFIX}/usr/$(get_libdir)" "")"

	ln -s "${S}"/docs/html docs/html || die
}

src_install() {
	gnome2_src_install
}
