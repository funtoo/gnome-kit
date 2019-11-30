# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit autotools gnome.org meson vala xdg

DESCRIPTION="Library providing a virtual terminal emulator widget"
HOMEPAGE="https://wiki.gnome.org/action/show/Apps/Terminal/VTE"
SRC_URI="https://gitlab.gnome.org/GNOME/vte/-/archive/${PV}/vte-${PV}.tar.gz"

LICENSE="LGPL-2+"
SLOT="2.91"
KEYWORDS="*"

IUSE="+crypt doc debug glade +introspection bidi +vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	>=dev-libs/libpcre2-10.21
	>=x11-libs/gtk+-3.24.12:3[introspection?]
	>=x11-libs/pango-1.44.7

	sys-libs/ncurses:0=
	sys-libs/zlib

	crypt?  ( >=net-libs/gnutls-3.2.7:0= )
	glade? ( >=dev-util/glade-3.9:3.10 )
	introspection? ( >=dev-libs/gobject-introspection-1.62.0:= )
"
DEPEND="${RDEPEND}
	dev-util/gperf
	dev-libs/libxml2
	dev-util/gtk-doc
	>=dev-util/gtk-doc-am-1.13
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig

	vala? ( $(vala_depend) )
"
RDEPEND="${RDEPEND}
	!x11-libs/vte:2.90[glade]
"

src_prepare() {

	use vala && vala_src_prepare

	eapply "${FILESDIR}"/vte-0.58.0-cntnr-precmd-preexec-scroll.patch

	xdg_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_use debug debugg)
		$(meson_use doc docs)
		$(meson_use introspection gir)
		$(meson_use bidi fribidi)
		$(meson_use crypt gnutls)
		-Dgtk3=true
		-Dgtk4=false
		-Diconv=true
		$(meson_use vala vapi)
	)

	meson_src_configure
}

src_install() {
	meson_src_install
	mv "${ED}"/etc/profile.d/vte{,-${SLOT}}.sh || die
}
