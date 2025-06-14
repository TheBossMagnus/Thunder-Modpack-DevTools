import os
import subprocess
from config import packwiz_dir, root
from typing import Tuple, List


def update(edition: Tuple[str, List[str]]) -> None:
    mc_version, _ = edition

    os.chdir(os.path.join(root, "src", mc_version))

    subprocess.run([packwiz_dir, "update", "-a"], check=False)
