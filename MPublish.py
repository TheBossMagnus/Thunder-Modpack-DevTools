import os
import subprocess
from config import root, modpack_author, modpack_name, get_latest_version
from typing import Tuple, List
from Mtest import test_pack


def publish(edition: Tuple[str, List[str]]) -> None:
    mc_version, _ = edition
    version = get_latest_version(mc_version)
    files_to_upload = [os.path.join(root, "bin", mc_version, version, file) for file in os.listdir(os.path.join(root, "bin", mc_version, version)) if file.endswith(".md") or file.endswith(".mrpack") or file.endswith(".zip")]

    for file in files_to_upload:
        if file.endswith(".mrpack") and "fabric" in file:
            if not test_pack(file):
                print("Test failed, do you want to continue? (y/n)")
                if input().lower() != "y":
                    print("Aborting")
                    return
            break  # test just one file

    os.chdir(os.path.join(root, "src", mc_version))
    os.system(f"git add {os.path.join(root, 'src', mc_version)}")
    os.system(f"git commit -S -m {version}+{mc_version}")
    os.system("git push")
    subprocess.run(
        ["gh", "release", "create", f"{version}+{mc_version}", "-R", f"{modpack_author}/{modpack_name}", "-d", "-t", f"Thunder {version} for {mc_version}", "--notes", "GitHub releases are not recommended for use. Please download the modpack from the Modrinth or curseforge pages instead."],
        check=False,
    )
    for file in files_to_upload:
        os.system(f"gh release upload {version}+{mc_version} {file}")
