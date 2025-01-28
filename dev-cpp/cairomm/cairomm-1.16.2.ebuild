# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit meson

DESCRIPTION="C++ bindings for the Cairo vector graphics library"
HOMEPAGE="https://www.cairographics.org/cairomm/"
SRC_URI="https://www.cairographics.org/releases/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="X"

RDEPEND="
	dev-libs/libsigc++:3=
	>=x11-libs/cairo-1.16.0[X=]
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local emesonargs=(
		-Dbuild-documentation=false
		-Dbuild-examples=false
		-Dbuild-tests=false
		-Dboost-shared=true
	)
	meson_src_configure
}
