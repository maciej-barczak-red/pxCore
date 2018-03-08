#!/bin/bash -xe
#
# Author: Damian Wrobel <dwrobel@ertelnet.rybnik.pl>
#

groupadd --gid $GID "$USER"
useradd --uid $UID --gid $GID "$USER"

echo "Hello ${USER}!"

cd "$CWD"

sudo -H -u "$USER" "$@"

