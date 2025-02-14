#                        GCOM Makefile Include File

#                        Edit this file as necessary

# *****************************COPYRIGHT*******************************
# (c) CROWN COPYRIGHT 2001, Met Office, All Rights Reserved. 
# Please refer to Copyright file in top level GCOM directory
#                 for further details
# *****************************COPYRIGHT*******************************


#**********************************************************************
# This file is split into a number of sections. You may wish to make
# changes in each section:
#
#  1) Main GCOM configuration CPP flags
#       These control things such as:
#         - Message passing library to use
#         - Numerical representation precision (32bit or 64 bit)
#         - Overriding any internal limits
#
#  2) File locations (GCOM Library and log file) and names
#
#  4) Definitions of compilers/preprocessors etc. and flags to use
#
#  5) UNIX commands used in the make files
#
#**********************************************************************





#**********************************************************************
# 1) Main GCOM configuration CPP flags                                *
#**********************************************************************

# The following CPP flags are available:
#
# Insert -D to use


# GC_DESCRIP  - A description of the installation used in GCOM's header
 
 
 
# 32/64 Bit Interfacing
# ---------------------
                                                                                
# GCOM can be compiled with 32 or 64 bit default Integers and Reals and this should
# agree with the flag PREC_XXB specified in the config files. If, however
# you require a 64 bit GCOM library (as would be required by the Unified Model) and
# have an MPI implementation that expects 32 bit arguments then you will need to
# include several extra flags. These are:
 
# * MPILIB_32B [Mandatory] specifies that the MPI library is designed to operate at
# 32 bit.
 
# %precision
# ----------
 
# PREC_32B                     |  Expect 32 bit floating point numbers and integers
# +---------------------------+------------------------------------------------------+
# PREC_64B                     |  Expect 64 bit floating point numbers and integers
 
 
# %library_type
# -------------
 
# This covers a large number of options, specifying the basic type of library to
# build together with a number of options,
 
# MPI_SRC                  |  Enables MPI interface
# SERIAL_SRC               |  Enables dummy serial interface
 
# The library_type can also include a number of options, as specified below,
 
# +===========================+======================================================+
# |  *GCOM Internal Limits*
# +===========================+======================================================+
# MAX_PROC=<number>           |  Maximum number of processors permitted
#                             |  [Default MAX_PROC=1024]
# +---------------------------+------------------------------------------------------+
# MAX_COLL=<number>           |  Size of array for collective operations
#                             |  [Default MAX_COLL=1024]
# +---------------------------+------------------------------------------------------+
# MAX_GROUP=<number>          |  Maximum number of groups per processor
#                             |  [Default MAX_GROUP=32]
# +---------------------------+------------------------------------------------------+
# MAX_ROTATE=<number>         |  Maximum number of elements in a rotate (shift)
#                             |  operation
#                             |  [Default MAX_ROTATE=8192]
# +---------------------------+------------------------------------------------------+
# MAX_CHARS=<number>          |  Maximum number of characters that can be
#                             |  transmitted by any GCOM call (must be a multiple
# of
#                             |  8 for alignment)
#                             |  [Default MAX_CHARS=65536]
# +---------------------------+------------------------------------------------------+
# MAX_MPI_TYPES=<num>         |  Maximum number of MPI derived data types that are  
#                             |  cached internally within GCOM. If more are required
#                             |  old ones are removed, so there should be no need
#                             |  to increase from the default
#                             |  [Default MAX_MPI_TYPES=1024]
# +===========================+======================================================+
 
# |  *GCOM Diagnostics*
#    |
# +===========================+======================================================+
# GCOM_TIMER                  |  GCOM records time spent in key operations and
#                             |  amount of data transferred. Switching this on will
#                             |  incur a penalty in run-time cost.
# +===========================+======================================================+
# |  *Other configuration options*
#    |
# +===========================+======================================================+
# GC__FORTERRUNIT=<number>    |  Specify the Fortran unit to write error message
#                             |  to when GC_ABORT is called.
#                             |  If your system supports it, you may wish to change
#                             |  to unit 0 which often is mapped to stderr
  
#                             |  [Default GC__FORTERRUNIT=*]
# +---------------------------+------------------------------------------------------+
# GC__FLUSHUNIT6              |  Ensures any unwritten data in Fortran UNIT6
#                             |  buffer is flushed if GC_ABORT is called.
#                             |  Only select this option if your Fortran compiler
#                             |  supports the "CALL FLUSH(<unit_number>)" intrinsic.
# +===========================+======================================================+
# |  *MPI Flags*              |
#    |
# +===========================+======================================================+
# MPI_BSEND_BUFFER_SIZE=      |  Size of buffer to use for MPI communications
#                   <number>  |  [Default MPI_BSEND_BUFFER_SIZE=160000]
# +---------------------------+------------------------------------------------------+
# MPILIB_32B                  |  For 32bit MPI libraries (ie. the library
#                             |  expects its arguments to be supplied as 32bit
#                             |  numbers - although it may quite happily deal
#                             |  with 64bit data)
# +---------------------------+------------------------------------------------------+
# MPIABORT_ERRNO=<number>     |  Specify the exit code that is generated by the
    
#                             |  user code when GC_ABORT has been called.
  
#                             |  [Default MPIABORT_ERRNO=9]
# +===========================+======================================================+


# MPP GCOM
GC_CPPFLAGS=-DMPI_SRC -DPREC_64B -DMPILIB_32B -DMPI_BSEND_BUFFER_SIZE=192000
#GC_CPPFLAGS=-DMPI_SRC -DPREC_64B -DMPILIB_32B -DMPI_BSEND_BUFFER_SIZE=192000
GC_TYPE=buffered_mpi
GC_DESCRIP=MPP
LIB_INC=-I../mpl -I../gc 


# Serial non-MPP GCOM (64-bit)
#GC_CPPFLAGS=-DSERIAL_SRC -DFLP_64B -DI_64B
#GC_TYPE=serial
#GC_DESCRIP=Non MPP Single Processor
#LIB_INC=


#**********************************************************************
# 2) File locations (GCOM Library and log file) and names             *
#**********************************************************************

# Default value is in the top GCOM directory (above the build directory)
LIBDIR=${GC_TOPDIR}/lib
LOGDIR=${GC_TOPDIR}/logs

# User ID string to label the library with (optional)
# (For example you may wish to have versions compiled with "-g" which
#  you might label with "_debug")
GC_USER_ID=


#**********************************************************************
# 4) Definitions of compilers/preprocessors etc. and flags to use     *
#**********************************************************************

# First of all we make some generic definitions.
# Add or uncomment specific definitions to override this for your platform

#HPCx
## C Preprocessor and flags
#CPP=/usr/ccs/lib/cpp
## GNU cpp requires the -traditional flag:
#CPPFLAGS=-P
#
## Fortran compiler, flags and include files
#FORT=mpxlf_r
#F90=mpxlf90_r
##F90=${FORT}
#FFLAGS=-qarch=pwr4 -q64 -qwarn64
#
## C compiler and flags
#CC=mpcc_r
#CFLAGS=-q64 -qstrict
#
## Library creator and flags
#MKLIB=ar -X64
#LIBFLAGS=rc 

#Intel/mpich2
# C Preprocessor and flags
CPP=cpp
# GNU cpp requires the -traditional flag:
CPPFLAGS=-P -traditional

# Fortran compiler, flags and include files
#Both a f77 and f90 compiler are required
FORT=mpif77 -fp-model source -g -traceback
F90=$(MPIF90_UM)  -fp-model source -g -traceback
#F90=${FORT}
FLAGS=

# C compiler and flags
CC=gcc
CFLAGS=

# Library creator and flags
MKLIB=ar
LIBFLAGS=rc 

# Platform specific Overrides, comment and uncomment as appropriate

# Cray T3E
#CPP=cpp
#CPPFLAGS=-N -P
#FFLAGS=-Oscalar3 -Ounroll2 -Opipeline2 -Oaggress

# NEC SX6 (IA64 Cross compiler)
#CPP=/usr/bin/cpp
#CPPFLAGS=-P -traditional
#FORT=sxf90
#FFLAGS=-e w -C hopt

# NEC SX6 (Compiling on SX6 compiler)
#CPP=/lib/cpp
#CPPFLAGS=-P
#FORT=f90
#FFLAGS=-e w -C hopt

# SGI Origin (64 bits)
#CPPFLAGS=-P -DSGI
#FFLAGS=-default64
#CFLAGS=-64

# UKMO HP NAG f95 compiler (32 bits)
# FFLAGS=-fixed -w=obs -w=unused -w=x77 -mismatch -f77

# UKMO HP NAG f95 compiler (64 bits)+
# FFLAGS=-fixed -w=obs -w=unused -w=x77 -mismatch_all -dusty -double -O

# UKMO HP f90 compiler (32 bits)
# FORT=/opt/fortran90/bin/f90

# Linux Lahey compiler (32 bits) (options will also work for Fujitsu compiler)
# FFLAGS=-D_REENTRANT --trace --trap -fs -Kfast -w

# Linux Lahey compiler (64 bits) (options will also work for Fujitsu compiler)
# FFLAGS=-D_REENTRANT --trace --trap -fs -Kfast -w -Ccd4d8

# IBM p690 (64bit)
# CPP=/usr/ccs/lib/cpp
# CPPFLAGS=-P -D_AIX
# FORT=mpxlf_r
# FFLAGS=-q64 -qrealsize=8 -qintsize=8
# CC=mpcc_r
# CFLAGS=-q64
# LIBFLAGS=-X64 rv


# Add your platform here...

# UKMO Linux Intel f90 compiler (64 bits):  Added by Paul Dando (frqz) 25-07-03

#CPP=/usr/bin/cpp
#CPPFLAGS=-U CRAY -P -traditional

#FORT=ifc
#FFLAGS= -i8 -r8 





#**********************************************************************
# 5) UNIX commands used in the make files                             *
#**********************************************************************

# Simple UNIX commands
COPY=/bin/cp
MOVE=/bin/mv
DELETE=/bin/rm -f
ECHO=/bin/echo
BASENAME=basename
TOUCH=touch
MKDIR=mkdir
