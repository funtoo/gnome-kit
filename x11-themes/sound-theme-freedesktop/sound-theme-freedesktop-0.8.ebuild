# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="Default freedesktop.org sound theme following the XDG theming specification"
HOMEPAGE="https://www.freedesktop.org/wiki/Specifications/sound-theme-spec"
SRC_URI="https://people.freedesktop.org/~mccann/dist/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2 CC-BY-3.0 CC-BY-SA-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=""
DEPEND="sys-devel/gettext
	>=dev-libs/glib-2.62.2:2
	>=dev-util/intltool-0.40"
