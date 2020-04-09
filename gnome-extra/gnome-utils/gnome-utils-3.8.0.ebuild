# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="Meta package for utilities for the GNOME desktop"
HOMEPAGE="https://wiki.gnome.org/Apps/Attic/GnomeUtils"

LICENSE="metapackage"
SLOT="0"
IUSE=""
KEYWORDS="*"

DEPEND=""
RDEPEND="
	>=app-dicts/gnome-dictionary-${PV}
	>=gnome-extra/gnome-search-tool-3.6.0
	>=media-gfx/gnome-font-viewer-${PV}
	>=media-gfx/gnome-screenshot-${PV}
	>=sys-apps/baobab-${PV}
"
