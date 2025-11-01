import os
import subprocess

from click import pause
from config import modpack_name, root, packwiz_dir, get_latest_version
import shutil
from typing import Tuple, List


def get_release_number(old_release_number: str) -> str:
    while True:
        print("M = major, m = minor, p = patch, c = custom")
        choice = input(f"Select release type (latest available {old_release_number}): ").strip()
        parts = old_release_number.split(".")
        if choice == "M":
            return f"{int(parts[0]) + 1}.0.0"
        elif choice == "m":
            return f"{parts[0]}.{int(parts[1]) + 1}.0"
        elif choice == "p":
            return f"{parts[0]}.{parts[1]}.{int(parts[2]) + 1}"
        elif choice == "c":
            return input("Enter custom release number: ").strip()
        else:
            print("Invalid choice. Please try again.")


def build_modpack(edition: Tuple[str, List[str]]) -> None:
    config_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "config.json")  # Path to the config for modpack-changelogger
    mc_version, loaders = edition
    older_version = get_latest_version(mc_version)
    release = get_release_number(older_version)
    print(f"Building modpack for Minecraft {mc_version} version {release} with loaders: {', '.join(loaders)}")

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
        old_mrpack = os.path.join(
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

        subprocess.run([packwiz_dir, "cfg", "-v", f"{release}+{loader}-{mc_version}"], cwd=modpack_src, check=False)
        # Export .mrpack
        subprocess.run([packwiz_dir, "export"], cwd=modpack_src, check=False)
        # Move the .mrpack file to the bin folder
        shutil.move(os.path.join(modpack_src, "build", "modrinth", f"{modpack_name}-{release}+{loader}-{mc_version}.mrpack"), os.path.join(root, "bin", mc_version, release, mrpack_name))
        shutil.move(os.path.join(modpack_src, "build", "curseforge", f"{modpack_name}-{release}+{loader}-{mc_version}.zip"), os.path.join(root, "bin", mc_version, release, cfzip_name))

        # remove the build folder
        shutil.rmtree(os.path.join(modpack_src, "build"))

        # curseforge uses the same changelog as modrinth
        if os.path.exists(old_mrpack):
            # Generate the changelog
            subprocess.run(
                ["modpack-changelogger", "--old", old_mrpack, "--new", mrpack_name, "--file", changelog_file, "--config", config_path],
                check=False,
            )
        else:
            # If the .mrpack file doesn't exist, write "No changelog available" and print a warning
            with open(changelog_file, "w") as file:
                file.write("No changelog available")
