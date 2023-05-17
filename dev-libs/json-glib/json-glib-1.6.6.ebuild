# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org meson multilib-minimal xdg-utils

DESCRIPTION="Library providing GLib serialization and deserialization for the JSON format"
HOMEPAGE="https://wiki.gnome.org/Projects/JsonGlib"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"
IUSE="gtk-doc +introspection"

RDEPEND="
	>=dev-libs/glib-2.54.0:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
"
DEPEND="${RDEPEND}"
# TODO: Can we use a newer docbook-xml-dtd, or is one needed at all?
BDEPEND="
	~app-text/docbook-xml-dtd-4.1.2
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	dev-util/glib-utils
	gtk-doc? ( >=dev-util/gi-docgen-2021.6 )
	>=sys-devel/gettext-0.18
	virtual/pkgconfig
"

src_prepare() {
	xdg_environment_reset
	default
	# Disable installed-tests; this also indirectly removes build_aux/gen-installed-test.py calls, thus not needing python-any-r1.eclass
	sed -e 's/install: true/install: false/g' -i json-glib/tests/meson.build || die
	sed -e '/install_data/d' -i json-glib/tests/meson.build || die
}

multilib_src_configure() {
	local emesonargs=(
		# Never use gi-docgen subproject
		--wrap-mode nofallback

		$(multilib_native_use_feature introspection)
		$(multilib_native_use_feature gtk-doc gtk_doc)
		$(multilib_native_true man)
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install

	einstalldocs
	if use gtk-doc ; then
		# Move to location that <devhelp-41 will see, reconsider once devhelp-41 is stable
		mkdir -p "${ED}"/usr/share/gtk-doc/html || die
		mv "${ED}"/usr/share/doc/json-glib-1.0 "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}