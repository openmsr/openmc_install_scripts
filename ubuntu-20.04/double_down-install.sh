################################################################################
#double-down source install
################################################################################
#!/bin/bash
set -ex

#embree compile & install
#./embree-install.sh
#echo "Compiled & installed embree, proceeding..."

#moab compile & install
./moab-install.sh
echo "Compiled & installed moab, proceeding..."

WD=`pwd`
name=`basename $0`
package_name='double_down'

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
#check if there is a .done file indicating that we have already built this target
sudo apt-get install --yes doxygen\
        libembree3-3 libembree-dev


#if there is a .done-file then skip this step
if [ ! -e ${name}.done ]; then
  sudo apt-get install --yes doxygen\
        libembree3-3 libembree-dev

  #Should we run make in parallel? Default is to use all available cores
  ccores=`cat /proc/cpuinfo |grep CPU|wc -l`
  if [ "x$1" != "x" ]; then
	ccores=$1
  fi

  mkdir -p ${build_prefix}/openmc/double-down
  cd ${build_prefix}/openmc/double-down
  if [ ! -d double-down ]; then
	  git clone --single-branch --branch v1.1.0 --depth 1 https://github.com/pshriwise/double-down.git
  fi


  # These bits are hacks to get things working on older ubuntu
  # needed because the binary packages dont include .cmake-configs.
  cd double-down
  patches=`ls ${WD}/../patches/double_down_002.patch`
  for pat in ${patches}; do
    echo applying $pat
    patch -p1 < $pat
  done

  mkdir -p cmake
  cp ${WD}/../patches/Findembree.cmake cmake
  cd ..

  mkdir -p build
  cd build
  cmake ../double-down -DMOAB_DIR=${install_prefix}\
            -DCMAKE_BUILD_TYPE=${build_type}\
            -DCMAKE_INSTALL_PREFIX=${install_prefix}
  make -j $ccores
  make install

  cd ${WD}
  touch ${name}.done
else
  echo double-down appears to be already installed \(lock file ${name}.done exists\) - skipping.
fi
