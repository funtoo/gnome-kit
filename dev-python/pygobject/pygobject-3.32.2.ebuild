# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} )

inherit eutils virtualx python-r1 meson

SRC_URI="https://download.gnome.org/sources/pygobject/3.32/pygobject-${PV}.tar.xz"

DESCRIPTION="GLib's GObject library bindings for Python"
HOMEPAGE="https://wiki.gnome.org/Projects/PyGObject"

LICENSE="LGPL-2.1+"
SLOT="3"
KEYWORDS="*"
IUSE="examples +cairo"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

COMMON_DEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.58.0:2
	>=dev-libs/gobject-introspection-1.58.0:=
	virtual/libffi:=
	cairo? (
		>=dev-python/pycairo-1.17.0[${PYTHON_USEDEP}]
		x11-libs/cairo )
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	cairo? ( x11-libs/cairo[glib] )
	dev-libs/atk[introspection]
	x11-libs/cairo[glib]
	>=x11-libs/gdk-pixbuf-2.38.0:2[introspection]
	>=x11-libs/gtk+-3.24.0:3[introspection]
	x11-libs/pango[introspection]
"

RDEPEND="${COMMON_DEPEND}
	!<dev-python/pygtk-2.13
	!<dev-python/pygobject-2.28.6-r50:2[introspection]
"

src_configure() {
	# Hard-enable libffi support since both gobject-introspection and
	# glib-2.29.x rdepend on it anyway
	# docs disabled by upstream default since they are very out of date
	configuring() {
		local emesonargs=(
		    -Dpython=${EPYTHON}
			$(meson_use cairo pycairo)
		)

		meson_src_configure
	}

	python_foreach_impl run_in_build_dir configuring
}

src_compile() {
	python_foreach_impl run_in_build_dir meson_src_compile
}

src_install() {
	python_foreach_impl run_in_build_dir meson_src_install

	dodoc -r examples
}
