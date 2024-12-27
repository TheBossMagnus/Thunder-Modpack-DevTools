#!/usr/bin/python
import sys

from config import supp_editions
from MBuild import build_modpack
from MBulkRun import bulk_run
from MPublish import publish
from MUpdate import update
from MUpdateList import update_list
from MUpdateVersions import update_game_versions


def main() -> None:
    try:
        tool = sys.argv[1]

        targets = sys.argv[2:]

        if not targets or "a" in targets or "all" in targets:
            editions = [(mc_version, loaders) for mc_version, loaders in supp_editions.items()]
        else:
            editions = [(mc_version, loaders) for mc_version, loaders in supp_editions.items() if any(target in mc_version or target in loaders for target in targets)]

        if tool in ("uv", "updateversion"):
            update_game_versions()
            return

        if not editions:
            print("No edition selected")
            return

        if tool != "br":
            editions = [editions[0]]

        if tool in ("u", "update"):
            update(editions[0])
        elif tool in ("ul", "updatelist"):
            update_list(editions[0])
        elif tool in ("br", "bulkrun"):
            bulk_run(editions)
        elif tool in ("b", "build"):
            build_modpack(editions[0])
        elif tool in ("p", "publish"):
            publish(editions[0])
        elif tool in ("r", "release"):
            update(editions[0])
            build_modpack(editions[0])
            publish(editions[0])
        else:
            print("Invalid tool")
            return
    except KeyboardInterrupt:
        print("\nOperation cancelled by user.")


if __name__ == "__main__":
    main()
