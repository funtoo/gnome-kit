# Distributed under the terms of the GNU General Public License v2
 
EAPI=7

inherit autotools meson udev xdg
 
DESCRIPTION="IIO sensors to D-Bus proxy"
HOMEPAGE="https://gitlab.freedesktop.org/hadess/iio-sensor-proxy"

SRC_URI="https://gitlab.freedesktop.org/hadess/iio-sensor-proxy/-/archive/3.3/iio-sensor-proxy-3.3.tar.gz -> iio-sensor-proxy-3.3.tar.gz"
KEYWORDS="*"

LICENSE="GPL-3"
SLOT="0"
IUSE="systemd"

RDEPEND="
	dev-libs/glib
	gnome-base/gnome-common
	sys-apps/dbus
	!systemd? ( || ( >=sys-fs/eudev-3:0 ) )
	systemd? ( >=sys-apps/systemd-233:0 )
	virtual/libgudev
	virtual/udev
"

DEPEND="
	${RDEPEND}
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	virtual/pkgconfig
"

src_prepare() {
	use systemd || eapply "${FILESDIR}"/${PN}_nosystemd.patch
	default
}

src_install() {
	meson_src_install
	# OpenRC init file
	if ! use systemd ; then
		newinitd "${FILESDIR}/${PN}.openrc" ${PN}
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	elog
	elog "enable iio-sensor-proxy service:"
	elog
	elog "[openrc]	# rc-update add iio-sensor-proxy"
	elog "[systemd]	# systemctl enable iio-sensor-proxy"
	elog
}

pkg_postrm() {
	xdg_pkg_postrm
}
