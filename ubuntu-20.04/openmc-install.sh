################################################################################
#openmc source install
################################################################################
#!/bin/bash
set -ex

#nuclear_data_download
#./nuclear_data-install.sh
#echo "Downloaded & extracted nuclear data, proceeding..."
  
#dagmc compile & install
./dagmc-install.sh
echo "Compiled & installed dagmc, proceeding..."

WD=`pwd`
name=`basename $0`
#if there is a .done-file then skip this step
if [ ! -e ${name}.done ]; then
  sudo apt-get install --yes libpng-dev libpng++-dev\
	imagemagick\
	python3-lxml\
        python3-scipy\
        python3-pandas\
        python3-h5py\
        python3-matplotlib\
        python3-uncertainties

  #Should we run make in parallel? Default is to use all available cores
  ccores=`cat /proc/cpuinfo |grep CPU|wc -l`
  if [ "x$1" != "x" ]; then
	ccores=$1
  fi

  #source install
  mkdir -p $HOME/openmc
  cd $HOME/openmc
  if [ -e openmc ]; then
        cd openmc
        git pull --recurse-submodules
  else
        git clone --recurse-submodules --single-branch --branch develop --depth 1 https://github.com/openmc-dev/openmc.git
        cd openmc
  fi

  if [ -e build ]; then
    rm -rf build.bak
    mv build build.bak
  fi
  mkdir -p build
  cd build
  cmake -DOPENMC_USE_DAGMC=ON\
        -DCMAKE_BUILD_TYPE=Debug\
        -DDAGMC_ROOT=${install_prefix}\
        -DOPENMC_USE_OPENMP=OFF\
        -DOPENMC_USE_MPI=off\
        -DHDF5_PREFER_PARALLEL=off\
        -DCMAKE_INSTALL_PREFIX=${install_prefix}\
        -DCMAKE_VERBOSE_MAKEFILE=TRUE\
        -DCMAKE_BUILD_TYPE=Debug ..
  make -j $ccores
  sudo make install

  cd ..
  sudo pip3 install .

  cd ${WD}

  #this was apparently successful - mark as done. 
  touch ${name}.done
else
  echo openmc appears to be already installed \(lock file ${name}.done exists\) - skipping.
fi
