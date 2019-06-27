# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Keep cmake-utils at the end
inherit gnome2 vala meson

DESCRIPTION="A lightweight, easy-to-use, feature-rich email client"
HOMEPAGE="https://wiki.gnome.org/Apps/Geary"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="*"
IUSE="nls"

DEPEND="
	>=app-crypt/gcr-3.10.1:0=[gtk,introspection,vala]
	app-crypt/libsecret
	app-text/iso-codes
	dev-db/sqlite:3
	>=dev-libs/glib-2.42:2[dbus]
	>=dev-libs/libgee-0.8.5:0.8=
	dev-libs/libxml2:2
	dev-libs/gmime:2.6
	media-libs/libcanberra
	>=net-libs/webkit-gtk-2.10.0:4=[introspection]
	>=x11-libs/gtk+-3.14.0:3[introspection]
	x11-libs/libnotify
	sys-libs/libunwind
"
RDEPEND="${DEPEND}
	gnome-base/gsettings-desktop-schemas
	nls? ( virtual/libintl )
"
DEPEND="${DEPEND}
	app-text/gnome-doc-utils
	dev-util/desktop-file-utils
	nls? ( sys-devel/gettext )
	$(vala_depend)
	virtual/pkgconfig
"

src_prepare() {
	local i
	if use nls ; then
		if [[ -n "${LINGUAS+x}" ]] ; then
			for i in $(cd po ; echo *.po) ; do
				if ! has ${i%.po} ${LINGUAS} ; then
					sed -i -e "/^${i%.po}$/d" po/LINGUAS || die
				fi
			done
		fi
	else
		sed -i -e 's#add_subdirectory(po)##' CMakeLists.txt || die
	fi

	gnome2_src_prepare
	vala_src_prepare
}
