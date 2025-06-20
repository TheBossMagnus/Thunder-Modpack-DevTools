import os
from pathlib import Path

modpack_name = "Thunder"
modpack_author = "TheBossMagnus"
root = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "Thunder")
supp_editions = {
    "1.20.1": ["quilt", "fabric"],
    "1.20.4": ["quilt", "fabric"],
    "1.21.1": ["quilt", "fabric"],
    "1.21.4": ["quilt", "fabric"],
    "1.21.5": ["quilt", "fabric"],
    "1.21.6": ["fabric"],
}

packwiz_dir = "pakku"


def get_latest_version(mc_version: str) -> str:
    """Get the latest version of the modpack for the specified Minecraft version.
    Searches in bin folder of the specified Minecraft version for the dir with the most recent creation date, witch corresponds to the latest version of the modpack published as now."""
    version_path = Path(root) / "bin" / mc_version
    versions = [p for p in version_path.glob("*") if p.is_dir()]
    if not versions:
        print(f"No versions found for Minecraft {mc_version}, if this is the first release for this mc version, you can ignore this message.")
        return "No older version"  # Just a placeholder to avoid errors
    return versions[-1].name
