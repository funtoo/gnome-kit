# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_USE_DEPEND=vapigen
PYTHON_COMPAT=( python3+ )
inherit meson gnome3-utils python-any-r1 vala

SRC_URI="http://download.gimp.org/pub/${PN}/${PV:0:3}/${P}.tar.xz"
KEYWORDS="*"

DESCRIPTION="A graph based image processing framework"
HOMEPAGE="http://www.gegl.org/"

LICENSE="|| ( GPL-3+ LGPL-3 )"
SLOT="0.4"

IUSE="cairo cpu_flags_x86_mmx cpu_flags_x86_sse debug ffmpeg +introspection jpeg2k lcms lensfun libav openexr pdf raw sdl svg tiff umfpack vala v4l webp zlib"
REQUIRED_USE="
	svg? ( cairo )
	vala? ( introspection )
"

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	dev-libs/json-glib
	>=media-libs/babl-0.1.74[introspection?]
	>=media-libs/libpng-1.6.0:0=
	virtual/jpeg:0=
	>=x11-libs/gdk-pixbuf-2.39.2:2
	x11-libs/pango
	cairo? ( >=x11-libs/cairo-1.16.0 )
	ffmpeg? (
		libav? ( media-video/libav:0= )
		!libav? ( media-video/ffmpeg:0= )
	)
	introspection? ( >=dev-libs/gobject-introspection-1.62.0:= )
	jpeg2k? ( >=media-libs/jasper-1.900.1:= )
	lcms? ( >=media-libs/lcms-2.8:2 )
	lensfun? ( >=media-libs/lensfun-0.2.5 )
	openexr? ( >=media-libs/openexr-2.2.0:= )
	pdf? ( >=app-text/poppler-0.71.0[cairo] )
	raw? ( >=media-libs/libraw-0.15.4:0= )
	sdl? ( >=media-libs/libsdl-1.2.0 )
	svg? ( >=gnome-base/librsvg-2.40.6:2 )
	tiff? ( >=media-libs/tiff-4:0 )
	umfpack? ( sci-libs/umfpack )
	v4l? ( >=media-libs/libv4l-1.0.1 )
	webp? ( >=media-libs/libwebp-0.5.0:= )
	zlib? ( >=sys-libs/zlib-1.2.0 )
"
DEPEND="${RDEPEND}
	dev-lang/perl
	>=dev-util/gtk-doc-am-1
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	>=sys-devel/libtool-2.2
	vala? ( $(vala_depend) )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.4.18-program-suffix.patch
)

src_prepare() {
	default
	gnome3_environment_reset
	use vala && vala_src_prepare
}

src_configure() {
	local emesonargs=(
		# FL-7209: docs target will throw a sandbox violation on /dev/video0 if it exists:
		-Ddocs=false
		-Dworkshop=true
		-Dprofile=enabled
		-Dsilent-rules=enabled
		-Dgdk-pixbuf=enabled
		-Dpango=enabled
		-Dgraphviz=disabled
		# libspiro: not in portage main tree
		-Dlibspiro=disabled
		-Dlua=disabled
		-Dmrg=disabled
		$(meson_feature cairo)
		$(meson_feature cairo pangocairo)
		$(meson_feature ffmpeg libavformat)
		$(meson_feature jpeg2k jasper)
		$(meson_feature lcms)
		$(meson_feature lensfun)
		$(meson_feature openexr)
		$(meson_feature pdf popplerglib)
		$(meson_feature raw libraw)
		$(meson_feature sdl)
		$(meson_feature svg librsvg)
		$(meson_feature tiff libtiff)
		$(meson_feature umfpack)
		$(meson_feature v4l libv4l)
		$(meson_feature v4l libv4l2)
		$(meson_feature vala vapigen)
		$(meson_feature webp)
		$(meson_feature zlib)
		$(meson_use introspection)
	)

	meson_src_configure
}
