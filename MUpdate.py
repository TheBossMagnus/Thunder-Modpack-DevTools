import os
import subprocess


def update(root, editions) -> None:
    for edition in editions:
        os.chdir(os.path.join(root, "src", edition))

        # Update all mods with packwiz
        subprocess.run(["packwiz.exe", "update", "--all", "-y"], shell=True, check=False)

