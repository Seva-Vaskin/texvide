import sys
import subprocess
from pathlib import Path

def open_editor(filename):
    print(f"Opening {filename} with urxvt")
    subprocess.run([
        'urxvt',
        '-geometry', '60x5',
        '-name', 'popup-bottom-center',
        '-e', "nvim",
        f"{filename}",
    ])

def latex_document(latex):
    return r"""
        \documentclass[12pt,border=12pt]{standalone}

        \usepackage[utf8]{inputenc}
        \usepackage[T1]{fontenc}
        \usepackage{textcomp}
        \usepackage{amsmath, amssymb}
        \newcommand{\R}{\mathbb R}

        \begin{document}
    """ + latex + r"\end{document}"

config = {
    # For example '~/.config/rofi/ribbon.rasi' or None
    'rofi_theme': None,
    # Font that's used to add text in inkscape
    'font': 'monospace',
    'font_size': 10,
    'open_editor': open_editor,
    'latex_document': latex_document,
}
