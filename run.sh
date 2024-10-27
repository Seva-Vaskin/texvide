#!/bin/bash

xhost +local:docker >> /dev/null

docker run \
    --volume="${HOME}:/home" \
    --env="DISPLAY" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix" \
    --volume="$HOME/.Xauthority:/root/.Xauthority:rw" \
    -it texvide
    