#!/bin/bash

export CONTAINER_NAME="px4_ros2_cont"
export IMAGE_NAME="px4_ros2"


xhost +local:docker;
export DISPLAY=:0
PROJECT_DIR="/";
PROJECT_DIST="$HOME";

if [ "$(docker ps -qaf name=$CONTAINER_NAME)" = "" ]; then
    echo 'Container not found, creating it ...';

    docker run -it \
    --name $CONTAINER_NAME \
    --privileged \
    --workdir $PROJECT_DIST \
    --env DISPLAY=$DISPLAY \
    --volume /tmp/.X11-unix:/tmp/.X11-unix \
    --volume /mnt/wslg:/mnt/wslg \
    $IMAGE_NAME bash;

    echo 'Container created.';
else
    if [ "${1}" = "restart" ] && ! docker stop $CONTAINER_NAME > /dev/null; then
        echo 'Error while stopping the container, exiting now ...';
        return 1;
    fi;
    if ! docker start $CONTAINER_NAME > /dev/null; then
        echo 'Error while starting the container, exiting now ...';
        return 1;
    fi;
    echo 'px4_docker found and running, executing a shell ...';
    docker exec -it $CONTAINER_NAME bash --login;
fi;
