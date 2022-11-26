################################################################################
#CAD_to_openMC install
################################################################################
#!/bin/bash
set -ex

WD=`pwd`
name=`basename $0`
package_name='CAD_to_openMC'

#install_prefix="/opt"
#build_prefix="$HOME/openmc"

#if there is a .done-file then skip this step
if [ ! -e ${name}.done ]; then
  mkdir -p $HOME/openmc
  cd $HOME/openmc
  if [ ! -e CAD_to_openMC ]; then
    git clone https://github.com/openmsr/CAD_to_openMC.git
  else
    cd CAD_to_openMC
    git fetch
    git pull
    cd ..
  fi
  cd ${WD}
  touch ${name}.done
else
  echo CAD_to_openMC appears already to be installed \(lock file ${name}.done exists\) - skipping.
fi
