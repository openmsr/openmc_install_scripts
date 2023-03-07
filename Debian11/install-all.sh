#!/bin/bash
set -ex

echo 'Defaults    timestamp_timeout=-1' | sudo EDITOR='tee -a' visudo

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

echo "Running test script..."
python test_openmc.py
rm *.xml
rm *.h5

