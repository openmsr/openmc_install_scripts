################################################################################
#embree source install
################################################################################
#!/bin/bash
set -ex

WD=`pwd`
name=`basename $0`

#check if there is a .done file indicating that we have already built this target
if [ ! -e ${name}.done ]; then
  #check dependencies
  sudo pacman -Syu --noconfirm \
	gcc \
	make \
	cmake \
	glfw \
	python-numpy \
	tbb \
	openimageio

  #Should we run make in parallel? Default is yo use all available cores
  ccores=`cat /proc/cpuinfo |grep CPU|wc -l`
  if [ "x$1" != "x" ]; then
	ccores=$1
  fi

  #run actual install process
  mkdir -p $HOME/openmc/embree
  cd $HOME/openmc/embree
  git clone --single-branch --branch v3.13.3 --depth 1 https://github.com/embree/embree.git
  mkdir -p build
  cd build
  cmake ../embree -DCMAKE_INSTALL_PREFIX=/opt/embree\
              -DEMBREE_ISPC_SUPPORT=OFF\
              -DEMBREE_TUTORIALS=OFF
  make -j ${ccores}
  sudo make install
  cd ${WD}
  #touch a lock file to avoid uneccessary rebuilds
  touch ${name}.done
else
  echo embree appears to be already installed \(lock file ${name}.done exists\) - skipping.
fi
