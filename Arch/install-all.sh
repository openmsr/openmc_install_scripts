#!/bin/bash
# set -ex

#echo 'Defaults    timestamp_timeout=-1' | sudo EDITOR='tee -a' visudo

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

#openmc compile & install
#openmc-install.sh will call install scripts of its dependencies & nuclear data
./openmc-install.sh
echo "Compiled & installed openmc, done."

#bash cad-to-openmc-install.sh
#echo "Compiled & installed CAD_to_openMC, done."

#remove timestamp update
#sudo sed -i '/Defaults    timestamp_timeout=-1/d' /etc/sudoers

#echo "Running test scripts..."
#python ./tests/step_to_h5m.py
#python ./tests/test_openmc.py
rm *.xml
rm *.h5
rm *.stl
rm *.h5m
rm *.vtk
