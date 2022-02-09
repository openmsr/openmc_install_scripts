###############################################################################
#moab souce install
################################################################################
#!/bin/bash
set -ex

sudo apt-get --yes install libeigen3-dev \
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
if [ ! -e $0.done ]; then

  touch ${0}.done

  cd $HOME/openmc
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
              -DENABLE_PYMOAB=ON \
              -DCMAKE_INSTALL_PREFIX=$HOME/openmc/MOAB
  make
  make install 
  cd pymoab
  bash install.sh
  sudo python setup.py install
else
   name=`basename $0`
   echo MOAB appears to already be installed \(lock file ${name}.done exists\) - skipping.
fi
