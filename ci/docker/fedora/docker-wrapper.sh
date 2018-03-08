#!/bin/bash -xe
#
# Wraps commands with docker
#
# Author: Damian Wrobel <dwrobel@ertelnet.rybnik.pl>
#
# Usage: docker-wrapper.sh <command-to-execute-within-docker>
#
# Note: It has also access to the entire $HOME directory

CWD=$PWD

DIRECTORY=$(cd `dirname $0` && pwd)

DOCKER_ID=dwrobel/pxscene:27

sudo docker build -t ${DOCKER_ID} $DIRECTORY

VDIR="$HOME"

sudo docker run -it -e USER=$USER -e UID=$UID -e GID=$(id -g $USER) -e CWD="$CWD" -v "${VDIR}":"${VDIR}" ${DOCKER_ID} "$@"
