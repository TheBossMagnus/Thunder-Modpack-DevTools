import os
import subprocess


def build_modpack(modpack_name, dev_name, root, editions) -> None:
    mc_version = editions[0].split("\\")[0]
    older_version = os.listdir(os.path.join(root, "bin", mc_version))[-1] if os.listdir(os.path.join(root, "bin", mc_version)) else "None"

    release = input(f"Enter the release number (latest release {older_version}): ")

    for edition in editions:
        os.chdir(os.path.join(root, "src", edition))

        # Get the modloader and Minecraft version
        _, loader = edition.split("\\")
        os.makedirs(os.path.join(root, "bin", mc_version, release), exist_ok=True)

        if mc_version == "1.21.2":
            tmp = input("Snapshot version")
            subprocess.run(["packwiz", "init", "-r", "--name", modpack_name, "--author", dev_name, "--modloader", loader, f"--{loader}-latest", f"--version={release}+{loader}-{mc_version}", f"--mc-version={tmp}"], shell=True, check=False)
        else:
            subprocess.run(["packwiz", "init", "-r", "--name", modpack_name, "--author", dev_name, "--modloader", loader, f"--{loader}-latest", f"--version={release}+{loader}-{mc_version}", f"--mc-version={mc_version}"], shell=True, check=False)

        # Export .mrpack
        subprocess.run(["packwiz", "mr", "export", "-o", str(os.path.join(root, "bin", mc_version, release, f"{modpack_name}-{release}+{loader}-{mc_version}.mrpack"))], shell=True, check=False)

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

        if os.path.exists(old_pack) and os.path.exists(current_pack):
            # Generate the changelog
            subprocess.run(
                [
                    "modpack-changelogger",
                    "--old",
                    old_pack,
                    "--new",
                    current_pack,
                    "--file",
                    os.path.join(
                        root,
                        "bin",
                        mc_version,
                        release,
                        f"Changelog-{release}+{loader}-{mc_version}.md",
                    ),
                    "--config",
                    os.path.join(os.path.abspath(__file__), "config.json"),
                ],
                shell=True,
                check=False,
            )
        else:
            # If the .mrpack file doesn't exist, write "No changelog available" and print a warning
            with open(
                os.path.join(
                    root,
                    "bin",
                    mc_version,
                    release,
                    f"Changelog-{release}+{loader}-{mc_version}.md",
                ),
                "w",
            ) as file:
                file.write("No changelog available")
