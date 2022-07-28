#!/bin/bash
set -ex

#echo 'Defaults    timestamp_timeout=-1' | sudo EDITOR='tee -a' visudo

#openmc compile & install
#openmc-install.sh will call install scripts of its dependencies & nuclear data
./openmc-install.sh
echo "Compiled & installed openmc, done."

bash cad-to-openmc-install.sh
echo "Compiled & installed CAD_to_openMC, done."

#remove timestamp update
sudo sed -i '/Defaults    timestamp_timeout=-1/d' /etc/sudoers

echo "Running test scripts..."
python ./tests/step_to_h5m.py
python ./tests/test_openmc.py
rm *.xml
rm *.h5
rm *.stl
rm *.h5m
rm *.vtk
