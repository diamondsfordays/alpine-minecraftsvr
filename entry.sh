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
if [ ! -f "$DATA_DIR/logs/latest.log" ]
then
  touch $DATA_DIR/logs/latest.log
fi
tail -f $DATA_DIR/logs/latest.log &
while :
do
  pid=`pgrep -o -x java`
  if [ $? -eq 1 ];
  then
    # java process has stopped running!
    pkill tail
    exit 1
  else
    # echo "Minecraft still running: $pid"
    sleep 10
  fi
done
