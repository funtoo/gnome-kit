# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# vala and introspection support is broken, bug #468208
VALA_USE_DEPEND=vapigen

inherit meson gnome2-utils vala

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/gegl.git"
	SRC_URI=""
else
	SRC_URI="http://download.gimp.org/pub/${PN}/${PV:0:3}/${P}.tar.xz"
	KEYWORDS="*"
fi

DESCRIPTION="A graph based image processing framework"
HOMEPAGE="http://www.gegl.org/"

LICENSE="|| ( GPL-3+ LGPL-3 )"
SLOT="0.4"

IUSE="cairo cpu_flags_x86_mmx cpu_flags_x86_sse debug ffmpeg +introspection jpeg2k lcms lensfun libav openexr pdf raw sdl svg test tiff umfpack vala v4l webp zlib"
REQUIRED_USE="
	svg? ( cairo )
	vala? ( introspection )
"

# NOTE: Even current libav 11.4 does not have AV_CODEC_CAP_VARIABLE_FRAME_SIZE
#       so there is no chance to support libav right now (Gentoo bug #567638)
#       If it returns, please check prior GEGL ebuilds for how libav was integrated.  Thanks!
RDEPEND="
	>=dev-libs/glib-2.62.2:2
	dev-libs/json-glib
	>=media-libs/babl-0.1.74
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
	test? ( ffmpeg? ( media-libs/gexiv2 )
		introspection? (
			dev-lang/python
		)
	)
	vala? ( $(vala_depend) )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.4.18-drop-failing-tests.patch
	"${FILESDIR}"/${PN}-0.4.18-program-suffix.patch
)

src_prepare() {
	default

	gnome2_environment_reset

	use vala && vala_src_prepare
}

src_configure() {
	local emesonargs=(
		# disable documentation as the generating is bit automagic
		#    if anyone wants to work on it just create bug with patch
		-Ddocs=true
		#  - Parameter --disable-workshop disables any use of Lua, effectivly
		-Dworkshop=true
		# never enable altering of CFLAGS via profile option
		-Dprofile=enabled
		-Dsilent-rules=enabled
		-Dgdk-pixbuf=enabled
		-Dpango=enabled
		#  - There are two checks for dot, one controllable by --with(out)-graphviz
		#    which toggles HAVE_GRAPHVIZ that is not used anywhere.  Yes.
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
		#  - v4l support does not work with our media-libs/libv4l-0.8.9,
		#    upstream bug at https://bugzilla.gnome.org/show_bug.cgi?id=654675
		$(meson_feature v4l libv4l)
		$(meson_feature v4l libv4l2)
		$(meson_feature vala)
		$(meson_feature webp)
		$(meson_feature zlib)
		$(meson_use introspection)
	)

#	if use test; then
#		myeconfargs+=( $(use_with ffmpeg gexiv2) )
#	else
#		myeconfargs+=( --without-gexiv2 )
#	fi

	meson_src_configure
}

src_install() {
	meson_src_install
	find "${ED}" -name '*.la' -delete || die
}

