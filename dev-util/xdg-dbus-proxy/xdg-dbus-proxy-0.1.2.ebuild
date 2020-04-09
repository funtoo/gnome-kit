# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Filtering proxy for D-Bus connections."
HOMEPAGE="https://github.com/flatpak/xdg-dbus-proxy"
SRC_URI="https://github.com/flatpak/xdg-dbus-proxy/releases/download/${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="*"
IUSE=""

COMMON_DEPEND=">=dev-libs/glib-2.62
		dev-libs/libffi"
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt"
RDEPEND="${COMMON_DEPEND}"
