#!/bin/bash
set -ex

#install needed base-devel software & turn off install confirms
#echo 'Defaults    timestamp_timeout=-1' | sudo EDITOR='tee -a' visudo
sudo pacman -Syy --ignore sudo --needed base-devel

# Compile MOAB package and install it
cd MOAB-PKGBUILD
makepkg --noconfirm -cs -g >> PKGBUILD && makepkg
sudo pacman -U ./moab*
cd ..
echo "compiled & installed MOAB, proceeding..."

# Compile Embree package and install it
cd EMBREE-PKGBUILD
makepkg --noconfirm -cs
sudo pacman -U ./embree*
cd ..
echo "compiled & installed Embree, proceeding..."

# Compile double-down package and install it
cd DOUBLE-DOWN-PKGBUILD
makepkg --noconfirm -cs
sudo pacman -U ./double-down*
cd ..
echo "compiled & installed double-down, proceeding..."

# Compile DAGMC package and install it
cd DAGMC-PKGBUILD
makepkg --noconfirm -cs
sudo pacman -U ./dagmc*
cd ..
echo "compiled & installed DAGMC, proceeding..."

# Compile OpenMC package and install it
cd NUCLEAR-DATA-PKGBUILD
makepkg --noconfirm -cs
sudo pacman -U ./nuclear-data*
cd ..
echo "nuclear data downloaded , proceeding..."

# Compile OpenMC package and install it
cd OPENMC-PKGBUILD
makepkg --noconfirm -cs
sudo pacman -U ./openmc*
cd ..

#reset sudoers file
#sudo sed '$d' -i /etc/sudoers

echo "compiled & installed OpenMC, finised!"
