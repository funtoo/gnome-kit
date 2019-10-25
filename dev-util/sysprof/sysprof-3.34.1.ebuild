# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2 linux-info systemd gnome2-utils xdg meson

DESCRIPTION="System-wide Linux Profiler"
HOMEPAGE="http://sysprof.com/"

LICENSE="GPL-3+ GPL-2+"
SLOT="0"
KEYWORDS="*"
IUSE="elogind gtk systemd"
REQUIRED_USE="
	?? ( elogind systemd )
"

RDEPEND="
	>=dev-libs/glib-2.44:2
	sys-auth/polkit
	gtk? ( >=x11-libs/gtk+-3.22.0:3 )
	systemd? ( >=sys-apps/systemd-222 )
"
DEPEND="${RDEPEND}
	dev-libs/libxml2:2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	>=sys-kernel/linux-headers-2.6.32
	dev-libs/appstream-glib
	virtual/pkgconfig
"

pkg_pretend() {
	kernel_is -ge 2 6 31 && return
	die "Sysprof will not work with a kernel version less than 2.6.31"
}

src_configure() {
	# introspection & vala not use in build system
	# --with-sysprofd=host currently unavailable from ebuild
	if use elogind || use systemd; then
		sysprof_opt=bundled
	else
		sysprof_opt=none
	fi

	local emesonargs=(
		-Dsystemdunitdir=$(systemd_get_systemunitdir)
		-Dwith_sysprofd=${sysprof_opt}
		$(meson_use gtk enable_gtk)
	)

	meson_src_configure
}

pkg_postinst() {
	gnome2_pkg_postinst

	elog "On many systems, especially amd64, it is typical that with a modern"
	elog "toolchain -fomit-frame-pointer for gcc is the default, because"
	elog "debugging is still possible thanks to gcc4/gdb location list feature."
	elog "However sysprof is not able to construct call trees if frame pointers"
	elog "are not present. Therefore -fno-omit-frame-pointer CFLAGS is suggested"
	elog "for the libraries and applications involved in the profiling. That"
	elog "means a CPU register is used for the frame pointer instead of other"
	elog "purposes, which means a very minimal performance loss when there is"
	elog "register pressure."
}

pkg_postrm() {
	gnome2_pkg_postrm
}
