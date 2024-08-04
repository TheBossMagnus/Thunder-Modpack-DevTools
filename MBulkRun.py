import os


def bulk_run(root, editions):
    command = input("Enter the command to run in all selected subfolders: ")

    for edition in editions:
        print(f"Running command in {edition}...")
        os.chdir(f"{root}/src/{edition}")
        os.system(command)
