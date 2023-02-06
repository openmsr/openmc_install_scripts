# set non-standard paths
export PATH=$PATH:/opt/openmc/bin:$HOME/.local/lib/python3.10/site-packages
var=`echo /opt/nuclear-data/*hdf5 | head -n1`
export OPENMC_CROSS_SECTIONS=$var/cross_sections.xml
echo $OPENMC_CROSS_SECTIONS


# test geometry build
#python tests/step_to_h5m.py

# test run
python tests/test_openmc.py

# clean
#rm *.stl
