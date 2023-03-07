###############################################################################
#moab souce install
################################################################################
#!/bin/bash
set -ex
if [ "x" == "$1x" ]; then
	ccores=1
else
	ccores=$1
fi

sudo apt-get install --yes gcc\
	libeigen3-dev \
        python3-netcdf4 \
        libhdf5-103 \
        libhdf5-cpp-103 \
        libnetcdf13\
        libnetcdf-dev\
        libnetcdf-mpi-13\
        libnetcdf-mpi-dev\
        libhdf5-dev \
        cython

#if there is a .done-file then skip this step
PWD=`pwd`
if [ ! -e $0.done ]; then

  cd $HOME
  mkdir -p openmc
  cd openmc
  mkdir -p MOAB
  cd MOAB
  git clone  --single-branch --branch 5.3.0 --depth 1 https://bitbucket.org/fathomteam/moab.git
  mkdir -p build
  cd build
  cmake ../moab -DENABLE_HDF5=ON \
              -DENABLE_NETCDF=ON \
              -DENABLE_FORTRAN=OFF \
              -DENABLE_BLASLAPACK=OFF \
              -DBUILD_SHARED_LIBS=ON \
              -DENABLE_PYMOAB=OFF \
              -DCMAKE_INSTALL_PREFIX=$HOME/openmc/MOAB
  make  -j $ccores
  make install 
  cd pymoab
  bash install.sh
  sudo python3 setup.py install
  
  touch i${PWD}/${0}.done

else
   name=`basename $0`
   echo MOAB appears to already be installed \(lock file ${name}.done exists\) - skipping.
fi
