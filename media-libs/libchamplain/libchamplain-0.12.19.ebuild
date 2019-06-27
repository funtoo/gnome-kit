# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome2 meson vala

DESCRIPTION="Clutter based world map renderer"
HOMEPAGE="https://wiki.gnome.org/Projects/libchamplain"

SLOT="0.12"
LICENSE="LGPL-2"
KEYWORDS="*"

IUSE="doc +gtk +introspection vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	dev-db/sqlite:3
	>=dev-libs/glib-2.38:2
	>=media-libs/clutter-1.24:1.0[introspection?]
	media-libs/cogl:=
	>=net-libs/libsoup-2.42:2.4
	>=x11-libs/cairo-1.4
	x11-libs/gtk+:3
	gtk? (
		x11-libs/gtk+:3[introspection?]
		media-libs/clutter-gtk:1.0 )
	introspection? ( dev-libs/gobject-introspection:= )
"
DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc-am )
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_prepare() {
	# Fix documentation slotability
	sed \
		-e "s/^DOC_MODULE.*/DOC_MODULE = ${PN}-${SLOT}/" \
		-i docs/reference/Makefile.am || die "sed (1) failed"
	mv "${S}"/docs/reference/${PN/lib//}{,-${SLOT}}-docs.xml || die "mv (1) failed"

	eapply_user

	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dmemphis=false
		-Ddemos=false
		$(meson_use introspection)
		$(meson_use doc gtk_doc)
		$(meson_use gtk widgetry)
		$(meson_use vala vapi)
	)

	meson_src_configure
}

src_install() {
	meson_src_install
}
