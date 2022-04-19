###############################################################################
#moab souce install
################################################################################
#!/bin/bash
set -ex

WD=`pwd`
name=`basename $0`
package_name='MOAB'

#check if there is a .done file indicating that we have already built this target
if [ ! -e ${name}.done ]; then

  sudo pacman -Syu --noconfirm \
	eigen \
	netcdf \
	hdf5 \
    python-setuptools \
	cython

  cd $HOME/openmc
  mkdir MOAB
  cd MOAB
  git clone  --single-branch --branch 5.3.0 --depth 1 https://bitbucket.org/fathomteam/moab.git
  mkdir build
  cd build
  cmake ../moab -DENABLE_HDF5=ON \
              -DENABLE_NETCDF=ON \
              -DENABLE_FORTRAN=OFF \
              -DENABLE_BLASLAPACK=OFF \
              -DBUILD_SHARED_LIBS=ON \
              -DCMAKE_INSTALL_PREFIX=$HOME/openmc/MOAB
  sudo make -j ${ccores}
  sudo make install
  cmake ../moab -DENABLE_HDF5=ON \
              -DENABLE_PYMOAB=ON \
              -DENABLE_FORTRAN=OFF \
              -DBUILD_SHARED_LIBS=ON \
              -DENABLE_BLASLAPACK=OFF \
              -DCMAKE_INSTALL_PREFIX=$HOME/openmc/MOAB
  sudo make install
  cd pymoab
  sudo bash install.sh
  sudo python setup.py install

  cd ${WD}
  #touch a lock file to avoid uneccessary rebuilds
  touch ${name}.done
else
  echo ${package_name} appears to be already installed \(lock file ${name}.done exists\) - skipping.
fi
