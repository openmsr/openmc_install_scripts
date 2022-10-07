################################################################################
#nuclear data download & extract
################################################################################
#!/bin/bash
set -ex

echo "export OPENMC_CROSS_SECTIONS=$HOME/openmc/nuclear_data/endfb80_hdf5/cross_sections.xml" >> $HOME/.bashrc
source $HOME/.bashrc

sudo pacman -Sy --noconfirm wget

#defaul libraries
endfb_VII="https://anl.box.com/shared/static/9igk353zpy8fn9ttvtrqgzvw1vtejoz6.xz"
endfb_VIII="https://anl.box.com/shared/static/uhbxlrx7hvxqw27psymfbhi7bx7s6u6a.xz"
jeff="https://anl.box.com/shared/static/4jwkvrr9pxlruuihcrgti75zde6g7bum.xz"

cd /opt
sudo mkdir -p nuclear_data
cd nuclear_data

#see other default options above
sudo wget $endfb_VIII

for entry in "$PWD"/*
do
  sudo tar -xvf $entry
done
