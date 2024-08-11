import os
from config import root


def bulk_run(editions) -> None:
    command = input("Enter the command to run in all selected subfolders: ")

    for mc_version, loader in editions:
        os.chdir(os.path.join(root, "src", mc_version, loader))
        os.system(command)
