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

echo will install to $LOCAL_INSTALL_PREFIX

#check if there is a .done file indicating that we have already built this target
if [ ! -e ${name}.done ]; then

  sudo apt-get install --yes gcc\
	cmake\
	make\
	build-essential\
	libeigen3-dev \
        libnetcdf-dev \
	libnetcdf18\
        libnetcdf-mpi-dev\
	libnetcdf-mpi-18\
	python3-netcdf4 \
        libhdf5-103 \
        libhdf5-cpp-103 \
        libhdf5-dev \
        python3-setuptools\
	cython3
  #Should we run make in parallel? Default is to use all available cores
  ccores=`cat /proc/cpuinfo |grep CPU|wc -l`
  if [ "x$1" != "x" ]; then
	ccores=$1
  fi

  mkdir -p $HOME/openmc/MOAB
  cd $HOME/openmc/MOAB
  if [ ! -e moab ]; then
    git clone --single-branch --branch 5.4.1 --depth 1 https://bitbucket.org/fathomteam/moab.git
  else
    cd moab
    git pull
    cd ..
  fi
  mkdir -p build
  cd build
  cmake ../moab -DENABLE_HDF5=ON \
              -DENABLE_PYMOAB=ON \
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
  echo ${package_name} appears to be already installed \(lock file ${name}.done exists\) - skipping.
fi
