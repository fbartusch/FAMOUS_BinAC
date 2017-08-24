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
CLL   SUBROUTINE DIV_DAMP -------------------------------------------
CLL
CLL   PURPOSE:   CALCULATES AND ADDS DIVERGENCE DAMPING INCREMENTS TO
CLL              U AND V AS DESCRIBED IN SECTION 3.4 OF DOCUMENTATION
CLL              PAPER NO 10.
CLL   NOT SUITABLE FOR SINGLE COLUMN USE.
CLL
CLL   WRITTEN BY M.H MAWSON.
CLL
CLL  MODEL            MODIFICATION HISTORY FROM MODEL VERSION 3.0:
CLL VERSION  DATE
CLL   4.0  10/07/95   SEC_P_LATITUDE at pole changed for consistency
CLL                   with other parts of UM code.  C.D.Hall
!     3.5    28/03/95 MPP code: Change updateable area and
!                     remove wrap around code.  P.Burton
!     4.1    23/04/96 Added TYPFLDPT arguments to dynamics routines
!                     which allows many of the differences between
!                     MPP and "normal" code to be at top level
!                     P.Burton
CLL
CLL  4.2  4/12/96 : FIX to code to make it work for MPP
CLL                 Alan Dickinson and Deborah Salmond
CLL  4.4 18/11/97   Correction to loop bound: divergence for first point
CLL                 following polar row (non-MPP only) used but not
CLL                 assigned. Rick Rawlins 
CLL
CLL   PROGRAMMING STANDARD: UNIFIED MODEL DOCUMENTATION PAPER NO. 4,
CLL                         STANDARD B. VERSION 2, DATED 18/01/90
CLL
CLL   SYSTEM COMPONENTS COVERED: P15
CLL
CLL   SYSTEM TASK: P1
CLL
CLL   DOCUMENTATION:       THE EQUATIONS USED ARE (30) AND (49)
CLL                        IN UNIFIED MODEL DOCUMENTATION
CLL                        PAPER NO. 10  M.J.P. CULLEN, T.DAVIES AND
CLLEND-------------------------------------------------------------
C
C*L   ARGUMENTS:---------------------------------------------------
      SUBROUTINE DIV_DAMP
     1   (U,V,RS,SEC_U_LATITUDE,PSTAR_OLD,COS_U_LATITUDE,
     2                 KD,LONGITUDE_STEP_INVERSE,LATITUDE_STEP_INVERSE,
     3                 P_FIELD,U_FIELD,ROW_LENGTH,P_LEVELS,
     &  FIRST_ROW , TOP_ROW_START , P_LAST_ROW , U_LAST_ROW,
     &  P_BOT_ROW_START , U_BOT_ROW_START , upd_P_ROWS , upd_U_ROWS,
     &  FIRST_FLD_PT , LAST_P_FLD_PT , LAST_U_FLD_PT,
     &  FIRST_VALID_PT , LAST_P_VALID_PT , LAST_U_VALID_PT,
     &  VALID_P_ROWS, VALID_U_ROWS,
     &  START_POINT_NO_HALO, START_POINT_INC_HALO,
     &  END_P_POINT_NO_HALO, END_P_POINT_INC_HALO,
     &  END_U_POINT_NO_HALO, END_U_POINT_INC_HALO,
     &  FIRST_ROW_PT ,  LAST_ROW_PT , tot_P_ROWS , tot_U_ROWS,
     &  GLOBAL_ROW_LENGTH, GLOBAL_P_FIELD, GLOBAL_U_FIELD,
     4                 BKH,ADVECTION_TIMESTEP,DELTA_AK,
     5                 DELTA_BK,COS_U_LONGITUDE,SIN_U_LONGITUDE,
     6                 SEC_P_LATITUDE)

      IMPLICIT NONE

      INTEGER
     *  P_FIELD            !IN DIMENSION OF FIELDS ON PRESSSURE GRID.
     *, U_FIELD            !IN DIMENSION OF FIELDS ON VELOCITY GRID
     *, P_LEVELS           !IN NUMBER OF PRESSURE LEVELS.
     *, ROW_LENGTH         !IN NUMBER OF POINTS PER ROW
! All TYPFLDPT arguments are intent IN
! Comdeck TYPFLDPT
! Variables which point to useful positions in a horizontal field

      INTEGER
     &  FIRST_ROW        ! First updatable row on field
     &, TOP_ROW_START    ! First point of north-pole (global) or
!                        ! Northern (LAM) row
     &, P_LAST_ROW       ! Last updatable row on pressure point field
     &, U_LAST_ROW       ! Last updatable row on wind point field
     &, P_BOT_ROW_START  ! First point of south-pole (global) or
!                        ! Southern (LAM) row on press-point field
     &, U_BOT_ROW_START  ! First point of south-pole (global) or
!                        ! Southern (LAM) row on wind-point field
     &, upd_P_ROWS       ! number of P_ROWS to be updated
     &, upd_U_ROWS       ! number of U_ROWS to be updated
     &, FIRST_FLD_PT     ! First point on field
     &, LAST_P_FLD_PT    ! Last point on pressure point field
     &, LAST_U_FLD_PT    ! Last point on wind point field
     &, FIRST_VALID_PT   ! first valid point of data on field
     &, LAST_P_VALID_PT  ! last valid point of data on field
     &, LAST_U_VALID_PT  ! last valid point of data on field
     &, VALID_P_ROWS     ! number of valid rows of P data
     &, VALID_U_ROWS     ! number of valid rows of U data
     &, START_POINT_NO_HALO
!                        ! first non-polar point of field (misses
!                        ! halo for MPP code)
     &, START_POINT_INC_HALO
!                        ! first non-polar point of field (includes
!                        ! halo for MPP code)
     &, END_P_POINT_NO_HALO
!                        ! last non-polar point of P field (misses
!                        ! halo for MPP code)
     &, END_P_POINT_INC_HALO
!                        ! last non-polar point of P field (includes
!                        ! halo for MPP code)
     &, END_U_POINT_NO_HALO
!                        ! last non-polar point of U field (misses
!                        ! halo for MPP code)
     &, END_U_POINT_INC_HALO
!                        ! last non-polar point of U field (includes
!                        ! halo for MPP code)
     &, FIRST_ROW_PT     ! first data point along a row
     &, LAST_ROW_PT      ! last data point along a row
     &, tot_P_ROWS         ! total number of P_ROWS on grid
     &, tot_U_ROWS         ! total number of U_ROWS on grid
     &, GLOBAL_ROW_LENGTH  ! length of a global row
     &, GLOBAL_P_FIELD     ! size of a global P field
     &, GLOBAL_U_FIELD     ! size of a global U field
!


! End of comdeck TYPFLDPT

      REAL
     * U(U_FIELD,P_LEVELS)       !IN  U VELOCITY FIELD
     *,V(U_FIELD,P_LEVELS)       !IN  V VELOCITY FIELD
     *  ,COS_U_LATITUDE(U_FIELD)  ! cos(lat) at u points (2nd array)
     *,PSTAR_OLD(U_FIELD)        !IN PSTAR AT PREVIOUS TIME-LEVEL AT
     *                           ! U POINTS
     *,RS(P_FIELD,P_LEVELS)      !IN RS FIELD ON U GRID

      REAL
     * DELTA_AK(P_LEVELS)      !IN  LAYER THICKNESS
     *,DELTA_BK(P_LEVELS)      !IN  LAYER THICKNESS
     *,BKH(P_LEVELS+1)         !IN  SECOND TERM IN HYBRID CO-ORDS AT
     *                         !    HALF LEVELS.
     *,SEC_U_LATITUDE(U_FIELD) !IN  1/COS(LAT) AT U POINTS (2-D ARRAY)
     *,SEC_P_LATITUDE(P_FIELD) !IN  1/COS(LAT) AT P POINTS (2-D ARRAY)
     *,COS_U_LONGITUDE(ROW_LENGTH) !IN  COS(LONGITUDE) AT U POINTS
     *,SIN_U_LONGITUDE(ROW_LENGTH) !IN  SIN(LONGITUDE) AT U POINTS
     *,LONGITUDE_STEP_INVERSE  !IN 1/(DELTA LAMDA)
     *,LATITUDE_STEP_INVERSE   !IN 1/(DELTA PHI)
     *,KD(P_LEVELS)            !IN DIVERGENCE COEFFICIENTS.
     *,ADVECTION_TIMESTEP      !IN
C*---------------------------------------------------------------------

C*L   DEFINE ARRAYS AND VARIABLES USED IN THIS ROUTINE-----------------
C DEFINE LOCAL ARRAYS: 7 ARE REQUIRED
      REAL
     *  D(P_FIELD)           ! HOLDS DIVERGENCE AT A LEVEL
     *, D_BY_DLAT(P_FIELD)   ! HOLDS D/D(LAT) OF DIVERGENCE
     *, D_BY_DLAT2(P_FIELD)  ! HOLDS AVERAGED D_BY_DLAT
     *, D_BY_DLONG(P_FIELD)  ! HOLDS D/D(LONG) OF DIVERGENCE
     *, DU_DLONGITUDE(U_FIELD)
     *, DV_DLATITUDE(U_FIELD)
     *, DV_DLATITUDE2(U_FIELD)
     *  ,U_MW(U_FIELD)      ! Mass weighted u field
     *  ,V_MW(U_FIELD)      ! Mass weighted v field
     *  ,RS_U_GRID(U_FIELD) ! RS field on u grid

C*---------------------------------------------------------------------
C DEFINE LOCAL VARIABLES

C REAL SCALARS
      REAL
     * SCALAR
     *,SUM_N,SUM_S

C COUNT VARIABLES FOR DO LOOPS ETC.
      INTEGER
     *  I,J,K

C*L   EXTERNAL SUBROUTINE CALLS:---------------------------------------
      EXTERNAL P_TO_UV
     &  ,POLAR_UV
C*---------------------------------------------------------------------

CL    MAXIMUM VECTOR LENGTH ASSUMED IS P_POINTS_UPDATE
CL---------------------------------------------------------------------
CL    INTERNAL STRUCTURE INCLUDING SUBROUTINE CALLS:
CL---------------------------------------------------------------------
CL
CL---------------------------------------------------------------------
CL    SECTION 1.     INITIALISATION
CL---------------------------------------------------------------------
C INCLUDE LOCAL CONSTANTS FROM GENERAL CONSTANTS BLOCK


CL LOOP OVER P_LEVELS

      DO 100 K=1,P_LEVELS
        IF(KD(K).GT.0.) THEN
CL      CALCULATE MASS WEIGHTED VELOCITY COMPONENTS
      CALL P_TO_UV(RS(1,K),RS_U_GRID,P_FIELD,U_FIELD,ROW_LENGTH,
     &             tot_P_ROWS)
! Loop over field, missing North and South halos
      DO I=FIRST_VALID_PT,LAST_U_VALID_PT
      SCALAR=RS_U_GRID(I)*(DELTA_AK(K)+DELTA_BK(K)*PSTAR_OLD(I))
      U_MW(I)=U(I,K)*SCALAR
      V_MW(I)=V(I,K)*SCALAR*COS_U_LATITUDE(I)
      ENDDO

CL
CL---------------------------------------------------------------------
CL    SECTION 2.     CALCULATE DIVERGENCE USING EQUATION (30)
CL---------------------------------------------------------------------

C CALCULATE DU/D(LAMDA)
! Loop over field, starting at second row and ending on row above
! last row. Missing out North and South halos
          DO 210 I=START_POINT_NO_HALO-ROW_LENGTH+1,
     &         LAST_U_VALID_PT
            DU_DLONGITUDE(I) = LONGITUDE_STEP_INVERSE*
     &  (U_MW(I)-U_MW(I-1))
 210      CONTINUE

C CALCULATE DV/D(PHI)
! Loop over field, missing top and bottom rows and North and South halos
      DO 220 I=START_POINT_NO_HALO,LAST_U_VALID_PT
            DV_DLATITUDE(I) = LATITUDE_STEP_INVERSE*
     &  (V_MW(I-ROW_LENGTH)-V_MW(I))
 220      CONTINUE

C CALCULATE AVERAGE OF DV_DLATITUDE
! Loop over field, missing first point, poles and North and South halos
      DO 230 I=START_POINT_NO_HALO+1,LAST_U_VALID_PT
            DV_DLATITUDE2(I) = DV_DLATITUDE(I) + DV_DLATITUDE(I-1)
 230      CONTINUE

C NOW DO FIRST POINT ON EACH SLICE FOR DU_DLONGITUDE AND DV_DLATITUDE2
          I=START_POINT_NO_HALO-ROW_LENGTH
      DU_DLONGITUDE(I)=LONGITUDE_STEP_INVERSE*
     &                 (U_MW(I)-U_MW(I+ROW_LENGTH-1))
! Loop over the first point of each row between top and bottom rows
          DO 240 I=START_POINT_NO_HALO,END_P_POINT_NO_HALO,ROW_LENGTH
      DU_DLONGITUDE(I)=LONGITUDE_STEP_INVERSE*
     &                 (U_MW(I)-U_MW(I+ROW_LENGTH-1))
          DV_DLATITUDE2(I)=DV_DLATITUDE(I)+DV_DLATITUDE(I-1+ROW_LENGTH)
 240      CONTINUE

C CALCULATE DIVERGENCES

! Loop over field, missing top and bottom rows and North and South halos
      DO 250 J=START_POINT_NO_HALO,END_P_POINT_NO_HALO
            D(J)= SEC_P_LATITUDE(J)*.5*(DU_DLONGITUDE(J)
     *                           + DU_DLONGITUDE(J-ROW_LENGTH)
     *                           + DV_DLATITUDE2(J))
 250      CONTINUE

C CALCULATE DIVERGENCE AT POLES.
        SCALAR = LATITUDE_STEP_INVERSE*SEC_P_LATITUDE(TOP_ROW_START)/
     &           GLOBAL_ROW_LENGTH

        SUM_N = 0.0
        SUM_S = 0.0

! North Pole
! Loop over North Pole row
        DO I=TOP_ROW_START,TOP_ROW_START+ROW_LENGTH-1
          SUM_N=SUM_N-V_MW(I)
        ENDDO

! Set all points on North Pole row to this value
          DO I=TOP_ROW_START,TOP_ROW_START+ROW_LENGTH-1
            D(I)=SUM_N
          ENDDO

! South Pole
! Loop over South Pole row
        DO I=U_BOT_ROW_START,U_BOT_ROW_START+ROW_LENGTH-1
          SUM_S=SUM_S+V_MW(I)
        ENDDO

! Set all points on South Pole row to this value
          DO I=P_BOT_ROW_START,P_BOT_ROW_START+ROW_LENGTH-1
            D(I)=SUM_S
          ENDDO

CL
CL---------------------------------------------------------------------
CL    SECTION 3.     CALCULATE D(D)/D(LONGITUDE)
CL---------------------------------------------------------------------

! Loop over field, missing top and bottom rows and halos
      DO 300 I=START_POINT_NO_HALO,END_P_POINT_INC_HALO-1
            D_BY_DLONG(I) = (D(I+1) - D(I))*LONGITUDE_STEP_INVERSE
 300      CONTINUE

CL
CL---------------------------------------------------------------------
CL    SECTION 4.     CALCULATE D(D)/D(LATITUDE)
CL                   UPDATE V FIELD WITH DIVERGENCE.
CL                   UPDATE U FIELD WITH DIVERGENCE
CL                   IF GLOBAL CALL POLAR_UV TO UPDATE U AND V AT POLE.
CL---------------------------------------------------------------------

C----------------------------------------------------------------------
CL    SECTION 4.1    CALCULATE D(D)/D(LATITUDE)
C----------------------------------------------------------------------

! Loop over field, including Northern row but missing Southern row and
! top and bottom halos
          DO 410 I=START_POINT_NO_HALO-ROW_LENGTH,
     &              END_P_POINT_NO_HALO
            D_BY_DLAT(I) = (D(I)-D(I+ROW_LENGTH))*LATITUDE_STEP_INVERSE
 410      CONTINUE

C----------------------------------------------------------------------
CL    SECTION 4.2    UPDATE V FIELD WITH DIVERGENCE
CL                   UPDATE U FIELD WITH DIVERGENCE
C----------------------------------------------------------------------

C GLOBAL MODEL, CALCULATE SECOND V TERM IN EQUATION.
! Loop over field, including Northern row, but missing Southern row, and
! last point of last row, and top and bottom halos
          DO 420 I=START_POINT_NO_HALO-ROW_LENGTH,
     &              END_P_POINT_NO_HALO-1
            D_BY_DLAT2(I) =  KD(K)*.5*(D_BY_DLAT(I)+D_BY_DLAT(I+1))
     *                   *ADVECTION_TIMESTEP
 420      CONTINUE

C NOW DO END POINTS.
! Loop over last point of each row
          DO 424 I=START_POINT_NO_HALO+LAST_ROW_PT-1,
     &             END_P_POINT_NO_HALO,ROW_LENGTH
            D_BY_DLAT2(I)= KD(K)*.5*(D_BY_DLAT(I)+
     *                    D_BY_DLAT(I+1-ROW_LENGTH))*ADVECTION_TIMESTEP
C DO END POINTS FOR SECTION 3.1
          D_BY_DLONG(I)=(D(I+1-ROW_LENGTH)-D(I))*LONGITUDE_STEP_INVERSE
 424      CONTINUE

C DO FIRST END POINT OF SECTION 4.1.
          D_BY_DLAT2(TOP_ROW_START+LAST_ROW_PT-1)= KD(K)*.5*
     &      (D_BY_DLAT(TOP_ROW_START)+
     &       D_BY_DLAT(TOP_ROW_START+LAST_ROW_PT-1))*ADVECTION_TIMESTEP

C UPDATE U AND V FIELDS WITH DIVERGENCE

C UPDATE ALL POINTS.
! Loop over U field, missing Northern and Southern rows and top and
! bottom halos.
      DO 426 I=START_POINT_NO_HALO,END_U_POINT_NO_HALO-1
            SCALAR=1./(RS_U_GRID(I)*RS_U_GRID(I)*RS_U_GRID(I)
     *               *(DELTA_AK(K)+DELTA_BK(K)*PSTAR_OLD(I)))
            U(I,K) = U(I,K) + KD(K)*.5*(D_BY_DLONG(I)+
     *               D_BY_DLONG(I+ROW_LENGTH))
     *               *SEC_U_LATITUDE(I)*ADVECTION_TIMESTEP*SCALAR
            V(I,K) = V(I,K) + D_BY_DLAT2(I)*SCALAR
 426      CONTINUE

C----------------------------------------------------------------------
CL    SECTION 4.3    GLOBAL MODEL POLAR UPDATE OF U AND V.
C----------------------------------------------------------------------


CL    CALL POLAR_UV TO UPDATE U AND V.

          CALL POLAR_UV(U(1,K),V(1,K),ROW_LENGTH,U_FIELD,1,
     &  FIRST_ROW , TOP_ROW_START , P_LAST_ROW , U_LAST_ROW,
     &  P_BOT_ROW_START , U_BOT_ROW_START , upd_P_ROWS , upd_U_ROWS,
     &  FIRST_FLD_PT , LAST_P_FLD_PT , LAST_U_FLD_PT,
     &  FIRST_VALID_PT , LAST_P_VALID_PT , LAST_U_VALID_PT,
     &  VALID_P_ROWS, VALID_U_ROWS,
     &  START_POINT_NO_HALO, START_POINT_INC_HALO,
     &  END_P_POINT_NO_HALO, END_P_POINT_INC_HALO,
     &  END_U_POINT_NO_HALO, END_U_POINT_INC_HALO,
     &  FIRST_ROW_PT ,  LAST_ROW_PT , tot_P_ROWS , tot_U_ROWS,
     &  GLOBAL_ROW_LENGTH, GLOBAL_P_FIELD, GLOBAL_U_FIELD,
     &              COS_U_LONGITUDE,SIN_U_LONGITUDE)


        END IF
CL END LOOP OVER LEVELS

 100  CONTINUE

CL    END OF ROUTINE DIV_DAMP

      RETURN
      END
