# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for libgudev providers"
SLOT="0/0"
KEYWORDS="*"
IUSE="introspection"

RDEPEND=">=dev-libs/libgudev-${PV}:0/0[introspection?]"
