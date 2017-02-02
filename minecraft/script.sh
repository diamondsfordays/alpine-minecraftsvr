#!/bin/bash

#MINECRAFT_DIR="/minecraft"
#XMX_MEM=768M
#XMS_MEM=768M

usage() { echo "Usage: $0 [-c <directory] [-d <directory>] [-M <num>M] [-m <num>M]" 1>&2; exit 1; }

while getopts ":c:M:m:d:" o; do
    case "${o}" in
        M)
            XMX_MEM=${OPTARG}
            ;;
        m)
            XMS_MEM=${OPTARG}
            ;;
        d)
            MINECRAFT_DIR=${OPTARG}
            ;;
        c)
            DATA_DIR=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
#shift $((OPTIND-1))
#
#if [ -z "${M}" ] || [ -z "${m}" ]; then
#    usage
#fi

echo "Xmx = ${M}"
echo "Xms = ${m}"
echo "minecraft home dir = ${MINECRAFT_DIR}"
echo "minecraft external config directory = ${EXT_CONFIG_DIR}"
# exit on error
set -e

# print out environment variables
printenv

# Link in any external dependent config files or world directories
if [ -d "$DATA_DIR" ]; then
  # Link files
  for f in $DATA_DIR/*
  do
    ff=$(basename $f)
    echo "File $f found in $DATA_DIR"
    if [ ! -e "$MINECRAFT_DIR/$ff" ]; then
      echo "Linking file $ff"
      ln -s $f $MINECRAFT_DIR/$ff
    fi
  done
  # link directories
  for D in `find $DATA_DIR/ -type d`
  do
    DD=$(basename $D)
    echo "Directory $D found in $DATA_DIR"
    if [ ! -e "$MINECRAFT_DIR/$DD" ]; then
      echo "Linking dir $DD"
      ln -s $D $MINECRAFT_DIR/$DD
    fi
  done
fi

# start with default/initial server.properties if one is not provided
if [ ! -e "$MINECRAFT_DIR/server.properties" ]; then
  cp $MINECRAFT_DIR/tmp/server.properties $MINECRAFT_DIR
fi

# copy over eula.txt as startup requirement
if [ ! -e "$MINECRAFT_DIR/eula.txt" ]; then
  cp $MINECRAFT_DIR/tmp/eula.txt $MINECRAFT_DIR
fi


# -XX\:+UseConcMarkSweepGC, -XX\:+UseParNewGC, -XX\:+DisableExplicitGC, -XX\:MaxGCPauseMillis\=250, -XX\:PermSize\=256M, -XX\:MaxPermSize\=256M

  
#starting minescraft
cd /$MINECRAFT_DIR
java -Xmx$XMX_MEM \
     -Xms$XMS_MEM \
     -jar $MINECRAFT_DIR/mcs.jar nogui
# nohup
