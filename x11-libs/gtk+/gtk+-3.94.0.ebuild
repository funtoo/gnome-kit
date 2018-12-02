# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit flag-o-matic gnome2 meson virtualx

DESCRIPTION="Gimp ToolKit +"
HOMEPAGE="https://www.gtk.org/"

LICENSE="LGPL-2+"
SLOT="4"
IUSE="aqua broadway cloudprint colord cups docs examples +introspection test vim-syntax vulkan wayland X xinerama"
REQUIRED_USE="
	|| ( aqua wayland X )
	xinerama? ( X )
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
	>=x11-themes/adwaita-icon-theme-3.14
	vim-syntax? ( app-vim/gtk-syntax )
"

strip_builddir() {
	local rule=$1
	shift
	local directory=$1
	shift
	sed -e "s/^\(${rule} =.*\)${directory}\(.*\)$/\1\2/" -i $@ \
		|| die "Could not strip director ${directory} from build."
}

src_prepare() {
	eapply "${FILESDIR}/${PF}"-noschema.patch

	gnome2_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dquartz-backend=$(usex aqua true false)
		-Dbroadway-backend=$(usex broadway true false)
		-Dcloudprint-print-backend=$(usex cloudprint yes no)
		-Dcolord=$(usex colord yes no)
		-Dcups-print-backend=$(usex cups yes no)
		-Dwayland-backend=$(usex wayland true false)
		-Dx11-backend=$(usex X true false)
		-Dvulkan=$(usex vulkan yes no)
		-Dxinerama=$(usex xinerama yes no)
		-Ddocumentation=$(usex docs true false)
		-Dcloudproviders=false
		-Dmir-backend=false
		-Dwin32-backend=false
		-Dmodules=false
		-Dtest-print-backend=no
		-Dpapi-print-backend=no
		-Dbuild-tests=$(usex test true false)
		-Ddemos=$(usex examples true false)
		-Dinstall-tests=false
		-Dintrospection=$(usex introspection true false)
		-Dman-pages=true
		-DCUPS_CONFIG="${EPREFIX}/usr/bin/${CHOST}-cups-config"
	)

	meson_src_configure
}

src_test() {
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/gtk" || die
	GSETTINGS_SCHEMA_DIR="${S}/gtk" virtx emake check
}

src_compile() {
	meson_src_compile

	sed -i -e "s/\(\"\)\/.*gsk\//\1/" gsk/gskenumtypes.h
	sed -i -e "s/\(\"\)\/.*gdk\//\1/" gdk/gdkenumtypes.h
	sed -i -e "s/\(\"\)\/.*gtk\//\1/" gtk/gtktypebuiltins.h
}

src_install() {
	meson_src_install
	insinto /etc/gtk-4.0
	doins "${FILESDIR}"/settings.ini
	# Skip README.{in,commits,win32} and useless ChangeLog that would get installed by default
	DOCS=( AUTHORS NEWS README.md )
	einstalldocs
}

pkg_preinst() {
	gnome2_pkg_preinst

	# Make immodules.cache belongs to gtk+ alone
	local cache="usr/$(get_libdir)/gtk-4.0/4.0.0/immodules.cache"

	if [[ -e ${EROOT}${cache} ]]; then
		cp "${EROOT}"${cache} "${ED}"/${cache} || die
	else
		touch "${ED}"/${cache} || die
	fi
}

pkg_postinst() {
	gnome2_pkg_postinst

	if ! has_version "app-text/evince"; then
		elog "Please install app-text/evince for print preview functionality."
		elog "Alternatively, check \"gtk-print-preview-command\" documentation and"
		elog "add it to your settings.ini file."
	fi
}

pkg_postrm() {
	gnome2_pkg_postrm

	if [[ -z ${REPLACED_BY_VERSION} ]]; then
		rm -f "${EROOT}"usr/$(get_libdir)/gtk-4.0/4.0.0/immodules.cache
	fi
}
