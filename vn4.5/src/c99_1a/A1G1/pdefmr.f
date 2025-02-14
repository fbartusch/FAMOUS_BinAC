      SUBROUTINE PIPE_Define_Model_Read (cdfread,cdpread, kinfo)
C****
C               *****************************
C               * OASIS ROUTINE  -  LEVEL C *
C               * -------------     ------- *
C               *****************************
C
C**** *PIPE_Define*  - Initialize coupled mode communication for
C                      coupler
C
C     Purpose:
C     -------
C     Initialize coupler - models communication using named
c                          pipes(fifo).
C
C**   Interface:
C     ---------
C       *CALL*  *PIPE_Define (cdfread, cdpread, kinfo)*
C
C     Input:
C     -----
C                cdfread  : alias filename for read pipe (char string)
C                cdpread  : symbolic reading pipe name (char string)
C
C     Output:
C     ------
C                kinfo    : error status (integer)
C
C     Workspace:
C     ---------
C     None
C
C     Externals:
C     ---------
C     assign, empty, mknod
C
C     Reference:
C     ---------
C     See OASIS manual (1995)
C
C     History:
C     -------
C       Version   Programmer     Date      Description
C       -------   ----------     ----      -----------
C       2.0       L. Terray      95/09/01  created
C
C %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
C* ---------------------------- Argument declarations ---------------
C
      CHARACTER*8 cdfread
      CHARACTER*8 cdpread
C
C* ---------------------------- Local declarations ------------------
C
      CHARACTER*80 clcmd
      INTEGER mknod
      integer nulou
      data nulou /6/
C
C* ---------------------------- Poema verses ------------------------
C
C %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
C*    1. Initializations
C        ---------------
C

C
C* Zeroes error codes
C
      ierror = 0
      icumul = 0
C
C
C*    2. Create pipes to exchange fields coupler and remote models
C        ---------------------------------------------------------
C
C* Assign business for reading
C
C ---> Options u and unblocked valid for sequential unformatted files
C      Option u results in an immediate system call (see man assign)
C
      WRITE (UNIT = clcmd,FMT ='
     $  (''assign -s unblocked -a '',A8,
     $  '' f:'',A8 )') cdpread, cdfread
      CALL assign(clcmd, ierror)
      CALL empty(clcmd,80)
C
C* Find error if any
C
      IF (ierror .EQ. 0) THEN
        write(nulou,*) 'Assign command done for pipe file', cdpread
      ELSE
        write(nulou,*) 'Problem with assign command for pipe file',
     $    cdpread
        write(nulou,*) 'The error code number is', ierror
        icumul = icumul + ierror
      ENDIF
C
C* Get error code
C
      IF (icumul .NE. 0) kinfo = icumul
C
C* Mknod business
C
C ---> mode 4480: named pipe with rw permission for user
C      decimal value of octal 0010600 (see man mknod)
C
C* Reading pipes
C
      ierror = mknod (cdpread, 4480, 0)
C
C* Find error if any
C
      IF (ierror .EQ. 0) THEN
        write(nulou,*) 'Mknod command done for pipe', cdpread
      ELSE
        write(nulou,*) 'Mknod command useless for pipe', cdpread
        write(nulou,*) 'The error code number is', ierror
      ENDIF
C
C
C*    3. End of routine
C        --------------
C
      RETURN
      END










