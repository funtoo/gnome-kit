# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Sub-meta package for the applications of GNOME 3"
HOMEPAGE="https://www.gnome.org/"

LICENSE="metapackage"
SLOT="3.0"
# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="*"

IUSE="+bijiben boxes builder california empathy epiphany +evolution flashback +fonts +games geary gnote latexila +recipes +share +shotwell simple-scan +todo +tracker"

# Note to developers:
#
# This is a wrapper for the extra apps integrated with GNOME 3
#
# cantarell upstream relies on noto, unifont and symbola fonts for
# the fonts they cannot handle due to lack of enough manpower:
# https://bugzilla.gnome.org/show_bug.cgi?id=762890
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}

	>=app-arch/file-roller-${PV}
	>=app-dicts/gnome-dictionary-3.26.1
	>=gnome-base/dconf-editor-${PV}
	>=gnome-extra/chrome-gnome-shell-10
	>=gnome-extra/gconf-editor-3
	>=gnome-extra/gnome-calculator-${PV}
	>=gnome-extra/gnome-calendar-${PV}
	>=gnome-extra/gnome-characters-3.34.0
	>=gnome-extra/gnome-clocks-${PV}
	>=gnome-extra/gnome-getting-started-docs-${PV}
	>=gnome-extra/gnome-power-manager-3.32.0
	>=gnome-extra/gnome-search-tool-3.6
	>=gnome-extra/gnome-system-monitor-${PV}
	>=gnome-extra/gnome-tweaks-3.34
	>=gnome-extra/gnome-weather-3.34
	>=gnome-extra/gucharmap-12.0.1:2.90
	>=gnome-extra/nautilus-sendto-3.8.6
	>=gnome-extra/sushi-3.34
	>=media-gfx/gnome-font-viewer-3.34
	>=media-gfx/gnome-screenshot-${PV}
	>=media-sound/gnome-sound-recorder-3.34
	>=media-sound/sound-juicer-3.24.0
	>=media-video/cheese-3.34
	>=net-analyzer/gnome-nettool-3.8
	>=net-misc/vinagre-3.22.0
	>=net-misc/vino-3.22.0
	>=sci-geosciences/gnome-maps-${PV}
	>=sys-apps/baobab-3.34
	>=sys-apps/gnome-disk-utility-${PV}

	bijiben? ( >=app-misc/bijiben-${PV} )
	boxes? ( >=gnome-extra/gnome-boxes-${PV} )
	builder? ( >=gnome-extra/gnome-builder-${PV} )
	empathy? ( >=net-im/empathy-3.12.14 )
	epiphany? ( >=www-client/epiphany-${PV} )
	evolution? ( >=mail-client/evolution-${PV} )
	flashback? ( >=gnome-base/gnome-flashback-3.32.0 )
	fonts? (
		>=media-fonts/noto-20190524
		>=media-fonts/symbola-11.00
		>=media-fonts/unifont-11.0.02 )
	games? (
		>=games-arcade/gnome-nibbles-${PV}
		>=games-arcade/gnome-robots-${PV}
		>=games-board/aisleriot-3.22.0
		>=games-board/four-in-a-row-${PV}
		>=games-board/gnome-chess-${PV}
		>=games-board/gnome-mahjongg-${PV}
		>=games-board/gnome-mines-${PV}
		>=games-board/iagno-${PV}
		>=games-board/tali-${PV}
		>=games-puzzle/atomix-3.34
		>=games-puzzle/five-or-more-3.32.0
		>=games-puzzle/gnome2048-3.32.0
		>=games-puzzle/gnome-klotski-${PV}
		>=games-puzzle/gnome-sudoku-${PV}
		>=games-puzzle/gnome-taquin-${PV}
		>=games-puzzle/gnome-tetravex-${PV}
		>=games-puzzle/hitori-${PV}
		>=games-puzzle/lightsoff-${PV}
		>=games-puzzle/quadrapassel-${PV}
		>=games-puzzle/swell-foop-3.34 )
	geary? ( >=mail-client/geary-3.34 )
	gnote? ( >=app-misc/gnote-3.34 )
	recipes? ( >=gnome-extra/gnome-recipes-2.0.2 )
	share? ( >=gnome-extra/gnome-user-share-3.34 )
	shotwell? ( >=media-gfx/shotwell-0.30 )
	simple-scan? ( >=media-gfx/simple-scan-${PV} )
	todo? ( >=gnome-extra/gnome-todo-3.28.1 )
	tracker? (
		>=app-misc/tracker-2
		>=gnome-extra/gnome-documents-3.34
		>=media-gfx/gnome-photos-3.34
		>=media-sound/gnome-music-${PV} )
"
DEPEND=""
S=${WORKDIR}
