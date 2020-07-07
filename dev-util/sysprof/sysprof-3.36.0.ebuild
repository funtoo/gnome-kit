# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This ebuild doesn't actually need systemd installed. But uses systemd
# eclass. -drobbins

inherit gnome3 linux-info meson systemd

DESCRIPTION="System-wide Linux Profiler"
HOMEPAGE="http://sysprof.com/"

LICENSE="GPL-3+ GPL-2+"
SLOT="0"
KEYWORDS="*"
IUSE="gtk"

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	>=dev-libs/libdazzle-3.34.0
	sys-auth/polkit
	gtk? ( >=x11-libs/gtk+-3.24.12:3 )
"
DEPEND="${RDEPEND}
	dev-libs/libxml2:2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	>=sys-kernel/linux-headers-2.6.32
	>=dev-libs/libdazzle-3.34.0
	dev-libs/appstream-glib
	virtual/pkgconfig
"

src_prepare() {
	default
	# test incompatible with 32-biti arches:
	sed -i -e '/^allocs_by_size/,/^)/d' ${S}/src/tests/meson.build || die
}

pkg_pretend() {
	kernel_is -ge 2 6 31 && return
	die "Sysprof will not work with a kernel version less than 2.6.31"
}

src_configure() {
	# introspection & vala not use in build system
	# --with-sysprofd=host currently unavailable from ebuild
	local emesonargs=(
		-Dsystemdunitdir=$(systemd_get_systemunitdir)
		-Dwith_sysprofd=bundled
		$(meson_use gtk enable_gtk)
	)
	meson_src_configure
}

pkg_postinst() {
	gnome3_pkg_postinst

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
	gnome3_pkg_postrm
}
