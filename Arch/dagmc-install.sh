################################################################################
#dagmc source install
################################################################################
#!/bin/bash
set -ex

#double-down compile & install
./double_down-install.sh
echo "Compiled & installed double-down, proceeding..."

WD=`pwd`
name=`basename $0`
package_name='dagmc'

install_prefix="/opt"
build_prefix="$HOME/openmc"

#if there is a .done-file then skip this step
if [ ! -e ${name}.done ]; then
  sudo pacman -Syu python

  #Should we run make in parallel? Default is to use all available cores
  ccores=`cat /proc/cpuinfo |grep CPU|wc -l`
  if [ "x$1" != "x" ]; then
	ccores=$1
  fi
  

  mkdir -p $HOME/openmc/DAGMC
  cd $HOME/openmc/DAGMC
  git clone --single-branch --branch develop --depth 1 https://github.com/svalinn/DAGMC.git
  mkdir build
  cd build
  cmake ../DAGMC -DBUILD_TALLY=ON \
               -DMOAB_DIR=${install_prefix}/MOAB\
               -DDOUBLE_DOWN=ON\
               -DBUILD_STATIC_EXE=OFF\
               -DBUILD_STATIC_LIBS=OFF\
               -DCMAKE_INSTALL_PREFIX=${install_prefix}/DAGMC/ \
               -DDOUBLE_DOWN_DIR=${install_prefix}/double-down
  make -j $ccores
  sudo make install

  cd ${WD}
  touch ${name}.done
else
  echo DAGMC appears already to be installed \(lock file ${name}.done exists\) - skipping.
fi
