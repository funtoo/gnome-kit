# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Funtoo Gnome Shell Theme"
HOMEPAGE="https://code.funtoo.org/bitbucket/projects/MOS/repos/funtoo-gnome-shell-theme/"
SRC_URI="https://code.funtoo.org/bitbucket/rest/api/latest/projects/MOS/repos/funtoo-gnome-shell-theme/archive?at=refs%2Ftags%2Fv${PV}&format=zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"

IUSE=""

RDEPEND=""
DEPEND=""

src_unpack() {
	mkdir ${P}
	cd ${P}
	unpack ${A}
	cd ${S}
}

src_compile() {
	einfo "Skipping compilation phase"
}

src_install() {
	DESTDIR=${D}/usr/share/themes emake install
}
