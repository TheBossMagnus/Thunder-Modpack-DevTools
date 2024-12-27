import os
from config import root
from typing import Tuple, List

def bulk_run(editions:List[Tuple[str, List[str]]]) -> None:
    command = input("Enter the command to run in all selected subfolders: ")

    for edition in editions:
        mc_version, _ = edition
        os.chdir(os.path.join(root, "src", mc_version))
        os.system(command)
