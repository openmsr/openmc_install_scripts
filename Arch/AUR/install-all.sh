#!/bin/bash
set -ex

#install needed base-devel software & turn off install confirms
sudo pacman -Syy --ignore sudo --needed base-devel

# Compile MOAB package and install it
cd MOAB-PKGBUILD
makepkg --noconfirm -csgi >> PKGBUILD && makepkg
cd ..
echo "compiled & installed MOAB, proceeding..."

# Compile Embree package and install it
cd EMBREE-PKGBUILD
sudo pacman -Syy --noconfirm tbb openimageio
makepkg --noconfirm -csgi >> PKGBUILD && makepkg
cd ..
echo "compiled & installed Embree, proceeding..."

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

# Compile OpenMC package and install it
cd NUCLEAR-DATA-PKGBUILD
makepkg --noconfirm -csgi >> PKGBUILD && makepkg
cd ..
echo "nuclear data downloaded , proceeding..."

# Compile OpenMC package and install it
cd OPENMC-PKGBUILD
makepkg --noconfirm -csgi >> PKGBUILD && makepkg
cd ..

echo "compiled & installed OpenMC, finised!"
