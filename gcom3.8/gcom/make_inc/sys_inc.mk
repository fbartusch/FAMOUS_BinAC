#                        GCOM Makefile Include File

#                   This file should not need to be edited

# *****************************COPYRIGHT*******************************
# (c) CROWN COPYRIGHT 2001, Met Office, All Rights Reserved. 
# Please refer to Copyright file in top level GCOM directory
#                 for further details
# *****************************COPYRIGHT*******************************

LPACKAGE=gcom
UPACKAGE=GCOM

GC_ID=${GC_TYPE}${GC_USER_ID}

LIBNAME=lib${LPACKAGE}_${GC_ID}.a
GC_LIB=${LIBDIR}/${LIBNAME}
GC_LOG=${LOGDIR}/${LPACKAGE}_${GC_ID}.log

INCLUDE_DIR=${GC_TOPDIR}/inc
FINC=-I${INCLUDE_DIR}
CINC=-I${INCLUDE_DIR}
GC_FDIR=-DGC_VERSION='"${GC_VERSION}"' \
        -DGC_DESCRIP='"${GC_DESCRIP}"' \
        -DGC_BUILD_DATE='"${GC_BUILD_DATE}"'

#GC_OBJ=${GC_SRC:.F90=.o} gc__stamp.o
#GCG_OBJ=${GCG_SRC:.F90=.o} gc__stamp.o
GC_OBJ=${GC_SRC:.F90=.o}
GCG_OBJ=${GCG_SRC:.F90=.o}
MPL_OBJ=${MPL_SRC:.F90=.o}

