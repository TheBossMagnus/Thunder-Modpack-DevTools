import os
import re
import subprocess


def update_list(root, editions) -> None:
    patterns_to_remove = [
        "Loading modpack...",
        "Reading metadata files...",
        "Checking for updates...",
        r"Warning: Modrinth versions .*? inconsistent between latest version number and newest release date \(.*? vs .*?\)(?:\r\n?|\n|$)",
        r"Do you want to update\? \[Y/n\]: Cancelled!(?:\r\n?|\n|$)",
        r"\n\n\n",
    ]

    for edition in editions:

        os.chdir(f"{root}/src/{edition}")

        # Update all mods with packwiz and capture output
        output = subprocess.run(["packwiz.exe", "update", "--all"], capture_output = True, text=True, input="n\n", check=False).stdout

        # Remove unwanted strings from the output using regex patterns
        for pattern in patterns_to_remove:
            output = re.sub(pattern, "", output)

