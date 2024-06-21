################################################################################
#dagmc source install
################################################################################
#!/bin/bash
set -ex

#double-down compile & install
./double_down-install.sh
echo "Compiled & installed double-down, proceeding..."

sudo apt-get install --yes python

#if there is a .done-file then skip this step
if [ ! -e $0.done ]; then

  cd $HOME/openmc
  mkdir DAGMC
  cd DAGMC
  git clone --single-branch --branch develop --depth 1 https://github.com/svalinn/DAGMC.git
  mkdir build
  cd build
  cmake ../DAGMC -DBUILD_TALLY=ON \
               -DCMAKE_BUILD_TYPE=Debug\
               -DMOAB_DIR=$HOME/openmc/MOAB \
               -DDOUBLE_DOWN=ON \
               -DBUILD_STATIC_EXE=OFF \
               -DBUILD_STATIC_LIBS=OFF \
               -DCMAKE_INSTALL_PREFIX=$HOME/openmc/DAGMC/ \
               -DDOUBLE_DOWN_DIR=$HOME/openmc/double-down
  make install
  cd ../..
  rm -rf DAGMC/DAGMC /DAGMC/build

  touch ${0}.done
else
   name=`basename $0`
   echo DAGMC appears to already be installed \(lock file ${name}.done exists\) - skipping.
fi
  
