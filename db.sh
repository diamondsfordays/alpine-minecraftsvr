#!/bin/bash
# Docker buildcycle script
# Build and automate cleanup - good to use on a dev box where this is the
# only project you are workingo on.

REPO_AND_IMAGE='diamondsfordays/alpine-minecraftsvr:1.11.2'
CONTAINER_NAME='minecraft'

# remove built image for rebuild
#docker rmi $(docker images | grep -v $REPO_AND_IMAGE | awk {'print $3'})
# docker rmi $(docker images | awk {'print $3'})
# remove any images that are left around
# docker rmi $(docker images -f dangling=true -q)

# remove any existing stopped containers
docker ps -a | awk '{print $1}' | xargs docker rm

# build the image, removing intermediate layers, deleting cache
# docker build --rm --no-cache -t "$REPO_AND_IMAGE" .
docker build \
    --rm \
    -t "$REPO_AND_IMAGE" .

# run the newly built image
#docker run --name $CONTAINER_NAME -p 25565:25565 -l $CONTAINER_NAME $REPO_AND_IMAGE

# run in inteactive for debugging / development
docker run \
      --name $CONTAINER_NAME \
      -d \
      -p 25565:25565 \
      -v ./data:/mcsdata \
      -l $CONTAINER_NAME \
      $REPO_AND_IMAGE
      # -it for interactive mode
      # --entrypoint="/bin/bash" for debugging

# attach to the new container
#docker attach -it minecraft

# for docker-machine, ensure port is available to host
# This is really only for development when using docker machine
VBoxManage controlvm "default" natpf1 "tcp-port25565,tcp,,25565,,25565";

# follow stdout
docker logs -f $CONTAINER_NAME
