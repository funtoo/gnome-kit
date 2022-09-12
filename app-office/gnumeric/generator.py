#!/usr/bin/env python3

from bs4 import BeautifulSoup
from packaging.version import Version
import re

regex = r'(\d+(?:\.\d+)+)'

async def generate(hub, **pkginfo):
	pkgname = pkginfo["name"]
	download_url = f"https://download.gnome.org/sources"
	html = await hub.pkgtools.fetch.get_page(f"{download_url}/{pkgname}")
	soup = BeautifulSoup(html, 'html.parser').find_all('a', href=True)
	
	current = max([Version(re.findall(regex, a.contents[0])[0]) for a in soup if re.findall(regex, a.contents[0])])

	# Descend into the current version series directory, find the latest release and push the ebuild
	html = await hub.pkgtools.fetch.get_page(f"{download_url}/{pkgname}/{current}/")
	soup = BeautifulSoup(html, 'html.parser').find_all('a', href=True)
	versions = [a for a in soup if 'tar' in a.contents[0]]
	release = max([
		(
			Version(re.findall(regex, a.contents[0])[0]),
			a.get('href')
		) for a in versions if re.findall(regex, a.contents[0])
	])

	if "subslot" in pkginfo and pkginfo["subslot"]:
		pkginfo["subslot_version"] = f"{release[0].major}{release[0].minor}"

	ebuild = hub.pkgtools.ebuild.BreezyBuild(
		**pkginfo,
		version=release[0].public,
		artifacts=[hub.pkgtools.ebuild.Artifact(url=f"{download_url}/{pkgname}/{current}/{release[1]}")],
	)
	ebuild.push()


# vim: ts=4 sw=4 noet
