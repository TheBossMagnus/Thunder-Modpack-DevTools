import shutil
import minecraft_launcher_lib
import subprocess
import os
import time
import datetime
import tempfile


def test_pack(mrpack_path: str) -> bool:
    try:
        mrpack_information = minecraft_launcher_lib.mrpack.get_mrpack_information(mrpack_path)
    except Exception:
        print("Test FAILED: Invalid .mrpack file")
        return False

    # Silent callback for installation
    def silent_callback(status):
        pass

    script_dir = os.path.dirname(os.path.abspath(__file__))
    loader = "fabric" if "fabric" in mrpack_path else "quilt"

    with tempfile.TemporaryDirectory(prefix="mc_test_") as temp_mc_dir:
        minecraft_directory = os.path.join(temp_mc_dir, str(mrpack_information["minecraftVersion"]), str(loader))
        os.makedirs(minecraft_directory, exist_ok=True)
        modpack_directory = minecraft_directory

        # Adds the Optional Files
        mrpack_install_options: minecraft_launcher_lib.types.MrpackInstallOptions = {"optionalFiles": []}
        for i in mrpack_information["optionalFiles"]:
            mrpack_install_options["optionalFiles"].append(i)

        # Install
        print("Installing...")
        minecraft_launcher_lib.mrpack.install_mrpack(mrpack_path, minecraft_directory, modpack_directory=modpack_directory, mrpack_install_options=mrpack_install_options, callback={"setStatus": silent_callback})

        options = minecraft_launcher_lib.utils.generate_test_options()
        options["gameDirectory"] = modpack_directory
        command = minecraft_launcher_lib.command.get_minecraft_command(minecraft_launcher_lib.mrpack.get_mrpack_launch_version(mrpack_path), minecraft_directory, options)

        # Create logs directory if it doesn't exist
        os.makedirs("logs", exist_ok=True)

        # Generate a log file path with timestamp
        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        log_file_path = f"logs/minecraft_output_{timestamp}.log"

        # Start process with output captured
        print("Running...")
        SUCCESS_TEXT = ["Game took", "gui.png-atlas"]
        result = False

        with open(log_file_path, "w") as log_file:
            # Start the process, capture stdout and stderr
            minecraft_process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, bufsize=1, universal_newlines=True)

            # Monitor output in real-time
            console_output = []
            timeout = time.time() + 300  # 5 minute timeout
            timeout_reached = False

            try:
                # Make sure stdout is not None before reading from it
                if minecraft_process.stdout is None:
                    pass
                else:
                    # Read output line by line
                    for line in iter(minecraft_process.stdout.readline, ""):
                        log_file.write(line)
                        log_file.flush()
                        console_output.append(line)

                        # Check for success text
                        if any(success_text in line for success_text in SUCCESS_TEXT):
                            result = True
                            break

                        # Check for timeout
                        if time.time() > timeout:
                            timeout_reached = True
                            break

                        # Check if process has terminated
                        if minecraft_process.poll() is not None:
                            break
            except Exception:
                pass

            # If process is still running, terminate it
            if minecraft_process.poll() is None:
                if timeout_reached:
                    minecraft_process.kill()
                else:
                    minecraft_process.terminate()
                    try:
                        minecraft_process.wait(timeout=10)
                    except subprocess.TimeoutExpired:
                        minecraft_process.kill()

        # Close the stdout pipe and the process
        if minecraft_process.stdout and not minecraft_process.stdout.closed:
            minecraft_process.stdout.close()
            minecraft_process.kill()

        # Handle the results
        if result:
            print("\033[1;32;40mPASSED")
        else:
            print("\033[0;31;4mFAILED")
            os.system(f"code --new-window {log_file_path}")

        print("\033[0m")  # Reset color

        # Clean up old log files but keep the current one
        if os.path.exists("logs") and os.path.isdir("logs"):
            for file in os.listdir("logs"):
                file_path = os.path.join("logs", file)
                if file_path != log_file_path and os.path.isfile(file_path):
                    os.unlink(file_path)

        return result


if __name__ == "__main__":
    test_pack(r"/home/tbmag/Downloads/Thunder 0.1.3+1.21.5.mrpack")
