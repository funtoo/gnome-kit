# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit versionator

DESCRIPTION="Meta package for GNOME 3, merge this package to install"
HOMEPAGE="https://www.gnome.org/"

LICENSE="metapackage"
SLOT="2.0" # Cannot be installed at the same time as gnome-2
# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="*"

IUSE="accessibility +bluetooth +classic +cdr cups +extras"

S=${WORKDIR}

# TODO: check accessibility completeness
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}[cups?]
	>=gnome-base/gnome-core-apps-${PV}[cups?,bluetooth?,cdr?]

	>=gnome-base/gdm-${PV}

	>=x11-wm/mutter-3.32.0
	>=gnome-base/gnome-shell-3.32.0[bluetooth?]
	gnome-base/gnome-shell-common

	>=x11-themes/gnome-backgrounds-3.32
	x11-themes/sound-theme-freedesktop

	accessibility? (
		>=app-accessibility/at-spi2-atk-2.32
		>=app-accessibility/at-spi2-core-2.32
		>=app-accessibility/caribou-0.4.21
		>=app-accessibility/orca-3.32.0
		>=gnome-extra/mousetweaks-3.32.0 )
	classic? ( >=gnome-extra/gnome-shell-extensions-3.32.0 )
	extras? ( >=gnome-base/gnome-extra-apps-${PV} )
"

DEPEND=""

PDEPEND=">=gnome-base/gvfs-1.40.0[udisks]"

pkg_postinst() {
	# Remember people where to find our project information
	elog "Please remember to look at https://wiki.gentoo.org/wiki/Project:GNOME"
	elog "for information about the project and documentation."
}
