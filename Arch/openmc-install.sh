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
install_prefix="/opt"
build_prefix="$HOME/openmc"

#if there is a .done-file then skip this step
if [ ! -e ${name}.done ]; then
  sudo pacman -Syu --noconfirm\
	python-lxml\
	python-scipy\
	python-pandas\
	python-h5py\
	python-matplotlib\
	python-uncertainties

  #Should we run make in parallel? Default is to use all available cores
  ccores=`cat /proc/cpuinfo |grep CPU|wc -l`
  if [ "x$1" != "x" ]; then
	ccores=$1
  fi

  #source install
  mkdir -p $HOME/openmc
  cd $HOME/openmc
  if [ -e openmc ]; then
        #repo exists checkout the stable version
        cd openmc
        git checkout v0.13.1
        git pull --recurse-submodules
  else
        #clone the repo and checkout the stable version
        git clone --recurse-submodules https://github.com/openmc-dev/openmc.git
        git checkout v0.13.1
        cd openmc
  fi

  if [ -e build ]; then
    rm -rf build.bak
    mv build build.bak
  fi
  mkdir -p build
  cd build
  cmake -DOPENMC_USE_DAGMC=ON\
        -DDAGMC_ROOT=${install_prefix}/DAGMC\
        -DHDF5_PREFER_PARALLEL=off\
	      -DCMAKE_INSTALL_PREFIX=${install_prefix} ..
  make -j $ccores
  sudo make install
  cd ..
  sudo python setup.py install
  #set up a python venv and install the python api (and deps) into that
  cd ${HOME}
  python -m venv openmc_env
  openmc_env/bin/python -m pip install --upgrade pip
  sudo openmc_env/bin/python -m pip install $HOME/openmc/openmc

  cd ${WD}

  #this was apparently successful - mark as done.
  touch ${name}.done
else
  echo openmc appears to be already installed \(lock file ${name}.done exists\) - skipping.
fi
