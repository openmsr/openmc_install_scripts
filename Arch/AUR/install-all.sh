#!/bin/bash

#install needed base-devel software & turn off install confirms
find /var/cache/pacman/pkg/ -iname "*.part" -delete
#sudo pacman -Syyu --ignore sudo --needed base-devel

# Compile MOAB package and install it
if [ ! -e ./MOAB-PKGBUILD/*.tar.zst ]; then
    cd MOAB-PKGBUILD
    makepkg --noconfirm -csgi >> PKGBUILD && makepkg
    cd ..
    echo "compiled & installed MOAB, proceeding..."
else
    echo "moab already installed, proceeding..."
fi

# embree is now available via pacman
# Compile Embree package and install it
#cd EMBREE-PKGBUILD
#makepkg --noconfirm -csgi >> PKGBUILD && makepkg
#cd ..
#echo "compiled & installed Embree, proceeding..."

# Compile double-down package and install it
if [ ! -e ./DOUBLE-DOWN-PKGBUILD/*.tar.zst ]; then
    cd DOUBLE-DOWN-PKGBUILD
    makepkg --noconfirm -csgi >> PKGBUILD && makepkg
    cd ..
    echo "compiled & installed double-down, proceeding..."
else
    echo "double-down already installed, proceeding..."
fi

# Compile DAGMC package and install it
if [ ! -e ./DAGMC-PKGBUILD/*.tar.zst ]; then
    cd DAGMC-PKGBUILD
    makepkg --noconfirm -csgi >> PKGBUILD && makepkg
    cd ..
    echo "compiled & installed DAGMC, proceeding..."
else
    echo "dagmc already installed, proceeding..."
fi

# Download the nuclear data
if [ ! -e ./NUCLEAR-DATA-PKGBUILD/*.tar.zst ]; then
    cd NUCLEAR-DATA-PKGBUILD
    makepkg --noconfirm -csgi >> PKGBUILD && makepkg
    cd ..
    echo "nuclear data downloaded , proceeding..."
else
    echo "nuclear data already installed, proceeding..."
fi

# Compile OpenMC package and install it
if [ ! -e ./OPENMC-PKGBUILD/*.tar.zst ]; then
    cd OPENMC-PKGBUILD
    makepkg --noconfirm -csgi >> PKGBUILD && makepkg
    cd ..
    echo "compiled & installed OpenMC, finised!"
else
    echo "openmc already installed"
fi
