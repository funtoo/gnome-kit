# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 meson

DESCRIPTION="A quick previewer for Nautilus, the GNOME file manager"
HOMEPAGE="https://git.gnome.org/browse/sushi"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"
IUSE="office wayland"

COMMON_DEPEND="
	>=x11-libs/gdk-pixbuf-2.39.2:2[introspection]
	>=dev-libs/gjs-1.40
	>=dev-libs/glib-2.62.2:2
	>=dev-libs/gobject-introspection-1.62.0:=
	>=media-libs/clutter-1.11.4:1.0[introspection]
	>=media-libs/clutter-gtk-1.0.1:1.0[introspection]
	>=x11-libs/gtk+-3.24.12:3[X,introspection]

	>=app-text/evince-3.0[introspection]
	media-libs/freetype:2
	media-libs/gstreamer:1.0[introspection]
	media-libs/gst-plugins-base:1.0[introspection]
	>=media-libs/harfbuzz-0.9.9:=
	media-libs/clutter-gst:3.0[introspection]
	media-libs/musicbrainz:5=
	net-libs/webkit-gtk:4[introspection]
	x11-libs/gtksourceview:3.0[introspection]
	x11-libs/gtksourceview:4[introspection]
	office? ( app-office/unoconv )
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/nautilus-3.30.0
"

src_prepare() {
	if ! use wayland; then
		eapply "${FILESDIR}"/gdk-wayland-fix.patch
	fi

	sed -i -e "s/meson.add_install_script('meson-post-install.py', libexecdir, bindir)//" "${S}"/meson.build || die "sed failed"
	default
}

src_configure() {
	# work around sandbox violation
	for card in /dev/dri/card* ; do
		addpredict "${card}"
	done

	for render in /dev/dri/render* ; do
		addpredict "${render}"
	done

	for vid in /dev/video*; do
		addpredict "${vid}"
	done

	meson_src_configure
}

pkg_postinst() {
	addwrite /usr/bin/sushi
	ln -s -f /usr/libexec/org.gnome.NautilusPreviewer /usr/bin/sushi
}
