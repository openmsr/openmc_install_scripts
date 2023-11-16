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

sudo apt-get install --yes doxygen

#if there is a .done-file then skip this step
if [ ! -e $0.done ]; then

  touch ${0}.done

  cd $HOME/openmc
  mkdir double-down
  cd double-down
  git clone --single-branch --branch develop --depth 1 https://github.com/pshriwise/double-down.git
  mkdir build
  cd build
  cmake ../double-down -DMOAB_DIR=$HOME/openmc/MOAB \
                     -DCMAKE_INSTALL_PREFIX=$HOME/openmc/double-down \
                     -DEMBREE_DIR=$HOME/openmc/embree
  make
  make install
  cd ../..
  rm -rf /double-down/build /double-down/double-down
else
   name=`basename $0`
   echo double-down appears to already be installed \(lock file ${name}.done exists\) - skipping.
fi
