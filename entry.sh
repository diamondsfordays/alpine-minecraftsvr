#!/bin/bash

# Fix data dir file permissions
chown -R minecraft: $DATA_DIR
chmod -R u+rw $DATA_DIR

# Script to run on entrypoint into container
sudo MINECRAFT_DIR=$MINECRAFT_DIR \
     XMX_MEM=$XMX_MEM \
     XMS_MEM=$XMS_MEM \
     DATA_DIR=$DATA_DIR \
     su -c '/minecraft/script.sh' \
     minecraft

# pipes log to stdout.  If you run docker logs -f minecraft, you will see
# the tail from this file
# This also keeps the container running!  Help - there's probably a more
# sane way to accomplish this.
tail -f $DATA_DIR/logs/latest.log
