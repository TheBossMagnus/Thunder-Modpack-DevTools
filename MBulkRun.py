import os
from config import root
import subprocess


def bulk_run(editions: list[tuple[str, list[str]]]) -> None:
    command = input("Enter the command to run in all selected subfolders: ")

    for edition in editions:
        mc_version, _ = edition
        os.chdir(os.path.join(root, "src", mc_version))
        subprocess.run(command, shell=True, check=False)
