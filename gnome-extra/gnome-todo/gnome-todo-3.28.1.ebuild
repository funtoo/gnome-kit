# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome-meson

DESCRIPTION="Personal task manager"
HOMEPAGE="https://wiki.gnome.org/Apps/Todo"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"

IUSE="+introspection"

RDEPEND="
	>=dev-libs/glib-2.43.4:2
	dev-libs/libical:0/2
	>=dev-libs/libpeas-1.17
	>=gnome-extra/evolution-data-server-3.17.1:=[gtk]
	>=net-libs/gnome-online-accounts-3.2:=
	>=x11-libs/gtk+-3.22.0:3

	introspection? ( >=dev-libs/gobject-introspection-1.42:= )
"
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	>=dev-util/gtk-doc-am-1.14
	>=dev-util/intltool-0.40.6
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	gnome-meson_src-configure \
		-Denable-background-plugin=true \
		-Denable-dark-theme-plugin=true \
		-Denable-scheduled-panel-plugin=true \
		-Denable-score-plugin=true \
		-Denable-today-panel-plugin=true \
		-Denable-unscheduled-panel-plugin=true \
		-Denable-todo-txt-plugin=true \
		-Denable-todoist-plugin=true \
		-Denable-gtk-doc=false \
		$(meson_use introspection instrospection)
}
