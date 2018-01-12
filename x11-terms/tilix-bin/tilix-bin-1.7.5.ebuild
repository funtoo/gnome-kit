# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="A tiling terminal emulator for Linux using GTK+ 3"
HOMEPAGE="https://github.com/gnunn1/tilix"
SRC_URI="https://github.com/gnunn1/tilix/releases/download/$PV/tilix.zip -> tilix-bin-$PV.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

IUSE="gnome-keyring"

DEPEND=""
RDEPEND="
	gnome-keyring? ( app-crypt/libsecret )
	gnome-keyring? ( gnome-base/gnome-keyring )"

S=${WORKDIR}

src_install() {
	insinto /usr
	doins -r usr/share || die

	into /usr
	dobin usr/bin/tilix || die
}

pkg_postinst()
{
	glib-compile-schemas /usr/share/glib-2.0/schemas/
}
