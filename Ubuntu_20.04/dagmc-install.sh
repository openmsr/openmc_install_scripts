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

#if there is a .done-file then skip this step
if [ ! -e ${name}.done ]; then

  sudo apt-get install --yes python3

  #Should we run make in parallel? Default is to use all available cores
  ccores=`cat /proc/cpuinfo |grep CPU|wc -l`
  if [ "x$1" != "x" ]; then
	ccores=$1
  fi

  mkdir -p $HOME/openmc/DAGMC
  cd $HOME/openmc/DAGMC
  if [ ! -e DAGMC ]; then
    git clone https://github.com/svalinn/DAGMC.git
  else
    cd DAGMC; git pull; cd ..
  fi

  for patch in `ls ${pwd}/../patches/dagmc_.patch`; do
    patch -p1 < $patch
  done

  mkdir -p build
  cd build
  cmake ../DAGMC -DBUILD_TALLY=ON \
               -DMOAB_DIR=$HOME/openmc/MOAB \
               -DDOUBLE_DOWN=ON \
               -DBUILD_STATIC_EXE=OFF \
               -DBUILD_STATIC_LIBS=OFF \
               -DCMAKE_INSTALL_PREFIX=$HOME/openmc/DAGMC/ \
               -DDOUBLE_DOWN_DIR=$HOME/openmc/double-down
  make -j $ccores
  make install

  cd ${WD}
  touch ${name}.done
else
  echo DAGMC appears already to be installed \(lock file ${name}.done exists\) - skipping.
fi
