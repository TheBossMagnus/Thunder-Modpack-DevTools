import os
import subprocess
from config import modpack_name, modpack_author, root, packwiz_dir
import glob


def build_modpack(editions) -> None:

    path = os.path.join(root, "bin", editions[0][0])
    directories = glob.glob(os.path.join(path, "*/"))

    older_version = max(directories, key=os.path.getctime) if directories else "none"
    older_version = older_version.rstrip("/").split("/")[-1]
    release = input(f"Enter the release number (latest release {older_version}): ")

    for mc_version, loader in editions:
        os.makedirs(os.path.join(root, "bin", mc_version, release), exist_ok=True)

        modpack_src = os.path.join(root, "src", mc_version, loader)
        minecraft_build = mc_version
        subprocess.run([packwiz_dir, "init", "-r", "--name", modpack_name, "--author", modpack_author, "--modloader", loader, f"--{loader}-latest", f"--version={release}+{loader}-{mc_version}", f"--mc-version={minecraft_build}"], cwd=modpack_src, check=False, stdout=subprocess.DEVNULL)

        # Export .mrpack
        subprocess.run([packwiz_dir, "mr", "export", "-o", str(os.path.join(root, "bin", mc_version, release, f"{modpack_name}-{release}+{loader}-{mc_version}.mrpack"))], cwd=modpack_src, check=False, stdout=subprocess.DEVNULL)

        current_pack = os.path.join(
            root,
            "bin",
            mc_version,
            release,
            modpack_name + "-" + release + "+" + loader + "-" + mc_version + ".mrpack",
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
        config_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "config.json")

        if os.path.exists(old_pack) and os.path.exists(current_pack):
            # Generate the changelog
            subprocess.run(
                ["modpack-changelogger", "--old", old_pack, "--new", current_pack, "--file", changelog_file, "--config", config_path],
                check=False,
            )
        else:
            # If the .mrpack file doesn't exist, write "No changelog available" and print a warning
            with open(changelog_file, "w") as file:
                file.write("No changelog available")
