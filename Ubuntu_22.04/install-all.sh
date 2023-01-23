#!/bin/bash
set -ex

echo 'Defaults    timestamp_timeout=-1' | sudo EDITOR='tee -a' visudo

#openmc compile & install
#openmc-install.sh will call install scripts of its dependencies & nuclear data
./openmc-install.sh
echo "Compiled & installed openmc, done."

./cad-to-openmc-install.sh
echo "Compiled & installed CAD_to_openMC, done."