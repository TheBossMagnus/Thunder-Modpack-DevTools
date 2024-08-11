import os
import subprocess
from config import root, dev_name, modpack_name


def publish(editions) -> None:
    mc_versions = set(mc_version for mc_version, _ in editions)

    for mc_version in mc_versions:
        version = (os.listdir(os.path.join(root, "bin", mc_version)))[-1]

        os.chdir(root)
        os.system(f"git add {os.path.join(root,"src",mc_version)}")
        os.system(f"git commit -S -m {version}+{mc_version}")
        os.system("git push")

        subprocess.run(["gh", "release", "create", f"{version}+{mc_version}", "-R", f"{dev_name}/{modpack_name}", "-d", "-t", f"Thunder {version} for {mc_version}", "--notes", "GitHub releases are not recommended for use. Please download the modpack from the Modrinth page instead."], check=False)

        files_to_upload = [os.path.join(root, "bin", mc_version, version, file) for file in os.listdir(os.path.join(root, "bin", mc_version, version)) if file.endswith(".md") or file.endswith(".mrpack")]

        for file in files_to_upload:
            os.system(f"gh release upload {version}+{mc_version} {file}")
