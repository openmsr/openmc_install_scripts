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

install_prefix="/opt"
if [ "x" != "x$LOCAL_INSTALL_PREFIX" ]; then
  install_prefix=$LOCAL_INSTALL_PREFIX
fi
build_prefix="$HOME/openmc"

#if there is a .done-file then skip this step
if [ ! -e ${name}.done ]; then
  sudo pacman -Sy --noconfirm embree doxygen

  #Should we run make in parallel? Default is to use all available cores
  ccores=`cat /proc/cpuinfo |grep CPU|wc -l`
  if [ "x$1" != "x" ]; then
	ccores=$1
  fi

  mkdir -p $HOME/openmc/double-down
  cd $HOME/openmc/double-down
  if [ ! -d double-down ]; then
	  git clone --single-branch --branch array_incl --depth 1 https://github.com/pshriwise/double-down.git
  fi
  mkdir -p build
  cd build
  cmake ../double-down -DMOAB_DIR=${install_prefix} \
                       -DCMAKE_INSTALL_PREFIX=${install_prefix}
  make -j ${ccores}
  make install

  #touch a lock file to avoid uneccessary rebuilds
  cd $WD
  touch ${name}.done
else
  echo double-down appears to be already installed \(lock file ${name}.done exists\) - skipping.
fi
