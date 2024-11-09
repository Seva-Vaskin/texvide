#!/bin/bash

inkscape-figures watch
python3 /inkscape-shortcut-manager/main.py >>/dev/null 2>&1 &
# service dbus start
# export $(dbus-launch)

echo "Current Docker DPI: ${DPI}"
xpra start :80 --dpi=${DPI} --bind-tcp=0.0.0.0:8080 --tray=no

exec bash