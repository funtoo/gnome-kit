# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME3_LA_PUNT="yes"

inherit gnome3

DESCRIPTION="A library of document-centric objects and utilities"
HOMEPAGE="https://gitlab.gnome.org/GNOME/goffice/"

LICENSE="GPL-2"
SLOT="0.10"
KEYWORDS="*"
IUSE="+introspection"

# FIXME: add lasem to tree
RDEPEND="
	>=app-text/libspectre-0.2.8:=
	>=dev-libs/glib-2.62.4:2
	>=dev-libs/libxml2-2.9.9:2
	dev-libs/libxslt
	>=gnome-base/librsvg-2.46.4:2
	>=gnome-extra/libgsf-1.14.46:=[introspection?]
	>=x11-libs/cairo-1.16.0:=[svg]
	>=x11-libs/gdk-pixbuf-2.40.0:2
	>=x11-libs/gtk+-3.24.13:3
	>=x11-libs/pango-1.44.7:=
	x11-libs/libXext:=
	x11-libs/libXrender:=
	introspection? (
		>=dev-libs/gobject-introspection-1:=
		>=gnome-extra/libgsf-1.14.46:= )
"
DEPEND="${RDEPEND}
	dev-lang/perl
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.32
	>=dev-util/intltool-0.51
	virtual/perl-Compress-Raw-Zlib
	virtual/perl-Getopt-Long
	virtual/perl-IO-Compress
	virtual/pkgconfig
"

src_configure() {
	gnome3_src_configure \
		--without-lasem \
		--with-gtk \
		--with-config-backend=gsettings \
		$(use_enable introspection)
}
