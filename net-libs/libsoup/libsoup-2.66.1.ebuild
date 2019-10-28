# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{3_5,3_6,3_7} )
VALA_USE_DEPEND="vapigen"

inherit gnome2 meson python-any-r1 vala eutils

DESCRIPTION="An HTTP library implementation in C"
HOMEPAGE="https://wiki.gnome.org/Projects/libsoup"

LICENSE="LGPL-2+"
SLOT="2.4"
KEYWORDS="*"

IUSE="gssapi +introspection samba +vala"
REQUIRED_USE="vala? ( introspection )"

COMMON_DEPEND="
	>=dev-libs/glib-2.40:2
	>=net-libs/glib-networking-2.38.2[ssl]
	>=net-libs/libpsl-0.20.0
	>=dev-libs/libxml2-2.9.1-r4:2
	>=dev-db/sqlite-3.8.2:3
	gssapi? ( virtual/krb5 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
	samba? ( net-fs/samba )
"

DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	>=dev-util/intltool-0.35
	>=dev-util/gtk-doc-am-1.20
	sys-devel/gettext
	>=virtual/pkgconfig-0-r1
	vala? ( $(vala_depend) )
"

RDEPEND="${COMMON_DEPEND}"

src_prepare() {
	use vala && vala_src_prepare
	default
}

src_configure() {
	local emesonargs=(
		$(meson_use gssapi)
		$(meson_use introspection)
		$(meson_use samba ntlm)
		$(meson_use vala vapi)
		$(usex samba -Dntlm_auth="'${EPREFIX}/usr/bin/ntlm_auth'" "")
	)

	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
}
