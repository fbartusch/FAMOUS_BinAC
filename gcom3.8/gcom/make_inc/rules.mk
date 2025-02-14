#==============================================================================
# RCS Header:
#   File         [$Source: /home/fr0400/frps/Projects/GCOM/GCOM_arch/build/make_inc/rules.mk,v $]
#   Revision     [$Revision: 1.11.2.2 $]     Named [$Name: release#2_9_b8 $]
#   Last checkin [$Date: 2003/07/21 16:07:10 $]
#   Author       [$Author: frps $]
#==============================================================================

#                        GCOM Makefile Include File

#                   This file should not need to be edited

# *****************************COPYRIGHT*******************************
# (c) CROWN COPYRIGHT 2001, Met Office, All Rights Reserved. 
# Please refer to Copyright file in top level GCOM directory
#                 for further details
# *****************************COPYRIGHT*******************************

.SUFFIXES : .F .F90 .c

.F90.o:
	@${ECHO} "--------------------------------------------------"
	@${ECHO} \*\*\* Compiling library member $* 
	@${ECHO} 

	${CPP} ${FINC} ${GC_FDIR} ${CPPFLAGS} ${GC_CPPFLAGS} $< $*_${GC_ID}.f90
	${F90} ${LIB_INC} ${FINC} ${FFLAGS} -c $*_${GC_ID}.f90
	@${MOVE} $*_${GC_ID}.o $*.o
	${MKLIB} ${LIBFLAGS} ${GC_LIB} $*.o 
	@${ECHO} Library member $* added/updated at `date` >> ${GC_LOG}

	@${ECHO}
	@${ECHO} \*\*\* Library member $* 
	@${ECHO} \*\*\* added to library `${BASENAME} ${GC_LIB}`
	@${ECHO} "--------------------------------------------------"
	@${ECHO}
.F.o:
	@${ECHO} "--------------------------------------------------"
	@${ECHO} \*\*\* Compiling library member $* 
	@${ECHO} 

	${CPP} ${FINC} ${GC_FDIR} ${CPPFLAGS} ${GC_CPPFLAGS} $< $*_${GC_ID}.f
	${FORT} ${LIB_INC} ${FINC} ${FFLAGS} -c $*_${GC_ID}.f
	@${MOVE} $*_${GC_ID}.o $*.o
	${MKLIB} ${LIBFLAGS} ${GC_LIB} $*.o 
	@${ECHO} Library member $* added/updated at `date` >> ${GC_LOG}

	@${ECHO}
	@${ECHO} \*\*\* Library member $* 
	@${ECHO} \*\*\* added to library `${BASENAME} ${GC_LIB}`
	@${ECHO} "--------------------------------------------------"
	@${ECHO}

.f.o:
	@${ECHO} "--------------------------------------------------"
	@${ECHO} \*\*\* Compiling library member $* 
	@${ECHO} 

	${FORT} ${FFLAGS} ${LIBINC} ${FINC} -c $< -o $*.o
	${MKLIB} ${LIBFLAGS} ${GC_LIB} $*.o 
	@${ECHO} Library member $* added/updated at `date` >> ${GC_LOG}

	@${ECHO}
	@${ECHO} \*\*\* Library member $* 
	@${ECHO} \*\*\* added to library `${BASENAME} ${GC_LIB}`
	@${ECHO} "--------------------------------------------------"
	@${ECHO}

.c.o:
	@${ECHO} "--------------------------------------------------"
	@${ECHO} \*\*\* Compiling library member $* 
	@${ECHO}

	${CC} ${CFLAGS} ${GC_CPPFLAGS} ${LIBINC} ${CINC} -c $< -o $*.o
	${MKLIB} ${LIBFLAGS} ${GC_LIB} $*.o

	@${ECHO}
	@${ECHO} \*\*\* Library member $* 
	@${ECHO} \*\*\* added to library `${BASENAME} ${GC_LIB}`
	@${ECHO} "--------------------------------------------------"
	@${ECHO}
