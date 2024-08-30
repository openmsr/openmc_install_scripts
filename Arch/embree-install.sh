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

#check if there is a .done file indicating that we have already built this target
if [ ! -e ${name}.done ]; then
  #check dependencies
  sudo pacman -Sy --noconfirm \
	gcc \
	make \
	cmake \
	glfw \
	python-numpy \
	tbb \
	openimageio

#if there is a .done-file then skip this step
if [ ! -e $0.done ]; then
   cd $HOME
   mkdir -p openmc
   cd openmc
   mkdir -p embree
   cd embree
   git clone --single-branch --branch v3.13.3 --depth 1 https://github.com/embree/embree.git
   mkdir build
   cd build
   cmake ../embree -DCMAKE_INSTALL_PREFIX=$HOME/openmc/embree \
                -DEMBREE_ISPC_SUPPORT=OFF \
	        -DEMBREE_TUTORIALS=OFF \
                -DEMBREE_MAX_ISA=NONE
   make -j $ccores
   sudo make install
   rm -rf embree/build embree/embree

   cd ${WD}
   touch ${0}.done
else
   name=`basename $0`
   echo embree appears to already be installed \(lock file ${name}.done exists\) - skipping.
fi
