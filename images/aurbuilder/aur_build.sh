#!/bin/bash

PACKAGE=$1

shift; shift

for DEPENDENCY in "$@"
do
    DEP_PATH="$HOME/aur/build/$DEPENDENCY.pkg.tar.xz"
    if [ -f "$DEP_PATH" ]; then
        sudo pacman -U --noconfirm "$DEP_PATH"
    fi
done

mkdir build_tmp
cd build_tmp

if [ -d "$HOME/aur/src/$PACKAGE" ]; then
    cp -r "$HOME/aur/src/$PACKAGE" "$PACKAGE"
elif [ -f "$HOME/aur/src/$PACKAGE.tar.gz" ]; then
    tar xvf "$HOME/aur/src/$PACKAGE.tar.gz"
fi

cd "$PACKAGE"

makepkg --syncdeps --needed --noconfirm

ls -al

sudo cp "$PACKAGE"*.pkg.tar.xz "$HOME/aur/build/$PACKAGE.pkg.tar.xz"

