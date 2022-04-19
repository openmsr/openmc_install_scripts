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
	cmake\
	make\
	build-essential\
	libeigen3-dev \
        libnetcdf-dev \
	libnetcdf15\
        libnetcdf-mpi-dev\
	libnetcdf-mpi-13\
	python3-netcdf4 \
        libhdf5-103 \
        libhdf5-cpp-103 \
        libhdf5-dev \
        python3-setuptools\
	cython3

#if there is a .done-file then skip this step
if [ ! -e $0.done ]; then

  touch ${0}.done

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
              -DENABLE_PYMOAB=ON \
              -DCMAKE_INSTALL_PREFIX=$HOME/openmc/MOAB
  make  -j $ccores
  make install 
  cd pymoab
  bash install.sh
  sudo python3 setup.py install
else
   name=`basename $0`
   echo MOAB appears to already be installed \(lock file ${name}.done exists\) - skipping.
fi
