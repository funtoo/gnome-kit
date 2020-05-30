# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2+ )
# inherit autotools flag-o-matic linux-info python-any-r1 readme.gentoo-r1 systemd virtualx user multilib-minimal
inherit autotools

DESCRIPTION=""
HOMEPAGE="https://github.com/flatpak/xdg-dbus-proxy"
SRC_URI="https://github.com/flatpak/xdg-dbus-proxy/releases/download/${PV}/${P}.tar.xz"

LICENSE=""
SLOT="0"
KEYWORDS="*"
IUSE=""

REQUIRED_USE=""

BDEPEND=""
COMMON_DEPEND=""
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

