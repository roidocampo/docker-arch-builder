#!/usr/bin/env bash

rootfile_name="$1"

shift

mkdir /root/tmpbuild

. ./mkimage.sh -d /root/tmpbuild mkimage-arch.sh "$@"

(set -x; cp "$tarFile" /root/build/"$rootfile_name")

echo Done!
