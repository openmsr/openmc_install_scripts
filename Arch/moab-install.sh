###############################################################################
#moab souce install
################################################################################
#!/bin/bash
set -ex

sudo pacman -Syu --noconfirm \
	eigen \
	netcdf \
	hdf5 \
    python-setuptools \
	cython

cd /opt
mkdir MOAB
cd MOAB
git clone  --single-branch --branch 5.3.0 --depth 1 https://bitbucket.org/fathomteam/moab.git
mkdir build
cd build
export PYTHONPATH=/opt/openmc/MOAB/lib/python3.10/site-packages/:$PYTHONPATH
cmake ../moab -DENABLE_HDF5=ON \
              -DENABLE_NETCDF=ON \
              -DENABLE_FORTRAN=OFF \
              -DENABLE_BLASLAPACK=OFF \
              -DBUILD_SHARED_LIBS=ON \
              -DCMAKE_INSTALL_PREFIX=/opt/MOAB
sudo make
sudo make install
cmake ../moab -DENABLE_HDF5=ON \
              -DENABLE_PYMOAB=ON \
              -DENABLE_FORTRAN=OFF \
              -DBUILD_SHARED_LIBS=ON \
              -DENABLE_BLASLAPACK=OFF \
              -DCMAKE_INSTALL_PREFIX=/opt/MOAB
sudo make install
cd pymoab
bash install.sh
sudo python setup.py install
