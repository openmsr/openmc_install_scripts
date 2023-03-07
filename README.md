![Build status](https://github.com/openmsr/openmc_install_scripts/actions/workflows/build_from_source_on_Debian.yml/badge.svg)

# openmc_install_scripts

This is a set of scripts that are intended to help
with installation of OpenMC with its DAGMC-backend and its
dependencies.

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
