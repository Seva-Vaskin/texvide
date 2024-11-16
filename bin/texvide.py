import os
import sys
import time
import signal
import platform
import subprocess
from pathlib import Path

class TexVIDELauncher:
    def __init__(self):
        self.host_os = platform.system()
        self.docker_process = None
        self.xpra_process = None
        self.project_root = Path(__file__).parent.parent
        
        # Set up signal handlers
        signal.signal(signal.SIGINT, self.cleanup)
        signal.signal(signal.SIGTERM, self.cleanup)

    def start_linux_container(self):
        """Start Docker container for Linux"""
        # Enable X11 forwarding
        subprocess.run(["xhost", "+local:docker"], 
                      stdout=subprocess.DEVNULL, 
                      stderr=subprocess.DEVNULL)

        cmd = [
            "docker", "run",
            "--hostname", "TexVIDE",
            "--env=HOST_OS=Linux",
            "--env=DISPLAY",
            f"--volume={os.path.expanduser('~')}:/home",
            f"--volume={self.project_root}/config/:/root/.config",
            "--volume=/tmp/.X11-unix:/tmp/.X11-unix",
            f"--volume={os.path.expanduser('~')}/.Xauthority:/root/.Xauthority:rw",
            "--volume=/run/user/1000/at-spi/bus_0:/run/user/1000/at-spi/bus_0:rw",
            "--rm",
            "-it",
            "--name", "texvide",
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
        ], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


        # Start Docker container
        cmd = [
            "docker", "run",
            "--hostname", "TexVIDE",
            "--env=HOST_OS=Darwin",
            "--env=DISPLAY=:80",
            f"--volume={os.path.expanduser('~')}:/home",
            f"--volume={self.project_root}/config/:/root/.config",
            "-p", "8080:8080",
            "--rm",
            "-it",
            "--name", "texvide",
            "texvide"
        ]
        self.docker_process = subprocess.Popen(cmd)

        # Wait for Docker to start
        print("Waiting for Docker container to start...")
        if not self.wait_for_port(8080):
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
                             stdout=subprocess.DEVNULL, 
                             stderr=subprocess.DEVNULL)
            except subprocess.TimeoutExpired:
                print("Docker container stop timed out, forcing...")
            
            # Then terminate the process
            self.docker_process.terminate()
            try:
                self.docker_process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                self.docker_process.kill()

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
    launcher = TexVIDELauncher()
    sys.exit(launcher.run())

if __name__ == "__main__":
    main()
