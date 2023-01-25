# set non-standard paths
export PATH=$PATH:/opt/openmc/bin:$HOME/.local/lib/python3.10/site-packages
export OPENMC_CROSS_SECTIONS=$PWD/NUCLEAR-DATA-PKGBUILD/src/endfb-vii.1-hdf5/cross_sections.xml

# test geometry build
python step_to_h5m.py

# test run
python test_openmc.py
