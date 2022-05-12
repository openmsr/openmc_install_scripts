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

WD=`pwd`
name=`basename $0`

#if there is a .done-file then skip this step
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

  cd $HOME
  mkdir -p openmc
  cd openmc
  mkdir -p MOAB
  cd MOAB
  git clone  --single-branch --branch 5.3.1 --depth 1 https://bitbucket.org/fathomteam/moab.git
  mkdir -p build
  cd build
  cmake ../moab -DENABLE_HDF5=ON \
              -DENABLE_NETCDF=ON \
              -DENABLE_FORTRAN=OFF \
              -DENABLE_BLASLAPACK=OFF \
              -DBUILD_SHARED_LIBS=ON \
              -DENABLE_PYMOAB=OFF \
              -DCMAKE_INSTALL_PREFIX=$HOME/openmc/MOAB
  make -j $ccores
  make install

  #cd pymoab
  #bash install.sh
  #sudo python3 setup.py install

  cd $WD

  touch ${name}.done
else
  echo MOAB appears to be already installed \(lock file ${name}.done exists\) - skipping.
fi
