import os
import re
import subprocess
from config import packwiz_dir, root


def update_list(editions) -> None:
    patterns_to_remove = [
        "Loading modpack...",
        "Reading metadata files...",
        "Checking for updates...",
        r"Warning: Modrinth versions .*? inconsistent between latest version number and newest release date \(.*? vs .*?\)(?:\r\n?|\n|$)",
        r"Do you want to update\? \[Y/n\]: Cancelled!(?:\r\n?|\n|$)",
        r"\n\n\n",
    ]

    for mc_version, loader in editions:
        os.chdir(os.path.join(root, "src", mc_version, loader))

        # Update all mods with packwiz and capture output
        output = subprocess.run([packwiz_dir, "update", "--all"], capture_output=True, text=True, input="n\n", check=False).stdout

        # Remove unwanted strings from the output using regex patterns
        for pattern in patterns_to_remove:
            output = re.sub(pattern, "", output)
