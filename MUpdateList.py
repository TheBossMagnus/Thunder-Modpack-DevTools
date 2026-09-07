import os
import subprocess

from config import pakku, root


def update_list(edition: tuple[str, list[str]]) -> None:
    mc_version, _ = edition
    os.chdir(os.path.join(root, "src", mc_version))
    subprocess.run([pakku, "status"], check=False)
