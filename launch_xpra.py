import webview
import threading
import time
import requests

PORT = 8080
URL = f'http://localhost:{PORT}/?floating_menu=no'

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
    js_code = """
    document.body.style.transform = 'scale(0.5)';
    document.body.style.transformOrigin = '0 0';
    document.body.style.width = '200%';
    document.body.style.height = '200%';
    """
    window.evaluate_js(js_code)

# Create the webview window
window = webview.create_window("Zathura", URL)

# Attach the on_loaded function to the loaded event
window.events.loaded += on_loaded

# Start the server checking in a separate thread
thread = threading.Thread(target=check_server, daemon=True)
thread.start()

# Start the webview
webview.start()
