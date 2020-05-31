# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit versionator

DESCRIPTION="Meta package for GNOME 3, merge this package to install"
HOMEPAGE="https://www.gnome.org/"

LICENSE="metapackage"
SLOT="0" 
KEYWORDS="*"

IUSE="accessibility +bluetooth +classic +cdr cups +extras"

S=${WORKDIR}

# Some things will require, eg. "3.36" not "3.36.2":
BASE_PV="${PV%.*}"

RDEPEND="
	!<=gnome-base/gnome-${PV}
	>=gnome-base/gnome-core-libs-${BASE_PV}[cups?]
	>=gnome-base/gnome-core-apps-${BASE_PV}[cups?,bluetooth?,cdr?]

	>=gnome-base/gdm-3.34

	>=x11-wm/mutter-${PV}
	>=gnome-base/gnome-shell-${PV}[bluetooth?]
	gnome-base/gnome-shell-common

	>=x11-themes/gnome-backgrounds-${BASE_PV}
	x11-themes/sound-theme-freedesktop

	accessibility? (
		>=app-accessibility/at-spi2-atk-2.34
		>=app-accessibility/at-spi2-core-2.36
		>=app-accessibility/caribou-0.4.21
		>=app-accessibility/orca-${PV}
		>=gnome-extra/mousetweaks-3.32.0 )
	classic? ( >=gnome-extra/gnome-shell-extensions-${PV} )
	extras? ( >=gnome-base/gnome-extra-apps-${BASE_PV} )
	>=gnome-extra/gnome-color-manager-${BASE_PV}
	>=gnome-extra/gnome-weather-${BASE_PV}
"

DEPEND=""
PDEPEND=">=gnome-base/gvfs-1.44.0[udisks]"
