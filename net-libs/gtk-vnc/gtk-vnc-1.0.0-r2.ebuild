# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )
VALA_MIN_API_VERSION=${VALA_MIN_API_VERSION:-0.44}
VALA_USE_DEPEND="vapigen"

inherit gnome.org multibuild python-r1 vala meson

DESCRIPTION="VNC viewer widget for GTK"
HOMEPAGE="https://wiki.gnome.org/Projects/gtk-vnc"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="+introspection +vala pulseaudio sasl"

PATCHES=(
	"$FILESDIR"/gtk-vnc-1.0.0-pulseaudio-optional.patch
)

COMMON_DEPEND="
	>=dev-libs/glib-2.62.2:2
	>=dev-libs/libgcrypt-1.4.2:0=
	dev-libs/libgpg-error
	>=net-libs/gnutls-3.0:0=
	>=x11-libs/cairo-1.16.0
	x11-libs/libX11
	>=x11-libs/gtk+-3.24.12:3[introspection?]
	>=dev-libs/gobject-introspection-1.62.0:=
	pulseaudio? ( media-sound/pulseaudio )
	${PYTHON_DEPS}
	>=dev-python/pygobject-3:3[${PYTHON_USEDEP}]
	sasl? ( dev-libs/cyrus-sasl )
"
RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	>=dev-lang/perl-5
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
	$(vala_depend)
"
src_prepare() {
	default
	vala_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dwith-coroutine=gthread
		$(meson_use pulseaudio with-pulseaudio)
		$(meson_use vala with-vala)
	)
	meson_src_configure
}
