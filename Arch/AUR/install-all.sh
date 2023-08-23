#!/bin/bash

#install needed base-devel software & turn off install confirms
find /var/cache/pacman/pkg/ -iname "*.part" -delete
#sudo pacman -Syyu --ignore sudo --needed base-devel

echo 'Defaults    timestamp_timeout=-1' | sudo EDITOR='tee -a' visudo

# Download the nuclear data
if [ ! -e ./NUCLEAR-DATA-PKGBUILD/*.tar.zst ]; then
    cd NUCLEAR-DATA-PKGBUILD
    makepkg --noconfirm -si #>> PKGBUILD && makepkg
    cd ..
    echo "nuclear data downloaded , proceeding..."
else
    echo "nuclear data already installed, proceeding..."
fi

# Compile CAD_to_OpenMC and install it
if [ ! -e ./CAD_TO_OPENMC-PKGBUILD/*.tar.zst ]; then
    cd CAD_TO_OPENMC-PKGBUILD
    makepkg --noconfirm -si #>> PKGBUILD && makepkg
    cd ..
    echo "CAD_to_OpenMC downloaded , proceeding..."
else
    echo "CAD_to_OpenMC already installed, proceeding..."
fi

# Compile MOAB package and install it
if [ ! -e ./MOAB-PKGBUILD/*.tar.zst ]; then
    cd MOAB-PKGBUILD
    makepkg --noconfirm -si #>> PKGBUILD && makepkg
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
    makepkg --noconfirm -si #>> PKGBUILD && makepkg
    cd ..
    echo "compiled & installed double-down, proceeding..."
else
    echo "double-down already installed, proceeding..."
fi

# Compile DAGMC package and install it
if [ ! -e ./DAGMC-PKGBUILD/*.tar.zst ]; then
    cd DAGMC-PKGBUILD
    makepkg --noconfirm -si #>> PKGBUILD && makepkg
    cd ..
    echo "compiled & installed DAGMC, proceeding..."
else
    echo "dagmc already installed, proceeding..."
fi

# Compile OpenMC package and install it
if [ ! -e ./OPENMC-PKGBUILD/*.tar.zst ]; then
    cd OPENMC-PKGBUILD
    makepkg --noconfirm -si #>> PKGBUILD && makepkg
    cd ..
    echo "compiled & installed OpenMC, finised!"
else
    echo "openmc already installed"
fi

echo "testing installation..."
bash test_install.sh

sudo sed -i '/Defaults    timestamp_timeout=-1/d' /etc/sudoers