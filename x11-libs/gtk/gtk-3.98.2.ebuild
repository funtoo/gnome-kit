# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME3_LA_PUNT="yes"

inherit flag-o-matic gnome3 meson virtualx

DESCRIPTION="Gimp ToolKit"
HOMEPAGE="https://www.gtk.org/"
SRC_URI="https://gitlab.gnome.org/GNOME/gtk/-/archive/${PV}/gtk-${PV}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
IUSE="aqua broadway cloudprint colord cups docs examples ffmpeg +gstreamer +introspection test vim-syntax vulkan wayland X xinerama"
REQUIRED_USE="
	|| ( aqua wayland X )
	xinerama? ( X )
	colord? ( cups )
"

KEYWORDS="*"

# Upstream wants us to do their job:
# https://bugzilla.gnome.org/show_bug.cgi?id=768662#c1
RESTRICT="test"

# FIXME: introspection data is built against system installation of gtk+:3,
# bug #????
COMMON_DEPEND="
	app-text/enchant
	>=dev-libs/atk-2.15.1[introspection?]
	>=media-libs/graphene-1.8.0[introspection?]
	>=dev-libs/glib-2.53.7:2
	media-libs/fontconfig
	>=media-libs/libepoxy-1.4[X(+)?]
	>=x11-libs/cairo-1.14[aqua?,glib,svg,X?]
	>=x11-libs/gdk-pixbuf-2.30:2[introspection?]
	>=x11-libs/pango-1.37.3[introspection?]
	x11-misc/shared-mime-info

	cloudprint? (
		>=net-libs/rest-0.7
		>=dev-libs/json-glib-1.0 )
	colord? ( >=x11-misc/colord-0.1.9:0= )
	cups? ( >=net-print/cups-1.2 )
	introspection? ( >=dev-libs/gobject-introspection-1.39:= )
	wayland? (
		>=dev-libs/wayland-1.14.91
		>=dev-libs/wayland-protocols-1.16
		media-libs/mesa[wayland]
		>=x11-libs/libxkbcommon-0.2
	)
	X? (
		>=app-accessibility/at-spi2-atk-2.5.3
		x11-libs/libX11
		>=x11-libs/libXi-1.3
		x11-libs/libXext
		>=x11-libs/libXrandr-1.5
		x11-libs/libXcursor
		x11-libs/libXfixes
		x11-libs/libXcomposite
		x11-libs/libXdamage
		xinerama? ( x11-libs/libXinerama )
	)
	gstreamer? ( >=media-libs/gstreamer-1.12.3 )
	ffmpeg? ( media-video/ffmpeg )
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xsl-stylesheets
	app-text/docbook-xml-dtd:4.1.2
	dev-libs/libxslt
	dev-libs/gobject-introspection-common
	>=dev-util/gdbus-codegen-2.48
	>=dev-util/gtk-doc-am-1.20
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
	X? (
		x11-proto/xextproto
		x11-proto/xproto
		x11-proto/inputproto
		x11-proto/damageproto
		xinerama? ( x11-proto/xineramaproto )
	)
	test? (
		media-fonts/font-misc-misc
		media-fonts/font-cursor-misc )
"
# gtk+-3.2.2 breaks Alt key handling in <=x11-libs/vte-0.30.1:2.90
# gtk+-3.3.18 breaks scrolling in <=x11-libs/vte-0.31.0:2.90
RDEPEND="${COMMON_DEPEND}
	>=dev-util/gtk-update-icon-cache-3
	!<gnome-base/gail-1000
	!<x11-libs/vte-0.31.0:2.90
"
# librsvg for svg icons (PDEPEND to avoid circular dep), bug #547710
PDEPEND="
	gnome-base/librsvg
	x11-themes/adwaita-icon-theme
	vim-syntax? ( app-vim/gtk-syntax )
"

src_prepare() {
	gnome3_src_prepare
}

src_configure() {
	local print_backends="file"
	if use cups; then
		print_backends="$print_backends,cups"
	fi
	if use cloudprint; then
		print_backends="$print_backends,cloudprint"
	fi
	local video_backends=""
	if use ffmpeg; then
		video_backends="ffmpeg"
	fi
	if use gstreamer; then
		video_backends="$video_backends,gstreamer"
	fi
	# strip potential leading comma
	if [ ${video_backends:0:1} == "," ]; then
		video_backends=${video_backends:1}
	fi
	if [ -z "${video_backends}" ]; then
		video_backends=none
	fi
	local emesonargs=(
		-Dc_args="$CFLAGS"
		-Dprint-backends=$print_backends
		-Dmedia=$video_backends
		-Dquartz-backend=$(usex aqua true false)
		-Dbroadway-backend=$(usex broadway true false)
		-Dcolord=$(usex colord yes no)
		-Dwayland-backend=$(usex wayland true false)
		-Dx11-backend=$(usex X true false)
		-Dvulkan=$(usex vulkan yes no)
		-Dxinerama=$(usex xinerama yes no)
		-Dgtk_doc=$(usex docs true false)
		-Dcloudproviders=false
		-Dwin32-backend=false
		-Dbuild-tests=$(usex test true false)
		-Ddemos=$(usex examples true false)
		-Dinstall-tests=false
		-Dintrospection=$(usex introspection true false)
		-Dman-pages=true
	)

	meson_src_configure
}

src_test() {
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/gtk" || die
	GSETTINGS_SCHEMA_DIR="${S}/gtk" virtx emake check
}

src_compile() {
	export CFLAGS="$CFLAGS"
	meson_src_compile

	sed -i -e "s/\(\"\)\/.*gsk\//\1/" gsk/gskenumtypes.h
	sed -i -e "s/\(\"\)\/.*gdk\//\1/" gdk/gdkenumtypes.h
	sed -i -e "s/\(\"\)\/.*gtk\//\1/" gtk/gtktypebuiltins.h
}

src_install() {
	meson_src_install
	insinto /etc/gtk-4.0
	doins "${FILESDIR}"/settings.ini
	# Skip README.{in,commits,win32} that would get installed by default
	DOCS=( AUTHORS NEWS README.md )
	einstalldocs
}

pkg_preinst() {
	gnome3_pkg_preinst
}

pkg_postinst() {
	gnome3_pkg_postinst

	if ! has_version "app-text/evince"; then
		elog "Please install app-text/evince for print preview functionality."
		elog "Alternatively, check \"gtk-print-preview-command\" documentation and"
		elog "add it to your settings.ini file."
	fi
}

pkg_postrm() {
	gnome3_pkg_postrm
}