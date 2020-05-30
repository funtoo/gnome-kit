# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3+ )

inherit gnome3 python-r1 ltprune

DESCRIPTION="Python binding to at-spi library"
HOMEPAGE="https://wiki.gnome.org/Accessibility"

# Note: only some of the tests are GPL-licensed, everything else is LGPL
LICENSE="LGPL-2 GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="" # test
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="${PYTHON_DEPS}
	>=dev-libs/atk-2.31.90
	dev-python/dbus-python[${PYTHON_USEDEP}]
	>=dev-python/pygobject-2.90.1:3[${PYTHON_USEDEP}]
"
RDEPEND="${COMMON_DEPEND}
	>=sys-apps/dbus-1
	>=app-accessibility/at-spi2-core-2.31.2[introspection]
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
"

src_prepare() {
	gnome3_src_prepare
	python_copy_sources
}

src_configure() {
	python_foreach_impl run_in_build_dir gnome3_src_configure --disable-tests
}

src_compile() {
	python_foreach_impl run_in_build_dir gnome3_src_compile
}

src_install() {
	python_foreach_impl run_in_build_dir gnome3_src_install

	docinto examples
	dodoc examples/*.py
}
