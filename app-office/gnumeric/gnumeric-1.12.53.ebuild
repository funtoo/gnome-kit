# Distributed under the terms of the GNU General Public License v2

EAPI="7"
GNOME3_LA_PUNT="yes"
PYTHON_COMPAT=( python3+ )

inherit gnome3 flag-o-matic python-r1

DESCRIPTION="The GNOME Spreadsheet"
HOMEPAGE="http://www.gnumeric.org/"
SRC_URI="https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.53.tar.xz -> gnumeric-1.12.53.tar.xz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="*"

IUSE="+introspection libgda perl python"

# lots of missing files, also fails tests due to 80-bit long story
# upstream bug #721556
RESTRICT="test"

RDEPEND="
	app-arch/bzip2
	sys-libs/zlib
	>=dev-libs/glib-2.40.0:2
	>=gnome-extra/libgsf-1.14.33:=
	>=x11-libs/goffice-0.10.42:0.10
	>=dev-libs/libxml2-2.4.12:2
	>=x11-libs/pango-1.24.0:=

	>=x11-libs/gtk+-3.8.7:3
	x11-libs/cairo:=[svg]

	introspection? ( >=dev-libs/gobject-introspection-1:= )
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS}
		>=dev-python/pygobject-3:3[${PYTHON_USEDEP}] )
	libgda? ( gnome-extra/libgda:5[gtk] )
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.5
	app-text/yelp-tools
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig
"

src_prepare() {
	# Manage gi overrides ourselves
	sed '/SUBDIRS/ s/introspection//' -i Makefile.{am,in} || die
	gnome3_src_prepare
}

src_configure() {
	if use python ; then
		python_setup 'python3*'
	fi
	gnome3_src_configure \
		--disable-static \
		--with-zlib \
		$(use_with libgda gda) \
		$(use_enable introspection) \
		$(use_with perl) \
		$(use_with python)
}

src_install() {
	gnome3_src_install
	python_moduleinto gi.overrides
	python_foreach_impl python_domodule introspection/gi/overrides/Gnm.py
}