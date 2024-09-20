################################################################################
#embree source install
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
package_name='embree'

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
if [ ! -e $0.done ]; then

  #Should we run make in parallel? Default is to use all available cores
  ccores=`cat /proc/cpuinfo |grep processor|wc -l`
  if [ "x$1" != "x" ]; then
	ccores=$1
  fi

  mkdir -p ${build_prefix}/openmc/embree
  cd ${build_prefix}/openmc/embree
  if [ ! -d embree ]; then
    git clone --single-branch --branch v3.13.3 --depth 1 https://github.com/embree/embree.git
  fi
  mkdir -p build
  cd build
  cmake ../embree -DCMAKE_INSTALL_PREFIX=${install_prefix}\
            -DCMAKE_BUILD_TYPE=${build_type}\
            -DEMBREE_ISPC_SUPPORT=OFF\
	    -DEMBREE_TUTORIALS=OFF\
            -DEMBREE_MAX_ISA=NONE
  make -j ${ccores}
  make install

  cd ${WD}
  touch ${name}.done
else
  echo embree appears to already be installed \(lock file ${name}.done exists\) - skipping.
fi
