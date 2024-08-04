import sys
from MBulkRun import bulk_run
from MBuild import build_modpack
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
    r"1.21\fabric"
]

def main():
    try:
        global editions, root, modpack_name, modpack_author
        tool = sys.argv[1]

        if len(sys.argv) < 3:
            print("No edition specified")
            return

        targets = sys.argv[2:]
        editions = [edition for edition in editions if any(target in edition for target in targets)]

        if tool == "u" or tool == "update":
            update(root, editions)
        elif tool == "ul" or tool == "updatelist":
            update_list(root, editions)
        elif tool == "br" or tool == "bulkrun":
            bulk_run(root, editions)
        elif tool == "b" or tool == "build":
            build_modpack(modpack_name, modpack_author, root, editions)
        elif tool == "p" or tool == "publish":
            publish(root, editions, modpack_author, modpack_name)
        elif tool == "r" or tool == "release":
            update(root, editions)
            build_modpack(modpack_name, modpack_author, root, editions)
            publish(root, editions, modpack_author, modpack_name)
        else:
            print("Invalid tool")
            return
    except KeyboardInterrupt:
        print("\nOperation cancelled by user.")

if __name__ == "__main__":
    main()