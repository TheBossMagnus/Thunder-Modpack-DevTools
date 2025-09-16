import os
import subprocess
from config import modpack_name, root, packwiz_dir, get_latest_version
import shutil
from typing import Tuple, List, Dict
import json


def adjust_loader(modpack_src: str, loader: str) -> None:
    """Update pakku-lock.json with correct loader version."""
    pakku_file = os.path.join(modpack_src, "pakku-lock.json")
    loader_versions: Dict[str, Dict[str, str]] = {"fabric": {"fabric": "0.17.2"}, "quilt": {"quilt": "0.29.1"}}

    with open(pakku_file, "r") as file:
        data = json.load(file)

    data["loaders"] = loader_versions[loader]

    with open(pakku_file, "w") as file:
        json.dump(data, file, indent=4)


def build_modpack(edition: Tuple[str, List[str]]) -> None:
    config_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "config.json")  # Path to the config for modpack-changelogger
    mc_version, loaders = edition
    older_version = get_latest_version(mc_version)
    release = input(f"Enter the release number (latest release {older_version}): ")

    os.makedirs(os.path.join(root, "bin", mc_version, release), exist_ok=True)
    modpack_src = os.path.join(root, "src", mc_version)

    for loader in loaders:
        mrpack_name = os.path.join(
            root,
            "bin",
            mc_version,
            release,
            modpack_name + "-" + release + "+" + loader + "-" + mc_version + ".mrpack",
        )

        cfzip_name = os.path.join(
            root,
            "bin",
            mc_version,
            release,
            modpack_name + "-" + release + "+" + loader + "-" + mc_version + ".zip",
        )
        old_pack = os.path.join(
            root,
            "bin",
            mc_version,
            older_version,
            modpack_name + "-" + older_version + "+" + loader + "-" + mc_version + ".mrpack",
        )
        changelog_file = os.path.join(
            root,
            "bin",
            mc_version,
            release,
            f"Changelog-{release}+{loader}-{mc_version}.md",
        )

        # temp workarround until pakku implements a way to switch the loader
        adjust_loader(modpack_src, loader)

        subprocess.run([packwiz_dir, "cfg", "-v", f"{release}+{loader}-{mc_version}"], cwd=modpack_src, check=False)
        # Export .mrpack
        subprocess.run([packwiz_dir, "export"], cwd=modpack_src, check=False)
        # Move the .mrpack file to the bin folder
        shutil.move(os.path.join(modpack_src, "build", "modrinth", f"{modpack_name}-{release}+{loader}-{mc_version}.mrpack"), os.path.join(root, "bin", mc_version, release, mrpack_name))
        shutil.move(os.path.join(modpack_src, "build", "curseforge", f"{modpack_name}-{release}+{loader}-{mc_version}.zip"), os.path.join(root, "bin", mc_version, release, cfzip_name))

        # remove the build folder
        shutil.rmtree(os.path.join(modpack_src, "build"))

        # curseforge uses the same changelog as modrinth
        if os.path.exists(old_pack):
            # Generate the changelog
            subprocess.run(
                ["modpack-changelogger", "--old", old_pack, "--new", mrpack_name, "--file", changelog_file, "--config", config_path],
                check=False,
            )
        else:
            # If the .mrpack file doesn't exist, write "No changelog available" and print a warning
            with open(changelog_file, "w") as file:
                file.write("No changelog available")
