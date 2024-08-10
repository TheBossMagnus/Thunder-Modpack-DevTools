import os
import subprocess
from config import modpack_name, modpack_author, root, packwiz_dir


def build_modpack(editions) -> None:
    release = input(f"Enter the release number (latest release {older_version}): ")
    older_version = os.listdir(os.path.join(root, "bin", mc_version))[-1] if os.listdir(os.path.join(root, "bin", mc_version)) else "None"


    for (mc_version, loader) in editions:
        os.makedirs(os.path.join(root, "bin", mc_version, release), exist_ok=True)


        os.chdir(os.path.join(root, "src", mc_version, loader ))
        minecraft_build = input() if mc_version == "1.21.2" else mc_version #for snapshots
        subprocess.run([packwiz_dir, "init", "-r", "--name", modpack_name, "--author", modpack_author, "--modloader", loader, f"--{loader}-latest", f"--version={release}+{loader}-{mc_version}", f"--mc-version={minecraft_build}"], shell=True, check=False)

        # Export .mrpack
        subprocess.run([packwiz_dir, "mr", "export", "-o", str(os.path.join(root, "bin", mc_version, release, f"{modpack_name}-{release}+{loader}-{mc_version}.mrpack"))], shell=True, check=False)

        current_pack = os.path.join(
            root, "bin", mc_version, release,
            modpack_name + "-" + release + "+" + loader + "-" + mc_version + ".mrpack",
        )
        old_pack = os.path.join(
            root, "bin", mc_version, older_version,
            modpack_name + "-" + older_version + "+" + loader + "-" + mc_version + ".mrpack",
        )
        changelog_file = os.path.join( root, "bin", mc_version, release,
                    f"Changelog-{release}+{loader}-{mc_version}.md",)

        if os.path.exists(old_pack) and os.path.exists(current_pack):
            # Generate the changelog
            subprocess.run([
                "modpack-changelogger", "--old", old_pack, "--new", current_pack, "--file", changelog_file,
                "--config", os.path.join(os.path.abspath(__file__), "config.json"),
            ],
            shell=True,
            check=False,
        )
        else:
            # If the .mrpack file doesn't exist, write "No changelog available" and print a warning
            with open( changelog_file, "w") as file:
                file.write("No changelog available")
