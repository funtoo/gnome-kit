#!/usr/bin/env python3

import urllib.parse


async def generate(hub, **pkginfo):
	python_compat = "python3+"
	user = "GNOME"
	repo = pkginfo["name"]
	project_path = urllib.parse.quote_plus(f"{user}/{repo}")
	tags_dict = await hub.pkgtools.fetch.get_page(
		f"https://gitlab.gnome.org/api/v4/projects/{project_path}/repository/tags", is_json=True
	)
	version = tags_dict[0]["name"].lstrip("v")
	shortver = ".".join(version.split(".")[0:2])
	url = f"https://download.gnome.org/sources/{repo}/{shortver}/{repo}-{version}.tar.xz"
	ebuild = hub.pkgtools.ebuild.BreezyBuild(
		**pkginfo,
		version=version,
		python_compat=python_compat,
		artifacts=[hub.pkgtools.ebuild.Artifact(url=url)],
	)
	ebuild.push()


# vim: ts=4 sw=4 noet
