#!/bin/bash

xhost +

DEVICE=""
CONTAINER_NAME="ros1"
DOCKER_NET="host"

PROG_NAME=$(basename $0)
RUN_DIR=$(dirname $(readlink -f $0))

HOST_WS=$(dirname $(dirname $(readlink -f $0)))/../../../m2mapping_ws
# HOST_SD=$(dirname $(dirname $(readlink -f $0)))/shared_dir

DOCKER_VOLUME="-v ${HOST_WS}:/home/ros1/m2mapping_ws:rw"
DOCKER_VOLUME="${DOCKER_VOLUME} -v /tmp/.X11-unix:/tmp/.X11-unix:rw"
DOCKER_VOLUME="${DOCKER_VOLUME} -v /home/data/mapping/Replica:/home/ros1/m2mapping_ws/src/GS-SDF/data/Replica:rw"

DOCKER_ENV="${DOCKER_ENV} -e DISPLAY=$DISPLAY"

docker run \
    -it \
    --rm \
    --gpus all \
    --privileged \
    --name ros1_GS \
    --net ${DOCKER_NET} \
    ${DEVICE} \
    ${DOCKER_VOLUME} \
    ${DOCKER_ENV} \
    ros1:noetic_GS \
    bash
