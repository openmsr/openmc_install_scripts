import sys
import os
import CAD_to_OpenMC.assembly as ab

a=ab.Assembly()
a.stp_files=[sys.argv[1]]
a.import_stp_files()
a.solids_to_h5m()
