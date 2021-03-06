################################################################################
#embree source install
################################################################################
#!/bin/bash
set -ex

sudo apt-get install --yes gcc\
        make\
        cmake\
        libglfw3\
        libglfw3-dev\
        python3-numpy\
        libtbb2\
        libtbb-dev\
        libopenimageio2.0\
        libopenimageio-dev

#if there is a .done-file then skip this step
if [ ! -e $0.done ]; then
    
   touch ${0}.done

   cd $HOME
   mkdir -p openmc
   cd openmc
   mkdir -p embree
   cd embree
   git clone --single-branch --branch v3.13.2 --depth 1 https://github.com/embree/embree.git
   mkdir build
   cd build
   cmake ../embree -DCMAKE_INSTALL_PREFIX=/embree \
                -DEMBREE_ISPC_SUPPORT=OFF
   make
   sudo make install
   cd ../..
   rm -rf embree/build embree/embree
else
   name=`basename $0`
   echo embree appears to already be installed \(lock file ${name}.done exists\) - skipping.
fi
