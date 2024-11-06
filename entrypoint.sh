#!/bin/bash

inkscape-figures watch
python3 /inkscape-shortcut-manager/main.py >>/dev/null 2>&1 &

exec bash -c "/usr/local/bin/startup.sh"