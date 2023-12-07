###############################################################################
#moab source install
################################################################################
#!/bin/bash
set -ex

WD=`pwd`
name=`basename $0`
package_name='MOAB'

install_prefix="/opt"
if [ "x" != "x$LOCAL_INSTALL_PREFIX" ]; then
  install_prefix=$LOCAL_INSTALL_PREFIX
fi
build_prefix="$HOME/openmc"
if [ "x" != "x$OPENMC_BUILD_PREFIX" ]; then
  build_prefix=$OPENMC_BUILD_PREFIX
fi

echo will install to $LOCAL_INSTALL_PREFIX

#check if there is a .done file indicating that we have already built this target
if [ ! -e ${name}.done ]; then
  if ! pacman -Qi eigen netcdf hdf5-openmpi python-setuptools cython; then
    sudo pacman -Sy --noconfirm \
	eigen \
	netcdf \
	hdf5-openmpi \
        python-setuptools \
	cython
  fi
  #Should we run make in parallel? Default is to use all available cores
  ccores=`cat /proc/cpuinfo |grep CPU|wc -l`
  if [ "x$1" != "x" ]; then
	ccores=$1
  fi

  mkdir -p ${build_prefix}/openmc/MOAB
  cd ${build_prefix}/openmc/MOAB
  if [ ! -e moab ]; then
    git clone --single-branch --branch 5.5.1 --depth 1 https://bitbucket.org/fathomteam/moab.git
  else
    cd moab
    git pull
    cd ..
  fi
  mkdir -p build
  cd build
  cmake ../moab -DENABLE_HDF5=ON \
              -DCMAKE_BUILD_TYPE=Debug\
              -DENABLE_NETCDF=ON \
	      -DENABLE_PYMOAB=ON \
              -DENABLE_FORTRAN=OFF \
              -DBUILD_SHARED_LIBS=ON \
              -DENABLE_BLASLAPACK=OFF \
              -DCMAKE_INSTALL_PREFIX=${install_prefix}
  make -j ${ccores}
  make install

  #to install the python API
  cd pymoab
  bash install.sh

  cd ${WD}
  touch ${name}.done
else
  echo ${package_name} appears already to be installed \(lock file ${name}.done exists\) - skipping.
fi
