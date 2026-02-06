import os
import subprocess
from config import packwiz_dir, root


def update(edition: tuple[str, list[str]]) -> None:
    mc_version, _ = edition

    os.chdir(os.path.join(root, "src", mc_version))

    subprocess.run([packwiz_dir, "update", "-a"], check=False)
