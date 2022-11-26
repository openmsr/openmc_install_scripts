#! /bin/bash

echo "Running test script..."
# set the path to the nuclear database
export OPENMC_CROSS_SECTIONS=$HOME"/openmc/nuclear_data/mcnp_endfb71/cross_sections.xml"
# set custom version of pyMOAB
export PYTHONPATH=$PYTHONPATH:$HOME"/openmc/MOAB/build/pymoab/"
# set custom version of CAD_to_openMC
export PYTHONPATH=$PYTHONPATH:$HOME"/openmc/CAD_to_openMC/src/"
# set custom version of OpenMC
export PYTHONPATH=$PYTHONPATH:$HOME"/openmc/openmc/"


if [ ! -e dagmc.h5m ]; then
    python step_to_h5m.py fuel_pins.step
fi
python test_openmc.py
