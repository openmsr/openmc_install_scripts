################################################################################
#double-down source install
################################################################################
#!/bin/bash
set -ex

#embree compile & install
./embree-install.sh
echo "Compiled & installed embree, proceeding..."

#moab compile & install
./moab-install.sh
echo "Compiled & installed moab, proceeding..."

WD=`pwd`
name=`basename $0`
package_name='double_down'

#if there is a .done-file then skip this step
if [ ! -e ${name}.done ]; then
  sudo apt-get install --yes doxygen\
        libembree3-3 libembree-dev

  #Should we run make in parallel? Default is to use all available cores
  ccores=`cat /proc/cpuinfo |grep CPU|wc -l`
  if [ "x$1" != "x" ]; then
	ccores=$1
  fi

  mkdir -p $HOME/openmc/double-down
  cd $HOME/openmc/double-down
  git clone --single-branch --branch main --depth 1 https://github.com/pshriwise/double-down.git
  mkdir build
  cd build
  cmake ../double-down -DMOAB_DIR=$HOME/openmc/MOAB \
                     -DCMAKE_INSTALL_PREFIX=$HOME/openmc/double-down
  make -j $ccores
  make install

  cd ${WD}
  touch ${name}.done
else
  echo double-down appears to be already installed \(lock file ${name}.done exists\) - skipping.
fi
