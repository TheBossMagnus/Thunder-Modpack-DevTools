import os
import subprocess
from config import packwiz_dir, root


def update(editions) -> None:
    for mc_version, loader in editions:
        os.chdir(os.path.join(root, "src", mc_version, loader))

        # Update all mods with packwiz
        subprocess.run([packwiz_dir, "update", "--all", "-y"], shell=True, check=False)
