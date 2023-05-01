#!/usr/bin/env python3

import json
import os
import toml

def do_cmd(hub, cmd):
	retval = os.system(cmd)
	if retval != 0:
		raise hub.pkgtools.ebuild.BreezyError("Unable to execute command: " + cmd)

async def generate(hub, **pkginfo):
	version = "2.48.8"
	majmin = ".".join(version.split(".")[0:2])
	custom = "update-1"
	final_name = f"librsvg-{version}-{custom}.tar.xz"
	src_uri = f"https://download.gnome.org/sources/librsvg/{majmin}/librsvg-{version}.tar.xz"
	my_archive, metadata = hub.Archive.find_by_name(final_name)
	if my_archive is None:
		upstream = hub.Artifact(url=src_uri)
		await upstream.ensure_fetched()
		upstream.extract()
		my_archive = hub.Archive(final_name)
		my_archive.initialize(top_directory="")
		do_cmd(hub, f"( cd {my_archive.extract_path} && cp -a {upstream.extract_path}/* . )")
		src_path = f"{my_archive.extract_path}/librsvg-{version}"
		cargo_path = f"{src_path}/rsvg_internals/Cargo.toml"
		in_toml = toml.load(cargo_path)
		in_toml["dependencies"]["tendril"] = "0.4.3"
		with open(cargo_path, "w") as f:
			f.write(toml.dumps(in_toml))
		do_cmd(hub, f"( cd {src_path} && cargo vendor )")
		await my_archive.store_by_name()
	ebuild = hub.pkgtools.ebuild.BreezyBuild(
		**pkginfo,
		version=version,
		artifacts=[my_archive]
	)
	ebuild.push()

# vim: ts=4 sw=4 noet
