import webview

def on_loaded():
    js_code = """
    // Scale the content by a factor of 2
    document.body.style.transform = 'scale(0.5)';
    document.body.style.transformOrigin = '0 0';
    document.body.style.width = '200%';
    document.body.style.height = '200%';
    """
    window.evaluate_js(js_code)

# Create the webview window
window = webview.create_window("Zathura", "http://localhost:8080/?floating_menu=no")

# Attach the on_loaded function to the loaded event
window.events.loaded += on_loaded

# Start the webview
webview.start()

