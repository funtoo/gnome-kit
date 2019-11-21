# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org gnome2-utils meson vala xdg

VALA_MAX_API_VERSION=0.46

DESCRIPTION="A calculator application for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Calculator"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"

IUSE=""

# gtksourceview vapi definitions in dev-lang/vala itself are too old, and newer vala removes them
# altogether, thus we need them installed by gtksourceview[vala]
RDEPEND="
	>=dev-libs/glib-2.62.2:2
	>=x11-libs/gtk+-3.24.12:3
	x11-libs/gtksourceview:4[vala]
	>=net-libs/libsoup-2.42:2.4
	dev-libs/libgee
	dev-libs/libxml2:2
	dev-libs/mpc:=
	dev-libs/mpfr:0=
"
DEPEND="${RDEPEND}
	$(vala_depend)
	dev-libs/appstream-glib
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	vala_src_prepare
	xdg_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dvala-version=0.46
	)

	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	xdg_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	xdg_icon_cache_update
	gnome2_schemas_update
}
