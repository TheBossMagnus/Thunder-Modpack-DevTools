import os
import subprocess


def update(root, editions):
    for edition in editions:
        os.chdir(os.path.join(root, "src", edition))

        # Update all mods with packwiz
        subprocess.run(["packwiz.exe", "update", "--all", "-y"], shell=True)

        print(f"{edition} done")
