################################################################################
#nuclear data download & extract
################################################################################
#!/bin/bash
set -ex

if [ ! -e $0.done ]; then
 if [ "x${OPENMC_CROSS_SECTIONS}"=="x" ]; then
	 echo "export OPENMC_CROSS_SECTIONS=$HOME/openmc/nuclear_data/mcnp_endfb71/cross_sections.xml" >> $HOME/.bashrc
 fi

 #default libraries
 endfb_VII="https://anl.box.com/shared/static/9igk353zpy8fn9ttvtrqgzvw1vtejoz6.xz"
 endfb_VIII="https://anl.box.com/shared/static/uhbxlrx7hvxqw27psymfbhi7bx7s6u6a.xz"
 jeff="https://anl.box.com/shared/static/4jwkvrr9pxlruuihcrgti75zde6g7bum.xz"

 mkdir -p $HOME/openmc/nuclear_data
 cd $HOME/openmc/nuclear_data

 toget=$endfb_VIII

 if [ ! -e `basename $toget` ]; then
   #see other default options above
   wget $toget

   for entry in "$PWD"/*.xz
   do
     tar -xvf $entry
   done
 fi
  touch ${0}.done
else
   name=`basename $0`
   echo nuclear data appears to already be installed \(lock file ${name}.done exists\) - skipping.
fi

