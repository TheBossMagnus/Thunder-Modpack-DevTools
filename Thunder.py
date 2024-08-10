import sys

from MBuild import build_modpack
from MBulkRun import bulk_run
from MPublish import publish
from MUpdate import update
from MUpdateList import update_list
from config import supp_editions

def main() -> None:
    try:
        global supp_editions, root, modpack_name, modpack_author
        tool = sys.argv[1]

        targets = sys.argv[2:]
        
        if 'a' in targets or 'all' in targets:
            editions = supp_editions
        else:
            editions = [
                edition for edition in supp_editions
                if any(target in edition for target in targets)
            ]
        
        if not editions:
            print("No edition selected")
            return

        if tool in ("u", "update"):
            update(editions)
        elif tool in ("ul", "updatelist"):
            update_list(editions)
        elif tool in ("br", "bulkrun"):
            bulk_run(editions)
        elif tool in ("b", "build"):
            build_modpack(editions)
        elif tool in ("p", "publish"):
            publish(editions)
        elif tool in ("r", "release"):
            update(editions)
            build_modpack(editions)
            publish(editions)
        else:
            print("Inavlid tool")
            return
    except KeyboardInterrupt:
        print("\nOperation cancelled by user.")

if __name__ == "__main__":
    main()
