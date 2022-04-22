################################################################################
#double-down source install
################################################################################
#!/bin/bash
set -ex

#embree compile & install
#./embree-install.sh
#echo "Compiled & installed embree, proceeding..."

#moab compile & install
#./moab-install.sh
#echo "Compiled & installed moab, proceeding..."

if [ "x" == "$1x" ]; then
	ccores=1
else
	ccores=$1
fi

WD=`pwd`
name=`basename $0`
package_name='double_down'

sudo apt-get install --yes doxygen libembree-dev libembree3-3

#if there is a .done-file then skip this step
if [ ! -e $0.done ]; then

  mkdir -p $HOME/openmc/double-down
  cd $HOME/openmc/double-down
  git clone --single-branch --branch main --depth 1 https://github.com/pshriwise/double-down.git
  mkdir build
  cd build
  cmake ../double-down -DMOAB_DIR=$HOME/openmc/MOAB \
                     -DCMAKE_INSTALL_PREFIX=$HOME/openmc/double-down
  make -j $ccores 
  make install
  cd ../..
  rm -rf /double-down/build /double-down/double-down

  cd ${WD}
  touch ${0}.done
else
   name=`basename $0`
   echo double-down appears to already be installed \(lock file ${name}.done exists\) - skipping.
fi
