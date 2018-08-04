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

	>=app-admin/gnome-system-log-3.9.90.20170809
	>=app-arch/file-roller-${PV}
	>=app-dicts/gnome-dictionary-3.26.1
	>=gnome-base/dconf-editor-3.28.0
	>=gnome-extra/gconf-editor-3
	>=gnome-extra/gnome-calculator-${PV}
	>=gnome-extra/gnome-calendar-${PV}
	>=gnome-extra/gnome-characters-3.28.2
	>=gnome-extra/gnome-clocks-${PV}
	>=gnome-extra/gnome-getting-started-docs-3.28.2
	>=gnome-extra/gnome-power-manager-3.26.0
	>=gnome-extra/gnome-search-tool-3.6
	>=gnome-extra/gnome-system-monitor-${PV}
	>=gnome-extra/gnome-tweaks-3.28.1
	>=gnome-extra/gnome-weather-3.26.0
	>=gnome-extra/gucharmap-10.0.3:2.90
	>=gnome-extra/nautilus-sendto-3.8.6
	>=gnome-extra/sushi-3.24.0
	>=media-gfx/gnome-font-viewer-3.28.0
	>=media-gfx/gnome-screenshot-3.26.0
	>=media-sound/gnome-sound-recorder-3.27.90
	>=media-sound/sound-juicer-3.24.0
	>=media-video/cheese-3.28.0
	>=net-analyzer/gnome-nettool-3.8
	>=net-misc/vinagre-3.22.0
	>=net-misc/vino-3.22.0
	>=sci-geosciences/gnome-maps-${PV}
	>=sys-apps/baobab-3.29.1
	>=sys-apps/gnome-disk-utility-${PV}

	bijiben? ( >=app-misc/bijiben-3.28.3 )
	boxes? ( >=gnome-extra/gnome-boxes-3.29.4 )
	builder? ( >=gnome-extra/gnome-builder-3.28.4 )
	california? ( >=gnome-extra/california-0.4.0 )
	empathy? ( >=net-im/empathy-3.12.13 )
	epiphany? ( >=www-client/epiphany-${PV} )
	evolution? ( >=mail-client/evolution-${PV} )
	flashback? ( >=gnome-base/gnome-flashback-3.28.0 )
	fonts? (
		>=media-fonts/noto-20160305
		>=media-fonts/symbola-8.00
		>=media-fonts/unifont-8.0.01 )
	games? (
		>=games-arcade/gnome-nibbles-3.24.0
		>=games-arcade/gnome-robots-3.22.0
		>=games-board/aisleriot-3.22.0
		>=games-board/four-in-a-row-3.28.0
		>=games-board/gnome-chess-3.28.1
		>=games-board/gnome-mahjongg-3.22.0
		>=games-board/gnome-mines-3.28.0
		>=games-board/iagno-3.28.0
		>=games-board/tali-3.22.0
		>=games-puzzle/atomix-3.22.0
		>=games-puzzle/five-or-more-3.28.0
		>=games-puzzle/gnome2048-3.26
		>=games-puzzle/gnome-klotski-3.22.0
		>=games-puzzle/gnome-sudoku-3.28.0
		>=games-puzzle/gnome-taquin-3.28.0
		>=games-puzzle/gnome-tetravex-3.22.0
		>=games-puzzle/hitori-3.22.0
		>=games-puzzle/lightsoff-3.28.0
		>=games-puzzle/quadrapassel-3.22.0
		>=games-puzzle/swell-foop-3.28.0 )
	geary? ( >=mail-client/geary-0.11.3 )
	gnote? ( >=app-misc/gnote-3.28.0 )
	latexila? ( >=app-editors/latexila-3.27.1 )
	recipes? ( >=gnome-extra/gnome-recipes-2.0.2 )
	share? ( >=gnome-extra/gnome-user-share-3.27.90 )
	shotwell? ( >=media-gfx/shotwell-0.24 )
	simple-scan? ( >=media-gfx/simple-scan-${PV} )
	todo? ( >=gnome-extra/gnome-todo-3.28.1 )
	tracker? (
		>=app-misc/tracker-2
		>=gnome-extra/gnome-documents-3.28.1
		>=media-gfx/gnome-photos-3.29.4
		>=media-sound/gnome-music-${PV} )
"
DEPEND=""
S=${WORKDIR}
