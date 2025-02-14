! *****************************COPYRIGHT*******************************
! (c) CROWN COPYRIGHT, Met Office, All Rights Reserved.           
! Please refer to Copyright file in top level GCOM directory
!                 for further details
! *****************************COPYRIGHT*******************************

#include "gc_prolog.h"    

SUBROUTINE GC_CBCAST (MSG, LEN, SEND, NPROC, ISTAT, SARR)
!     ******************************************************************
!     * Purpose:
!     *
!     *  Broadcast a character array to every processor.
!     *
!     * Input:
!     *  MSG     - message tag
!     *  LEN     - number of characters in message
!     *  SEND    - sender of the message
!     *  NPROC   - Number of processors
!     *  SARR    - array to be sent
!     *
!     * Output:
!     *  SARR    - array to be received (on nodes != SEND)
!     *  ISTAT   - status of bcast. 0 is OK (MPI_SRC only),
!     *            refer to the header files for nonzero status codes
!     *
!     * NOTES:       
!     *
!     ******************************************************************

USE MPL, ONLY :                                                   &
    MPL_CHARACTER

#if defined(MPI_SRC)
USE GC_GLOBALS_MOD, ONLY :                                        &
    GC__MY_MPI_COMM_WORLD
#endif

IMPLICIT NONE

#include "gc_kinds.h"
#include "gc_constants.h"

INTEGER (KIND=GC_INT_KIND) :: MSG, LEN, SEND, NPROC, ISTAT
CHARACTER*(*) SARR

#if defined(GCOM_TIMER)
#include "gc_timer.h"
#define THIS_LENGTH LEN
#include "gc_functions.h"
#endif

#include "gc_start_timer.h"

#if defined (MPI_SRC)
CALL MPL_BCAST(SARR, LEN, MPL_CHARACTER, SEND,                    &
               GC__MY_MPI_COMM_WORLD,ISTAT)
#endif

#if defined(SERIAL_SRC)
ISTAT = GC__OK
#endif

#if defined(GCOM_TIMER)
IF (GC_ME()  ==  SEND) THEN
#define THIS_TIMER TIMET_BCAST_SEND
#include "gc_end_timer.h"
ELSE ! At the receiving end
#define THIS_TIMER TIMET_BCAST_RECV
#include "gc_end_timer.h"
ENDIF
#endif

RETURN
END
