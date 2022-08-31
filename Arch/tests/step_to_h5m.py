import sys
import os
home=os.path.expanduser('~')
sys.path.append(f'{home}/openmc/CAD_to_openMC/CAD_to_openMC/src')
import CAD_to_OpenMC.assembly as ab
a=ab.Assembly()
a.stp_files=["tests/fuel_pins.step"]
a.import_stp_files()
a.solids_to_h5m()
