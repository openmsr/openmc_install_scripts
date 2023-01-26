# set non-standard paths
export PATH=$PATH:/opt/openmc/bin:$HOME/.local/lib/python3.10/site-packages
var=`ls /opt/*hdf5|head -n1`
echo $var
export OPENMC_CROSS_SECTIONS=$var

# test geometry build
python tests/step_to_h5m.py

# test run
python tests/test_openmc.py

# clean
rm *.stl
