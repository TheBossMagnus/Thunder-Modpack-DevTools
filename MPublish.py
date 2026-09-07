import os
import subprocess

from config import get_latest_version, modpack_author, modpack_name, root
from Mtest import test_pack


def publish(edition: tuple[str, list[str]]) -> None:
    mc_version, _ = edition
    version = get_latest_version(mc_version)
    files_to_upload = [os.path.join(root, "bin", mc_version, version, file) for file in os.listdir(os.path.join(root, "bin", mc_version, version)) if file.endswith((".md", ".mrpack", ".zip"))]

    for file in files_to_upload:
        if file.endswith(".mrpack") and "fabric" in file:
            if not test_pack(file):
                print("Test failed, do you want to continue? (y/n)")
                if input().lower() != "y":
                    print("Aborting")
                    return
            break  # test just one file

    os.chdir(os.path.join(root, "src", mc_version))
    subprocess.run(["git", "add", os.path.join(root, "src", mc_version)], check=False)
    subprocess.run(["git", "commit", "-S", "-m", f"{version}+{mc_version}"], check=False)
    subprocess.run(["git", "push"], check=False)
    subprocess.run(
        ["gh", "release", "create", f"{version}+{mc_version}", "-R", f"{modpack_author}/{modpack_name}", "-d", "-t", f"Thunder {version} for {mc_version}", "--notes", "GitHub releases are not recommended for use. Please download the modpack from the Modrinth or curseforge pages instead."],
        check=False,
    )
    for file in files_to_upload:
        subprocess.run(["gh", "release", "upload", f"{version}+{mc_version}", file, "-R", f"{modpack_author}/{modpack_name}"], check=False)
