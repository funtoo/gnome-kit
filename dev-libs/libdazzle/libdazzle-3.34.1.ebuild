# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome2 meson vala

DESCRIPTION="Experimental new features for GTK+ and GLib"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libdazzle"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"

IUSE="gtk-doc +introspection"

RDEPEND="
	>=dev-libs/glib-2.58.0:2
	>=x11-libs/gtk+-3.24.1[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
"

DEPEND="${RDEPEND}
	>=dev-util/meson-0.47.2
	~app-text/docbook-xml-dtd-4.1.2
	app-text/docbook-xsl-stylesheets
	dev-lang/vala
	dev-libs/libxslt
	>=dev-util/gtk-doc-am-1.20
	>=sys-devel/gettext-0.18
	virtual/pkgconfig
"

src_prepare() {
	default
	vala_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_use introspection with_introspection)
		$(meson_use gtk-doc enable_gtk_doc)
	)
	meson_src_configure
}
