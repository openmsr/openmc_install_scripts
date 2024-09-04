## ======================================================================== ##
## Copyright 2009-2013 Intel Corporation                                    ##
##                                                                          ##
## Licensed under the Apache License, Version 2.0 (the "License");          ##
## you may not use this file except in compliance with the License.         ##
## You may obtain a copy of the License at                                  ##
##                                                                          ##
##     http://www.apache.org/licenses/LICENSE-2.0                           ##
##                                                                          ##
## Unless required by applicable law or agreed to in writing, software      ##
## distributed under the License is distributed on an "AS IS" BASIS,        ##
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. ##
## See the License for the specific language governing permissions and      ##
## limitations under the License.                                           ##
## ======================================================================== ##

FIND_PATH(EMBREE_INCLUDE_DIRS embree3/rtcore.h
  /usr/include
  /usr/local/include
  /opt/local/include)

FIND_LIBRARY(EMBREE_LIBRARY NAMES embree3 PATHS 
  /usr/lib 
  /usr/local/lib 
  /opt/local/lib)

FIND_LIBRARY(EMBREE_LIBRARY_MIC NAMES embree3_xeonphi PATHS 
  /usr/lib 
  /usr/local/lib 
  /opt/local/lib)

IF (EMBREE_INCLUDE_DIRS AND EMBREE_LIBRARY)
  SET(EMBREE_FOUND TRUE)
  #set embree version to the lowest allowable number and hope for the best
  SET(EMBREE_VERSION 3.6.1)
ENDIF ()
