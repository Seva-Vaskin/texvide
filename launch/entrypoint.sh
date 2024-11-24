#!/bin/bash

inkscape-figures watch
python3 $HOME/.local/share/inkscape-shortcut-manager/main.py >>/dev/null 2>&1 &

xpra start :80 --bind-tcp=0.0.0.0:8080 --xvfb="Xvfb +extension Composite -screen 0 5760x2560x24+32 -dpi 155 -nolisten tcp -noreset -auth \$XAUTHORITY" --client-ping-timeout=0 >>/dev/null 2>&1

exec bash
