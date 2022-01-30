#!/bin/sh

docker build -f Dockerfile -t xelatex-iot .
docker run -it -v $PWD/src:/home -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY  xelatex-iot /bin/bash