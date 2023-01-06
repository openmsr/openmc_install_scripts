################################################################################
#openmc source install
################################################################################
#!/bin/bash
set -ex

#nuclear_data_download
#./nuclear_data-install.sh
#echo "Downloaded & extracted nuclear data, proceeding..."

openmc_version="v0.13.2"
if [ "x" != "x$OPENMC_VERSION" ]; then
	openmc_version=$OPENMC_VERSION
fi


#dagmc compile & install
./dagmc-install.sh
echo "Compiled & installed dagmc, proceeding..."

WD=`pwd`
name=`basename $0`
install_prefix="/usr/local/lib"
if [ "x" != "x$LOCAL_INSTALL_PREFIX" ]; then
  install_prefix=$LOCAL_INSTALL_PREFIX
fi

build_prefix="/dev/null/openmc" #this will never exist - and so use the default later.
if [ "x" != "x$OPENMC_BUILD_PREFIX" ]; then
  build_prefix=$OPENMC_BUILD_PREFIX
fi

echo will install openmc to $install_prefix
echo will build openmc from $build_prefix

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

  #Should --openmc_build be passed as argument, it assumes a git version is already checked-out
  if [ -e $build_prefix/openmc ]; then
    cd $build_prefix/openmc
  else
    #source install
  	mkdir -p $HOME/openmc
  	cd $HOME/openmc
  	if [ -e openmc ]; then
      #repo exists checkout the given version and get new updates
      #(updates are of course only relevant for development branches.)
      cd openmc
      git checkout $openmc_version
      #if this is a branch - make sure it is up to date
      if git show-ref --verify refs/heads/$openmc_version; then
        git pull
      fi
    else
      #clone the repo and checkout the given version
      git clone --recurse-submodules https://github.com/openmc-dev/openmc.git
      cd openmc
      git checkout $openmc_version
  	fi
  fi

  if [ -e build ]; then
    rm -rf build.bak
    mv build build.bak
  fi
  mkdir -p build
  cd build
  cmake -DOPENMC_USE_DAGMC=ON\
        -DOPENMC_USE_OPENMP=ON\
        -DOPENMC_USE_MPI=OFF\
        -DDAGMC_ROOT=${install_prefix}\
        -DHDF5_PREFER_PARALLEL=off\
	-DCMAKE_INSTALL_PREFIX=${install_prefix} ..
  make -j $ccores
  make install

  #install the python layer
  pip install ..

  cd ${WD}

  #this was apparently successful - mark as done.
  touch ${name}.done
else
  echo openmc appears to be already installed \(lock file ${name}.done exists\) - skipping.
fi
