#!/bin/bash
set -ex

# Compile MOAB package and install it
cd MOAB-PKGBUILD
makepkg -c
sudo pacman -U ./moab*
cd ..
echo "compiled & installed MOAB, proceeding..."

# Compile Embree package and install it
cd EMBREE-PKGBUILD
makepkg -c
sudo pacman -U ./embree*
cd ..
echo "compiled & installed Embree, proceeding..."

# Compile double-down package and install it
cd DOUBLE-DOWN-PKGBUILD
makepkg -c
sudo pacman -U ./double-down*
cd ..
echo "compiled & installed double-down, proceeding..."

# Compile DAGMC package and install it
cd DAGMC-PKGBUILD
makepkg -c
sudo pacman -U ./dagmc*
cd ..
echo "compiled & installed DAGMC, proceeding..."

# Compile OpenMC package and install it
cd NUCLEAR-DATA-PKGBUILD
makepkg -c
sudo pacman -U ./nuclear-data*
cd ..
echo "nuclear data downloaded , proceeding..."

# Compile OpenMC package and install it
cd OPENMC-PKGBUILD
makepkg -c
sudo pacman -U ./openmc*
cd ..
echo "compiled & installed OpenMC, finised!"
