#!/bin/bash
# set -ex

#default install location. may be overrridden by the option --prefix=<path>
LOCAL_INSTALL_PREFIX=/usr/local/lib

prefix_regex="^--prefix=(.*)$"
for arg in $*
do
  if [[ $arg =~ $prefix_regex ]]
  then
    echo ${BASH_REMATCH[0]}
    LOCAL_INSTALL_PREFIX=${BASH_REMATCH[1]}
  fi
done
export LOCAL_INSTALL_PREFIX

#default openmc build directory. may be overridden by the option --openmc_build=<path>
OPENMC_BUILD_PREFIX=$HOME/openmc

openmc_build_regex="^--openmc_build=(.*)$"
for arg in $*
do
  if [[ $arg =~ $openmc_build_regex ]]
  then
    echo ${BASH_REMATCH[0]}
    OPENMC_BUILD_PREFIX=${BASH_REMATCH[1]}
  fi
done
export OPENMC_BUILD_PREFIX

#openmc compile & install
#openmc-install.sh will call install scripts of its dependencies & nuclear data
./openmc-install.sh
echo "Compiled & installed openmc, done."

#bash cad-to-openmc-install.sh
#echo "Compiled & installed CAD_to_openMC, done."


#echo "Running test scripts..."
#python ./tests/step_to_h5m.py
#python ./tests/test_openmc.py

#clean up after tests
rm -f *.xml
rm -f *.h5
rm -f *.stl
rm -f *.h5m
rm -f *.vtk

regexpression="(.*)(_|-)(.*)"
[[ $LOCAL_INSTALL_PREFIX =~ $regexpression ]]
pfix=${BASH_REMATCH[1]}${BASH_REMATCH[2]}
version=${BASH_REMATCH[3]}

echo "Below is a possible implementation of a modulefile"
echo "  save in e.g. $HOME/modulefiles/openmc/${version}.lua"
echo "-------------"
cat << _end
local home    = os.getenv("HOME")
local version = myModuleVersion()
local pkgName = myModuleName()
local pkgpath     = pathJoin("${pfix}" .. version,"bin")
local pkgpypath   = pathJoin("${pfix}" .. version,"lib/python3.11/site-packages")

depends_on('openmc_chain')
depends_on('openmc_xsect')

prepend_path("PATH", pkgpath)
prepend_path("PYTHONPATH", pkgpypath)
_end
