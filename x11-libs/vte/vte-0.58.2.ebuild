# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"
VALA_MAX_API_VERSION="0.44"

inherit eutils gnome2 vala meson

# Gnome release team do ALWAYS forget to release vte and it likely will never change
SRC_URI="https://gitlab.gnome.org/GNOME/vte/-/archive/${PV}/vte-${PV}.tar.bz2"

DESCRIPTION="Library providing a virtual terminal emulator widget"
HOMEPAGE="https://wiki.gnome.org/action/show/Apps/Terminal/VTE"

LICENSE="LGPL-2+"
SLOT="2.91"
KEYWORDS="*"

IUSE="+crypt debug docs glade +gtk3 gtk4 +introspection +vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	>=dev-libs/libpcre2-10.21
	>=x11-libs/gtk+-3.24.12:3[introspection?]
	>=x11-libs/pango-1.44.7

	sys-libs/ncurses:0=
	sys-libs/zlib

	crypt?  ( >=net-libs/gnutls-3.2.7 )
	glade? ( >=dev-util/glade-3.9:3.10 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.0:= )
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc
	dev-libs/libxml2
	dev-libs/fribidi
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
	gnome2_src_prepare
}

src_configure() {
	# Python bindings are via gobject-introspection
	# Ex: from gi.repository import Vte
	local emesonargs=(
		$(meson_use debug debugg)
		$(meson_use docs)
		$(meson_use gtk3)
		$(meson_use gtk4)
		$(meson_use crypt gnutls)
		$(meson_use introspection gir)
		$(meson_use vala vapi)
	)

	meson_src_configure
}

src_install() {
	meson_src_install
	mv "${D}"/etc/profile.d/vte{,-${SLOT}}.sh || die
}
