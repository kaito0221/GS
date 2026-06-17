#!/bin/bash
ROS_DISTRO="noetic"

BUILD_DIR=$(dirname $(readlink -f $0))

docker build \
    --build-arg UID=$(id -u) \
    --build-arg ROS_DISTRO=${ROS_DISTRO} \
    -t ros1:${ROS_DISTRO}_GS \
    ${BUILD_DIR}/src

if [[ $? != 0 ]]; then
    echo "エラーにより中断しました．"
    exit 1
fi
