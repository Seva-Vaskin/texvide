import os
import sys
import time
import signal
import platform
import subprocess
import argparse
from pathlib import Path

OSX_GUI_PORT = 8080

class TexVIDELauncher:
    def __init__(self, log_file=None):
        self.host_os = platform.system()
        self.docker_process = None
        self.xpra_process = None
        self.project_root = Path(__file__).parent.parent
        self.log_file = open(log_file, 'w') if log_file else subprocess.DEVNULL
        
        self.common_docker_args = [
            "--hostname", "TexVIDE",
            "--rm",
            "-it",
            "--name", "texvide",
            f"--volume={os.path.expanduser('~')}:/userdata",
            f"--volume={os.path.expanduser('~')}/.local/state/nvim:/home/user/.local/state/nvim",
            f"--volume={self.project_root}/config/:/home/user/.config",
        ]

        self.linux_docker_args = [
            f"--env=DISPLAY={os.environ.get('DISPLAY')}",
            "--env=HOST_OS=Linux",
            f"--volume=/tmp/.X11-unix:/tmp/.X11-unix",
            f"--volume={os.path.expanduser('~')}/.Xauthority:/home/user/.Xauthority:rw",
            "--volume=/run/user/1000/at-spi/bus_0:/run/user/1000/at-spi/bus_0:rw",
        ]

        self.macos_docker_args = [
            "--env=HOST_OS=Darwin",
            "--env=DISPLAY=:80",
            "-p", f"{OSX_GUI_PORT}:{OSX_GUI_PORT}",
        ]


        # Set up signal handlers
        signal.signal(signal.SIGINT, self.cleanup)
        signal.signal(signal.SIGTERM, self.cleanup)

    def start_linux_container(self):
        """Start Docker container for Linux"""
        # Enable X11 forwarding
        subprocess.run(["xhost", "+local:docker"], 
                      stdout=self.log_file, 
                      stderr=self.log_file)

        cmd = [
            "docker", "run",
            *self.common_docker_args,
            *self.linux_docker_args,
            "texvide"
        ]
        self.docker_process = subprocess.Popen(cmd)
        return self.docker_process.wait()

    def start_macos_container(self):
        """Start Docker container and Xpra for macOS"""
        # Start Xpra client
        print("Starting Xpra client...")
        launch_script = self.project_root / "bin" / "launch_xpra.py"
        
        self.xpra_process = subprocess.Popen([
            sys.executable,
            str(launch_script)
        ], stdout=self.log_file, stderr=self.log_file)

        # Start Docker container
        cmd = [
            "docker", "run",
            *self.common_docker_args,
            *self.macos_docker_args,
            "texvide"
        ]
        self.docker_process = subprocess.Popen(cmd)

        # Wait for Docker to start
        print("Waiting for Docker container to start...")
        if not self.wait_for_port(OSX_GUI_PORT):
            print("Error: Docker container failed to start")
            self.cleanup()
            return 1

        # Wait for either process to exit
        while True:
            if self.docker_process.poll() is not None:
                print("Docker container has stopped")
                break
            if self.xpra_process.poll() is not None:
                print("Xpra client has stopped")
                break
            time.sleep(1)

        return 0

    def wait_for_port(self, port, timeout=30):
        """Wait for a port to become available"""
        import socket
        start_time = time.time()
        
        while time.time() - start_time < timeout:
            try:
                with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
                    sock.connect(('localhost', port))
                    return True
            except ConnectionRefusedError:
                time.sleep(1)
        return False

    def cleanup(self, signum=None, frame=None):
        """Clean up processes on exit"""
        print("\nCleaning up...")
        
        if self.xpra_process:
            print("Terminating Xpra client...")
            self.xpra_process.terminate()
            try:
                self.xpra_process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                self.xpra_process.kill()

        if self.docker_process:
            print("Terminating Docker container with name 'texvide', timeout 10s")
            # First try to stop the container gracefully
            try:
                subprocess.run(["docker", "stop", "texvide"], 
                             timeout=10,
                             stdout=self.log_file, 
                             stderr=self.log_file)
            except subprocess.TimeoutExpired:
                print("Docker container stop timed out, forcing...")
            
            # Then terminate the process
            self.docker_process.terminate()
            try:
                self.docker_process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                self.docker_process.kill()

        # Close log file if it was opened
        if self.log_file != subprocess.DEVNULL:
            self.log_file.close()

        sys.exit(0)

    def run(self):
        """Main execution method"""
        try:
            if self.host_os == "Linux":
                return self.start_linux_container()
            elif self.host_os == "Darwin":
                return self.start_macos_container()
            else:
                print(f"Unsupported OS: {self.host_os}")
                return 1
                
        except Exception as e:
            print(f"Error: {e}")
            return 1
        finally:
            self.cleanup()

def main():
    parser = argparse.ArgumentParser(description='TexVIDE Launcher')
    parser.add_argument('--log', type=str, help='Path to log file')
    args = parser.parse_args()

    launcher = TexVIDELauncher(log_file=args.log)
    sys.exit(launcher.run())

if __name__ == "__main__":
    main()
