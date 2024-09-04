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

install_prefix="/usr/local/lib"
if [ "x" != "x$LOCAL_INSTALL_PREFIX" ]; then
  install_prefix=$LOCAL_INSTALL_PREFIX
fi
build_prefix="$HOME"
if [ "x" != "x$OPENMC_BUILD_PREFIX" ]; then
  build_prefix=$OPENMC_BUILD_PREFIX
fi

build_type="Release"
if [ "xON" = "x$DEBUG_BUILD" ]; then
    build_type="Debug"
fi

#if there is a .done-file then skip this step
if [ ! -e ${name}.done ]; then

  sudo apt-get install --yes python3

  #Should we run make in parallel? Default is to use all available cores
  ccores=`cat /proc/cpuinfo |grep processor|wc -l`
  if [ "x$1" != "x" ]; then
	ccores=$1
  fi

  mkdir -p ${build_prefix}/openmc/DAGMC
  cd ${build_prefix}/openmc/DAGMC
  if [ ! -e DAGMC ]; then
    git clone --single-branch --branch develop --depth 1 https://github.com/svalinn/DAGMC.git
  else
    cd DAGMC; git pull; cd ..
  fi

  for patch in `ls ${WD}/../patches/dagmc_*.patch`; do
    patch -p1 < $patch
  done

  mkdir -p build
  cd build
  cmake ../DAGMC -DBUILD_TALLY=ON \
               -DMOAB_DIR=${install_prefix}\
               -DDOUBLE_DOWN=ON\
               -DBUILD_STATIC_EXE=OFF\
               -DBUILD_STATIC_LIBS=OFF\
               -DCMAKE_INSTALL_PREFIX=${install_prefix}\
               -DCMAKE_BUILD_TYPE=${build_type}\
               -DDOUBLE_DOWN_DIR=${install_prefix}
  make -j ${ccores}
  make install

  cd ${WD}
  touch ${name}.done
else
  echo ${package_name} appears already to be installed \(lock file ${name}.done exists\) - skipping.
fi
