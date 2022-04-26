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

if [ "x" == "$1x" ]; then
	ccores=1
else
	ccores=$1
fi


sudo apt-get install --yes doxygen\
        libembree3-3 libembree-dev


#if there is a .done-file then skip this step
if [ ! -e $0.done ]; then

  touch ${0}.done

  cd $HOME/openmc
  mkdir double-down
  cd double-down
  git clone --single-branch --branch main --depth 1 https://github.com/pshriwise/double-down.git
  mkdir build
  cd build
  cmake ../double-down -DMOAB_DIR=$HOME/openmc/MOAB \
                     -DCMAKE_INSTALL_PREFIX=$HOME/openmc/double-down
  
  make -j $ccores 
  make install
  cd ../..
  rm -rf /double-down/build /double-down/double-down
else
   name=`basename $0`
   echo double-down appears to already be installed \(lock file ${name}.done exists\) - skipping.
fi
