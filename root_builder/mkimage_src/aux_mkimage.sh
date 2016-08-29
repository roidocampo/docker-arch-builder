#!/usr/bin/env bash

mkdir /root/tmpbuild

. ./mkimage.sh -d /root/tmpbuild mkimage-arch.sh "$@"

(set -x; cp "$tarFile" /root/build/)

echo Done!
