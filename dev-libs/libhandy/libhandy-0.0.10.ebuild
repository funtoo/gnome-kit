# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson vala

DESCRIPTION="A library full of GTK+ widgets for mobile phones"
HOMEPAGE="https://source.puri.sm/Librem5/libhandy"
SRC_URI="https://source.puri.sm/Librem5/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"

IUSE=""

DEPEND="$(vala_depend)"
RDEPEND="${DEPEND}"
BDEPEND="dev-util/meson
	dev-lang/vala
	dev-util/glade
	>=dev-libs/gobject-introspection-1.62.0:=
	gnome-base/gnome-desktop"

VALA_USE_DEPEND=vapigen
BUILD_DIR="${S}/build"

src_prepare() {
	default

	vala_src_prepare --vala-api-version $(vala_best_api_version)
}
