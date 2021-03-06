# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome.org

DESCRIPTION="Notification daemon"
HOMEPAGE="https://git.gnome.org/browse/notification-daemon/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	>=x11-libs/gtk+-3.24.12:3[X]
	sys-apps/dbus
	x11-libs/libX11
	!x11-misc/notify-osd
	!x11-misc/qtnotifydaemon
"
DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog NEWS )

src_install() {
	default

	cat <<-EOF > "${T}"/org.freedesktop.Notifications.service
	[D-BUS Service]
	Name=org.freedesktop.Notifications
	Exec=/usr/libexec/notification-daemon
	EOF

	insinto /usr/share/dbus-1/services
	doins "${T}"/org.freedesktop.Notifications.service
}
