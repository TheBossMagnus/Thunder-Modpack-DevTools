import os


def bulk_run(root, editions) -> None:
    command = input("Enter the command to run in all selected subfolders: ")

    for edition in editions:
        os.chdir(f"{root}/src/{edition}")
        os.system(command)
