# Distributed under the terms of the GNU General Public License v2

EAPI="6"
VALA_USE_DEPEND="vapigen"

inherit gnome-meson multilib-minimal vala

DESCRIPTION="GObject wrapper for libusb"
HOMEPAGE="https://github.com/hughsie/libgusb"
SRC_URI="https://people.freedesktop.org/~hughsient/releases/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~*"

IUSE="+introspection static-libs +vala"
REQUIRED_USE="vala? ( introspection )"

# Tests try to access usb devices in /dev
RESTRICT="test"

RDEPEND="
	>=dev-libs/glib-2.44:2[${MULTILIB_USEDEP}]
	virtual/libusb:1[udev,${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.29:= )
"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	dev-util/gtk-doc-am
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	vala? ( $(vala_depend) )
"

PATCHES=("${FILESDIR}/${P}-introspection.patch")

src_prepare() {
	gnome-meson_src_prepare
	use vala && vala_src_prepare
}

multilib_src_configure() {
	gnome-meson_src_configure \
		-Dintrospection=$(multilib_native_usex introspection true false) \
		$(meson_use vala vapi)
}

multilib_src_install() {
	gnome-meson_src_install
}
