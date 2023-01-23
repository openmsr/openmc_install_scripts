###############################################################################
#moab source install
################################################################################
#!/bin/bash
set -ex

WD=`pwd`
name=`basename $0`
package_name='MOAB'

#if there is a .done-file then skip this step
if [ ! -e ${name}.done ]; then

  sudo apt-get install --yes gcc\
	cmake\
	make\
	build-essential\
	libeigen3-dev \
        libnetcdf-dev \
	libnetcdf19\
        libnetcdf-mpi-dev\
	libnetcdf-mpi-19\
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
    git clone --single-branch --branch 5.3.1 --depth 1 https://bitbucket.org/fathomteam/moab.git
  else
    cd moab && \
    git checkout 5.3.1 && \
    git fetch && \
    git pull && \
    cd ..
  fi

  if [ ! -e build ]; then
    mkdir -p build
  fi

  cd build
  cmake ../moab -DENABLE_HDF5=ON \
              -DENABLE_NETCDF=ON \
              -DENABLE_FORTRAN=OFF \
              -DENABLE_BLASLAPACK=OFF \
              -DBUILD_SHARED_LIBS=ON \
              -DENABLE_PYMOAB=ON \
              -DCMAKE_INSTALL_PREFIX=$HOME/openmc/MOAB
  make -j $ccores
  make install

  #cd pymoab
  #bash install.sh
  #sudo python3 setup.py install

  cd ${WD}
  touch ${name}.done
else
  echo MOAB appears to be already installed \(lock file ${name}.done exists\) - skipping.
fi
