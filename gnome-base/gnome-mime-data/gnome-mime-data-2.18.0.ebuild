# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit gnome2

DESCRIPTION="MIME data for Gnome"
HOMEPAGE="https://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=""
DEPEND="
	virtual/pkgconfig
	>=dev-util/intltool-0.35
"

src_prepare() {
	intltoolize --force || die "intltoolize failed"
	gnome2_src_prepare
}
