import webview
import threading
import time
import requests
import subprocess
import re
import tkinter as tk


PORT = 8080
URL = f'http://localhost:{PORT}/?floating_menu=no'
SCALING_RATIO = 1

def check_server():
    server_was_down = False
    while True:
        try:
            response = requests.get(URL)
            if response.status_code == 200:
                if server_was_down:
                    print('Server is now available. Reloading the window...')
                    window.load_url(URL)
                    server_was_down = False
            else:
                print('Server returned an unexpected status code:', response.status_code)
                server_was_down = True
        except requests.ConnectionError:
            print('Server is unavailable.')
            server_was_down = True
        # Wait before the next check
        time.sleep(2)

# Function to scale the content
def on_loaded():
    js_code = f"""
    document.body.style.transform = 'scale({1 / SCALING_RATIO})';
    document.body.style.transformOrigin = '0 0';
    document.body.style.width = '{SCALING_RATIO * 100}%';
    document.body.style.height = '{SCALING_RATIO * 100}%';
    """
    window.evaluate_js(js_code)

def get_screen_resolution():
    root = tk.Tk()
    root.withdraw()  # Hide the main tkinter window
    width = root.winfo_screenwidth()
    height = root.winfo_screenheight()
    return width, height

def get_hidpi_resolution():
    try:
        # Call the system_profiler command
        output = subprocess.check_output(
            ["system_profiler", "SPDisplaysDataType"],
            universal_newlines=True
        )
        # Extract resolution details
        for line in output.splitlines():
            if "Resolution" in line:
                    match = re.search(r"Resolution: (\d+) x (\d+)", line)
                    if match:
                        width = int(match.group(1))
                        height = int(match.group(2))
                        return width, height
    except Exception as e:
        print(f"Error: {e}")
    return None, None

def get_scaling_ratio():
    xh, yh = get_hidpi_resolution()
    x, y = get_screen_resolution()
    if xh is None or x is None:
        return None
    return xh / x

if __name__ == "__main__":
    SCALING_RATIO = get_scaling_ratio() or SCALING_RATIO
    print(f"Scaling ratio: {SCALING_RATIO}")

    # Create the webview window
    window = webview.create_window("Zathura", URL)

    # Attach the on_loaded function to the loaded event
    window.events.loaded += on_loaded

    # Start the server checking in a separate thread
    thread = threading.Thread(target=check_server, daemon=True)
    thread.start()

    # Start the webview
    webview.start()
