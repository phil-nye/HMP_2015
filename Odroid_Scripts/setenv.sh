#!/bin/bash

# Set the environment variables needed for PARSEC, POET, and Heartbeats.
# Run this script with ". ./setenv.sh". You must run with the dot before to
# set the environment variables for your current working instance of the shell
#
# Created by Philip Ni (5/21/2015)

Color_Off='\e[0m' # Text Reset

bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldcyn='\e[1;36m' # Cyan

echo -e "\nSet the environement variables needed for PARSEC, POET, and Heartbeats."
#echo -e ${bldcyn}"Run this script with \". ./setenv.sh\". You must run with the dot before to set the environment variables for your current working instance of the shell.\n"${Color_Off}

#echo -e ${bldylw}"Setting LD_LIBRARY_PATH"${Color_Off}
#echo "Original LD_LIBRARY_PATH: "$LD_LIBRARY_PATH
cd ~/parsec-3.0
. ./env.sh
echo -e "\tRunning ~/parsec-3.0/env.sh: "$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/odroid/heartbeats/lib:/home/odroid/poet/lib
echo -e ${bldblu}"\tLD_LIBRARY_PATH set: "$LD_LIBRARY_PATH ${Color_Off}

#echo -e ${bldylw}"\nSetting HEARTBEAT_ENABLED_DIR"${Color_Off}
#echo "Original HEARTBEAT_ENABLED_DIR: "$HEARTBEAT_ENABLED_DIR
export HEARTBEAT_ENABLED_DIR=/tmp
echo -e ${bldblu}"\tHEARTBEAT_ENABLED_DIR set: "$HEARTBEAT_ENABLED_DIR ${Color_Off}
cd
