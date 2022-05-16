###############################################################################
#moab souce install
################################################################################
#!/bin/bash
set -ex

WD=`pwd`
name=`basename $0`
package_name='MOAB'

install_prefix="/opt"

#check if there is a .done file indicating that we have already built this target
if [ ! -e ${name}.done ]; then

  sudo pacman -Syu --noconfirm \
	eigen \
	netcdf \
	hdf5 \
        python-setuptools \
	cython

  #Should we run make in parallel? Default is to use all available cores
  ccores=`cat /proc/cpuinfo |grep CPU|wc -l`
  if [ "x$1" != "x" ]; then
	ccores=$1
  fi

  mkdir -p $HOME/openmc/MOAB
  cd $HOME/openmc/MOAB
  git clone --single-branch --branch 5.3.1 --depth 1 https://bitbucket.org/fathomteam/moab.git
  mkdir -p build
  cd build
  cmake ../moab -DENABLE_HDF5=ON \
              -DCMAKE_BUILS_TYPE=Debug\
	      -DENABLE_PYMOAB=ON \
              -DENABLE_FORTRAN=OFF \
              -DBUILD_SHARED_LIBS=ON \
              -DENABLE_BLASLAPACK=OFF \
              -DCMAKE_INSTALL_PREFIX=${install_prefix}/MOAB
  make -j ${ccores}
  sudo make install

  #to install the python API
  cd pymoab
  sudo bash install.sh
  sudo python setup.py install

  cd ${WD}
  touch ${name}.done
else
  echo ${package_name} appears to be already installed \(lock file ${name}.done exists\) - skipping.
fi
