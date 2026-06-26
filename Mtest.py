import shutil
import minecraft_launcher_lib
import subprocess
import os
import time
import datetime


def cleanup_mc_dir(minecraft_directory):
    # Remove mods directory
    mods_dir = os.path.join(minecraft_directory, "mods")
    if os.path.exists(mods_dir) and os.path.isdir(mods_dir):
        shutil.rmtree(mods_dir)
    # Remove config directory
    config_dir = os.path.join(minecraft_directory, "config")
    if os.path.exists(config_dir) and os.path.isdir(config_dir):
        shutil.rmtree(config_dir)
    # Remove all .txt files in the minecraft_directory (recursive)
    for root, dirs, files in os.walk(minecraft_directory):
        for file in files:
            if file.endswith(".txt"):
                try:
                    os.remove(os.path.join(root, file))
                except Exception:
                    pass


def test_pack(mrpack_path: str) -> bool:
    try:
        mrpack_information = minecraft_launcher_lib.mrpack.get_mrpack_information(mrpack_path)
    except Exception:
        print("Test FAILED: Invalid .mrpack file")
        return False

    def silent_callback(status):
        pass

    # Change working directory to /tmp to avoid any accidental changes to mrpack_path location
    os.chdir("/tmp")

    loader = "fabric" if "fabric" in mrpack_path else "quilt"
    mc_version = str(mrpack_information["minecraftVersion"])
    minecraft_directory = os.path.join("/tmp", mc_version, loader)
    os.makedirs(minecraft_directory, exist_ok=True)

    # Copy the modpack file into the temp directory before doing anything
    modpack_filename = os.path.basename(mrpack_path)
    temp_mrpack_path = os.path.join(minecraft_directory, modpack_filename)
    shutil.copy2(mrpack_path, temp_mrpack_path)

    # Cleanup before install
    cleanup_mc_dir(minecraft_directory)

    modpack_directory = minecraft_directory
    mrpack_install_options: minecraft_launcher_lib.types.MrpackInstallOptions = {"optionalFiles": []}
    for i in mrpack_information["optionalFiles"]:
        mrpack_install_options["optionalFiles"].append(i)
    print("Installing...")
    minecraft_launcher_lib.mrpack.install_mrpack(temp_mrpack_path, minecraft_directory, modpack_directory=modpack_directory, mrpack_install_options=mrpack_install_options, callback={"setStatus": silent_callback})
    options = minecraft_launcher_lib.utils.generate_test_options()
    options["gameDirectory"] = modpack_directory
    command = minecraft_launcher_lib.command.get_minecraft_command(minecraft_launcher_lib.mrpack.get_mrpack_launch_version(temp_mrpack_path), minecraft_directory, options)
    os.makedirs("logs", exist_ok=True)
    log_timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    log_file_path = f"logs/minecraft_output_{log_timestamp}.log"
    print("Running...")
    SUCCESS_TEXT = ["Game took", "gui.png-atlas"]
    result = False
    with open(log_file_path, "w") as log_file:
        minecraft_process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, bufsize=1, universal_newlines=True)
        console_output = []
        timeout = time.time() + 300
        timeout_reached = False
        try:
            if minecraft_process.stdout is None:
                pass
            else:
                for line in iter(minecraft_process.stdout.readline, ""):
                    log_file.write(line)
                    log_file.flush()
                    console_output.append(line)
                    if any(success_text in line for success_text in SUCCESS_TEXT):
                        result = True
                        break
                    if time.time() > timeout:
                        timeout_reached = True
                        break
                    if minecraft_process.poll() is not None:
                        break
        except Exception:
            pass
        if minecraft_process.poll() is None:
            if timeout_reached:
                minecraft_process.kill()
            else:
                minecraft_process.terminate()
                try:
                    minecraft_process.wait(timeout=10)
                except subprocess.TimeoutExpired:
                    minecraft_process.kill()
    if minecraft_process.stdout and not minecraft_process.stdout.closed:
        minecraft_process.stdout.close()
        minecraft_process.kill()
    if result:
        print("\033[1;32mPASSED")
    else:
        print("\033[1;31mFAILED")
        subprocess.run(["tail", "-n", "20", log_file_path])
        print(f"Full log available at: {log_file_path}")
    print("\033[0m")
    # Cleanup after run
    cleanup_mc_dir(minecraft_directory)
    # Clean up old log files but keep the current one
    if os.path.exists("logs") and os.path.isdir("logs"):
        for file in os.listdir("logs"):
            file_path = os.path.join("logs", file)
            if file_path != log_file_path and os.path.isfile(file_path):
                os.unlink(file_path)
    return result


if __name__ == "__main__":
    test_pack(r"/home/tbmag/Downloads/Thunder 0.1.3+1.21.5.mrpack")
