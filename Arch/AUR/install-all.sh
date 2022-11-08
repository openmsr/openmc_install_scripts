#!/bin/bash
set -ex

#install needed base-devel software & turn off install confirms
find /var/cache/pacman/pkg/ -iname "*.part" -delete
#sudo pacman -Syyu --ignore sudo --needed base-devel

# Compile MOAB package and install it
cd MOAB-PKGBUILD
makepkg --noconfirm -csgi >> PKGBUILD && makepkg
cd ..
echo "compiled & installed MOAB, proceeding..."

# embree is now available via pacman
# Compile Embree package and install it
#cd EMBREE-PKGBUILD
#makepkg --noconfirm -csgi >> PKGBUILD && makepkg
#cd ..
#echo "compiled & installed Embree, proceeding..."

# Compile double-down package and install it
cd DOUBLE-DOWN-PKGBUILD
makepkg --noconfirm -csgi >> PKGBUILD && makepkg
cd ..
echo "compiled & installed double-down, proceeding..."

# Compile DAGMC package and install it
cd DAGMC-PKGBUILD
makepkg --noconfirm -csgi >> PKGBUILD && makepkg
cd ..
echo "compiled & installed DAGMC, proceeding..."

# Download the nuclear data
cd NUCLEAR-DATA-PKGBUILD
makepkg --noconfirm -csgi >> PKGBUILD && makepkg
cd ..
echo "nuclear data downloaded , proceeding..."

# Compile OpenMC package and install it
cd OPENMC-PKGBUILD
makepkg --noconfirm -csgi >> PKGBUILD && makepkg
cd ..
echo "compiled & installed OpenMC, finised!"
python test_openmc.py
