#!/bin/bash

inkscape-figures watch
python3 $HOME/.local/share/inkscape-shortcut-manager/main.py >>/dev/null 2>&1 &

xpra start :80 --bind-tcp=0.0.0.0:8080 >>/dev/null 2>&1

if [ -n "$OPEN_FILE" ]; then
    nvim "$OPEN_FILE"
else
    nvim
fi

exec bash
