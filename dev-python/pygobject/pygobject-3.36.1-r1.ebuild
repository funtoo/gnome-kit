# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2+ )

inherit gnome.org meson python-r1 virtualx xdg

SRC_URI="https://download.gnome.org/sources/pygobject/${PV::-2}/pygobject-${PV}.tar.xz"

DESCRIPTION="GLib's GObject library bindings for Python"
HOMEPAGE="https://wiki.gnome.org/Projects/PyGObject"

LICENSE="LGPL-2.1+"
SLOT="3"
KEYWORDS="*"
IUSE="+cairo examples test"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.62.2:2
	>=dev-libs/gobject-introspection-1.62.0:=
	virtual/libffi:=
	cairo? (
		>=dev-python/pycairo-1.17.0[${PYTHON_USEDEP}]
		x11-libs/cairo[glib] )
	!<dev-python/pygtk-2.13
	!<dev-python/pygobject-2.28.6-r50:2[introspection]
"
DEPEND="${RDEPEND}
	test? (
		dev-libs/atk[introspection]
		dev-python/pytest[${PYTHON_USEDEP}]
		x11-libs/gdk-pixbuf:2[introspection,jpeg]
		x11-libs/gtk+:3[introspection]
		x11-libs/pango[introspection]
	)
"
BDEPEND="
	virtual/pkgconfig
"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${PN}-3.36.1-python3_10.patch"
)

src_configure() {

	configuring() {

		local emesonargs=(
			-Dpython=${EPYTHON}
			$(meson_use test tests)
			$(meson_use cairo pycairo)
		)

		meson_src_configure
	}

	python_foreach_impl configuring
}

src_compile() {
	python_foreach_impl meson_src_compile
}

src_install() {
	installing() {
		meson_src_install
		python_optimize
	}
	python_foreach_impl installing
	use examples && dodoc -r examples
}
