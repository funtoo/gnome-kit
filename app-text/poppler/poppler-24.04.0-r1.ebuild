# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake toolchain-funcs xdg-utils

CMAKE_BUILD_TYPE=""
SRC_URI="https://gitlab.freedesktop.org/poppler/poppler/-/archive/poppler-24.04.0/poppler-poppler-24.04.0.tar.bz2 -> poppler-poppler-24.04.0.tar.bz2"
KEYWORDS="*"
SLOT="0/136"

DESCRIPTION="PDF rendering library based on the xpdf-3.0 code base"
HOMEPAGE="https://poppler.freedesktop.org/"

LICENSE="GPL-2"
# cairo is a no-op for compatibility and is always enabled in the build now:
IUSE="boost +cairo cjk curl +cxx debug doc +jpeg +jpeg2k +lcms nss png qt5 tiff"

# No test data provided
RESTRICT="test"

BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig
"
DEPEND="
	media-libs/fontconfig
	media-libs/freetype
	sys-libs/zlib
	dev-libs/glib:2
	x11-libs/cairo
	dev-libs/gobject-introspection:=
	curl? ( net-misc/curl )
	jpeg? ( virtual/jpeg:0 )
	jpeg2k? ( >=media-libs/openjpeg-2.3.0-r1:2= )
	lcms? ( media-libs/lcms:2 )
	nss? ( >=dev-libs/nss-3.19:0 )
	png? ( media-libs/libpng:0= )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtxml:5
	)
	tiff? ( media-libs/tiff:0 )
"
RDEPEND="${DEPEND}
	cjk? ( app-text/poppler-data )
"

DOCS=( AUTHORS NEWS README.md README-XPDF )

PATCHES=(
	"${FILESDIR}/${PN}-21.09.0-respect-cflags.patch"
	"${FILESDIR}/${PN}-0.57.0-disable-internal-jpx.patch"
)

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv ${WORKDIR}/poppler-poppler-* ${S} || die
	fi
}

src_prepare() {
	cmake_src_prepare

	# Clang doesn't grok this flag, the configure nicely tests that, but
	# cmake just uses it, so remove it if we use clang
	if [[ ${CC} == clang ]] ; then
		sed -e 's/-fno-check-new//' -i cmake/modules/PopplerMacros.cmake || die
	fi

	if ! grep -Fq 'cmake_policy(SET CMP0002 OLD)' CMakeLists.txt ; then
		sed -e '/^cmake_minimum_required/acmake_policy(SET CMP0002 OLD)' \
			-i CMakeLists.txt || die
	else
		einfo "policy(SET CMP0002 OLD) - workaround can be removed"
	fi
}

src_configure() {
	xdg_environment_reset
	local mycmakeargs=(
		-DBUILD_GTK_TESTS=OFF
		-DBUILD_QT5_TESTS=OFF
		-DBUILD_CPP_TESTS=OFF
		-DENABLE_GOBJECT_INTROSPECTION=ON
		-DENABLE_GPGME=OFF
		-DENABLE_QT6=OFF
		-DENABLE_UNSTABLE_API_ABI_HEADERS=ON
		-DENABLE_UTILS=ON
		-DENABLE_ZLIB_UNCOMPRESS=OFF
		-DRUN_GPERF_IF_PRESENT=OFF
		-DUSE_FLOAT=OFF
		-DENABLE_BOOST=$(usex boost ON OFF)
		-DENABLE_LIBCURL=$(usex curl ON OFF)
		-DENABLE_CPP=$(usex cxx ON OFF)
		-DENABLE_DCTDECODER=$(usex jpeg libjpeg none)
		-DENABLE_LIBOPENJPEG=$(usex jpeg2k openjpeg2 none)
		-DENABLE_LCMS=$(usex lcms ON OFF)
		-DENABLE_LIBCURL=$(usex curl ON OFF)
		-DENABLE_LIBTIFF=$(usex tiff ON OFF)
		-DENABLE_NSS3=$(usex nss ON OFF)
		-DENABLE_LIBPNG=$(usex png ON OFF)
		-DENABLE_QT5=$(usex qt5 ON OFF)
	)
	echo ${mycmakeargs[*]}
	cmake_src_configure
}

src_install() {
	cmake_src_install
}