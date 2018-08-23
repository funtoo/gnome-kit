# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit flag-o-matic gnome2 meson multilib virtualx multilib-minimal

DESCRIPTION="Gimp ToolKit +"
HOMEPAGE="https://www.gtk.org/"

LICENSE="LGPL-2+"
SLOT="4"
IUSE="aqua broadway cloudprint colord cups docs examples +introspection test vim-syntax vulkan wayland X xinerama"
REQUIRED_USE="
	|| ( aqua wayland X )
	xinerama? ( X )
"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# Upstream wants us to do their job:
# https://bugzilla.gnome.org/show_bug.cgi?id=768662#c1
RESTRICT="test"

# FIXME: introspection data is built against system installation of gtk+:3,
# bug #????
COMMON_DEPEND="
	>=dev-libs/atk-2.15.1[introspection?,${MULTILIB_USEDEP}]
	>=media-libs/graphene-1.8.0[introspection?,${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.53.7:2[${MULTILIB_USEDEP}]
	media-libs/fontconfig[${MULTILIB_USEDEP}]
	>=media-libs/libepoxy-1.4[X(+)?,${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.14[aqua?,glib,svg,X?,${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-2.30:2[introspection?,${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.37.3[introspection?,${MULTILIB_USEDEP}]
	x11-misc/shared-mime-info

	cloudprint? (
		>=net-libs/rest-0.7[${MULTILIB_USEDEP}]
		>=dev-libs/json-glib-1.0[${MULTILIB_USEDEP}] )
	colord? ( >=x11-misc/colord-0.1.9:0=[${MULTILIB_USEDEP}] )
	cups? ( >=net-print/cups-1.2[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.39:= )
	wayland? (
		>=dev-libs/wayland-1.14.91[${MULTILIB_USEDEP}]
		>=dev-libs/wayland-protocols-1.16
		media-libs/mesa[wayland,${MULTILIB_USEDEP}]
		>=x11-libs/libxkbcommon-0.2[${MULTILIB_USEDEP}]
	)
	X? (
		>=app-accessibility/at-spi2-atk-2.5.3[${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}]
		>=x11-libs/libXi-1.3[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
		>=x11-libs/libXrandr-1.5[${MULTILIB_USEDEP}]
		x11-libs/libXcursor[${MULTILIB_USEDEP}]
		x11-libs/libXfixes[${MULTILIB_USEDEP}]
		x11-libs/libXcomposite[${MULTILIB_USEDEP}]
		x11-libs/libXdamage[${MULTILIB_USEDEP}]
		xinerama? ( x11-libs/libXinerama[${MULTILIB_USEDEP}] )
	)
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xsl-stylesheets
	app-text/docbook-xml-dtd:4.1.2
	dev-libs/libxslt
	dev-libs/gobject-introspection-common
	>=dev-util/gdbus-codegen-2.48
	>=dev-util/gtk-doc-am-1.20
	>=sys-devel/gettext-0.19.7[${MULTILIB_USEDEP}]
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	X? (
		x11-proto/xextproto[${MULTILIB_USEDEP}]
		x11-proto/xproto[${MULTILIB_USEDEP}]
		x11-proto/inputproto[${MULTILIB_USEDEP}]
		x11-proto/damageproto[${MULTILIB_USEDEP}]
		xinerama? ( x11-proto/xineramaproto[${MULTILIB_USEDEP}] )
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
	gnome-base/librsvg[${MULTILIB_USEDEP}]
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

multilib_src_configure() {
	# Not sure how to handle
	#	$(use_enable X xcomposite) \
	#	$(use_enable X xdamage) \
	#	$(use_enable X xfixes) \
	#	$(use_enable X xkb) \
	#	$(use_enable X xrandr) \
	#	--with-xml-catalog="${EPREFIX}"/etc/xml/catalog \

	local emesonargs=(
		-Denable-quartz-backend=$(usex aqua true false)
		-Denable-broadway-backend=$(usex broadway true false)
		-Denable-cloudprint-print-backend=$(usex cloudprint yes no)
		-Denable-colord=$(usex colord yes no)
		-Denable-cups-print-backend=$(usex cups yes no)
		-Denable-wayland-backend=$(usex wayland true false)
		-Denable-x11-backend=$(usex X true false)
		-Denable-vulkan=$(usex vulkan yes no)
		-Denable-xinerama=$(usex xinerama yes no)
		-Ddocumentation=$(usex docs true false)
		-Denable-cloudproviders=false
		-Denable-mir-backend=false
		-Denable-win32-backend=false
		-Ddisable-modules=false
		-Denable-test-print-backend=no
		-Denable-papi-print-backend=no
		-Dbuild-tests=$(usex test true false)
		-Ddemos=$(usex examples true false)
		-Dinstall-tests=false
		-Dintrospection=$(multilib_native_usex introspection true false)
		-Dman-pages=true
		-DCUPS_CONFIG="${EPREFIX}/usr/bin/${CHOST}-cups-config"
	)

	meson_src_configure
}

multilib_src_test() {
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/gtk" || die
	GSETTINGS_SCHEMA_DIR="${S}/gtk" virtx emake check
}

multilib_src_compile() {
	meson_src_compile

	sed -i -e "s/\(\"\)\/.*gsk\//\1/" gsk/gskenumtypes.h
	sed -i -e "s/\(\"\)\/.*gdk\//\1/" gdk/gdkenumtypes.h
	sed -i -e "s/\(\"\)\/.*gtk\//\1/" gtk/gtktypebuiltins.h
}

multilib_src_install() {
	meson_src_install
}

multilib_src_install_all() {
	insinto /etc/gtk-4.0
	doins "${FILESDIR}"/settings.ini
	# Skip README.{in,commits,win32} and useless ChangeLog that would get installed by default
	DOCS=( AUTHORS NEWS README.md )
	einstalldocs
}

pkg_preinst() {
	gnome2_pkg_preinst

	multilib_pkg_preinst() {
		# Make immodules.cache belongs to gtk+ alone
		local cache="usr/$(get_libdir)/gtk-4.0/4.0.0/immodules.cache"

		if [[ -e ${EROOT}${cache} ]]; then
			cp "${EROOT}"${cache} "${ED}"/${cache} || die
		else
			touch "${ED}"/${cache} || die
		fi
	}
	multilib_parallel_foreach_abi multilib_pkg_preinst
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
		multilib_pkg_postrm() {
			rm -f "${EROOT}"usr/$(get_libdir)/gtk-4.0/4.0.0/immodules.cache
		}
		multilib_foreach_abi multilib_pkg_postrm
	fi
}
