# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic autotools out-of-source

SRC_URI="https://cairographics.org/releases/${P}.tar.xz"
KEYWORDS="*"

DESCRIPTION="A vector graphics library with cross-device output support"
HOMEPAGE="https://www.cairographics.org/ https://gitlab.freedesktop.org/cairo/cairo"
LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0"
IUSE="X aqua debug gles2 +glib opengl static-libs +svg utils valgrind +xcb"

# Test causes a circular depend on gtk+... since gtk+ needs cairo but test needs gtk+ so we need to block it
RESTRICT="test"

RDEPEND="
	>=dev-libs/lzo-2.06-r1
	>=media-libs/fontconfig-2.10.92
	>=media-libs/freetype-2.5.0.1:2
	>=media-libs/libpng-1.6.10:0=
	sys-libs/binutils-libs:0=
	>=sys-libs/zlib-1.2.8-r1
	>=x11-libs/pixman-0.32.4
	gles2? ( >=media-libs/mesa-9.1.6[gles2] )
	glib? ( >=dev-libs/glib-2.62.2:2 )
	opengl? ( >=media-libs/mesa-9.1.6[egl] )
	X? (
		>=x11-libs/libXrender-0.9.8
		>=x11-libs/libXext-1.3.2
		>=x11-libs/libX11-1.6.2
	)
	xcb? (
		>=x11-libs/libxcb-1.9.1
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=sys-devel/libtool-2
	X? ( x11-base/xorg-proto )
"

REQUIRED_USE="
	gles2? ( !opengl )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.12.18-disable-test-suite.patch
	"${FILESDIR}"/${PN}-respect-fontconfig.patch
	"${FILESDIR}"/${P}-pdf-add-missing-flush.patch
	"${FILESDIR}"/${P}-ft-Use-FT_Done_MM_Var-instead-of-free-when-available.patch
	"${FILESDIR}"/${PN}-CVE-2019-6462.patch
	"${FILESDIR}"/${PN}-CVE-2020-35492.patch
)

src_prepare() {
	default

	# tests and perf tools require X, bug #483574
	if ! use X; then
		sed -e '/^SUBDIRS/ s#boilerplate test perf# #' -i Makefile.am || die
	fi

	eautoreconf
}

my_src_configure() {
	local myopts

	[[ ${CHOST} == *-interix* ]] && append-flags -D_REENTRANT

	use elibc_FreeBSD && myopts+=" --disable-symbol-lookup"

	ECONF_SOURCE="${S}" \
	econf \
		--disable-dependency-tracking \
		$(use_with X x) \
		$(use_enable X tee) \
		$(use_enable X xlib) \
		$(use_enable X xlib-xrender) \
		$(use_enable aqua quartz) \
		$(use_enable aqua quartz-image) \
		$(use_enable debug test-surfaces) \
		$(use_enable gles2 glesv2) \
		$(use_enable glib gobject) \
		$(use_enable opengl gl) \
		$(use_enable static-libs static) \
		$(use_enable svg) \
		$(use_enable utils trace) \
		$(use_enable valgrind) \
		$(use_enable xcb) \
		$(use_enable xcb xcb-shm) \
		--enable-ft \
		--enable-pdf \
		--enable-png \
		--enable-ps \
		--enable-script \
		--enable-interpreter \
		--disable-drm \
		--disable-directfb \
		--disable-gallium \
		--disable-qt \
		--disable-vg \
		--disable-xlib-xcb \
		${myopts}
}

my_src_install_all() {
	prune_libtool_files --all
	einstalldocs
}
