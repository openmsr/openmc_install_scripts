![Build status](https://github.com/openmsr/openmc_install_scripts/actions/workflows/build_from_source.yml/badge.svg)
![Build status](https://github.com/openmsr/openmc_install_scripts/actions/workflows/build_from_source_containers.yml/badge.svg)

# openmc_install_scripts

This is a set of scripts that are intended to help
with installation of OpenMC with its DAGMC-backend and its
dependencies.

NOTE: the embree backend is developed by Intel and is known to ''cause issues on AMD processors'' and older Intel processors. For more details, see the EMBREE section.

To install to some given location do:
```
 ./install-all.sh --prefix=<path>
```

It is assumed that the installing user has permission to write files
at the installing location.
The most stable way of handling installation at present is to
install to a python venv. Like so:
```
 python -m venv <path>
 source <path>/bin/activate
 ./install-all.sh --prefix=<path>
```

This will put all the required libraries etc in that location and ensure the python modules are present.

A variant of this procedure which install to e.g. a system location is the following (assuming that the installing username  is <user> and has sudo-permissions)
```bash
 sudo mkdir <path>
 sudo chown <user> <path>
 python -m venv <path>
 source <path>/bin/activate
 ./install-all.sh --prefix=$VIRTUAL_ENV
```
The last step uses an environment variable set by the python virtual environment.

# Specifics with Embree

Carefully read the instructions on the embree git for the latest updates: https://github.com/embree/embree

The embree cmake configuration uses ISA-specific hardware acceleration.
by default, the `EMBREE_MAX_ISA` cmake flag is set to AVX2, which is a relatively new addition to the  x86_64 instruction set.
The following cmake flags may be used to alter your configuration as desired (copied from the embree readme):
+ `EMBREE_MAX_ISA`: Select highest supported ISA (SSE2, SSE4.2, AVX,
  AVX2, AVX512, or NONE). When set to NONE the
  EMBREE_ISA_* variables can be used to enable ISAs individually. By
  default, the option is set to AVX2.

+ `EMBREE_ISA_SSE2`: Enables SSE2 when EMBREE_MAX_ISA is set to
  NONE. By default, this option is turned OFF.

+ `EMBREE_ISA_SSE42`: Enables SSE4.2 when EMBREE_MAX_ISA is set to
  NONE. By default, this option is turned OFF.

+ `EMBREE_ISA_AVX`: Enables AVX when EMBREE_MAX_ISA is set to NONE. By
  default, this option is turned OFF.

+ `EMBREE_ISA_AVX2`: Enables AVX2 when EMBREE_MAX_ISA is set to
  NONE. By default, this option is turned OFF.

+ `EMBREE_ISA_AVX512`: Enables AVX-512 for Skylake when
  EMBREE_MAX_ISA is set to NONE. By default, this option is turned OFF.

