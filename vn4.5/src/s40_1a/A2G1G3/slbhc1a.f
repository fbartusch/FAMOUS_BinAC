C ******************************COPYRIGHT******************************
C (c) CROWN COPYRIGHT 1995, METEOROLOGICAL OFFICE, All Rights Reserved.
C
C Use, duplication or disclosure of this code is subject to the
C restrictions as set forth in the contract.
C
C                Meteorological Office
C                London Road
C                BRACKNELL
C                Berkshire UK
C                RG12 2SZ
C 
C If no contract has been raised with this copy of the code, the use,
C duplication or disclosure of it is strictly prohibited.  Permission
C to do so must first be obtained in writing from the Head of Numerical
C Modelling at the above address.
C ******************************COPYRIGHT******************************
C
C*LL
CLL   SUBROUTINE SLBHCONV
CLL   -------------------
CLL
CLL   THIS ROUTINE IS FOR USE WITH THE 'SLAB' OCEAN MODEL ONLY.
CLL
CLL   IT ACCUMULATES THE AREA WEIGHTED HEAT CONVERGENCE FOR
CLL   SEA-ICE POINTS WHERE IT IS NEGATIVE,
CLL   AND ADDS TO HEAT CONVERGENCE AT ICE FREE SEA POINTS FOR NORTHERN
CLL   AND SOUTHERN HEMISPHERES SEPARATLY
CLL
CLL   THIS ROUTINE FORMS PART OF SYSTEM COMPONENT P40.
CLL   IT CAN BE COMPILED BY CFT77, BUT DOES NOT CONFORM TO ANSI
CLL   FORTRAN77 STANDARDS, BECAUSE OF THE INLINE COMMENTS.
CLL
CLL NOTE - THIS ROUTINE DOES NOT FULLY MEET THE PROGRAMMING STANDARD
CLL        AT THIS VERSION; BECAUSE OF THE SEPARATE OPERATONS ON
CLL        NORTHERN AND SOUTHERN HEMISPHERE POINTS.
CLL        THIS WILL BE ADDRESSED AT THE NEXT RELEASE.
CLL
CLL   ALL QUANTITIES IN THIS ROUTINE ARE IN S.I. UNITS UNLESS
CLL   OTHERWISE STATED.
CLL
CLL   CALLED BY: SLABCNTL
CLL
CLL   WRITTEN BY A.B.KEEN (12/03/92)
CLL   VERSION NUMBER 1.1
CLL   REVIEWER: W.INGRAM (01/03/93)
CLL
CLLEND---------------------------------------------------------------
C*L
      SUBROUTINE SLBHCONV(L1,L2,ICOLS,JROWS,
     +                    HEATCONV,WEIGHTS,AMASK,ICY)
C
      IMPLICIT NONE
C
      INTEGER L1,  ! IN SIZE OF INPUT DATA ARRAY
     + L2,         ! IN AMOUNT OF DATA TO BE PROCESSED
     + ICOLS,      ! IN NUMBER OF POINTS IN A ROW
     + JROWS       ! IN NUMBER OF POINTS IN A COLUMN
C
      REAL
     + HEATCONV(L1),      ! INOUT HEAT CONVERGENCE RATE (W M-2)
     + WEIGHTS(L1)        ! IN WEIGHTS (COS LATITUDE) FOR AREA SUMS
C
      LOGICAL
     + AMASK(L1),         ! IN TRUE FOR LAND POINTS
     + ICY(L1)            ! IN TRUE IF BOX CONTAINS ICE.
C
C
C**   VARIABLES LOCAL TO THIS ROUTINE ARE NOW DEFINED.
C
      REAL
     + SEASUM,     ! SUM OF WEIGHTS OVER SEA POINTS
     + HCONVSUM,   ! SUM OF WEIGHTED HEAT CONVERGENCES
     + HC_CORR     ! HEAT CONVERGENCE CORRECTION
C
      INTEGER
     + HALFROWS,   ! HALF THE NUMBER OF ROWS
     + HALFPOINTS, ! HALF THE NUMBER OF POINTS
     + HPTSP1,     ! HALF THE NUMBER OF POINTS PLUS ONE
     + J         ! LOOP COUNTER
C
      HALFROWS=JROWS/2
      HALFPOINTS=ICOLS*HALFROWS
      HPTSP1=HALFPOINTS+1
C
C
C**  COMPUTE AND APPLY HEAT CONVERGENCE CORRECTION TO
C**  NORTHERN HEMISPHERE SEA POINTS
C
      SEASUM=0.0
      HCONVSUM=0.0
      DO J=1,HALFPOINTS
          IF ((.NOT.AMASK(J)).AND.(.NOT.ICY(J))) THEN
            SEASUM=SEASUM+WEIGHTS(J)
          ENDIF
          IF (ICY(J).AND.(HEATCONV(J).LT.0.0)) THEN
            HCONVSUM=HCONVSUM+HEATCONV(J)*WEIGHTS(J)
            HEATCONV(J)=0.0
          ENDIF
      END DO
      HC_CORR=HCONVSUM/SEASUM
      DO J=1,HALFPOINTS
          IF ((.NOT.AMASK(J)).AND.(.NOT.ICY(J))) THEN
            HEATCONV(J)=HEATCONV(J)+HC_CORR
          ENDIF
      END DO
C
C
C**  COMPUTE AND APPLY HEAT CONVERGENCE CORRECTION TO
C**  SOUTHERN HEMISPHERE SEA POINTS
C
      SEASUM=0.0
      HCONVSUM=0.0
      DO J=HPTSP1,L2
          IF ((.NOT.AMASK(J)).AND.(.NOT.ICY(J))) THEN
            SEASUM=SEASUM+WEIGHTS(J)
          ENDIF
          IF (ICY(J).AND.(HEATCONV(J).LT.0.0)) THEN
            HCONVSUM=HCONVSUM+HEATCONV(J)*WEIGHTS(J)
            HEATCONV(J)=0.0
          ENDIF
      END DO
      HC_CORR=HCONVSUM/SEASUM
      DO J=HPTSP1,L2
          IF ((.NOT.AMASK(J)).AND.(.NOT.ICY(J))) THEN
            HEATCONV(J)=HEATCONV(J)+HC_CORR
          ENDIF
      END DO
C
C
      RETURN
      END
