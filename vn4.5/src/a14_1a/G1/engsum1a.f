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
CLL  SUBROUTINE ENERGY_SUM---------------------------------------------
CLL
CLL  PURPOSE : PART OF ENERGY CORRECTION SUITE OF ROUTINES
CLL            - TO SUM A QUANTITY GLOBALLY ON A LEVEL
CLL
CLL  NOT SUITABLE FOR SINGLE COLUMN MODEL USE
CLL
CLL  CODE WRITTEN FOR CRAY Y-MP BY D.GREGORY FEBRUARY 1991
CLL
CLL  MODEL            MODIFICATION HISTORY FROM MODEL VERSION 3.0:
CLL VERSION  DATE
!     4.1   28/11/95  Changed interface to ENERGY_SUM to make
!                     suitable for MPP use.  P.Burton
CLL
CLL  PROGRAMMING STANDARDS : UNIFIED MODEL DOCUMENTATION PAPER NO. 4
CLL  VERSION NO. 1
CLL
CLL  SYSTEM TASK : P##
CLL
CLL  DOCUMENTATION : UNIFIED MODEL DOCUMENTATION PAPER P###
CLL
CLLEND-----------------------------------------------------------------
C
C*L  ARGUMENTS---------------------------------------------------------
C
      SUBROUTINE ENERGY_SUM (VAR,START_POINT,END_POINT,FIELD_SIZE,
     &                       AREA,MASS,RS,CONV_FAC,SUM_VAR)
C
      IMPLICIT NONE
C
C*L------------------COMDECK C_G----------------------------------------
C G IS MEAN ACCEL DUE TO GRAVITY AT EARTH'S SURFACE
      REAL G

      PARAMETER(G=9.80665)
C*----------------------------------------------------------------------
C
C----------------------------------------------------------------------
C VECTOR LENGTHS
C----------------------------------------------------------------------
C
      INTEGER START_POINT,  ! IN point to start sum at
     &        END_POINT,    ! IN point to end sum at
     &        FIELD_SIZE    ! IN size of field
C
C
C----------------------------------------------------------------------
C VARIABLES WHICH ARE INPUT
C----------------------------------------------------------------------
C
      REAL VAR(FIELD_SIZE), ! IN variable to be summed
     &     AREA(FIELD_SIZE),! IN area of grid box
     &     RS(FIELD_SIZE),  ! IN radius at level of the energy sum
     &     MASS(FIELD_SIZE) ! IN mass of grid box
C
      REAL CONV_FAC            ! IN CONVERSION FACTOR TO TRANSLATE
                               !    FLUX INTO ENERGY UNITS
C
C
C----------------------------------------------------------------------
C VARIABLES WHICH ARE IN AND OUT
C----------------------------------------------------------------------
C
      REAL SUM_VAR             ! INOUT SUM OF ENERGY
C
C
C----------------------------------------------------------------------
C VARIABLES WHICH ARE DEFINED LOCALLY - NONE
C----------------------------------------------------------------------
C
      REAL WORK(FIELD_SIZE) ! work space
C
C
C----------------------------------------------------------------------
C INTERNAL LOOP COUNTERS
C----------------------------------------------------------------------
C
      INTEGER I                ! LOOP COUNTER
C
C
C----------------------------------------------------------------------
C EXTERNAL SUBROUTINE CALLS  -  NONE
C----------------------------------------------------------------------
C
C*---------------------------------------------------------------------
CL
CL---------------------------------------------------------------------
CL SUM VARIABLE OVER LAYER
CL---------------------------------------------------------------------
CL
C
C CALCULATE CONTRIBUTION TO TOTAL ENERGY FROM EACH GRID BOX
C
      DO I=START_POINT,END_POINT
       WORK(I) = RS(I)*RS(I)*AREA(I)*MASS(I)*VAR(I)*CONV_FAC/G
      END DO
C
      CALL DO_SUMS(WORK,FIELD_SIZE,START_POINT,END_POINT,1,SUM_VAR)
C
      RETURN
      END
