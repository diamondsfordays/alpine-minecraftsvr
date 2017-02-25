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
echo "minecraft external data directory = ${DATA_DIR}"
# exit on error
set -e

# print out environment variables
printenv

# Link in any external dependent config files or world directories


# start with default/initial server.properties if one is not provided
if [ ! -e "$DATA_DIR/server.properties" ]; then
  cp $MINECRAFT_DIR/tmp/server.properties $DATA_DIR
fi

# copy over eula.txt as startup requirement
if [ ! -e "$DATA_DIR/eula.txt" ]; then
  cp $MINECRAFT_DIR/tmp/eula.txt $DATA_DIR
fi


# -XX\:+UseConcMarkSweepGC, -XX\:+UseParNewGC, -XX\:+DisableExplicitGC, -XX\:MaxGCPauseMillis\=250, -XX\:PermSize\=256M, -XX\:MaxPermSize\=256M


#starting minescraft
cd /$DATA_DIR
java -Xmx$XMX_MEM \
     -Xms$XMS_MEM \
     -jar $MINECRAFT_DIR/mcs.jar nogui &
# nohup
