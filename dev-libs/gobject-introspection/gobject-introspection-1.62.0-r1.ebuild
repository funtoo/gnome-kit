# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python{3_5,3_6,3_7} )
PYTHON_REQ_USE="xml"

inherit gnome2 python-single-r1 toolchain-funcs versionator meson

DESCRIPTION="Introspection system for GObject-based libraries"
HOMEPAGE="https://wiki.gnome.org/Projects/GObjectIntrospection"

LICENSE="LGPL-2+ GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="cairo doc doctool test"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	test? ( cairo )
"

# virtual/pkgconfig needed at runtime, bug #505408
# We force glib and g-i to be in sync by this way as explained in bug #518424
RDEPEND="
	>=dev-libs/gobject-introspection-common-${PV}
	>=dev-libs/glib-2.$(get_version_component_range 2):2
	doctool? ( dev-python/mako[${PYTHON_USEDEP}] )
	virtual/libffi:=
	!<dev-lang/vala-0.20.0
	${PYTHON_DEPS}
"
# Wants real bison, not virtual/yacc
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.19
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"
# PDEPEND to avoid circular dependencies, bug #391213
PDEPEND="cairo? ( x11-libs/cairo[glib] )"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	# we want to configure the various tools to specifically reference the version of python
	# we are building against. Otherwise, eselect python changes can break gobject-introspection.

	sed -i -e "/PYTHON_CMD/s:python_cmd:'$PYTHON':" tools/meson.build || die
	default
}

src_configure() {
	if ! has_version "x11-libs/cairo[glib]"; then
		# Bug #391213: enable cairo-gobject support even if it's not installed
		# We only PDEPEND on cairo to avoid circular dependencies
		export CAIRO_LIBS="-lcairo -lcairo-gobject"
		export CAIRO_CFLAGS="-I${EPREFIX}/usr/include/cairo"
	fi

	# To prevent crosscompiling problems, bug #414105
	local mesonargs=(
		$(meson_use cairo) \
		$(meson_use doc gtk_doc) \
		$(meson_use doctool)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	# Prevent collision with gobject-introspection-common
	rm -v "${ED}"usr/share/aclocal/introspection.m4 \
		"${ED}"usr/share/gobject-introspection-1.0/Makefile.introspection || die
	rmdir "${ED}"usr/share/aclocal || die

	sed -i -e "s#/usr/bin/env python3#/usr/bin/python3#" "${ED}"usr/bin/g-ir-scanner "${ED}"usr/bin/g-ir-annotation-tool
}
