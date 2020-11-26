# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson


DESCRIPTION="Library to create desktop components for Wayland using the Layer Shell protocol"
HOMEPAGE="https://github.com/wmww/gtk-layer-shell"
SRC_URI="https://github.com/wmww/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="*"

LICENSE="MIT-with-advertising"
SLOT="0"
IUSE="examples gtk-doc"

DEPEND="
	>=x11-libs/gtk+-3.22.0:3[introspection,wayland]
	>=dev-libs/wayland-1.10.0
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
"

src_configure() {
	local emesonargs=(
		$(meson_use examples)
		$(meson_use gtk-doc docs)
	)
	meson_src_configure
}
