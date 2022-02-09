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

sudo apt-get install --yes python3-lxml\
        python3-scipy\
        python3-pandas\
        python3-h5py\
        python3-matplotlib\
        python3-uncertainties 

#if there is a .done-file then skip this step
if [ ! -e $0.done ]; then
  #source install
  cd $HOME
  mkdir -p openmc_chkout
  cd openmc_chkout
  git clone --recurse-submodules --single-branch --branch develop --depth 1 https://github.com/openmc-dev/openmc.git
  cd openmc


  mkdir -p build
  cd build
  cmake -Doptimize=on \
           -Ddagmc=ON \
           -DDAGMC_ROOT=$HOME/openmc/DAGMC \
           -DHDF5_PREFER_PARALLEL=off ..
  sudo make install
  cd ..
  sudo pip install .
  rm -rf build
  
  touch ${0}.done
else
   name=`basename $0`
   echo openmc appears to already be installed \(lock file ${name}.done exists\) - skipping.
fi
