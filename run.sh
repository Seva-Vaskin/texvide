#!/bin/bash

xhost +local:docker >> /dev/null

docker run \
    --volume="${HOME}:/home" \
    --env="DISPLAY" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    -it texvide