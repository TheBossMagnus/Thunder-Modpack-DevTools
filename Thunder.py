import sys

from MBuild import build_modpack
from MBulkRun import bulk_run
from MPublish import publish
from MUpdate import update
from MUpdateList import update_list

modpack_name = "Thunder"
modpack_author = "TheBossMagnus"
root = r"D:\Thunder"
editions = [
    r"1.16.5\fabric",
    r"1.18.2\fabric",
    r"1.19.2\quilt",
    r"1.19.2\fabric",
    r"1.20.1\quilt",
    r"1.20.1\fabric",
    r"1.20.4\quilt",
    r"1.20.4\fabric",
    r"1.20.6\quilt",
    r"1.20.6\fabric",
    r"1.21\quilt",
    r"1.21\fabric",
    r"1.21.1\fabric"
]

def main() -> None:
    try:
        global editions, root, modpack_name, modpack_author
        tool = sys.argv[1]

        targets = sys.argv[2:]
        editions = [edition for edition in editions if any(target in edition for target in targets)]

        if tool in ("u", "update"):
            update(root, editions)
        elif tool in ("ub", "updatebulk"):
            update_list(root, editions)
        elif tool in ("br", "bulkrun"):
            bulk_run(root, editions)
        elif tool in ("b", "build"):
            build_modpack(modpack_name, modpack_author, root, editions)
        elif tool in ("p", "publish"):
            publish(root, editions, modpack_author, modpack_name)
        elif tool in ("r", "release"):
            update(root, editions)
            build_modpack(modpack_name, modpack_author, root, editions)
            publish(root, editions, modpack_author, modpack_name)
        else:
            return
    except KeyboardInterrupt:
        print("\nOperation cancelled by user.")

if __name__ == "__main__":
    main()
