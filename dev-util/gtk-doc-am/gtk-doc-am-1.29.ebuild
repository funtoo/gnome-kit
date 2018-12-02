# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME_ORG_MODULE="gtk-doc"
PYTHON_COMPAT=( python3_{6,7} )

inherit gnome.org python-single-r1

DESCRIPTION="Automake files from gtk-doc"
HOMEPAGE="https://www.gtk.org/gtk-doc/"

LICENSE="GPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-lang/perl-5.18"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	!<dev-util/gtk-doc-${GNOME_ORG_PVP}
"
# This ebuild doesn't even compile anything, causing tests to fail when updating (bug #316071)
RESTRICT="test"

src_configure() {
	# Replicate AC_SUBST
	sed -e "s:@PYTHON@:/usr/bin/env python:g" -e "s:@VERSION@:${PV}:g" \
		-e "s:@PYTHON_PACKAGE_DIR@:/usr/share/gtk-doc/python:g" \
		"${S}/gtkdoc-rebase.in" > "${S}/gtkdoc-rebase" || die "sed failed!"
}

src_compile() {
	:
}

src_install() {
	python_fix_shebang gtkdoc-rebase
	dobin gtkdoc-rebase
	insinto /usr/share/aclocal
	doins ${FILESDIR}/gtk-doc.m4
}
