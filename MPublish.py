import os
import subprocess

def publish(root, editions, dev_name, modpack_name):
    mc_version = editions[0].split("\\")[0]
    version = (os.listdir(f"{root}/bin/{mc_version}"))[-1]

    os.chdir(root)
    os.system(f"git add {root}/src/{mc_version}")
    os.system(f"git commit -S -m {version}+{mc_version}")
    os.system("git push")


    subprocess.run(["gh", "release","create", f"{version}+{mc_version}", "-R", f"{dev_name}/{modpack_name}", "-d","-t",f"Thunder {version} for {mc_version}","--notes","GitHub releases are not recommended for use. Please download the modpack from the Modrinth page instead." ])

    files_to_upload = [
        f"{root}/bin/{mc_version}/{version}/{file}"
        for file in os.listdir(f"{root}/bin/{mc_version}/{version}")
        if file.endswith((".mrpack", ".md"))
    ]
    for file in files_to_upload:
        os.system(f"gh release upload {version}+{mc_version} {file}")
