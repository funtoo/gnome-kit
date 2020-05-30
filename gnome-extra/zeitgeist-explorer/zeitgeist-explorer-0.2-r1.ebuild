# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2+ )

inherit distutils-r1 versionator

MY_PV="$(get_version_component_range 1-2)"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Monitor and inspect Zeitgeist's log at a low level - developer tool"
HOMEPAGE="https://launchpad.net/zeitgeist-explorer/"
SRC_URI="https://launchpad.net/${PN}/0.x/${MY_PV}/+download/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="*"
IUSE=""

RDEPEND="
	gnome-extra/zeitgeist
	x11-libs/gtk+:3[introspection]"
DEPEND="${RDEPEND}
	dev-python/python-distutils-extra[${PYTHON_USEDEP}]"
