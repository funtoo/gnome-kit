# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Package to install patch to have correct layout in GDM by Adrien.D"
HOMEPAGE="http://www.linuxtricks.fr"
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="*"
IUSE=""

S="${WORKDIR}"

src_install() {
	dobin ${FILESDIR}/${PN}
	insinto /usr/share/gdm/greeter/autostart/
	doins ${FILESDIR}/${PN}.desktop
}
