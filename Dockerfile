#---------------------------------------------
# DockerFile
# Name:        alpine-minecraftsvr
# Description: Minecraft Dockerfile starting from Alpine Java
# Location:    https://github.com/diamondsfordays/alpine-minecraftsvr
# Author:      falenn
# Created:     28Jan2017
#
# Starting from the smallest OS possible, plus help from anaspix's java inclusion
# For information on minecraft server, see https://minecraft.net/en-us/download/server
#---------------------------------------------

#-- Usage Guide ----------------
# Docker build command:
# docker build --rm --no-cache -t "diamondsfordays/alpine-minecraftsvr:1.11.2" .

# Docker run command:
# docker run --rm -it -p 25565:25565 -l minecraft diamondsfordays/alpine-minecraftsvr:1.11.2
# docker run --rm -p 25565:25565 -it -l minecraft --entrypoint="/bin/bash" diamondsfordays/alpine-minecraftsvr:1.11.2
# docker run --rm -p 25565:25565 -l minecraft -v ~/dev/git/minecraftsvr/data:/mcsdata diamondsfordays/alpine-minecraftsvr:1.11.2

# Docker remove images
# docker rmi $(docker images -f dangling=true -q)

# Docker remove containers matching minecraft
# docker ps -a | grep "minecraft" | awk '{print $1}' | xargs docker rm

# Docker remove all containers
# docker ps -a | awk '{print $1}' | xargs docker rm


FROM anapsix/alpine-java:8

LABEL org.diamondsfordays.alpine-minecraftsvr.verison="1.11.2" \
      org.diamondsfordays.alpine-minecraftsvr.image-specs="{ \
      \"Description\":\"Alpine-java container running minecraft server\", \
      \"java-version\":\"8\" \
      }"

MAINTAINER falenn

# Remember, Docker best practices:
# Containers should be ephemeral¶ ...
# Use a .dockerignore file¶ ...
# Avoid installing unnecessary packages¶ ...
# Run only one process per container¶ ...
# Minimize the number of layers¶ ...
# Sort multi-line arguments¶ ...
# Build cache¶ ...

# Container needs to be as ephemeral as possible - that is,
# that it can be stopped and restarted or upgraded without
# loosing data.
#
# We will therefor do the following:
# 1. NOT store the Minecraft world IN the container.  Will need to
#    mount a volume for that
# 2. Will mount in server configurations so we do not share configs
#    with the world.  We can start up with a default if there isn't
#    one provided at startup.

# set environment variables
ENV MCS_MAJOR=1.11 \
    MCS_VERSION=1.11.2 \
    MINECRAFT_DIR="/minecraft" \
    XMX_MEM=1024M \
    XMS_MEM=1024M \
    DATA_DIR=/mcsdata

# Modify the path
ENV PATH $MINECRAFT_DIR:$PATH

# update Alpine for wget ssl support
RUN apk add --update ca-certificates openssl bash sudo \
    && update-ca-certificates

# Install minecraft server
RUN mkdir -p $MINECRAFT_DIR/tmp \
    && wget -P $MINECRAFT_DIR https://s3.amazonaws.com/Minecraft.Download/versions/$MCS_VERSION/minecraft_server.$MCS_VERSION.jar \
    && ln -s $MINECRAFT_DIR/minecraft_server.$MCS_VERSION.jar $MINECRAFT_DIR/mcs.jar \
    && adduser -s /bin/bash -D -h $MINECRAFT_DIR minecraft \
    && mkdir -p $DATA_DIR/logs \
    && chown -R minecraft: $DATA_DIR

# Copy over essential config files to config dir
COPY minecraft/config $MINECRAFT_DIR/tmp/
COPY minecraft/script.sh $MINECRAFT_DIR

# create a Docker volume to store data beyond Docker container lifecycle
# VOLUME /mcsdata

# Copy over startup script
COPY entry.sh /usr/bin

# Set startup script as executable
RUN chmod u+x $MINECRAFT_DIR/script.sh \
    && chown -R minecraft: $MINECRAFT_DIR \
    && chmod u+x /usr/bin/entry.sh

# Expose default expected service ports
EXPOSE 25565

ENTRYPOINT ["/usr/bin/entry.sh"]
