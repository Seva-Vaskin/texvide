import webview

def set_fake_screen_size(window):
    # Override the device pixel ratio and scale the view back down
    js_code = """
        Object.defineProperty(window, 'devicePixelRatio', {
            get: function() { return 0.5; } // Makes the site believe the screen size is double
        });
        document.documentElement.style.transform = 'scale(0.5)'; // Scale content down to fit the screen
        document.documentElement.style.transformOrigin = '0 0'; // Keep the scaling origin at the top left
    """
    window.evaluate_js(js_code)

# Create the WebView window
window = webview.create_window('Larger Screen Simulation', 'http://localhost:8080/', width=800, height=600)

# Start the WebView with JavaScript injection to adjust device pixel ratio and scaling
webview.start(set_fake_screen_size, window)



# import webview
# # webview.create_window("Zathura", "http://localhost:8080/?floating_menu=no")
# webview.create_window("Zathura", "http://localhost:8080/")

# webview.start()
