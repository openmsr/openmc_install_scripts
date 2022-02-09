################################################################################
#nuclear data download & extract
################################################################################
#!/bin/bash
set -ex

echo "export OPENMC_CROSS_SECTIONS=$HOME/openmc/nuclear_data/endfb71_hdf5/cross_sections.xml" >> $HOME/.bashrc
#source $HOME/.bashrc

#default libraries
endfb_VII="https://anl.box.com/shared/static/d359skd2w6wrm86om2997a1bxgigc8pu.xz"
endfb_VIII="https://anl.box.com/shared/static/nd7p4jherolkx4b1rfaw5uqp58nxtstr.xz"
jeff="https://anl.box.com/shared/static/ddetxzp0gv1buk1ev67b8ynik7f268hw.xz"

mkdir -p $HOME/openmc/nuclear_data
cd $HOME/openmc/nuclear_data

#see other default options above
wget $endfb_VII

for entry in "$PWD"/*
do
  tar -xvf $entry
done
