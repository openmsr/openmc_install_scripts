################################################################################
#embree source install
################################################################################
#!/bin/bash
set -ex

#check if there is a .done file indicating that we have already built this target
if [ ! -e $0.done ]; then
  #check dependencies
  sudo pacman -Syu --noconfirm \
	gcc \
	make \
	cmake \
	glfw \
	python-numpy \
	tbb \
	openimageio

cd $HOME
mkdir openmc
cd openmc
mkdir embree
cd embree
git clone --single-branch --branch v3.13.2 --depth 1 https://github.com/embree/embree.git
mkdir build
cd build
cmake ../embree -DCMAKE_INSTALL_PREFIX=$HOME/openmc/embree \
                -DEMBREE_ISPC_SUPPORT=OFF
  make -j ${ccores}
  sudo make install

  #touch a lock file to avoid uneccessary rebuilds
  touch ${name}.done
else
  name=`basename $0`
  echo embree appears to be already installed \(lock file ${name}.done exists\) - skipping.
fi
