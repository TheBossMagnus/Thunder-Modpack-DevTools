import os
import subprocess

def build_modpack(modpack_name, dev_name, root, editions):
    MC_version = editions[0].split("\\")[0]
    older_version = (os.listdir(os.path.join(root, "bin", MC_version)))[-1]

    release = input(f"Enter the release number (latest release {older_version}): ")

    for edition in editions:
        os.chdir(os.path.join(root, "src", edition))

        # Get the modloader and Minecraft version
        _, loader = edition.split("\\")
        os.makedirs(os.path.join(root, "bin", MC_version, release), exist_ok=True)

        if MC_version == "1.21.1":
            tmp = input("Snapshot version")
            subprocess.run(["packwiz","init","-r","--name",modpack_name,"--author",dev_name,"--modloader",loader,f"--{loader}-latest",f"--version={release}+{loader}-{MC_version}",f"--mc-version={tmp}"],shell=True)
        else:
            subprocess.run(["packwiz","init","-r","--name",modpack_name,"--author",dev_name,"--modloader",loader,f"--{loader}-latest",f"--version={release}+{loader}-{MC_version}",f"--mc-version={MC_version}"], shell=True)

        # Export .mrpack
        subprocess.run(["packwiz","mr","export","-o",str(os.path.join(root,"bin",MC_version,release,f"{modpack_name}-{release}+{loader}-{MC_version}.mrpack"))], shell=True)
        input()

        current_pack = os.path.join(
            root,
            "bin",
            MC_version,
            release,
            modpack_name + "-" + release + "+" + loader + "-" + MC_version + ".mrpack",
        )
        old_pack = os.path.join(
            root,
            "bin",
            MC_version,
            older_version,
            modpack_name
            + "-"
            + older_version
            + "+"
            + loader
            + "-"
            + MC_version
            + ".mrpack",
        )

        if os.path.exists(old_pack) and os.path.exists(current_pack):
            # Generate the changelog
            subprocess.run([
                "ModpackChangelogger.exe",
                "--old",
                old_pack,
                "--new",
                current_pack,
                "--file",
                os.path.join(
                    root,
                    "bin",
                    MC_version,
                    release,
                    f"Changelog-{release}+{loader}-{MC_version}.md",
                ),
                "--config",
                r"D:\Modpack DevTools\config.json"],shell=True
            )
        else:
            # If the .mrpack file doesn't exist, write "No changelog available" and print a warning
            with open(
                os.path.join(
                    root,
                    "bin",
                    MC_version,
                    release,
                    f"Changelog-{release}+{loader}-{MC_version}.md",
                ),
                "w",
            ) as file:
                file.write("No changelog available")

            print("No changelog was available")

        print(f"{modpack_name}-{release} for {loader} {MC_version} done")
