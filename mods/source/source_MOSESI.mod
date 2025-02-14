*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/Orginal mod:  UVTOP_SEA
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*DECK UTPSEA
*IF DEF,C90_1A,OR,DEF,C90_2A,OR,DEF,C90_2B
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
CLL  SUBROUTINE UV_TO_P_SEA-----------------------------------------
CLL
CLL  Purpose:   Interpolates a horizontal sea field from wind to 
CLL             pressure points on an Arakawa B grid. Under UPDATE
CLL             identifier GLOBAL the data is assumed periodic along
CLL             rows. Otherwise, the first value on each row is set
CLL             eqal to the second value on each row . The output arra
CLL             contains one less row than the input array.
CLL
CLL  Not suitable for single column use.
CLL
CLL  Adapted from UVTOP by Nic Gedney (09/99)
CLL
CLL  Programming standard: Unified Model Documentation Paper No 3
CLL                        Version No 1 15/1/90
CLL
CLL  System component: S101
CLL
CLL  System task: S1
CLL
CLL  Documentation:  The equation it is based on is (2.1)
CLL                  in unified model documentation paper No. S1
CLL
CLLEND-------------------------------------------------------------
 
C
C*L  Arguments:---------------------------------------------------
      SUBROUTINE UV_TO_P_SEA
     1  (U_DATA,P_DATA,U_FIELD,P_FIELD,FLANDG_UV,ROW_LENGTH,ROWS)
 
      IMPLICIT NONE
 
      INTEGER
     *  ROWS               !IN    Number of rows to be updated.
     *, ROW_LENGTH         !IN    Number of points per row
     *, P_FIELD            !IN    Number of points in output field
     *, U_FIELD            !IN    Number of points in input field
 
      REAL
     * P_DATA(P_FIELD)     !OUT   Data on p  points
     *,U_DATA(U_FIELD)     !IN    Data on uv points
     *,FLANDG_UV(U_FIELD)   !IN    Land fraction on uv points
C*---------------------------------------------------------------------
 
C*L  Local arrays:-----------------------------------------------------
C    None
C*---------------------------------------------------------------------
*IF DEF,MPP
! Parameters and Common blocks
*CALL PARVARS
*ENDIF
 
C*L  External subroutine calls:----------------------------------------
C    None
C*---------------------------------------------------------------------
 
C----------------------------------------------------------------------
C    Define local variables
C----------------------------------------------------------------------
      INTEGER
     *  P_POINTS      !     Number of values at p points
     *,I              !     Horizontal loop indices
      REAL
     &  TOTFRAC
*IF DEF,MPP
      INTEGER J,extra
*ENDIF
 
C---------------------------------------------------------------------
CL    1.     Initialise local constants
C---------------------------------------------------------------------
 
      P_POINTS      =  ROW_LENGTH * (ROWS-1)
 
C---------------------------------------------------------------------
CL    2.     Calculate horizontal average at p points
C---------------------------------------------------------------------
 
      DO 200 I=2,P_POINTS
       TOTFRAC=4.0-(FLANDG_UV(I)+FLANDG_UV(I-1) +
     &         FLANDG_UV(I+ROW_LENGTH)+FLANDG_UV(I-1+ROW_LENGTH))
       IF(TOTFRAC.GT.0.0)THEN
         P_DATA(I)=(1.-FLANDG_UV(I))*U_DATA(I) +
     &           (1.-FLANDG_UV(I-1))*U_DATA(I-1) +
     &           (1.-FLANDG_UV(I+ROW_LENGTH))*U_DATA(I+ROW_LENGTH) +
     &           (1.-FLANDG_UV(I-1+ROW_LENGTH))*U_DATA(I-1+ROW_LENGTH)
         P_DATA(I)=P_DATA(I)/TOTFRAC
       ELSE
         P_DATA(I)=0.0
       ENDIF
200   CONTINUE
 
C  End points
 
*IF DEF,GLOBAL
 
*IF -DEF,MPP
      DO 201 I=1,P_POINTS,ROW_LENGTH
       TOTFRAC=4.0-(FLANDG_UV(I)+FLANDG_UV(I-1+ROW_LENGTH) +
     &         FLANDG_UV(I+ROW_LENGTH)+FLANDG_UV(I-1+2*ROW_LENGTH))
       IF(TOTFRAC.GT.0.0)THEN
         P_DATA(I)=(1.-FLANDG_UV(I))*U_DATA(I) +
     &         (1.-FLANDG_UV(I-1+ROW_LENGTH))*U_DATA(I-1+ROW_LENGTH) +
     &         (1.-FLANDG_UV(I+ROW_LENGTH))*U_DATA(I+ROW_LENGTH) +
     &         (1.-FLANDG_UV(I-1+2*ROW_LENGTH))*U_DATA(I-1+2*ROW_LENGTH)
         P_DATA(I)=P_DATA(I)/TOTFRAC
       ELSE
         P_DATA(I)=0.0
       ENDIF
201   CONTINUE
*ELSE
!  Cyclic wrap around already taken account of via halo
*ENDIF
*ELSE
C Set first values on each row equal to second values
*IF -DEF,MPP
      DO 201 I=1,P_POINTS,ROW_LENGTH
       P_DATA(I)=P_DATA(I+1)
201   CONTINUE
*ELSE
        IF (atleft) THEN
          DO I=1,P_POINTS,ROW_LENGTH
            P_DATA(I+Offx)=P_DATA(I+Offx+1)
          ENDDO
        ENDIF
*ENDIF
 
*ENDIF
*IF DEF,MPP
! and set a sensible number in the top left corner
      P_DATA(1)=P_DATA(2)
 
*ENDIF
 
      RETURN
      END
 
*ENDIF
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/Orginal mod:  ccouple
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*IDENT ccouple,DC=DOARAV1
*/
*/ This is a FAMOUS mod.
*/
*/[02]
*/       - ccouple 06Mar100SEVERITY MODTYPE
*/
*/       - Applies to level:
*/         6.1 ccouple
*/
*/       - Machine type:  ALL
*/
*/       - Description:
*/DELTA    DESCRIPTION
*/
*/       - Modules affected:  DOARAV1, TRANA2O1, TRANO2A1, SWAPA2O1, 
*/         SWAPO2A1, INITIAL1, INITA2O1
*/
*/       - Depends on the following mods for update:  OJG1F403, OOM3F403, 
*/         CJG6F401, @DYALLOC, GRR2F305, GSS2F305
*/
*/       - Depends on the following mods for execution:  NONE
*/
*/       - SPRs closed:  NONE
*/
*/       - TIRs closed:  NONE
*/
*/       - Supporting documents:  NONE
*/
*/DELTA  - Author: t20rt 
*/
*D OJG1F403.3
     &,DATA_TARG,ADJUST_TARG,ICODE,CMESSAGE)                            
*I OJG1F403.28    
     &,ADJUST_TARG(LROW_TARG,*)
*D DOARAV1.82,DOARAV1.83   
          IF (MASK_TARG(IX2,IY2).EQV.WANT) THEN                         
          IF (COUNT_TARG(IX2,IY2).NE.0) THEN                            
*I DOARAV1.91    
	    ELSE
	    IF(ADJUST.EQ.5)THEN
	    TEMP_TARG=0.0
	    ELSEIF(ADJUST.EQ.6)THEN
	    TEMP_TARG=1.0
	    ELSE
	    TEMP_TARG=DATA_TARG(IX2,IY2)
	    ENDIF
	    ENDIF
*I OJG1F403.54    
            ELSEIF (ADJUST.EQ.3) THEN
	      ADJUST_TARG(IX2,IY2)=DATA_TARG(IX2,IY2)-TEMP_TARG
            ELSEIF (ADJUST.EQ.4) THEN
	      IF (TEMP_TARG.EQ.0) THEN
		ADJUST_TARG(IX2,IY2)=1.0
              ELSE
	        ADJUST_TARG(IX2,IY2)=DATA_TARG(IX2,IY2)/TEMP_TARG
              ENDIF
            ELSEIF (ADJUST.EQ.5) THEN
              DATA_TARG(IX2,IY2)=DATA_TARG(IX2,IY2)+TEMP_TARG
	    ELSEIF (ADJUST.EQ.6) THEN
	      DATA_TARG(IX2,IY2)=DATA_TARG(IX2,IY2)*TEMP_TARG
*DC TRANA2O1
*I TRANA2O1.40    
     + FRAC,
*I TRANA2O1.120   
     + FRAC(ICOLS,JROWS),    ! IN FRACTIONAL LAND MASK
*I TRANA2O1.169   
     +,ADJUSTMENT(ICOLS,JROWS) ! RATIO/DELTA stored for 2nd do_areaver 
     +                       ! call. Assumes atm size:ICOLS & JROWS
     +,DUMMY(IMT,JMT)
*I OJG1F403.58    
     &,index_back(maxl)
*I OJG1F403.59    
     &,backweight(maxl)
*D OJG1F403.60
*D OJG1F403.64
*I OJG1F403.67    
*IF DEF,CSRV_TWO_WAY
C
C    New arrays required to invert the coupling fields during 
C    conservative interpolation
C
      REAL
     & wmixinv(imt,jmt)      ! wind mixing power 
     &,blueinv(imt,jmt)      ! penetrative solar
     &,heatinv(imt,jmt)      ! non penetrative heat fluxes
     &,pmininv(imt,jmt)      ! precipitation - evaporation
     &,riverinv(imt,jmt)     ! river outflow
     &,snowinv(imt,jmt)      ! snowfall
     &,sublminv(imt,jmt)     ! sublimation
     &,btmltinv(imt,jmt)     ! sea ice diffusive heat flux
     &,tpmltinv(imt,jmt)     ! sea ice top melt heat flux
C-----------------------------------------------------------------------
C
C    The coupling is done in 3 stages:
C
C    1  Atmospheric fields are interpolated onto the ocean grid
C    2  The ocean fields are back interpolated onto the atmospheric 
C       grid, and the ratio/difference between the original atmosphere. 
C       and the back-interpolated atmosphere is calculated.
C    3  The ratio/difference from 2 is then applied to the ocean 
C       field to give the correct oceanic values for conservation to 
C       be maintained.
C
C    The logic is as follows (assuming the atmosphere and ocean grids 
C    are orientated oppositely in latitude).
C
C    Pre_areaver calculates weights for A==>O and O==>A. The weights 
C    are valid for atmospheric mask amasktp, and inverted ocean, with 
C    inverted mask omaskd.
C
C    Stage 2: use Do_areaver from O==>A. Invert =true, results go onto 
C             atmospheric mask.
C
C    Stage 3: use Do_areaver from A==>O. Invert =false. The weights will
C             assume the ocean is inverted, therefore it must be 
C             flipped before do_areaver is used, and omaskd must 
C             be specified. The resulting ocean field will be upside dow
C             therefore it must be inverted again after do_areaver has 
C             been called.
C
C
C   Summary
C
C   *    pre_areaver called twice, A==>O(inverted) and O(inverted)==>A
C   *    field X is interpolated from A==>O
C   *    do_areaver O(inv)==>A produces the differences/ratios on the 
C        atmospheric mask
C   *    ocean field is inverted
C   *    do_areaver A==>O(inv) calculates new ocean field
C   *    ocean field is inverted
C=======================================================================
C
*I OOM3F403.4     
       REAL VALMAX,VALMIN             ! Field A==>O test variables
       REAL WRKMAX,WRKMIN
       PARAMETER(WRKMAX=-1.0e10,WRKMIN=1.0e10)
*I TRANA2O1.308   
      VALMAX=WRKMAX
      VALMIN=WRKMIN
      DO J=1,JMTM1
      DO I=1,IMT
      IF(USTRSOUT(I,J).GT.VALMAX)VALMAX=USTRSOUT(I,J)
      IF(USTRSOUT(I,J).LT.VALMIN)VALMIN=USTRSOUT(I,J)
      ENDDO
      ENDDO
*     WRITE(6,*)'USTRSOUT A==>O  MAX/MIN ',VALMAX,VALMIN
      VALMAX=WRKMAX
      VALMIN=WRKMIN
      DO J=1,JMTM1
      DO I=1,IMT
      IF(VSTRSOUT(I,J).GT.VALMAX)VALMAX=VSTRSOUT(I,J)
      IF(VSTRSOUT(I,J).LT.VALMIN)VALMIN=VSTRSOUT(I,J)
      ENDDO
      ENDDO
*     WRITE(6,*)'VSTRSOUT A==>O  MAX/MIN ',VALMAX,VALMIN
*I OJG1F403.73    
*IF DEF,CSRV_TWO_WAY
      call pre_areaver(irt,xuo,jmt,ocyd,global,imt,.false.
     &,omaskd,icols,xua,jrows,yua,.true.,.true.
     &,lenl,count_a,base_a,index_arav,weight,icode,cmessage)
      lenl=maxl
      call pre_areaver(icols,xua,jrows,yua,.true.,icols,.false.
     &,amasktp,irt,xuo,jmt,ocyd,global,.true.
     &,lenl,count_o,base_o,index_back,backweight,icode,cmessage)
*ELSE
*I TRANA2O1.374   
*ENDIF                                                                  
*I OJG1F403.80    
*IF DEF,CSRV_TWO_WAY
      call do_areaver(irt,jmt,imt,invert,wmixout,icols,jrows
     &,count_a,base_a,icols,.false.,amasktp,index_arav,weight,4
     &,wmixin,adjustment,icode,cmessage)
      if (invert.eqv..true.) then
        do j=1,jmt
          do i=1,imt
            wmixinv(i,j)=wmixout(i,jmt+1-j)
          enddo
        enddo
        call do_areaver(icols,jrows,icols,.false.,adjustment,irt,jmt,
     &   count_o,base_o,imt,.false.,omaskd,index_back,backweight,6,
     &   wmixinv,dummy,icode,cmessage)
        do j=1,jmt
          do i=1,imt
            wmixout(i,j)=wmixinv(i,jmt+1-j)
          enddo
        enddo
      else 
        call do_areaver(icols,jrows,icols,.false.,adjustment,irt,jmt,
     &    count_o,base_o,imt,.false.,omaskd,index_back,backweight,6,
     &    wmixout,dummy,icode,cmessage)
      endif
*ELSE
*D OJG1F403.83
     &,wmixin,adjustment,icode,cmessage)                                
*ENDIF
*D CJG6F401.95
     &,work,adjustment,icode,cmessage)                                  
*I TRANA2O1.387   
      VALMAX=WRKMAX
      VALMIN=WRKMIN
      DO J=1,JMT
      DO I=1,IMT
      IF(OMASKD(I,J).EQV..FALSE.)THEN
      IF(WMIXOUT(I,J).GT.VALMAX)VALMAX=WMIXOUT(I,J)
      IF(WMIXOUT(I,J).LT.VALMIN)VALMIN=WMIXOUT(I,J)
      ENDIF
      ENDDO
      ENDDO
*     WRITE(6,*)'WMIXOUT A==>O  MAX/MIN ',VALMAX,VALMIN
*I OJG1F403.87    
*IF DEF,CSRV_TWO_WAY
      call do_areaver(irt,jmt,imt,invert,blueout,icols,jrows
     &,count_a,base_a,icols,.false.,amasktp,index_arav,weight,4
     &,bluein,adjustment,icode,cmessage)
      if (invert.eqv..true.) then
        do j=1,jmt
          do i=1,imt
            blueinv(i,j)=blueout(i,jmt+1-j)
          enddo
        enddo
        call do_areaver(icols,jrows,icols,.false.,adjustment,irt,jmt,
     &    count_o,base_o,imt,.false.,omaskd,index_back,backweight,6,
     &    blueinv,dummy,icode,cmessage)
        do j=1,jmt
          do i=1,imt
            blueout(i,j)=blueinv(i,jmt+1-j)
          enddo
        enddo
      else
        call do_areaver(icols,jrows,icols,.false.,adjustment,irt,jmt,
     &    count_o,base_o,imt,.false.,omaskd,index_back,backweight,6,
     &    blueout,dummy,icode,cmessage)
      endif
*ELSE
*D OJG1F403.90
     &,bluein,adjustment,icode,cmessage)                                
*ENDIF
*D CJG6F401.102
     &,work,adjustment,icode,cmessage)                                  
*I TRANA2O1.412   
      VALMAX=WRKMAX
      VALMIN=WRKMIN
      DO J=1,JMT
      DO I=1,IMT
      IF(OMASKD(I,J).EQV..FALSE.)THEN
      IF(BLUEOUT(I,J).GT.VALMAX)VALMAX=BLUEOUT(I,J)
      IF(BLUEOUT(I,J).LT.VALMIN)VALMIN=BLUEOUT(I,J)
      ENDIF
      ENDDO
      ENDDO
*     WRITE(6,*)'BLUEOUT A==>O  MAX/MIN ',VALMAX,VALMIN
*I OJG1F403.94    
*IF DEF,CSRV_TWO_WAY
      call do_areaver(irt,jmt,imt,invert,heatflux,icols,jrows
     &,count_a,base_a,icols,.false.,amasktp,index_arav,weight,3
     &,worka,adjustment,icode,cmessage)
      if (invert.eqv..true.) then
        do j=1,jmt
          do i=1,imt
            heatinv(i,j)=heatflux(i,jmt+1-j)
          enddo
        enddo
        call do_areaver(icols,jrows,icols,.false.,adjustment,irt,jmt,
     &    count_o,base_o,imt,.false.,omaskd,index_back,backweight,5,
     &    heatinv,dummy,icode,cmessage)
        do j=1,jmt
          do i=1,imt
            heatflux(i,j)=heatinv(i,jmt+1-j)
          enddo
        enddo
      else
        call do_areaver(icols,jrows,icols,.false.,adjustment,irt,jmt,
     &    count_o,base_o,imt,.false.,omaskd,index_back,backweight,5,
     &    heatflux,dummy,icode,cmessage)
      endif
*ELSE
*D OJG1F403.97
     &,worka,adjustment,icode,cmessage)                                 
*ENDIF
*D CJG6F401.109
     &,work,adjustment,icode,cmessage)                                  
*I TRANA2O1.438   
      VALMAX=WRKMAX
      VALMIN=WRKMIN
      DO J=1,JMT
      DO I=1,IMT
      IF(OMASKD(I,J).EQV..FALSE.)THEN
      IF(HEATFLUX(I,J).GT.VALMAX)VALMAX=HEATFLUX(I,J)
      IF(HEATFLUX(I,J).LT.VALMIN)VALMIN=HEATFLUX(I,J)
      ENDIF
      ENDDO
      ENDDO
*     WRITE(6,*)'HEATFLUX A==>O  MAX/MIN ',VALMAX,VALMIN
*I OJG1F403.101   
*IF DEF,CSRV_TWO_WAY
      call do_areaver(irt,jmt,imt,invert,pminuse,icols,jrows
     &,count_a,base_a,icols,.false.,amasktp,index_arav,weight,3
     &,worka,adjustment,icode,cmessage)
      if (invert.eqv..true.) then
        do j=1,jmt
          do i=1,imt
            pmininv(i,j)=pminuse(i,jmt+1-j)
          enddo
        enddo
        call do_areaver(icols,jrows,icols,.false.,adjustment,irt,jmt,
     &    count_o,base_o,imt,.false.,omaskd,index_back,backweight,5,
     &    pmininv,dummy,icode,cmessage)
        do j=1,jmt
          do i=1,imt
            pminuse(i,j)=pmininv(i,jmt+1-j)
          enddo
        enddo
      else
        call do_areaver(icols,jrows,icols,.false.,adjustment,irt,jmt,
     &    count_o,base_o,imt,.false.,omaskd,index_back,backweight,5,
     &    pminuse,dummy,icode,cmessage)
      endif
*ELSE
*D OJG1F403.104
     &,worka,adjustment,icode,cmessage)                                 
*ENDIF
*D CJG6F401.116
     &,work,adjustment,icode,cmessage)                                  
*I TRANA2O1.469   
      VALMAX=WRKMAX
      VALMIN=WRKMIN
      DO J=1,JMT
      DO I=1,IMT
      IF(OMASKD(I,J).EQV..FALSE.)THEN
      IF(PMINUSE(I,J).GT.VALMAX)VALMAX=PMINUSE(I,J)
      IF(PMINUSE(I,J).LT.VALMIN)VALMIN=PMINUSE(I,J)
      ENDIF
      ENDDO
      ENDDO
*     WRITE(6,*)'PMINUSE A==>O  MAX/MIN ',VALMAX,VALMIN
*D TRANA2O1.488
c  Note River run off if there is some land
          IF (FRAC(I,J).GT.0.) THEN
*I TRANA2O1.492   
     &        FRAC(I,J)/(1.-FRAC(K,L)) *
*I OJG1F403.108   
*IF DEF,CSRV_TWO_WAY
      call do_areaver(irt,jmt,imt,invert,riverout,icols,jrows
     &,count_a,base_a,icols,.false.,amasktp,index_arav,weight,4
     &,worka,adjustment,icode,cmessage)
      if (invert.eqv..true.) then
        do j=1,jmt
          do i=1,imt
            riverinv(i,j)=riverout(i,jmt+1-j)
          enddo
        enddo
        call do_areaver(icols,jrows,icols,.false.,adjustment,irt,jmt,
     &    count_o,base_o,imt,.false.,omaskd,index_back,backweight,6,
     &    riverinv,dummy,icode,cmessage)
        do j=1,jmt
          do i=1,imt
            riverout(i,j)=riverinv(i,jmt+1-j)
          enddo
        enddo
      else
        call do_areaver(icols,jrows,icols,.false.,adjustment,irt,jmt,
     &    count_o,base_o,imt,.false.,omaskd,index_back,backweight,6,
     &    riverout,dummy,icode,cmessage)
      endif
*ELSE
*D OJG1F403.111
     &,worka,adjustment,icode,cmessage)                                 
*ENDIF
*D CJG6F401.123
     &,work,adjustment,icode,cmessage)                                  
*I TRANA2O1.506   
      VALMAX=WRKMAX
      VALMIN=WRKMIN
      DO J=1,JMT
      DO I=1,IMT
      IF(OMASKD(I,J).EQV..FALSE.)THEN
      IF(RIVEROUT(I,J).GT.VALMAX)VALMAX=RIVEROUT(I,J)
      IF(RIVEROUT(I,J).LT.VALMIN)VALMIN=RIVEROUT(I,J)
      ENDIF
      ENDDO
      ENDDO
*     WRITE(6,*)'RIVEROUT A==>O  MAX/MIN ',VALMAX,VALMIN
*I OJG1F403.115   
*IF DEF,CSRV_TWO_WAY
      call do_areaver(irt,jmt,imt,invert,snowout,icols,jrows
     &,count_a,base_a,icols,.false.,amasktp,index_arav,weight,4
     &,worka,adjustment,icode,cmessage)
      if (invert.eqv..true.) then
        do j=1,jmt
          do i=1,imt
            snowinv(i,j)=snowout(i,jmt+1-j)
          enddo
        enddo
        call do_areaver(icols,jrows,icols,.false.,adjustment,irt,jmt,
     &    count_o,base_o,imt,.false.,omaskd,index_back,backweight,6,
     &    snowinv,dummy,icode,cmessage)
        do j=1,jmt
          do i=1,imt
            snowout(i,j)=snowinv(i,jmt+1-j)
          enddo
        enddo
      else
        call do_areaver(icols,jrows,icols,.false.,adjustment,irt,jmt,
     &    count_o,base_o,imt,.false.,omaskd,index_back,backweight,6,
     &    snowout,dummy,icode,cmessage)
      endif
*ELSE
*D OJG1F403.118
     &,worka,adjustment,icode,cmessage)                                 
*ENDIF
*D CJG6F401.131
     &,work,adjustment,icode,cmessage)                                  
*I TRANA2O1.531   
      VALMAX=WRKMAX
      VALMIN=WRKMIN
      DO J=1,JMT
      DO I=1,IMT
      IF(OMASKD(I,J).EQV..FALSE.)THEN
      IF(SNOWOUT(I,J).GT.VALMAX)VALMAX=SNOWOUT(I,J)
      IF(SNOWOUT(I,J).LT.VALMIN)VALMIN=SNOWOUT(I,J)
      ENDIF
      ENDDO
      ENDDO
*     WRITE(6,*)'SNOWOUT A==>O  MAX/MIN ',VALMAX,VALMIN
*I OJG1F403.122   
*IF DEF,CSRV_TWO_WAY
      call do_areaver(irt,jmt,imt,invert,sublmout,icols,jrows
     &,count_a,base_a,icols,.false.,amasktp,index_arav,weight,3
     &,sublmin,adjustment,icode,cmessage)
      if (invert.eqv..true.) then
        do j=1,jmt
          do i=1,imt
            sublminv(i,j)=sublmout(i,jmt+1-j)
          enddo
        enddo
        call do_areaver(icols,jrows,icols,.false.,adjustment,irt,jmt,
     &    count_o,base_o,imt,.false.,omaskd,index_back,backweight,5,
     &    sublminv,dummy,icode,cmessage)
        do j=1,jmt
          do i=1,imt
            sublmout(i,j)=sublminv(i,jmt+1-j)
          enddo
        enddo
      else
        call do_areaver(icols,jrows,icols,.false.,adjustment,irt,jmt,
     &    count_o,base_o,imt,.false.,omaskd,index_back,backweight,5,
     &    sublmout,dummy,icode,cmessage)
      endif
*ELSE
*D OJG1F403.125
     &,sublmin,adjustment,icode,cmessage)                               
*ENDIF
*D CJG6F401.138
     &,work,adjustment,icode,cmessage)                                  
*I TRANA2O1.544   
      VALMAX=WRKMAX
      VALMIN=WRKMIN
      DO J=1,JMT
      DO I=1,IMT
      IF(OMASKD(I,J).EQV..FALSE.)THEN
      IF(SUBLMOUT(I,J).GT.VALMAX)VALMAX=SUBLMOUT(I,J)
      IF(SUBLMOUT(I,J).LT.VALMIN)VALMIN=SUBLMOUT(I,J)
      ENDIF
      ENDDO
      ENDDO
*     WRITE(6,*)'SUBLMOUT A==>O  MAX/MIN ',VALMAX,VALMIN
*I OJG1F403.129   
*IF DEF,CSRV_TWO_WAY
      call do_areaver(irt,jmt,imt,invert,btmltout,icols,jrows
     &,count_a,base_a,icols,.false.,amasktp,index_arav,weight,3
     &,btmltin,adjustment,icode,cmessage)
      if (invert.eqv..true.) then
        do j=1,jmt
          do i=1,imt
            btmltinv(i,j)=btmltout(i,jmt+1-j)
          enddo
        enddo
        call do_areaver(icols,jrows,icols,.false.,adjustment,irt,jmt,
     &    count_o,base_o,imt,.false.,omaskd,index_back,backweight,5,
     &    btmltinv,dummy,icode,cmessage)
        do j=1,jmt
          do i=1,imt
            btmltout(i,j)=btmltinv(i,jmt+1-j)
          enddo
        enddo
      else
        call do_areaver(icols,jrows,icols,.false.,adjustment,irt,jmt,
     &    count_o,base_o,imt,.false.,omaskd,index_back,backweight,5,
     &    btmltout,dummy,icode,cmessage)
      endif
*ELSE
*D OJG1F403.132
     &,btmltin,adjustment,icode,cmessage)                               
*ENDIF
*D CJG6F401.145
     &,work,adjustment,icode,cmessage)                                  
*I TRANA2O1.557   
      VALMAX=WRKMAX
      VALMIN=WRKMIN
      DO J=1,JMT
      DO I=1,IMT
      IF(OMASKD(I,J).EQV..FALSE.)THEN
      IF(BTMLTOUT(I,J).GT.VALMAX)VALMAX=BTMLTOUT(I,J)
      IF(BTMLTOUT(I,J).LT.VALMIN)VALMIN=BTMLTOUT(I,J)
      ENDIF
      ENDDO
      ENDDO
*     WRITE(6,*)'BTMLTOUT A==>O  MAX/MIN ',VALMAX,VALMIN
*I OJG1F403.136   
*IF DEF,CSRV_TWO_WAY
      call do_areaver(irt,jmt,imt,invert,tpmltout,icols,jrows
     &,count_a,base_a,icols,.false.,amasktp,index_arav,weight,4
     &,tpmltin,adjustment,icode,cmessage)
      if (invert.eqv..true.) then
        do j=1,jmt
          do i=1,imt
            tpmltinv(i,j)=tpmltout(i,jmt+1-j)
          enddo
        enddo
        call do_areaver(icols,jrows,icols,.false.,adjustment,irt,jmt,
     &    count_o,base_o,imt,.false.,omaskd,index_back,backweight,6,
     &    tpmltinv,dummy,icode,cmessage)
        do j=1,jmt
          do i=1,imt
            tpmltout(i,j)=tpmltinv(i,jmt+1-j)
          enddo
        enddo
      else
        call do_areaver(icols,jrows,icols,.false.,adjustment,irt,jmt,
     &    count_o,base_o,imt,.false.,omaskd,index_back,backweight,6,
     &    tpmltout,dummy,icode,cmessage)
      endif
*ELSE
*D OJG1F403.139
     &,tpmltin,adjustment,icode,cmessage)                               
*ENDIF
*D CJG6F401.152
     &,work,adjustment,icode,cmessage)                                  
*I TRANA2O1.570   
      VALMAX=WRKMAX
      VALMIN=WRKMIN
      DO J=1,JMT
      DO I=1,IMT
      IF(OMASKD(I,J).EQV..FALSE.)THEN
      IF(TPMLTOUT(I,J).GT.VALMAX)VALMAX=TPMLTOUT(I,J)
      IF(TPMLTOUT(I,J).LT.VALMIN)VALMIN=TPMLTOUT(I,J)
      ENDIF
      ENDDO
      ENDDO
*     WRITE(6,*)'TPMLTOUT A==>O  MAX/MIN ',VALMAX,VALMIN
*DC TRANO2A1
*D TRANO2A1.140
     +,I,J,K                 ! Working indices                          
*I TRANO2A1.202   
     &,DUMMY(IMT,JMT)          ! Dummy argument (for DO_AREAVER)
*I TRANO2A1.210   
      REAL VALMAX,VALMIN      ! Max & min values passed O--> A
      REAL WRKMAX,WRKMIN      ! Max & min work start points
      PARAMETER(WRKMAX=-1.0e10,WRKMIN=1.0e10)
*D OJG1F403.146
     &,0,UOUT,DUMMY,ICODE,CMESSAGE)                                     
*D OJG1F403.150
     &,0,VOUT,DUMMY,ICODE,CMESSAGE)  
*D OJG1F403.154
     &,0,AICEOUT,DUMMY,ICODE,CMESSAGE)                                  
*D TRANO2A1.536
	  IF(INVERT)THEN
	  K=JMT+1-J
	  ELSE
	  K=J
	  ENDIF
          IF (OMASK(I,K).EQV..FALSE.) THEN                              
*D OJG1F403.158
     &,0,WORK_A,DUMMY,ICODE,CMESSAGE)                                   
*D TRANO2A1.570
        IF (AMASKTP(I,J).EQV..FALSE.) THEN                              
*D TRANO2A1.584
	IF(INVERT)THEN
	K=JMT+1-J
	ELSE
	K=J
	ENDIF
        IF (OMASK(I,K).EQV..FALSE.)                                     
*D OJG1F403.162
     &,0,HSNOWOUT,DUMMY,ICODE,CMESSAGE)                                 
*D OJG1F403.166
     &,0,WORK_A,DUMMY,ICODE,CMESSAGE)                                   
*D TRANO2A1.630
C*IF DEF,SEAICE                                                         
*D TRANO2A1.640,TRANO2A1.654  
C     DO 420 J = 1,JROWS                                                
C       DO 415 I = 1,ICOLS                                              
C         IF (WORK_A(I,J) .NE. RMDI) THEN                               
C           IF (AICEOUT(I,J) .EQ. 0.0) THEN                             
C             TSTAROUT(I,J) = WORK_A(I,J) + ZERODEGC                    
C           ELSEIF (AICEREF(I,J) .GE. AICEMIN) THEN                     
C             TSTAROUT(I,J) = TFS + ( AICEOUT(I,J)/AICEREF(I,J) )       
C    +                             *( TSTAROUT(I,J) - TFS )             
C           ELSE                                                        
C             TSTAROUT(I,J) = TFS                                       
C           ENDIF                                                       
C         ENDIF                                                         
C415     CONTINUE                                                       
C420   CONTINUE                                                         
C*ELSE                                                                  
*D TRANO2A1.657
          IF (AMASKTP(I,J) .EQV..FALSE.) THEN                           
*D TRANO2A1.660,TRANO2A1.662  
 425     CONTINUE                                                       
 430   CONTINUE                                                         
C*ENDIF
*DC SWAPA2O2
*B SWAPA2O2.159
      REAL FLAND_GLO(G_P_FIELD),FLAND_LOC(P_FIELD)
      LOGICAL AMASKTP(G_P_FIELD)
*I SWAPA2O2.345   
*IF DEF,TRANGRID,OR,DEF,RIVERS
      CALL FROM_LAND_POINTS(FLAND_LOC,D1(JUSER_ANC1),
     & atmos_landmask_local,
     & lasize(1)*lasize(2),number_of_landpts_out)

      CALL GATHER_FIELD(FLAND_LOC,FLAND_GLO,
     & lasize(1),lasize(2),glsize(1),glsize(2),
     & gather_pe,GC_ALL_PROC_GROUP,info)
      IF(mype.EQ.gather_pe) THEN
        DO I=1,G_P_FIELD
        AMASKTP(I)=(FLAND_GLO(I).EQ.1.0)
        ENDDO
      ENDIF
*ENDIF
*D SWAPA2O2.481   
     + AMASKTP,FLAND_GLO,
*DC SWAPO2A2
*I SWAPO2A2.162    
*IF DEF,TRANGRID
      LOGICAL
     &       AMASK(G_P_FIELD)
      REAL FLAND_GLO(G_P_FIELD),FLAND_LOC(P_FIELD)
      INTEGER NLANDPT
*ENDIF
*I SWAPO2A2.319   
*IF DEF,TRANGRID
C
C Unpack the fractional land mask, reassign land fraction of 0.0 to the 
C points where there is no land (previously missing data) and 
C define a mask which is .true. over all points that are land only.
C Transo2a will take effect only where this mask is .false. (some 
C sea).
C
      CALL FROM_LAND_POINTS(FLAND_LOC,D1(JUSER_ANC1),
     & atmos_landmask_local,
     & lasize(1)*lasize(2),NLANDPT)

*     write(6,*) 'lasize(1,2),nlandpt: ',lasize(1),lasize(2),nlandpt
*     write(6,*) 'atmos_landmask_local: ',atmos_landmask_local
*     write(6,*) 'FLAND_LOC: ',FLAND_LOC

      do i=1,p_field
        if (fland_loc(i).eq.rmdi) fland_loc(i)=0
      enddo
*     write(6,*) 'FLAND_LOC zeroed: ',FLAND_LOC


      CALL GATHER_FIELD(FLAND_LOC,FLAND_GLO,
     & lasize(1),lasize(2),glsize(1),glsize(2),
     & gather_pe,GC_ALL_PROC_GROUP,info)
      IF(info.NE.0) THEN      ! Check return code
         CMESSAGE='SWAPO2A : ERROR in gather of FLAND_GLO'
         ICODE=20
         GO TO 999
      ENDIF

      if(mype.eq.gather_pe) then
      DO I=1,G_P_FIELD
        AMASK(I)=(FLAND_GLO(I).EQ.1.0)
*       WRITE(6,*)'FLAND_GLO',AMASK(I),FLAND_GLO(I)
      ENDDO
      ENDIF
*ENDIF
*D SWAPO2A2.332
     & XUO,XTO,YUO,YTO,XTA,XUA,YTA,YUA,AMASK,                           
*I SWAPO2A2.407
*/ need to add this to the MPP version, since omitted initially
*/ back on the standard atmosphere decomposition
C
C     Diagnose the new grid box means for TSTAR based upon the
C     open sea surface temperature (field 407/TSTAR_SEA)
C     which is passed by TRANSO2A
C
      DO I=0,P_FIELD-1
c        IF(atmos_landmask_local(i+1).EQV..FALSE.)THEN
        IF(fland_loc(i+1).NE.1.)THEN
c       IF(AMASK(I+1).EQV..FALSE.)THEN
c          IF(LTLEADS.EQV..FALSE.) D1(JTSTAR_SEA+I)=TFS
          IF((LTLEADS.EQV..FALSE.).AND.(D1(JICE_FRACTION+I).GT.0))
     &          D1(JTSTAR_SEA+I)=TFS
          D1(JTSTAR_SICE+I)=AMIN1(D1(JTSTAR_SICE+I),TFS)
          D1(JTSTAR_SSI+I) =D1(JICE_FRACTION+I) *D1(JTSTAR_SICE+I)+
     &                 (1.0-D1(JICE_FRACTION+I))*D1(JTSTAR_SEA+I)
        ENDIF
        D1(JTSTAR+I)=FLAND_LOC(I+1) *D1(JTSTAR_LAND+I)+
     &          (1.0-FLAND_LOC(I+1))*D1(JTSTAR_SSI+I)
      ENDDO

      CALL SWAPBOUNDS(D1(JTSTAR),lasize(1),lasize(2),offx,offy,
     &                   swap_levels)
      CALL SET_SIDES(D1(JTSTAR),lasize(1)*lasize(2),lasize(1),
     &                   swap_levels,fld_type_p)

      CALL SWAPBOUNDS(D1(JTSTAR_SICE),lasize(1),lasize(2),offx,offy,
     &                   swap_levels)
      CALL SET_SIDES(D1(JTSTAR_SICE),lasize(1)*lasize(2),lasize(1),
     &                   swap_levels,fld_type_p)

      CALL SWAPBOUNDS(D1(JTSTAR_SSI),lasize(1),lasize(2),offx,offy,
     &                   swap_levels)
      CALL SET_SIDES(D1(JTSTAR_SSI),lasize(1)*lasize(2),lasize(1),
     &                   swap_levels,fld_type_p)

      CALL SWAPBOUNDS(D1(JTSTAR_SEA),lasize(1),lasize(2),offx,offy,
     &                   swap_levels)
      CALL SET_SIDES(D1(JTSTAR_SEA),lasize(1)*lasize(2),lasize(1),
     &                   swap_levels,fld_type_p)


*DC INITA2O1
*D GSS2F305.117
      CALL FINDPTR(ATMOS_IM, 3,392,                                     
*D INITA2O1.99
        ICODE=3392                                                      
*D GSS2F305.118
      CALL FINDPTR(ATMOS_IM, 3,394,                                     
*D INITA2O1.121
        ICODE=3394                                                      
*D GSS2F305.121
      CALL FINDPTR(ATMOS_IM, 1,250,                                     
*D INITA2O1.179
        ICODE=1250                                                      
*D GSS2F305.129
      CALL FINDPTR(ATMOS_IM, 3,351,                                     
*D INITA2O1.329
        ICODE=3351                                                      
*D INITA2O1.449
      JA_TSTAR=JTSTAR_SEA                                               
*D INITA2O1.451
        ICODE=407                                                       
*D INITA2O1.522
        ICODE=407                                                       
*/
*/       - End of mod ccouple
*/
*/ ------------------------------------------------------------------
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/Orginal mod:  ctile_09_new_param_ftlfix
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*ID CTILE0
*/---------------------------------------------------------------------------
*/---------------------------------------------------------------------------
*/ Extra diagnostics/prognostics on land/sea points
*/ 
*/ This is a FAMOUS mod.
*/ 
*/ comment out C_ROUGH bit - because it clashed with params_in_namelist.mod.
*/  Should now be used in conjunction with params_in_namelist_famous.mod
*/ CDJ - 3/9/02
*/
*/---------------------------------------------------------------------------
*/---------------------------------------------------------------------------
*/.......................................................................
*/-----------------------------------------------------------------------
*DECLARE BL_IC5A
*D BL_IC5A.71    
     & CO2_MMR,PHOTOSYNTH_ACT_RAD,PSTAR,RADNET_LAND,RADNET_SICE,
     & TIMESTEP, 
*/
*D BL_IC5A.75    
     & GS,Q,STHF,STHU,T,T_DEEP_SOIL,TI,
     & TSTAR_LAND,TSTAR_SEA,TSTAR_SICE,TSTAR_SSI,TSTAR,
*/ Not updating JZ0 with Z0MSEA, writing this to a separate
*/ Diagnostic instead:
     & U,V,Z0MSEA,
*D BL_IC5A.78,79
     & CD,CD_LAND,CD_SSI,CH,CH_LAND,CH_SSI,E_SEA,ETRAN,
     & FQW,FQW_LAND,FQW_SSI,FTL,FTL_LAND,FTL_SSI,GPP,H_SEA,
     & NPP,RESP_P,RHOKH,RHOKM,RIB,RIB_LAND,RIB_SSI,
     & SEA_ICE_HTF,
*D ARN0F405.130   
     & TAUX,TAUX_LAND,TAUX_SSI,TAUY,TAUY_LAND,TAUY_SSI,
     & VSHR,VSHR_LAND,VSHR_SSI,ZHT,
*/
*D ANG1F405.51    
     & EPOT,EPOT_LAND,EPOT_SSI,FSMC,FLANDG,
*/
*D BL_IC5A.84    
     & Q1P5M,Q1P5M_LAND,Q1P5M_SSI,T1P5M,T1P5M_LAND,T1P5M_SSI,
     & U10M,U10M_LAND,U10M_SSI,V10M,V10M_LAND,V10M_SSI,
*D BL_IC5A.86
     & SFME,SIMLT,SMLT,SLH,SQ1P5,ST1P5,SU10,SV10,
*D BL_IC5A.96,97
     + ECAN,EI,EI_LAND,EI_SICE,ES,EXT,SNOWMELT,
     & SURF_HT_FLUX_LAND,SURF_HT_FLUX_SICE,
     & ZH,T1_SD,Q1_SD,ERROR,
*/-----------------------------------------------------------------------
*/.......................................................................
*/-----------------------------------------------------------------------
*DECLARE BL_CTL1
*I GDR6F405.87
CLL            08/99 Allow for the inclusion of coastal tiles, i.e.
CLL                  land and sea and sea-ice may coexist on the same
CLL                  grid box. Requires the splitting up of all the
CLL                  surface fluxes into land, sea and sea-ice
CLL                  components. Separate temperatures are also
CLL                  required. Some global variables (SNOW_SUBLIMATION,
CLL                  SURF_HT_FLUX,SURF_RADFLUX,SURF_RADFLUX) 
CLL                  passed to other physics sections have been
CLL                  replaced by land/sea-only equivalents 
CLL                  (SNOW_SUB_LAND,SURF_HT_FLUX_LAND,
CLL                  SURF_RADFLUX_LAND,SURF_RADFLUX_SICE).
CLL                                            N. Gedney
*/
*D AJS1F401.217   
      SUBROUTINE BL_CTL(CLOUD_FRACTION,SNOW_SUB_LAND,SNOWMELT,
*/
*D AJS1F401.219   
     &           SOIL_EVAPORATION,SURF_HT_FLUX_LAND,
     &           SURF_RADFLUX_LAND,SURF_RADFLUX_SICE,
*/
*D AJS1F401.304   
*D GDR4F305.29 
     & STASHWORK(SI(219,3,im_index)),
     & STASHWORK(SI(391,3,im_index)),STASHWORK(SI(392,3,im_index)),
     & STASHWORK(SI(220,3,im_index)),
     & STASHWORK(SI(393,3,im_index)),STASHWORK(SI(394,3,im_index)),
     & WORK3,
     & STASHWORK(SI(389,3,im_index)),STASHWORK(SI(390,3,im_index)),
*/
*D ARN0F405.26    
*/
*D AJS1F401.228   
     &       SURF_HT_FLUX_LAND(P_FIELDDA),         !
     &       SURF_HT_FLUX_SICE(P_FIELDDA),         !
*/
*D AJS1F400.214 
     &       SNOW_SUBLIMATION(P_FIELDDA),          !
     &       SNOW_SUB_LAND(P_FIELDDA),             ! to other sections
     &       SNOW_SUB_SEA(P_FIELDDA),              !
*/
*D @DYALLOC.647
     &       SURF_RADFLUX_LAND(P_FIELDDA),         !
     &       SURF_RADFLUX_SICE(P_FIELDDA),         !
*/
*I AJS1F401.238
     &      ,WORK11(LAND_FIELDDA)
     &      ,WORK12(LAND_FIELDDA)
     &      ,WORK13(LAND_FIELDDA)
*/
*D ANG1F405.5     
     &,       EPOT(P_FIELDDA)            ! potential evaporation
     &,       EPOT_LAND(LAND_FIELDDA)    ! land potential evap
     &,       EPOT_SSI(P_FIELDDA)        ! mean sea potential evap
*/
*I ANG1F405.6
     &,       FLANDG(P_FIELDDA)          ! land fraction
*/
*D BL_CTL1.138   
        SNOW_SUBLIMATION(I) = 0.0
        SNOW_SUB_LAND(I) = 0.0
        SNOW_SUB_SEA(I) = 0.0
*/
*D AJS1F401.256    
        SURF_HT_FLUX_LAND(I) = 0.0     
        SURF_HT_FLUX_SICE(I) = 0.0  
*/
*D AYY1F404.65 
     & SURF_RADFLUX_LAND,SURF_RADFLUX_SICE,
     & SECS_PER_STEPim(atmos_im),L_RMBL,
*/
*/ Make stashflags depend on GBM and land/sea only diagnostics
*D TJ181193.4,5
      SF225=SF(225,3).OR.SF(249,3).OR.SF(368,3).OR.SF(369,3)
      SF226=SF(226,3).OR.SF(249,3).OR.SF(372,3).OR.SF(373,3)
*D BL_CTL1.123
      SF236=SF(236,3).OR.SF(237,3).OR.SF(360,3).OR.SF(361,3).OR.
*D BL_CTL1.125
      SF237=SF(237,3).OR.SF(236,3).OR.SF(364,3).OR.SF(365,3).OR.
*D ARE1F405.18,30
C Item 380 surface net radiation over land

      IF (SF(380,3)) THEN 

        CALL COPYDIAG(STASHWORK(SI(380,3,im_index)),SURF_RADFLUX_LAND,
     &       FIRST_POINT,LAST_POINT,P_FIELD,ROW_LENGTH,
     &       im_ident,3,380,
*CALL ARGPPX
     &       ICODE,CMESSAGE)

        IF (ICODE .GT. 0) GOTO 9999

      END IF

C Item 381 surface net radiation over sea-ice

      IF (SF(381,3)) THEN 

        CALL COPYDIAG(STASHWORK(SI(381,3,im_index)),SURF_RADFLUX_SICE,
     &       FIRST_POINT,LAST_POINT,P_FIELD,ROW_LENGTH,
     &       im_ident,3,381,
*CALL ARGPPX
     &       ICODE,CMESSAGE)

        IF (ICODE .GT. 0) GOTO 9999

      END IF
*/
*/ ----------------------------------------------------------------
*/ call bl_ic5a
*D AJS1F401.297   
     & D1(JZ0),D1(JOROG_SIL),L_Z0_OROG,D1(JOROG_HO2),
     & D1(JUSER_ANC1),
*D AJS1F401.306,307     
     & CANOPY_EVAPORATION,SNOW_SUBLIMATION,
     & SNOW_SUB_LAND,SNOW_SUB_SEA,
     & SOIL_EVAPORATION,EXT,SNOWMELT,
     & SURF_HT_FLUX_LAND,SURF_HT_FLUX_SICE,
*/
*D AJS1F400.225,226
     & D1(J_DEEP_SOIL_TEMP(1)),D1(JTI),
     & D1(JTSTAR_LAND),D1(JTSTAR_SEA),D1(JTSTAR_SICE),
     & D1(JTSTAR_SSI),D1(JTSTAR),
*/ Not updating JZ0 with Z0MSEA, writing this to a separate
*/ Diagnostic instead:
     & D1(JU(1)),D1(JV(1)),D1(JZ0_SSI),
*/ work1,work2 =cd and ch resp.
*D AJS1F400.227
     & WORK1,
     & STASHWORK(SI(330,3,im_index)),STASHWORK(SI(331,3,im_index)),
     & WORK2,
     & STASHWORK(SI(334,3,im_index)),STASHWORK(SI(335,3,im_index)),
*/ moisture and heat fluxes
*D AJS1F401.302   
     & STASHWORK(SI(223,3,im_index)),
     & WORK12,STASHWORK(SI(347,3,im_index)),
     & STASHWORK(SI(217,3,im_index)),
     & WORK11,STASHWORK(SI(343,3,im_index)),
*/ stash 208=rib
*D GDR4F305.27
     & STASHWORK(SI(208,3,im_index)),
     & STASHWORK(SI(338,3,im_index)),STASHWORK(SI(339,3,im_index)),
     & STASHWORK(SI(201,3,im_index)),
*/
*D ANG1F405.1     
     & EPOT,EPOT_LAND,EPOT_SSI,FSMC,FLANDG,
*/ 1.5m and 10m diags:
*D GDR4F305.31
     & STASHWORK(SI(234,3,im_index)),
*/
*D GDR4F305.32
     & STASHWORK(SI(237,3,im_index)),
     & STASHWORK(SI(360,3,im_index)),
     & STASHWORK(SI(361,3,im_index)),
*/
     & STASHWORK(SI(236,3,im_index)),
     & STASHWORK(SI(364,3,im_index)),
     & STASHWORK(SI(365,3,im_index)),
*/
     & STASHWORK(SI(225,3,im_index)),
     & STASHWORK(SI(368,3,im_index)),
     & STASHWORK(SI(369,3,im_index)),
*D ANG1F405.7     
     & STASHWORK(SI(226,3,im_index)),
     & STASHWORK(SI(372,3,im_index)),
     & STASHWORK(SI(373,3,im_index)),
*/
*/ ----------------------------------------------------------------
*/

*/*I  ASJ1F304.115
*/         TMP_X=0.0
*/         TMP_Y=1./TMP_X
*/         TMP_Y=TMP_Y+1./TMP_X
*/         IF(TMP_X.EQ.0.0)CALL ABORT

*I ANG1F405.38
C
C Item 382 potential evaporation over land
C
      IF (SF(382,3)) THEN
        DO I=1,LAND_FIELDDA
          WORK13(I)=EPOT_LAND(I)*SECS_PER_STEPim(a_im)
        ENDDO
C
        CALL FROM_LAND_POINTS(STASHWORK(SI(382,3,im_index)),
     &           WORK13,D1(JLAND),P_FIELD,LAND_FIELD)
      END IF
C
C Item 383 potential evaporation over sea-ice
C
      IF (SF(383,3)) THEN
C
        CALL COPYDIAG(STASHWORK(SI(383,3,im_index)),EPOT_SSI,
     &       FIRST_POINT,LAST_POINT,P_FIELD,ROW_LENGTH,
     &       im_ident,3,383,
*CALL ARGPPX
     &       ICODE,CMESSAGE)
C
        IF (ICODE .GT. 0) GOTO 9999
        DO I=FIRST_VALID_PT,LAST_P_VALID_PT
          STASHWORK(SI(383,3,im_index)+I-1)=
     &    STASHWORK(SI(383,3,im_index)+I-1)*SECS_PER_STEPim(a_im)
        END DO
C
      END IF
C
C Item 386 potential evaporation rate over land (kg/m2/s)
C
      IF (SF(386,3)) THEN
        CALL FROM_LAND_POINTS(STASHWORK(SI(386,3,im_index)),
     &           EPOT_LAND,D1(JLAND),P_FIELD,LAND_FIELD)
      END IF
C
C Item 387 potential evaporation rate over sea-ice (kg/m2/s)
C
      IF (SF(387,3)) THEN

        CALL COPYDIAG(STASHWORK(SI(387,3,im_index)),EPOT_SSI,
     &       FIRST_POINT,LAST_POINT,P_FIELD,ROW_LENGTH,
     &       im_ident,3,387,
*CALL ARGPPX
     &       ICODE,CMESSAGE)

        IF (ICODE .GT. 0) GOTO 9999

      END IF
C
*/
*D BL_CTL1.325,328
*D GDR4F305.45
*D GPB1F403.432,437
*D APBGF401.80
*D GDR4F305.46
*D ADR1F305.52
*D BL_CTL1.334,336
C Item 231 snow sublimation

      IF (SF(231,3)) THEN

        CALL COPYDIAG(STASHWORK(SI(231,3,im_index)),SNOW_SUBLIMATION,
     &       FIRST_POINT,LAST_POINT,P_FIELD,ROW_LENGTH,
     &       im_ident,3,231,
CALL ARGPPX
     &       ICODE,CMESSAGE)

        IF (ICODE .GT. 0) GOTO 9999
        DO I=FIRST_VALID_PT,LAST_P_VALID_PT
          STASHWORK(SI(231,3,im_index)+I-1)=
     &    STASHWORK(SI(231,3,im_index)+I-1)*SECS_PER_STEPim(a_im)
        END DO

      END IF
C
C Item 350 snow sublimation over land
C
      IF (SF(350,3)) THEN
C
        CALL COPYDIAG(STASHWORK(SI(350,3,im_index)),SNOW_SUB_LAND,
     &       FIRST_POINT,LAST_POINT,P_FIELD,ROW_LENGTH,
     &       im_ident,3,350,
*CALL ARGPPX
     &       ICODE,CMESSAGE)
C
        IF (ICODE .GT. 0) GOTO 9999
        DO I=FIRST_VALID_PT,LAST_P_VALID_PT
          STASHWORK(SI(350,3,im_index)+I-1)=
     &    STASHWORK(SI(350,3,im_index)+I-1)*SECS_PER_STEPim(a_im)
        END DO
C
      END IF
C
C Item 351 snow sublimation over sea-ice
C
      IF (SF(351,3)) THEN
C
        CALL COPYDIAG(STASHWORK(SI(351,3,im_index)),SNOW_SUB_SEA,
     &       FIRST_POINT,LAST_POINT,P_FIELD,ROW_LENGTH,
     &       im_ident,3,351,
*CALL ARGPPX
     &       ICODE,CMESSAGE)
C
        IF (ICODE .GT. 0) GOTO 9999
        DO I=FIRST_VALID_PT,LAST_P_VALID_PT
          STASHWORK(SI(351,3,im_index)+I-1)=
     &    STASHWORK(SI(351,3,im_index)+I-1)*SECS_PER_STEPim(a_im)
        END DO
C
      END IF
*/
*D ABX1F405.655,668
C Item 298 snow sublimation rate (kg/m2/s)
C
      IF (SF(298,3)) THEN

        CALL COPYDIAG(STASHWORK(SI(298,3,im_index)),SNOW_SUBLIMATION,
     &       FIRST_POINT,LAST_POINT,P_FIELD,ROW_LENGTH,
     &       im_ident,3,298,
*CALL ARGPPX
     &       ICODE,CMESSAGE)

        IF (ICODE .GT. 0) GOTO 9999

      END IF
C
C Item 352 snow sublimation rate over land (kg/m2/s)
C
      IF (SF(352,3)) THEN

        CALL COPYDIAG(STASHWORK(SI(352,3,im_index)),SNOW_SUB_LAND,
     &       FIRST_POINT,LAST_POINT,P_FIELD,ROW_LENGTH,
     &       im_ident,3,352,
*CALL ARGPPX
     &       ICODE,CMESSAGE)

        IF (ICODE .GT. 0) GOTO 9999

      END IF
C
C Item 353 snow sublimation rate over sea-ice (kg/m2/s)
C
      IF (SF(353,3)) THEN

        CALL COPYDIAG(STASHWORK(SI(353,3,im_index)),SNOW_SUB_SEA,
     &       FIRST_POINT,LAST_POINT,P_FIELD,ROW_LENGTH,
     &       im_ident,3,353,
*CALL ARGPPX
     &       ICODE,CMESSAGE)

        IF (ICODE .GT. 0) GOTO 9999

      END IF
C
*/
*/
*D AJS1F401.696,700
*D GPB1F403.414,419
*D AJS1F401.702,703
C Item 328 land surface heat flux 
      IF (SF(328,3)) THEN
C
        CALL COPYDIAG(STASHWORK(SI(328,3,im_index)),SURF_HT_FLUX_LAND,
     &       FIRST_POINT,LAST_POINT,P_FIELD,ROW_LENGTH,
     &       im_ident,3,328,
*CALL ARGPPX
     &       ICODE,CMESSAGE)

        IF (ICODE .GT. 0) GOTO 9999

      END IF
C
C Item 329 sea surface heat flux 
      IF (SF(329,3)) THEN
C
        CALL COPYDIAG(STASHWORK(SI(329,3,im_index)),SURF_HT_FLUX_SICE,
     &       FIRST_POINT,LAST_POINT,P_FIELD,ROW_LENGTH,
     &       im_ident,3,329,
*CALL ARGPPX
     &       ICODE,CMESSAGE)

        IF (ICODE .GT. 0) GOTO 9999

      END IF
*/
*I APB2F401.234 
C
         CALL POLAR_UV(STASHWORK(SI(368,3,im_index)),
     &                 STASHWORK(SI(372,3,im_index)),
     &                 ROW_LENGTH,U_FIELD,1,
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
*IF DEF,MPP
     &  MY_PROC_ID , NP_PROC_ID , SP_PROC_ID ,
     &  GC_ALL_GROUP, GC_ROW_GROUP, GC_COL_GROUP, N_PROCS,
     &  EW_Halo , NS_Halo, halo_4th, extra_EW_Halo, extra_NS_Halo,
     &  LOCAL_ROW_LENGTH, FIRST_GLOBAL_ROW_NUMBER,
     &  at_top_of_LPG,at_right_of_LPG, at_base_of_LPG,at_left_of_LPG,
*ENDIF
     &                 COS_LONGITUDE,SIN_LONGITUDE)
         CALL POLAR_UV(STASHWORK(SI(369,3,im_index)),
     &                 STASHWORK(SI(373,3,im_index)),
     &                 ROW_LENGTH,U_FIELD,1,
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
*IF DEF,MPP
     &  MY_PROC_ID , NP_PROC_ID , SP_PROC_ID ,
     &  GC_ALL_GROUP, GC_ROW_GROUP, GC_COL_GROUP, N_PROCS,
     &  EW_Halo , NS_Halo, halo_4th, extra_EW_Halo, extra_NS_Halo,
     &  LOCAL_ROW_LENGTH, FIRST_GLOBAL_ROW_NUMBER,
     &  at_top_of_LPG,at_right_of_LPG, at_base_of_LPG,at_left_of_LPG,
*ENDIF
     &                 COS_LONGITUDE,SIN_LONGITUDE)
C
*/
*I ABX1F405.676
C
CL ITEM 342 Land sensible heat flux
      IF (SF(342,3)) THEN
        CALL FROM_LAND_POINTS(STASHWORK(SI(342,3,im_index)),
     &           WORK11,D1(JLAND),P_FIELD,LAND_FIELD)
      ENDIF
C
CL ITEM 346 Land moisture flux
      IF (SF(346,3)) THEN
        CALL FROM_LAND_POINTS(STASHWORK(SI(346,3,im_index)),
     &           WORK12,D1(JLAND),P_FIELD,LAND_FIELD)
      ENDIF
*/
*/ Set polar rows:
*I APBGF401.39
          D1(JTSTAR_LAND+TOP_ROW_START+I-2)=0.0
          D1(JTSTAR_SEA+TOP_ROW_START+I-2)=0.0
          D1(JTSTAR_SICE+TOP_ROW_START+I-2)=0.0
          D1(JTSTAR_SSI+TOP_ROW_START+I-2)=0.0
*I APBGF401.47    
          D1(JTSTAR_LAND+P_BOT_ROW_START+I-2)=0.0
          D1(JTSTAR_SEA+P_BOT_ROW_START+I-2)=0.0
          D1(JTSTAR_SICE+P_BOT_ROW_START+I-2)=0.0
          D1(JTSTAR_SSI+P_BOT_ROW_START+I-2)=0.0
*/
*I APB2F401.96
C
      CALL POLAR(D1(JTSTAR_LAND),D1(JTSTAR_LAND),D1(JTSTAR_LAND),
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
*IF DEF,MPP                                                   
     &  MY_PROC_ID , NP_PROC_ID , SP_PROC_ID ,                
     &  GC_ALL_GROUP, GC_ROW_GROUP, GC_COL_GROUP, N_PROCS,    
     &  EW_Halo , NS_Halo, halo_4th, extra_EW_Halo, extra_NS_Halo,
     &  LOCAL_ROW_LENGTH, FIRST_GLOBAL_ROW_NUMBER,
     &  at_top_of_LPG,at_right_of_LPG, at_base_of_LPG,at_left_of_LPG,
*ENDIF                                   
     &           P_FIELD,P_FIELD,P_FIELD,
     &           TOP_ROW_START+ROW_LENGTH,
     &           P_BOT_ROW_START-ROW_LENGTH,
     &           ROW_LENGTH,1)
*/
      CALL POLAR(D1(JTSTAR_SEA),D1(JTSTAR_SEA),D1(JTSTAR_SEA),
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
*IF DEF,MPP                                                   
     &  MY_PROC_ID , NP_PROC_ID , SP_PROC_ID ,                
     &  GC_ALL_GROUP, GC_ROW_GROUP, GC_COL_GROUP, N_PROCS,    
     &  EW_Halo , NS_Halo, halo_4th, extra_EW_Halo, extra_NS_Halo,
     &  LOCAL_ROW_LENGTH, FIRST_GLOBAL_ROW_NUMBER,
     &  at_top_of_LPG,at_right_of_LPG, at_base_of_LPG,at_left_of_LPG,
*ENDIF                                   
     &           P_FIELD,P_FIELD,P_FIELD,
     &           TOP_ROW_START+ROW_LENGTH,
     &           P_BOT_ROW_START-ROW_LENGTH,
     &           ROW_LENGTH,1)
*/
      CALL POLAR(D1(JTSTAR_SICE),D1(JTSTAR_SICE),D1(JTSTAR_SICE),
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
*IF DEF,MPP                                                   
     &  MY_PROC_ID , NP_PROC_ID , SP_PROC_ID ,                
     &  GC_ALL_GROUP, GC_ROW_GROUP, GC_COL_GROUP, N_PROCS,    
     &  EW_Halo , NS_Halo, halo_4th, extra_EW_Halo, extra_NS_Halo,
     &  LOCAL_ROW_LENGTH, FIRST_GLOBAL_ROW_NUMBER,
     &  at_top_of_LPG,at_right_of_LPG, at_base_of_LPG,at_left_of_LPG,
*ENDIF                                   
     &           P_FIELD,P_FIELD,P_FIELD,
     &           TOP_ROW_START+ROW_LENGTH,
     &           P_BOT_ROW_START-ROW_LENGTH,
     &           ROW_LENGTH,1)
*/
      CALL POLAR(D1(JTSTAR_SSI),D1(JTSTAR_SSI),D1(JTSTAR_SSI),
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
*IF DEF,MPP                                                   
     &  MY_PROC_ID , NP_PROC_ID , SP_PROC_ID ,                
     &  GC_ALL_GROUP, GC_ROW_GROUP, GC_COL_GROUP, N_PROCS,    
     &  EW_Halo , NS_Halo, halo_4th, extra_EW_Halo, extra_NS_Halo,
     &  LOCAL_ROW_LENGTH, FIRST_GLOBAL_ROW_NUMBER,
     &  at_top_of_LPG,at_right_of_LPG, at_base_of_LPG,at_left_of_LPG,
*ENDIF                                   
     &           P_FIELD,P_FIELD,P_FIELD,
     &           TOP_ROW_START+ROW_LENGTH,
     &           P_BOT_ROW_START-ROW_LENGTH,
     &           ROW_LENGTH,1)
*/
*I APBGF401.57 
          D1(JTSTAR_LAND+TOP_ROW_START+I-2)=
     &      D1(JTSTAR_LAND+TOP_ROW_START+ROW_LENGTH+I-2)
          D1(JTSTAR_SEA+TOP_ROW_START+I-2)=
     &      D1(JTSTAR_SEA+TOP_ROW_START+ROW_LENGTH+I-2)
          D1(JTSTAR_SICE+TOP_ROW_START+I-2)=
     &      D1(JTSTAR_SICE+TOP_ROW_START+ROW_LENGTH+I-2)
          D1(JTSTAR_SSI+TOP_ROW_START+I-2)=
     &      D1(JTSTAR_SSI+TOP_ROW_START+ROW_LENGTH+I-2)
*/
*I APBGF401.66           
          D1(JTSTAR_LAND+P_BOT_ROW_START+I-2)=
     &      D1(JTSTAR_LAND+P_BOT_ROW_START-ROW_LENGTH+I-2)
          D1(JTSTAR_SEA+P_BOT_ROW_START+I-2)=
     &      D1(JTSTAR_SEA+P_BOT_ROW_START-ROW_LENGTH+I-2)
          D1(JTSTAR_SICE+P_BOT_ROW_START+I-2)=
     &      D1(JTSTAR_SICE+P_BOT_ROW_START-ROW_LENGTH+I-2)
          D1(JTSTAR_SSI+P_BOT_ROW_START+I-2)=
     &      D1(JTSTAR_SSI+P_BOT_ROW_START-ROW_LENGTH+I-2)

*/
*I ABX1F405.677 
      IF (SF(396,3)) THEN
       DO I=FIRST_VALID_PT,LAST_P_VALID_PT
          STASHWORK(SI(396,3,im_index)+I-1)=
     &    FLANDG(I)
        END DO
       ENDIF
c      DO I=FIRST_VALID_PT,LAST_P_VALID_PT
c        STASHWORK(SI(396,3,im_index)+I-1)=
c     &  FLANDG(I)
c      END DO
C

*/.......................................................................
*/-----------------------------------------------------------------------
*/ This is useful for debugging if there is a crash in stash:
*/*DECLARE STWORK1A
*/*I STWORK1A.384  
*/      WRITE(6,*) 'called stwork1a',' il=',IL,' is=',IS,'im=',IM
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------










*ID CTILE1
*/---------------------------------------------------------------------------
*/---------------------------------------------------------------------------
*/ start putting in some of the changes needed for coast tileing
*/ a) set up indeces for sea, land, coast, sea-ice, sea-ice free sea points.
*/ b) add these in all the relevant boundary layer routines
*/---------------------------------------------------------------------------
*/---------------------------------------------------------------------------
*/.......................................................................
*/-----------------------------------------------------------------------
*DECLARE BDYLYR5A
*/
*I GSM4F403.3
CLL            08/99 Allow for the inclusion of coastal tiles, i.e.
CLL                  land and sea and sea-ice may coexist on the same
CLL                  grid box. Requires the splitting up of all the surface
CLL                  fluxes into land, sea and sea-ice components. Separate
CLL                  temperatures are also required.
CLL                                            N. Gedney
*/
*I BDYLYR5A.73
     &,SEA_PTS,SEA_INDEX,SICE_PTS,SICE_INDEX
     &,SEANOICE_PTS,SEANOICE_INDEX,COAST_PTS,COAST_INDEX
     &,FLANDG,FLAND
*/
*D BDYLYR5A.102
     &,Q,GC,T,T_SOIL,TI
     &,TSTAR,TSTAR_LAND,TSTAR_SEA,TSTAR_SICE,TSTAR_SSI
     &,U,V,Z0MSEA
*/
*D BDYLYR5A.123   
     +,ECAN,EI,EI_LAND,EI_SICE,ES,EXT,SNOWMELT,ZH 
*/
*D BDYLYR5A.98    
     &,CO2_MMR,PHOTOSYNTH_ACT_RAD,PSTAR,RADNET_LAND,RADNET_SICE
     &,TIMESTEP
*D BDYLYR5A.107   
     &,TAUX,TAUX_LAND,TAUX_SSI,TAUY,TAUY_LAND,TAUY_SSI
     &,VSHR,VSHR_LAND,VSHR_SSI
*/
*D ANG1F405.61 
     &,CD,CD_LAND,CD_SSI,CH,CH_LAND,CH_SSI
     &,E_SEA,EPOT,EPOT_LAND,EPOT_SSI,ETRAN,FQW,FQW_LAND,FQW_SSI
     &,FSMC,FTL,FTL_LAND,FTL_SSI,H_SEA,RHOKH,RHOKM
     &,RIB,RIB_LAND,RIB_SSI
*D BDYLYR5A.106
     &,SEA_ICE_HTF,SURF_HT_FLUX_LAND,SURF_HT_FLUX_SICE
*/
*D BDYLYR5A.111   
     &,Q1P5M,Q1P5M_LAND,Q1P5M_SSI,T1P5M,T1P5M_LAND,T1P5M_SSI
     &,U10M,U10M_LAND,U10M_SSI,V10M,V10M_LAND,V10M_SSI
*D BDYLYR5A.113
     &,SFME,SIMLT,SMLT,SLH,SQ1P5,ST1P5,SU10,SV10
*/
*D BDYLYR5A.214 
     & LAND_MASK(P_FIELD)        ! IN T if any land, F elsewhere.
*/
*D BDYLYR5A.262   
     &,VFRAC(LAND_FIELD)         ! IN Fraction of Vegetation in
C                                !    land portion of grid box.
*/
*D BDYLYR5A.264,265
*/
*D BDYLYR5A.280,281
     &,ICE_FRACT(P_FIELD)        ! IN Fraction of sea which is sea-ice.
*/
*D BDYLYR5A.306,307 
     &,RADNET_LAND(P_FIELD)      ! IN Land sfc net radiation 
C                                !    (W/sq m, positive downwards).
     &,RADNET_SICE(P_FIELD)      ! IN Sea-ice sfc net radiation
C                                !    (W/sq m, positive downwards).
C                                !    Weighted by sea-ice fraction
C                                !    in sea portion of grid box.
*/
*D BDYLYR5A.339
     &,TSTAR(P_FIELD)                  ! INOUT Grid box mean surface
!                                      !       temperature (K).
     &,TSTAR_LAND(P_FIELD)             ! INOUT Land surface 
!                                      !       temperature (K).
     &,TSTAR_SEA(P_FIELD)              ! INOUT Sea only surface 
!                                      !       temperature (K).
     &,TSTAR_SICE(P_FIELD)             ! INOUT Sea-ice surface 
!                                      !       temperature (K).
     &,TSTAR_SSI(P_FIELD)              ! INOUT Mean sea surface 
!                                      !       temperature (K).
*/
*D BDYLYR5A.346,348
*/
*D ANG1F405.62
     &,EPOT(P_FIELD)             ! OUT Grid box mean 
C                                !     potential evaporation (kg/m2/s).
     &,EPOT_ICE(P_FIELD)         ! OUT Sea-ice potential evap (kg/m2/s).
     &,EPOT_LAND(LAND_FIELD)     ! OUT Land potential evap (kg/m2/s).
     &,EPOT_SSI(P_FIELD)         ! OUT Mean sea potential evap (kg/m2/s)
*D BDYLYR5A.357,359
     + CD(P_FIELD)               ! OUT Grid box mean
C                                !     Turbulent surface exchange (bulk
C                                !     transfer) coefficient for
C                                !     momentum.
     &,CD_LAND(P_FIELD)          ! OUT Turbulent surface exchange (bulk
C                                !     transfer) coefficient for
C                                !     momentum over land.
     &,CD_SSI(P_FIELD)           ! OUT Turbulent surface exchange (bulk
C                                !     transfer) coefficient for
C                                !     momentum over sea/sea-ice.
*D BDYLYR5A.360,362
     &,CH(P_FIELD)               ! OUT Grid box mean 
C                                !     Turbulent surface exchange (bulk
C                                !     transfer) coefficient for heat
C                                !     and/or moisture.
     &,CH_LAND(P_FIELD)          ! OUT Turbulent surface exchange (bulk
C                                !     transfer) coefficient for heat
C                                !     and/or moisture over land.
     &,CH_SSI(P_FIELD)           ! OUT Turbulent surface exchange (bulk
C                                !     transfer) coefficient for heat
C                                !     and/or moisture over sea/sea-ice.
*D BDYLYR5A.363,365
     &,E_SEA(P_FIELD)            ! OUT Evaporation from sea times leads
C                                !     fraction of total sea portion
C                                !     of grid box. Zero over land-only
C                                !     points. (kg/m2/s).
*/
*I BDYLYR5A.369
     &,FQW_LAND(LAND_FIELD)    
C                                ! OUT Land surface moisture flux
C                                !     (kg/m2/s).
     &,FQW_SSI(P_FIELD)          ! OUT Mean sea surface moisture flux
C                                !     (kg/m2/s).
*/
*I BDYLYR5A.373
     &,FTL_LAND(LAND_FIELD)      ! OUT Land surface sensible heat
C                                !     (W/m2).
     &,FTL_SSI(P_FIELD)          ! OUT Mean sea surface sensible heat
C                                !     (W/m2).
*/
*D BDYLYR5A.374,375
     &,H_SEA(P_FIELD)            ! OUT Surface sensible heat flux over
C                                !     sea times leads fraction of
C                                !     total sea portion of grid box.
C                                !     Zero over land-only points.
C                                !     (W/m2).
*/
*I BDYLYR5A.381
     &,RHOKH_LAND(P_FIELD)       ! OUT Exchange coeffs for moisture.   
C                                !     Out of SF_EXCH containing
C                                !     GAMMA(1)*RHOKH_LAND after
C                                !     IMPL_CAL contains only RHOKH_LAND
     &,RHOKH_SICE(P_FIELD)       ! OUT Exchange coeffs for moisture.
C                                !     Out of SF_EXCH containing
C                                !     GAMMA(1)*RHOKH_SICE, after
C                                !     IMPL_CAL contains only RHOKH_SICE
*I BDYLYR5A.390
     &,RHOKM_LAND(U_FIELD)       ! OUT Land exchange coefficient for
C                                !     momentum (on UV-grid, with 1st
C                                !     and last rows undefined (or, at
C                                !     present, set to "missing data")).
C                                !     Out of SF_EXCH containing
C                                !     GAMMA(1)*RHOKM_LAND, after
C                                !     IMPL_CAL contains only RHOKM_LAND
     &,RHOKM_SSI(U_FIELD)        ! OUT Sea exchange coefficient for
C                                !     momentum (on UV-grid, with 1st
C                                !     and last rows undefined (or, at
C                                !     present, set to "missing data")).
C                                !     Out of SF_EXCH containing
C                                !     GAMMA(1)*RHOKM_SICE, after
C                                !     IMPL_CAL contains only RHOKM_SICE
*/
*D BDYLYR5A.391,392
     &,RIB(P_FIELD)              ! OUT Grid box mean
C                                !     Bulk Richardson number between
C                                !     lowest layer and surface.
     &,RIB_LAND(P_FIELD)         ! OUT Bulk Richardson number between
C                                !     lowest layer and land surface.
     &,RIB_SSI(P_FIELD)          ! OUT Bulk Richardson number between
C                                !     lowest layer and sea/sea-ice
C                                !     surface.
*D BDYLYR5A.393,394
     &,SEA_ICE_HTF(P_FIELD)      ! OUT Heat flux through sea-ice. 
C                                !     Weighted by sea-ice frac in sea
C                                !     portion of gridbox. 
C                                !     (W/m2,+tive downwards).
*/
*D BDYLYR5A.395,397
     &,SURF_HT_FLUX_LAND(P_FIELD)! OUT Net downward heat flux at surface
C                                !     over land (W/m2).
     &,SURF_HT_FLUX_SICE(P_FIELD)! OUT Net downward heat flux at surface
C                                !     over sea-ice fraction of sea
C                                !     portion of gridbox (W/m2).
*/
*I BDYLYR5A.401
     &,TAUX_LAND(U_FIELD)        ! OUT W'ly compt. of land sfc wind
C                                !     stress (N/sq m).(On UV-grid with
C                                !     first and last rows undefined or
C                                !     at present, set to 'missing data'
     &,TAUX_SSI(U_FIELD)         ! OUT W'ly compt. of mean sea sfc wind
C                                !     stress (N/sq m).(On UV-grid with
C                                !     first and last rows undefined or
C                                !     at present, set to 'missing data'
*I BDYLYR5A.404
     &,TAUY_LAND(U_FIELD)        ! OUT S'ly compt. of land sfc wind
C                                !     stress (N/sq m).  On UV-grid;
C                                !     comments as per TAUX_LAND.

     &,TAUY_SSI(U_FIELD)         ! OUT S'ly compt. of mean sea sfc wind
C                                !     stress (N/sq m).  On UV-grid;
C                                !     comments as per TAUX_SSI.

*/
*D BDYLYR5A.405,406  
     &,VSHR(P_FIELD)             ! OUT Magnitude of mean surface-to-
C                                !     lowest  level wind shear (m/s).
     &,VSHR_LAND(P_FIELD)        ! OUT Magnitude of land surface-to-
C                                !     lowest level wind shear (m/s).
     &,VSHR_SSI(P_FIELD)         ! OUT Magnitude of mean sea surface-to-
C                                !     lowest level wind shear (m/s).
*/
*D BDYLYR5A.428,429
     &,SICE_MLT_HTF(P_FIELD)    ! OUT Heat flux due to melting of sea-
C                               !     ice (W/m2).
C                               !     Weighted over sea mean.
*/
*D BDYLYR5A.434,437
     &,Q1P5M(P_FIELD)           ! OUT Q at 1.5 m (kg water per kg air).
     &,Q1P5M_LAND(P_FIELD)      ! OUT land Q at 1.5 m.
     &,Q1P5M_SSI(P_FIELD)       ! OUT mean sea Q at 1.5 m.
*/
     &,T1P5M(P_FIELD)           ! OUT T at 1.5 m (K).
     &,T1P5M_LAND(P_FIELD)      ! OUT land T at 1.5 m (K).
     &,T1P5M_SSI(P_FIELD)       ! OUT mean sea T at 1.5 m (K).
*/
     &,U10M(U_FIELD)            ! OUT U at 10 m (m per s).
     &,U10M_LAND(U_FIELD)       ! OUT land U at 10 m (m per s).
     &,U10M_SSI(U_FIELD)        ! OUT mean sea U at 10 m (m per s).
*/
     &,V10M(U_FIELD)            ! OUT V at 10 m (m per s).
     &,V10M_LAND(U_FIELD)       ! OUT land V at 10 m (m per s).
     &,V10M_SSI(U_FIELD)        ! OUT mean sea V at 10 m (m per s).
*/
*D BDYLYR5A.442,443
     & EI(P_FIELD)    ! OUT Sublimation from lying snow or sea-ice
C                     !     (kg per sq m per sec).
     &,EI_LAND(P_FIELD)
C                     ! OUT Sublimation from lying snow
C                     !     (kg per sq m per sec).                
     &,EI_SICE(P_FIELD)
C                     ! OUT Sublimation from lying sea-ice
C                     !     (kg per sq m per sec).               
*D BDYLYR5A.444 
     &,ECAN(P_FIELD)  ! OUT Land evaporation from canopy/surface
*D BDYLYR5A.496
*CALL C_ROUGH
*CALL C_0_DG_C
      INTEGER
     & COAST_INDEX(P_FIELD)      ! WORK COAST_INDEX(I)=J => the Jth
!                                !    point in P_FIELD is the Ith
!                                !    coast point.
     &,COAST_PTS                 ! WORK No of coastal points processed.
     &,SEA_INDEX(P_FIELD)        ! WORK SEA_INDEX(I)=J => the Jth
!                                !    point in P_FIELD is the Ith
!                                !    sea point.
     &,SEA_PTS                   ! WORK No of sea points processed.
     &,SICE_INDEX(P_FIELD)       ! WORK SICE_INDEX(I)=J => the Jth
!                                !    point in P_FIELD is the Ith
!                                !    sea-ice point.
     &,SICE_PTS                  ! WORK No of sea-ice points processed.
     &,SEANOICE_INDEX(P_FIELD)   ! WORK SEANOICE_INDEX(I)=J => the Jth
!                                !    point in P_FIELD is the Ith
!                                !    sea point without sea-ice.
     &,SEANOICE_PTS              ! WORK No of sea-ice free sea points
!                                !    processed.
      REAL
     & FLANDG(P_FIELD)       ! WORK Fraction of land in grid box. 
     &,FLANDG_UV(U_FIELD)    ! WORK Fraction of land in grid box. 
     &,FLAND(LAND_FIELD)     ! WORK Fraction of land in grid box. 
*D BDYLYR5A.592,596
     & ALPHA1_LAND(P_FIELD)     ! WORK Gradient of saturated        
C                               !      specific humidity with       
C                               !      respect to temperature between
C                               !      the bottom model layer and the
C                               !      land surface.                  
     &,ALPHA1_SICE(P_FIELD)     ! WORK Gradient of saturated      
C                               !      specific humidity with      
C                               !      respect to temperature between
C                               !      the bottom model layer and the
C                               !      sea-ice surface.                    
*D BDYLYR5A.597,601
     &,ASHTF_LAND(LAND_FIELD)   ! WORK Coefficient to calculate surface
C                               !      heat flux into soil.
     &,ASHTF_SICE(P_FIELD)      ! WORK Coefficient to calculate surface
C                               !      heat flux into sea-ice.
     &,ASURF_SICE(P_FIELD)      ! WORK Reciprocal areal heat capacity
C                               !      of sea-ice surface layer 
C                               !      (K m**2 / J).
*D  BDYLYR5A.614 
     &,FRACA(P_FIELD)           ! WORK Frac of land sfc moisture flux.
*D BDYLYR5A.631 
     &,RHOKPM_LAND(P_FIELD)     ! WORK Land surface exchange coeff.
     &,RHOKPM_SICE(P_FIELD)     ! WORK Sea-ice surface exchange coeff.
*D ANG1F405.64
     &,RHOKPM_POT_LAND(LAND_FIELD)
C                               ! WORK Land surface exchange coeff. for
     &,RHOKPM_POT_SICE(P_FIELD) ! WORK Sea-ice sfc exchange coeff. for
*D BDYLYR5A.659,661
     & Z0H(P_FIELD)               ! WORK Roughness length for heat and
C                                 !      moisture.
     &,Z0H_LAND(P_FIELD)          ! WORK Roughness length for heat and
C                                 !      moisture.
     &,Z0H_SSI(P_FIELD)           ! WORK Roughness length for heat and
C                                 !      moisture.
     &,Z0M(P_FIELD)               ! WORK Roughness length for momentum.
     &,Z0M_LAND(P_FIELD)          ! WORK Land roughness length
C                                 !      for momentum.
     &,Z0M_SSI(P_FIELD)           ! WORK Mean sea roughness length
C                                 !      for momentum.
*/
*D BDYLYR5A.670,677
     + CDR10M(U_FIELD)            ! WORK Ratio of CD's reqd for
C                                 !      calculation of 10 m wind.
C                                 !      On UV-grid; comments as per
C                                 !      RHOKM.
     &,CDR10M_LAND(U_FIELD)       ! WORK Ratio of CD's reqd for
C                                 !      calculation of 10 m wind.
C                                 !      On UV-grid; comments as per
C                                 !      RHOKM.
     &,CER1P5M_LAND(P_FIELD)      ! WORK Ratio of coefficients reqd for
C                                 !      calculation of 1.5 m Q.
     &,CHR1P5M_LAND(P_FIELD)      ! WORK Ratio of coefficients reqd for
C                                 !      calculation of 1.5 m T.
     &,CDR10M_SSI(U_FIELD)        ! WORK Ratio of CD's reqd for
C                                 !      calculation of 10 m wind.
C                                 !      On UV-grid; comments as per
C                                 !      RHOKM.
     &,CER1P5M_SSI(P_FIELD)       ! WORK Ratio of coefficients reqd for
C                                 !      calculation of 1.5 m Q.
     &,CHR1P5M_SSI(P_FIELD)       ! WORK Ratio of coefficients reqd for
C                                 !      calculation of 1.5 m T.
*/
*D APA1F405.328   
     &,RADNET_C_LAND(P_FIELD)     ! WORK Adjusted net radiation for
*/
*/
*I BDYLYR5A.701
     &,SE
     &,SI
*/
*/------------------------------------------------------------------------
*I BDYLYR5A.786
C-----------------------------------------------------------------------
CL    Set compressed sea, sea-ice and coast point pointers.
C-----------------------------------------------------------------------
      SEA_PTS=0
      SICE_PTS=0
      SEANOICE_PTS=0
      DO I=P1,P1+P_POINTS-1
        SEA_INDEX(I)=0
        SICE_INDEX(I)=0
        SEANOICE_INDEX(I)=0
        COAST_INDEX(I) = 0
      ENDDO
      DO I=1,P1+P_POINTS-1
        FLANDG(I)=0.0
      ENDDO
      DO L=1,LAND1+LAND_PTS-1
        I = LAND_INDEX(L)
        FLANDG(I)=FLAND(L)
      ENDDO
C
      DO I=P1,P1+P_POINTS-1
        IF(FLANDG(I).LT.1.0)THEN
          SEA_PTS = SEA_PTS + 1
          SEA_INDEX(SEA_PTS) = I
          IF(ICE_FRACT(I).GT.0.0)THEN
            SICE_PTS = SICE_PTS + 1
            SICE_INDEX(SICE_PTS) = I
          ELSE
            SEANOICE_PTS = SEANOICE_PTS + 1
            SEANOICE_INDEX(SEANOICE_PTS) = I
          ENDIF
        ENDIF
      ENDDO  
C
      COAST_PTS=0
      DO I=P1,P1+P_POINTS-1
        IF(LAND_MASK(I).AND.FLANDG(I).LT.1.0)THEN
          COAST_PTS = COAST_PTS + 1
          COAST_INDEX(COAST_PTS) = I
        ENDIF
      ENDDO 
C
C 
*I AJC1F405.512
C-----------------------------------------------------------------------
CL    Set compressed sea, sea-ice and coast point pointers.
C-----------------------------------------------------------------------
      SEA_PTS=0
      SICE_PTS=0
      SEANOICE_PTS=0
      DO I=P1,P1+P_POINTS-1
        SEA_INDEX(I)=0
        SICE_INDEX(I)=0
        SEANOICE_INDEX(I)=0
        COAST_INDEX(I) = 0
      ENDDO
      DO I=1,P1+P_POINTS-1
        FLANDG(I)=0.0
      ENDDO
      DO L=1,LAND1+LAND_PTS-1
        I = LAND_INDEX(L)
        FLANDG(I)=FLAND(L)
      ENDDO
C
      DO I=P1,P1+P_POINTS-1
        IF(FLANDG(I).LT.1.0)THEN
          SEA_PTS = SEA_PTS + 1
          SEA_INDEX(SEA_PTS) = I
          IF(ICE_FRACT(I).GT.0.0)THEN
            SICE_PTS = SICE_PTS + 1
            SICE_INDEX(SICE_PTS) = I
          ELSE
            SEANOICE_PTS = SEANOICE_PTS + 1
            SEANOICE_INDEX(SEANOICE_PTS) = I
          ENDIF
        ENDIF
      ENDDO  
C
      COAST_PTS=0
      DO I=P1,P1+P_POINTS-1
        IF(LAND_MASK(I).AND.FLANDG(I).LT.1.0)THEN
          COAST_PTS = COAST_PTS + 1
          COAST_INDEX(COAST_PTS) = I
        ENDIF
      ENDDO 
C
      WRITE(6,*)'***ERROR:***'
      WRITE(6,*)'COASTAL TILING DOES NOT WORK IN SCM MODE'
      CALL ABORT
C
*/
*/------------------------------------------------------------------------
*/
!---------------------------------------------------------------------
*/
*/ MOVE RADNET_C_LAND initialisation to after LAND1 is set up.
*D APA1F405.331,336
*I BDYLYR5A.819
C-----------------------------------------------------------------------
C Initialise RADNET_C to be the same as RADNET over all points.
C Initialise Z0MSEA to be Z0MSEA_VAL over all points.
C-----------------------------------------------------------------------
*IF DEF,SCMA
c      DO I=1,P_FIELD
c        RADNET_SICE(I) = RADNET(I)
c      ENDDO
*ENDIF
      DO I=1,P_FIELD
        IF(FLANDG(I).GT.0.0)THEN
          RADNET_C_LAND(I) = RADNET_LAND(I)
        ELSE
          RADNET_C_LAND(I)=0.0
        ENDIF
      ENDDO
*/
C Initialise:
      DO I=1,P_FIELD
        EI_SICE(I)=0.0
        EI_LAND(I)=0.0
        FTL_SSI(I)=0.0
        FQW_SSI(I)=0.0
        EPOT_SSI(I)=0.0
        EPOT_ICE(I)=0.0
        RHOKPM_SICE(I)=0.0
        RHOKPM_LAND(I)=0.0
        RHOKPM_POT_SICE(I)=0.0
        SURF_HT_FLUX_LAND(I)=0.0
        SURF_HT_FLUX_SICE(I)=0.0
      ENDDO
*/
*I GSM4F403.14
      DO L=1,LAND_FIELD
        FTL_LAND(L)=0.0
        FQW_LAND(L)=0.0
        EPOT_LAND(L)=0.0
        RHOKPM_POT_LAND(L)=0.0
        FTL_LAND(L)=0.0
        FQW_LAND(L)=0.0
        EPOT_LAND(L)=0.0
        RHOKPM_POT_LAND(L)=0.0
      ENDDO
*/
*/-----------------------------------------------------------------------
*/.......................................................................
*/
*/ call sfexch
*I BDYLYR5A.905   
     & SEA_PTS,SEA_INDEX,SICE_PTS,SICE_INDEX,
     & SEANOICE_PTS,SEANOICE_INDEX,COAST_PTS,COAST_INDEX,
     & FLANDG(P1),FLANDG_UV(U1),
*D ADM3F404.68
     & ALPHA1_LAND(P1),ALPHA1_SICE(P1),
     & ASHTF_LAND(LAND1),ASHTF_SICE(P1),
     & BQ_1(P1),BT_1(P1),BF_1(P1),
     & CD(P1),CD_LAND(P1),CD_SSI(P1),CH(P1),CH_LAND(P1),CH_SSI(P1),
*D APA1F405.340   
     & QCF(P1,1),QCL(P1,1),RADNET_SICE(P1),RADNET_C_LAND(P1),
     & GC(LAND1),RESIST(LAND1),
*D BDYLYR5A.915
     & T(P1,1),TIMESTEP,TI(P1),T_SOIL(LAND1,1),
     & TSTAR(P1),TSTAR_LAND(P1),
     & TSTAR_SEA(P1),TSTAR_SICE(P1),TSTAR_SSI(P1),
*D ANG1F405.69    
     & RESFT(P1),
     & RHOKH(P1,1),RHOKH_LAND(P1),RHOKH_SICE(P1),
     & RHOKM(U1,1),RHOKM_LAND(U1),RHOKM_SSI(U1),
*D ANG1F405.70    
     & RHOKPM_LAND(P1),RHOKPM_SICE(P1),
     & RHOKPM_POT_LAND(LAND1),RHOKPM_POT_SICE(P1),
*D ANG1F405.68    
     & EPOT_LAND(LAND1),EPOT_SSI(P1),EPOT_ICE(P1),
     & FQW(P1,1),FQW_LAND(LAND1),FQW_SSI(P1),
     & FSMC(LAND1),FTL(P1,1),FTL_LAND(LAND1),FTL_SSI(P1),
     & E_SEA(P1),H_SEA(P1),
*D BDYLYR5A.921  
     & TAUX(U1,1),TAUY(U1,1),
     & TAUX_LAND(U1),TAUX_SSI(U1),TAUY_LAND(U1),TAUY_SSI(U1),
     & QW(P1,1),FRACA(P1),RESFS(P1),F_SE(P1),
*D BDYLYR5A.923   
     & RIB(P1),RIB_LAND(P1),RIB_SSI(P1),
     & TL(P1,1),VSHR(P1),VSHR_LAND(P1),VSHR_SSI(P1),
     & Z0H(P1),Z0H_LAND(P1),Z0H_SSI(P1),
     & Z0M(P1),Z0M_LAND(P1),Z0M_SSI(P1),
*D BDYLYR5A.925,926   
     & RHO_CD_MODV1(P1),FME(P1),
     & CDR10M_LAND(U1),CHR1P5M_LAND(P1),CER1P5M_LAND(P1),
     & CDR10M_SSI(U1),CHR1P5M_SSI(P1),CER1P5M_SSI(P1),
     & SU10,SV10,SQ1P5,ST1P5,SFME,
*/
*/.......................................................................
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*/.......................................................................
*D BDYLYR5A.957,959   
CL 6.  "Implicit" calculation of increments for land and sea-ice TSTAR
CL     & atmospheric boundary layer variables (P244, routine IMPL_CAL).
CL     10-metre wind components are also diagnosed if requested.

*/ call implca
*D BDYLYR5A.963,965
     & LAND_FIELD,P_FIELD,U_FIELD,LAND1,P1,U1,
     & LAND_PTS,P_POINTS,U_POINTS,LAND_INDEX,
     & BL_LEVELS,ROW_LENGTH,N_P_ROWS,N_U_ROWS,
     & ALPHA1_LAND,ALPHA1_SICE,
     & ASHTF_LAND,ASHTF_SICE,
     & CDR10M_LAND,CDR10M_SSI,
     & DELTA_AK,DELTA_BK,
*D APA1F405.343   
     + ICE_FRACT,LYING_SNOW,PSTAR,RADNET_SICE,RADNET_C_LAND,RESFT,
     + RHOKPM_LAND,RHOKPM_SICE,
*D ANG1F405.71    
     & RHOKPM_POT_LAND,RHOKPM_POT_SICE,
*I BDYLYR5A.968   
     & SEA_PTS,SEA_INDEX,SICE_PTS,SICE_INDEX,
     & SEANOICE_PTS,SEANOICE_INDEX,COAST_PTS,COAST_INDEX,
     & FLANDG,FLANDG_UV,FLAND,
*D ANG1F405.72 
     & EPOT_ICE,EPOT_LAND,EPOT_SSI,FQW,FQW_LAND,FQW_SSI,
     & FTL,FTL_LAND,FTL_SSI,E_SEA,H_SEA,QW,
*D BDYLYR5A.970   
     & RHOKH_LAND,RHOKH_SICE,
     & RHOKM(1,1),RHOKM_LAND,RHOKM_SSI,TL,U,V, 
*D BDYLYR5A.971
     & DTRDZ,DTRDZ_RML,TAUX,TAUY,
     & TAUX_LAND,TAUX_SSI,TAUY_LAND,TAUY_SSI,
     & SURF_HT_FLUX_LAND,SURF_HT_FLUX_SICE,
     & U10M,U10M_LAND,U10M_SSI,V10M,V10M_LAND,V10M_SSI,NRML,
*/
*/.......................................................................
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*/.......................................................................
*/
*D BDYLYR5A.989,990   
C    Diagnose surface temperatures and increment sub-surface
C    temperatures for land and sea-ice. 
*/
*/ call siceht
*D BDYLYR5A.998,1000
     & ASHTF_SICE(P1),
     & DI(P1),ICE_FRACT(P1),SURF_HT_FLUX_SICE(P1),
     & TIMESTEP,
     & LAND1,LAND_MASK(P1),P1,P_POINTS,
     & SEA_PTS,SEA_INDEX,SICE_PTS,SICE_INDEX,
     & SEANOICE_PTS,SEANOICE_INDEX,COAST_PTS,COAST_INDEX,
     & LAND_PTS,LAND_INDEX,FLANDG(P1),
     & TI(P1),TSTAR_LAND(P1),TSTAR_SEA(P1),TSTAR_SSI(P1),TSTAR_SICE(P1),
     & ASURF_SICE(P1),SEA_ICE_HTF(P1),LTIMER
*/
*/.......................................................................
*/-----------------------------------------------------------------------
*D BDYLYR5A.1017
        TSTAR_LAND(J)=T_SOIL(I,1)+SURF_HT_FLUX_LAND(J)/ASHTF_LAND(I)
*/-----------------------------------------------------------------------
*/.......................................................................
*/
*/ call sfevap
*I BDYLYR5A.1034  
     & SEA_PTS,SEA_INDEX,SICE_PTS,SICE_INDEX,
     & SEANOICE_PTS,SEANOICE_INDEX,COAST_PTS,COAST_INDEX,     
     & FLANDG,
*D BDYLYR5A.1036,1042
     & ALPHA1_LAND,ALPHA1_SICE,ASHTF_LAND,ASHTF_SICE,
     & ASURF_SICE,CANOPY,CATCH,
     & DTRDZ,DTRDZ_RML,E_SEA,FRACA,
     & ICE_FRACT,NRML,RHOKH_LAND,RHOKH_SICE,
     & SMC,TIMESTEP,
     & CER1P5M_LAND,CHR1P5M_LAND,CER1P5M_SSI,CHR1P5M_SSI,
     & PSTAR,RESFS,RESFT,Z1,
     & Z0M_LAND,Z0M_SSI,Z0H_LAND,Z0H_SSI,
     & SQ1P5,ST1P5,SIMLT,SMLT,    
     & FTL,FTL_LAND,FTL_SSI,FQW,FQW_LAND,FQW_SSI,LYING_SNOW,QW,
     & SURF_HT_FLUX_LAND,SURF_HT_FLUX_SICE,
     & TL,TSTAR_LAND,TSTAR_SEA,TSTAR_SICE,TSTAR_SSI,TI,
     & ECAN,ES,EI,EI_LAND,EI_SICE,
     & SICE_MLT_HTF,SNOMLT_SURF_HTF,SNOWMELT,
     & Q1P5M,Q1P5M_LAND,Q1P5M_SSI,T1P5M,T1P5M_LAND,T1P5M_SSI,
     & LTIMER
*/
*D APA1F405.350,351
        SURF_HT_FLUX_LAND(J) = SURF_HT_FLUX_LAND(J) - CANCAP(J) *
     &          ( TSTAR_LAND(J) - T_SOIL(I,1) ) / TIMESTEP
*/
*/
*I APA1F405.353
C-----------------------------------------------------------------------
CL   Diagnose the grid box mean and sea-ice surface temperatures
C-----------------------------------------------------------------------
C
      DO L=LAND1,LAND1+LAND_PTS-1
        I = LAND_INDEX(L)
          TSTAR(I)=TSTAR_LAND(I)*FLANDG(I)
      ENDDO
      DO SE=1,SEA_PTS
        I=SEA_INDEX(SE)
        IF(LAND_MASK(I))THEN
          TSTAR(I)=TSTAR(I)+TSTAR_SSI(I)*(1.-FLANDG(I))
        ELSE
          TSTAR(I)=TSTAR_SSI(I)
        ENDIF
        IF(ICE_FRACT(I).GT.0.0)THEN
          TSTAR_SICE(I)=(TSTAR_SSI(I)-TSTAR_SEA(I)*(1.-ICE_FRACT(I)))
     &     /ICE_FRACT(I)
        ENDIF
      ENDDO
*I BDYLYR5A.1104
C-----------------------------------------------------------------------
CL  Ensures that the potential evaporation rate equals the evaporation
CL  rate, when there is net condensation. Otherwise E/Ep could be
CL  <0 or >1 when the implicit adjustment is added.          
C-----------------------------------------------------------------------
      DO L=LAND1,LAND1+LAND_PTS-1
        IF(FQW_LAND(L).LT.0.0)THEN
          EPOT_LAND(L)=FQW_LAND(L)
        ENDIF
      ENDDO
      DO SE=1,SEA_PTS
        I=SEA_INDEX(SE)
        IF(FQW_SSI(I).LT.0.0)THEN
          EPOT_SSI(I)=FQW_SSI(I)
        ENDIF
      ENDDO
C-----------------------------------------------------------------------
CL   Diagnose grid box means:
C-----------------------------------------------------------------------
      DO L=LAND1,LAND1+LAND_PTS-1
        I = LAND_INDEX(L)
        RHOKH(I,1)=RHOKH_LAND(I)*FLANDG(I)
        EPOT(I) = FLANDG(I)*EPOT_LAND(L)
CL   Set sea roughness length to missing data over land-only points
C        IF(FLANDG(I).GE.1.0)Z0MSEA(I)=RMDI
      ENDDO
C
      DO SE=1,SEA_PTS
        I=SEA_INDEX(SE)
        IF(LAND_MASK(I))THEN
          RHOKH(I,1)=RHOKH(I,1)+RHOKH_SICE(I)*(1.-FLANDG(I))
          EPOT(I) = EPOT(I)+(1.-FLANDG(I))*EPOT_SSI(I)
        ELSE
          RHOKH(I,1)=RHOKH_SICE(I)
          EPOT(I) = EPOT_SSI(I)
        ENDIF
      ENDDO
C
*/
*/
*/.......................................................................
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*/.......................................................................
*DECLARE BL_IC5A
*I ABX1F405.702 
CLL            08/99 Allow for the inclusion of coastal tiles, i.e.
CLL                  land and sea and sea-ice may coexist on the same
CLL                  grid box. Requires the splitting up of all the surface
CLL                  fluxes into land, sea and sea-ice components. Separate
CLL                  temperatures are also required.
CLL                                            N. Gedney
*/
*D BL_IC5A.187   
     & LAND_MASK(P_FIELD)        ! IN T if any land, F elsewhere.
*/
*D BL_IC5A.234 
     &,VFRAC(LAND_FIELD)         ! IN Fraction of Vegetation in
C                                !    land portion of grid box.
*D BL_IC5A.236
*/
*D BL_IC5A.245,246
     &,ICE_FRACT(P_FIELD)        ! IN Fraction of sea which is sea-ice.
*/
*D BL_IC5A.271,272  
     &,RADNET_LAND(P_FIELD)      ! IN Land sfc net radiation
C                                !     (W/sq m, positive downwards).
     &,RADNET_SICE(P_FIELD)      ! IN Sea-ice sfc net radiation
C                                !     (W/sq m, positive downwards).
C                                !     Weighted by fraction of sea-ice
C                                !     in sea.
*/
*D BL_IC5A.313,315
     &,TSTAR(P_FIELD)                  ! INOUT Grid box mean
C                                      ! surface temperature (K).
     &,TSTAR_LAND(P_FIELD)             ! INOUT Land Surface temperature
C                                      ! (= top soil
C                                      ! layer temperature) (K).
     &,TSTAR_SEA(P_FIELD)              ! IN Open sea surface 
C                                      ! temperature (K).
     &,TSTAR_SICE(P_FIELD)             ! INOUT Sea-ice surface 
C                                      ! temperature (K).
     &,TSTAR_SSI(P_FIELD)              ! INOUT Mean sea surface 
C                                      ! temperature (K).
*/
*D BL_IC5A.322,324
*/
*D ARN0F405.138
*D BL_IC5A.334,335
     &,CD(P_FIELD)               ! OUT Grid box mean
C                                !     Turbulent surface exchange (bulk
C                                !     transfer) coefficient for
C                                !     momentum.
     &,CD_LAND(P_FIELD)          ! OUT Turbulent surface exchange (bulk
C                                !     transfer) coefficient for
C                                !     momentum over land.
     &,CD_SSI(P_FIELD)           ! OUT Turbulent surface exchange (bulk
C                                !     transfer) coefficient for
C                                !     momentum over sea/sea-ice.
*D BL_IC5A.336,338
     &,CH(P_FIELD)               ! OUT Grid box mean
C                                !     Turbulent surface exchange (bulk
C                                !     transfer) coefficient for heat
C                                !     and/or moisture.
     &,CH_LAND(P_FIELD)          ! OUT Turbulent surface exchange (bulk
C                                !     transfer) coefficient for heat
C                                !     and/or moisture over land.
     &,CH_SSI(P_FIELD)           ! OUT Turbulent surface exchange (bulk
C                                !     transfer) coefficient for heat
C                                !     and/or moisture over sea/sea-ice.
*D BL_IC5A.339,341
     &,E_SEA(P_FIELD)            ! OUT Evaporation from sea times leads
C                                !     fraction of total sea portion
C                                !     of grid box. Zero over land-only
C                                !     points. (kg/m2/s).
*D ANG1F405.52    
     &,EPOT(P_FIELD)             ! OUT Grid box mean
C                                !     potential evaporation (kg/m2/s).
     &,EPOT_LAND(P_FIELD)        ! OUT Land potential evap (kg/m2/s).
     &,EPOT_SSI(P_FIELD)         ! OUT Mean sea potential evap (kg/m2/s)
*I BL_IC5A.349   
     &,FQW_LAND(LAND_FIELD)      ! OUT Total water flux
C                                !     from land surface, 'E'.
     &,FQW_SSI(P_FIELD)          ! OUT Total water flux
C                                !     from sea/sea-ice surface, 'E'.
*I BL_IC5A.353   
     &,FTL_LAND(LAND_FIELD)      ! OUT Land surface sensible heat, H.
     &,FTL_SSI(P_FIELD)          ! OUT Sea/sea-ice sfc sensible heat, H.
*/
*D BL_IC5A.356,357
     &,H_SEA(P_FIELD)            ! OUT Surface sensible heat flux over
C                                !     sea times leads fraction of
C                                !     total sea portion of grid box.
C                                !     Zero over land-only points.
C                                !     (W/m2).
*/
*D BL_IC5A.377,378
     &,RIB(P_FIELD)              ! OUT Grid box mean bulk Richardson
C                                !     number between lowest layer
C                                !     and surface.
     &,RIB_LAND(P_FIELD)         ! OUT Bulk Richardson number 
C                                !     between lowest layer
C                                !     and land surface.
     &,RIB_SSI(P_FIELD)          ! OUT Bulk Richardson number
C                                !     between lowest layer
C                                !     and sea/sea-ice surface.
*/
*D BL_IC5A.379,380
     &,SEA_ICE_HTF(P_FIELD)      ! OUT Heat flux through sea-ice. 
C                                !     Weighted by sea-ice frac in sea
C                                !     portion of gridbox. 
C                                !     (W/m2,+tive downwards).
*/
*D BL_IC5A.382,384
     &,SURF_HT_FLUX_LAND(P_FIELD)
!                                ! OUT Net downward heat flux at surface
!                                !     over land (W/m2).
     &,SURF_HT_FLUX_SICE(P_FIELD)! OUT Net downward heat flux at surface
C                                !     over sea-ice fraction of sea
C                                !     portion of gridbox (W/m2).
*/
*I BL_IC5A.388
     &,TAUX_LAND(U_FIELD)        ! OUT S'ly compt of land surface wind
C                                !     stress (N/sq m). On UV-grid with
C                                !     first and last rows undefined or
C                                !     at present, set to 'missing data'
     &,TAUX_SSI(U_FIELD)         ! OUT As TAUX_LAND but for mean sea.
*/
*I BL_IC5A.391
     &,TAUY_LAND(U_FIELD)        ! OUT S'ly compt of land surface wind
C                                !     stress (N/sq m). On UV-grid with
C                                !     first and last rows undefined or
C                                !     at present, set to 'missing data'
     &,TAUY_SSI(U_FIELD)         ! OUT As TAUY_LAND but for mean sea.
*/
*D BL_IC5A.392   
     &,VSHR(P_FIELD)             ! OUT Magnitude of surface-to-lowest
C                                !     atm level wind shear (m/s).
     &,VSHR_LAND(P_FIELD)        ! OUT Land surface-to-lowest
C                                !     atm level wind shear (m/s).
     &,VSHR_SSI(P_FIELD)         ! OUT Mean sea surface-to-lowest
C                                !     atm level wind shear (m/s).
*/
*D BL_IC5A.415,416
     &,SICE_MLT_HTF(P_FIELD)    ! OUT Heat flux due to melting of sea-
C                               !     ice (Watts per sq metre).
C                               !     Weighted over sea mean.
*/
*I BL_IC5A.420 
     &,Q1P5M_LAND(P_FIELD)      ! OUT Land Q at 1.5 m (kg/kg).
     &,Q1P5M_SSI(P_FIELD)       ! OUT Mean sea Q at 1.5 m (kg/kg).
*I BL_IC5A.421
     &,T1P5M_LAND(P_FIELD)      ! OUT Land T at 1.5 m (K).
     &,T1P5M_SSI(P_FIELD)       ! OUT Mean sea T at 1.5 m (K).
*I BL_IC5A.422
     &,U10M_LAND(U_FIELD)       ! OUT Land U at 10 m (m/s).
     &,U10M_SSI(U_FIELD)        ! OUT Mean sea U at 10 m (m/s).
*I BL_IC5A.423
     &,V10M_LAND(U_FIELD)       ! OUT Land V at 10 m (m/s).
     &,V10M_SSI(U_FIELD)        ! OUT Mean sea V at 10 m (m/s).
*/
*D BL_IC5A.428
     & ECAN(P_FIELD)  ! OUT Land evaporation from canopy/surface
*/
*D BL_IC5A.430,431
     &,EI(P_FIELD)    ! OUT Sublimation from lying snow or sea-ice (kg
C                     !     per sq m per sec).
     &,EI_LAND(P_FIELD)    
C                     ! OUT Sublimation from lying snow (kg
C                     !     per sq m per sec).
     &,EI_SICE(P_FIELD)
C                     ! OUT Sublimation from lying sea-ice (kg
C                     !     per sq m per sec).
*/
*I BL_IC5A.444
C
      REAL
     & FLANDG(P_FIELD)            ! WORK Fraction of land in grid box. 
     &,FLAND(LAND_FIELD)         ! WORK Fraction of land in grid box. 
C
      INTEGER
     & COAST_INDEX(P_FIELD)      ! WORK COAST_INDEX(I)=J => the Jth
!                                !    point in P_FIELD is the Ith
!                                !    coast point.
     &,COAST_PTS                 ! WORK No of coastal points processed.
     &,SEA_INDEX(P_FIELD)        ! WORK SEA_INDEX(I)=J => the Jth
!                                !    point in P_FIELD is the Ith
!                                !    sea point.
     &,SEA_PTS                   ! WORK No of sea points processed.
     &,SICE_INDEX(P_FIELD)       ! WORK SICE_INDEX(I)=J => the Jth
!                                !    point in P_FIELD is the Ith
!                                !    sea-ice point.
     &,SICE_PTS                  ! WORK No of sea-ice points processed.
     &,SEANOICE_INDEX(P_FIELD)   ! WORK SEANOICE_INDEX(I)=J => the Jth
!                                !    point in P_FIELD is the Ith
!                                !    sea point without sea-ice.
     &,SEANOICE_PTS              ! WORK No of sea-ice free sea points
!                                !    processed.
*/
*I BL_IC5A.447   
     &,k
*/----------------------------------------------------------------
*/ call boundary layer
*I BL_IC5A.465
     &,SEA_PTS,SEA_INDEX,SICE_PTS,SICE_INDEX
     &,SEANOICE_PTS,SEANOICE_INDEX,COAST_PTS,COAST_INDEX
     &,FLANDG,FLAND
*/
*D BL_IC5A.491
     &,CO2_MMR,PHOTOSYNTH_ACT_RAD,PSTAR,RADNET_LAND,RADNET_SICE
     &,TIMESTEP
*/
*D BL_IC5A.495
     &,Q,GS,T,T_DEEP_SOIL,TI
     &,TSTAR,TSTAR_LAND,TSTAR_SEA,TSTAR_SICE,TSTAR_SSI
     &,U,V,Z0MSEA
*/
*D ANG1F405.54
     &,CD,CD_LAND,CD_SSI,CH,CH_LAND,CH_SSI
     &,E_SEA,EPOT,EPOT_LAND,EPOT_SSI,ETRAN,FQW,FQW_LAND,FQW_SSI
     &,FSMC,FTL,FTL_LAND,FTL_SSI,H_SEA,RHOKH,RHOKM
     &,RIB,RIB_LAND,RIB_SSI
*D BL_IC5A.499
     &,SEA_ICE_HTF,SURF_HT_FLUX_LAND,SURF_HT_FLUX_SICE
     &,TAUX,TAUX_LAND,TAUX_SSI,TAUY,TAUY_LAND,TAUY_SSI
     &,VSHR,VSHR_LAND,VSHR_SSI
*D BL_IC5A.503   
     &,Q1P5M,Q1P5M_LAND,Q1P5M_SSI,T1P5M,T1P5M_LAND,T1P5M_SSI
     &,U10M,U10M_LAND,U10M_SSI,V10M,V10M_LAND,V10M_SSI
*D BL_IC5A.515   
     &,ECAN,EI,EI_LAND,EI_SICE,ES,EXT,SNOWMELT,ZH
*/
*/----------------------------------------------------------------
*/------------------------------------------------------------------------
*ID CTILE2
*/---------------------------------------------------------------------------
*/--------------------------------------------------------------------------
*/ Modifications to SFEVAP5A and SFMELT5A
*/---------------------------------------------------------------------------
*/---------------------------------------------------------------------------
*/.......................................................................
*/-----------------------------------------------------------------------
*DECLARE SFMELT5A
*/
*I AJC1F405.69    
C           08/99  Split land and sea-ice processes up so that
C                  they can co-exist in same grid box.
C                                             N. Gedney
*/
*/
*I SFMELT5A.32    
     &,SEANOICE_PTS,SEANOICE_INDEX,SICE_PTS,SICE_INDEX
     &,FLANDG
*D SFMELT5A.34,36
     &,ALPHA1_LAND,ALPHA1_SICE,ASHTF_LAND,ASHTF_SICE
     &,ASURF_SICE,ICE_FRACT
     &,RHOKH1_PRIME_LAND,RHOKH1_PRIME_SICE
     &,TIMESTEP,SIMLT,SMLT,DFQW_LAND,DFQW_SICE
     &,DIFF_SENS_HTF_LAND,DIFF_SENS_HTF_SICE
     &,EI_LAND,EI_SICE,LYING_SNOW
     &,SURF_HT_FLUX_LAND
     &,TSTAR_LAND,TSTAR_SEA,TSTAR_SICE,TSTAR_SSI,TI
*/
*I SFMELT5A.54
      INTEGER
     & SICE_INDEX(P_FIELD)       ! IN SICE_INDEX(I)=J => the Jth
!                                !    point in P_FIELD is the Ith
!                                !    sea-ice point.
     &,SICE_PTS                  ! IN No of sea-ice points processed.
     &,SEANOICE_INDEX(P_FIELD)   ! IN SEANOICE_INDEX(I)=J => the Jth
!                                !    point in P_FIELD is the Ith
!                                !    sea-ice free sea point.
     &,SEANOICE_PTS              ! IN No of sea-ice free sea points
!                                !    processed.
      REAL
     & FLANDG(P_FIELD)       ! IN Fraction of land in grid box. 
*/
*D SFMELT5A.57,60
     & ALPHA1_LAND(P_FIELD) ! IN Gradient of saturated specific
C                           !    humidity with respect to temp.
C                           !    between the bottom model layer
C                           !    and the land surface.
     &,ALPHA1_SICE(P_FIELD) ! IN Gradient of saturated specific
C                           !    humidity with respect to temp.
C                           !    between the bottom model layer
C                           !    and the sea-ice surface.
*D SFMELT5A.61
     &,ASHTF_LAND(LAND_FIELD)
C                           ! IN Forward time weighted coeff.
     &,ASHTF_SICE(P_FIELD)  ! IN Forward time weighted coeff.
*D SFMELT5A.65,67
     &,ASURF_SICE(P_FIELD)  ! IN Reciprocal areal heat capacity of
C                           !    sea-ice surface layer (m2 K / J).
*D SFMELT5A.68,69
     &,ICE_FRACT(P_FIELD)   ! IN Fraction of sea which is sea-ice.
*D SFMELT5A.70,71
     &,RHOKH1_PRIME_LAND(P_FIELD)
C                           ! IN Modified forward time-weighted
C                           !    transfer coefficient for land.
     &,RHOKH1_PRIME_SICE(P_FIELD)
C                           ! IN Modified forward time-weighted
C                           !    transfer coefficient for sea/sea-ice.
*D SFMELT5A.77,82  
     & DFQW_LAND(P_FIELD)   ! INOUT Increment to the land flux
C                           !       of total water.
     &,DFQW_SICE(P_FIELD)   ! INOUT Increment to the sea-ice flux 
C                           !       of total water.
     &,DIFF_SENS_HTF_LAND(P_FIELD)
C                           ! INOUT Increment to the land sensible heat
C                           !        flux (W/m2).              
     &,DIFF_SENS_HTF_SICE(P_FIELD)
C                           ! INOUT Increment to the sea ensible heat
C                           !        flux (W/m2).              
     &,EI_LAND(P_FIELD)     ! INOUT Sublimation from lying snow
C                           !        (Kg/m2/s).
     &,EI_SICE(P_FIELD)     ! INOUT Sublimation from sea-ice
C                           !        (Kg/m2/s).
*D SFMELT5A.84,86
     &,SURF_HT_FLUX_LAND(P_FIELD)
C                           ! INOUT Net downward heat flux at surface
C                           !       over land (W/m2).
*D SFMELT5A.87
     &,TSTAR_LAND(P_FIELD)  ! INOUT Land surface temperature (K).
     &,TSTAR_SEA(P_FIELD)   ! IN Sea surface temperature (K).
     &,TSTAR_SICE(P_FIELD)  ! INOUT Sea-ice surface temperature (K).
     &,TSTAR_SSI(P_FIELD)   ! INOUT Mean sea surface temperature (K).
*/
*D SFMELT5A.89,90
     &,SICE_MLT_HTF(P_FIELD)! OUT Heat flux due to melting of sea-ice
C                           !     (W/m2). Weighted over sea mean.
*I SFMELT5A.109
     &,SE                   ! Loop counter - sea field.
     &,SI                   ! Loop counter - sea-ice field.
     &,SNI                  ! Loop counter (sea-ice free
!                           ! sea point field index).
*/.......................................................................
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*/ And now to separate the variables in the code itself:
*/-----------------------------------------------------------------------
*/******LAND PART:
*D SFMELT5A.130   
C  Melt snow if TSTAR_LAND is greater than TM.
*D SFMELT5A.132,135
        SNOW_MAX = MAX(0.0, LYING_SNOW(I) - EI_LAND(I)*TIMESTEP )
        IF ( SNOW_MAX.GT.0.0 .AND. TSTAR_LAND(I).GT.TM ) THEN
          DMELT = ( CP + LC * ALPHA1_LAND(I) ) * RHOKH1_PRIME_LAND(I) 
     &      + ASHTF_LAND(L)
          DTSTAR = - MIN ( TSTAR_LAND(I) - TM ,
*D SFMELT5A.137   
          DMELT = DMELT + LF * ALPHA1_LAND(I) * RHOKH1_PRIME_LAND(I)
*D SFMELT5A.139 
          DIFF_SENS_HTF_LAND(I) = DIFF_SENS_HTF_LAND(I) +
*D SFMELT5A.140,146
     &                        CP * RHOKH1_PRIME_LAND(I) * DTSTAR
          DIFF_EI = ALPHA1_LAND(I) * RHOKH1_PRIME_LAND(I) * DTSTAR
          EI_LAND(I) = EI_LAND(I) + DIFF_EI
          DFQW_LAND(I) = DFQW_LAND(I) + DIFF_EI
          DIFF_SURF_HTF = ASHTF_LAND(L) * DTSTAR
          SURF_HT_FLUX_LAND(I) = SURF_HT_FLUX_LAND(I) + DIFF_SURF_HTF
          TSTAR_LAND(I) = TSTAR_LAND(I) + DTSTAR
*/
*/-----------------------------------------------------------------------
*/.......................................................................
*/******SEA/SEA-ICE PART:
*D SFMELT5A.153,154
*D SFMELT5A.156
      DO 20 SI=1,SICE_PTS
        I=SICE_INDEX(SI)
*/
*D SFMELT5A.170
              TI(I) =TI(I) + ASURF_SICE(I) * TIMESTEP * DIFF_SURF_HTF
*D SFMELT5A.176
     &                            (TI(I) - TM)/(ASURF_SICE(I)*TIMESTEP)
*/
*D SFMELT5A.180
*D SFMELT5A.185,186
 20   CONTINUE               ! End of loop over sea-ice points
*/.......................................................................
*/-----------------------------------------------------------------------
*/
*/******SEA PART:
*D SFMELT5A.160,169
            TSTARMAX = ICE_FRACT(I)*TM
     &          + (1.0 - ICE_FRACT(I))*TSTAR_SEA(I)
            IF ( TSTAR_SSI(I) .GT. TSTARMAX ) THEN
              DTSTAR = TSTARMAX - TSTAR_SSI(I)
              DMELT = (CP + (LC + LF)*ALPHA1_SICE(I))
     &          *RHOKH1_PRIME_SICE(I) + ASHTF_SICE(I)
              DIFF_SENS_HTF_SICE(I) = CP * RHOKH1_PRIME_SICE(I) * DTSTAR
              DIFF_EI = ALPHA1_SICE(I) * RHOKH1_PRIME_SICE(I) * DTSTAR
              EI_SICE(I) = EI_SICE(I) + DIFF_EI
              DFQW_SICE(I) = DFQW_SICE(I) + DIFF_EI
              DIFF_SURF_HTF = ASHTF_SICE(I) * DTSTAR
*D SFMELT5A.171 
              TSTAR_SSI(I) = TSTARMAX
              TSTAR_SICE(I) = TM
*/.......................................................................
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*/.......................................................................
*DECLARE SFEVAP5A
*/
*I SFEVAP5A.34 
CLL           08/99  Allow for the inclusion of coastal tiles, i.e.
CLL                  land and sea and sea-ice may coexist on the same
CLL                  grid box. Requires the splitting up of all the surface
CLL                  fluxes into land, sea and sea-ice components. Separate
CLL                  temperatures are also required.
CLL                                            N. Gedney
CLL
*/
*I SFEVAP5A.52    
     &,SEA_PTS,SEA_INDEX,SICE_PTS,SICE_INDEX
     &,SEANOICE_PTS,SEANOICE_INDEX,COAST_PTS,COAST_INDEX
     &,FLANDG
*D SFEVAP5A.54,61
     &,ALPHA1_LAND,ALPHA1_SICE,ASHTF_LAND,ASHTF_SICE
     &,ASURF_SICE,CANOPY,CATCH
     &,DTRDZ,DTRDZ_RML,E_SEA,FRACA                                         SFEVAP5A.55    
     &,ICE_FRACT,NRML,RHOKH_LAND,RHOKH_SICE
     &,SMC,TIMESTEP
     &,CER1P5M_LAND,CHR1P5M_LAND,CER1P5M_SSI,CHR1P5M_SSI
     &,PSTAR,RESFS,RESFT,Z1
     &,Z0M_LAND,Z0M_SSI,Z0H_LAND,Z0H_SSI
     &,SQ1P5,ST1P5,SIMLT,SMLT
     &,FTL,FTL_LAND,FTL_SSI,FQW,FQW_LAND,FQW_SSI,LYING_SNOW,QW
     &,SURF_HT_FLUX_LAND,SURF_HT_FLUX_SICE
     &,TL,TSTAR_LAND,TSTAR_SEA,TSTAR_SICE,TSTAR_SSI,TI
     &,ECAN,ES,EI_GB,EI_LAND,EI_SICE
     &,SICE_MLT_HTF,SNOMLT_SURF_HTF,SNOWMELT                               SFEVAP5A.60    
     &,Q1P5M,Q1P5M_LAND,Q1P5M_SSI,T1P5M,T1P5M_LAND,T1P5M_SSI
     &,LTIMER
*/
*D SFEVAP5A.74
     & LAND_MASK(P_FIELD)   ! IN T if any land, F otherwise.
*I SFEVAP5A.79
      INTEGER
     & COAST_INDEX(P_FIELD)      ! IN COAST_INDEX(I)=J => the Jth
!                                !    point in P_FIELD is the Ith
!                                !    coast point.
     &,COAST_PTS                 ! IN No of coastal points processed.
     &,SEA_INDEX(P_FIELD)        ! IN SEA_INDEX(I)=J => the Jth
!                                !    point in P_FIELD is the Ith
!                                !    sea point.
     &,SEA_PTS                   ! IN No of sea points processed.
     &,SICE_INDEX(P_FIELD)       ! IN SICE_INDEX(I)=J => the Jth
!                                !    point in P_FIELD is the Ith
!                                !    sea-ice point.
     &,SICE_PTS                  ! IN No of sea-ice points processed.
     &,SEANOICE_INDEX(P_FIELD)   ! IN SEANOICE_INDEX(I)=J => the Jth
!                                !    point in P_FIELD is the Ith
!                                !    sea-ice free sea point.
     &,SEANOICE_PTS              ! IN No of sea-ice free sea points
!                                !    processed.
      REAL
     & FLANDG(P_FIELD)       ! IN Fraction of land in grid box. 
*/
*D SFEVAP5A.82,85
     & ALPHA1_LAND(P_FIELD) ! IN Gradient of saturated specific
C                           !    humidity with respect to temp.
C                           !    between the bottom model layer
C                           !    and the land surface.           
     &,ALPHA1_SICE(P_FIELD)  ! IN Gradient of saturated specific
C                           !    humidity with respect to temp.
C                           !    between the bottom model layer
C                           !    and the sea surface.           
*D SFEVAP5A.86,91 
     &,ASURF_SICE(P_FIELD)  ! IN Sea-ice coeff. from P242 (sq m K per
C                           !    per Joule * timestep).
     &,ASHTF_LAND(LAND_FIELD)
C                           ! IN Coefficient to calculate
C                           !    the soil heat flux
C                           !    between the surface and top soil
C                           !    layer (W/m2/K).
     &,ASHTF_SICE(LAND_FIELD)
C                           ! IN Coefficient to calculate
C                           !    the soil heat flux
C                           !    between the surface and top sea-ice
C                           !    layer (W/m2/K).
*/
*/th     &,CANOPY(LAND_FIELD)   ! IN Land mean canopy / surface water
*/
*D SFEVAP5A.100,103
     &,E_SEA(P_FIELD)       ! IN Evaporation from sea times leads
C                           !    fraction of total sea portion
C                           !    of grid box. Zero over land-only
C                           !    points. (kg/m2/s).
     &,FRACA(P_FIELD)       ! IN Fraction of land surface moisture flux
C                           !    with only aerodynamic resistance.
*/
*D SFEVAP5A.107,110
*D SFEVAP5A.112,113
     &,ICE_FRACT(P_FIELD)   ! IN Fraction of sea which is sea-ice.
C                           !    (decimal fraction, but most of
C                           !    this sub-component assumes it to be
C                           !    either 1.0 or 0.0 precisely).
*/
*D SFEVAP5A.118,119
     & SQ1P5                ! IN STASH flag for 1.5-metre
C                           !    grid box mean sp humidity.
     &,ST1P5                ! IN STASH flag for 1.5-metre
C                           !    grid box mean temperature.
*/
*D SFEVAP5A.132
     &,Z0M_LAND(P_FIELD)    ! IN Land roughness length
C                           !    for momentum (m).
     &,Z0M_SSI(P_FIELD)     ! IN Sea/Sea-ice roughness length
C                           !    for momentum (m).
*D SFEVAP5A.123,124
     & CER1P5M_LAND(P_FIELD)! IN Transfer coefficient ratio, from P243.
     &,CHR1P5M_LAND(P_FIELD)! IN Transfer coefficient ratio, from P243.
     &,CER1P5M_SSI(P_FIELD) ! IN Transfer coefficient ratio, from P243.
     &,CHR1P5M_SSI(P_FIELD) ! IN Transfer coefficient ratio, from P243.

*D SFEVAP5A.133
     &,Z0H_LAND(P_FIELD)    ! IN Land roughness length
C                           ! for heat and moisture (m).
     &,Z0H_SSI(P_FIELD)     ! IN Sea/sea-ice roughness length
C                           ! for heat and moisture (m).
*D SFEVAP5A.138,139
     & RHOKH_LAND(P_FIELD)  ! IN    Turbulent surface exchange
C                           !       coefficient for sensible heat
C                           !       over land.
     &,RHOKH_SICE(P_FIELD)  ! IN    Turbulent surface exchange
C                           !       coefficient for sensible heat
C                           !       over sea.
*I SFEVAP5A.142
     &,FTL_LAND(LAND_FIELD) ! INOUT Land surface sensible heat
C                           !       flux (W/sq m).
     &,FTL_SSI(P_FIELD)     ! INOUT Sea/sea-ice surface sensible heat
C                           !       flux (W/sq m).
*I SFEVAP5A.146   
     &,FQW_LAND(LAND_FIELD) ! INOUT Land surface turbulent moisture
C                           !       flux (kg/sq m/s).
     &,FQW_SSI(P_FIELD)     ! INOUT Sea/sea-ice sfc turbulent moisture
C                           !       flux (kg/sq m/s).
*D SFEVAP5A.152,154 
     &,SURF_HT_FLUX_LAND(P_FIELD)
C                           ! INOUT Net downward heat flux at surface
C                           !       over land (W/m2).               
     &,SURF_HT_FLUX_SICE(P_FIELD)
C                           ! INOUT Net downward heat flux at surface
C                           !       over sea-ice fraction of sea
C                           !       portion of gridbox (W/m2).               
*D SFEVAP5A.155
     &,TSTAR_GB(P_FIELD)    ! WORK Surface temperature (K).
     &,TSTAR_LAND(P_FIELD)  ! INOUT Land surface temperature (K).
     &,TSTAR_SEA(P_FIELD)   ! IN Sea surface temperature (K).
     &,TSTAR_SICE(P_FIELD)  ! IN Sea-ice surface temperature (K).
     &,TSTAR_SSI(P_FIELD)   ! INOUT Mean sea surface temperature (K).
*D SFEVAP5A.159 
     & ECAN(P_FIELD)        ! OUT Land evaporation from canopy/
*D SFEVAP5A.162,165   
     &,ES(P_FIELD)          ! OUT Land surface evapotranspiration
C                           !     (through a resistance which is
C                           !     not entirely aerodynamic). Always
C                           !     non-negative. (kg/m2/s).
*D SFEVAP5A.169,170
     &,EI_GB(P_FIELD)       ! OUT Sublimation from lying snow or sea-
C                           !     ice (kg per sq m per s).        
     &,EI_LAND(P_FIELD)     ! OUT Land sublimation from lying snow 
C                           !     (kg per sq m per s).           
     &,EI_SICE(P_FIELD)     ! OUT Sublimation from sea-ice
C                           !     (kg per sq m per s).           
*D SFEVAP5A.172,173
     & SICE_MLT_HTF(P_FIELD)! OUT Heat flux due to melting of sea-ice
C                           !     (W/m2). Weighted over sea mean.
*D SFEVAP5A.177,180
     &,Q1P5M(P_FIELD)       ! OUT Grid box mean specific humidity
C                           !     at screen height of
C                           !     1.5 metres (kg water per kg air).
     &,Q1P5M_LAND(P_FIELD)  ! OUT Specific humidity at screen height of
C                           !     1.5 metres (kg water per kg air).
     &,Q1P5M_SSI(P_FIELD)   ! OUT Specific humidity at screen height of
C                           !     1.5 metres (kg water per kg air).
     &,T1P5M(P_FIELD)       ! OUT Grid box mean temperature at 
C                           !     1.5 metres above the surface (K).
     &,T1P5M_LAND(P_FIELD)  ! OUT Temperature at 1.5 metres above the
C                           !     surface (K).
     &,T1P5M_SSI(P_FIELD)   ! OUT Temperature at 1.5 metres above the
C                           !     surface (K).
*D SFEVAP5A.203,204
     & DFQW_LAND(P_FIELD)    ! Adjustment increment to the flux of
C                            ! total water over land.
     &,DFQW_SICE(P_FIELD)    ! Adjustment increment to the flux of
C                            ! total water over sea-ice.
*D SFEVAP5A.205,206
     &,DIFF_SENS_HTF_LAND(P_FIELD)
C                            ! Adjustment increment to the sensible
C                            ! heat flux over land.            
     &,DIFF_SENS_HTF_SICE(P_FIELD)
C                            ! Adjustment increment to the sensible
C                            ! heat flux over sea.
*D SFEVAP5A.207
     &,DQW_LAND(P_FIELD)     ! Increment to spec. humidity on land.
     &,DQW_SICE(P_FIELD)     ! Increment to spec. humidity on sea-ice.
*D SFEVAP5A.208
     &,DTL_LAND(P_FIELD)     ! Increment to temperature on land.
     &,DTL_SICE(P_FIELD)     ! Increment to temperature on sea-ice.
*D  SFEVAP5A.211,212
     &,EOLD_LAND(P_FIELD)    ! Used to store initial value of
C                            ! land evap. from P244                           
     &,EOLD_SSI(P_FIELD)     ! Used to store initial value of
C                            ! sea/sea-ice evap. from P244                           
*D  SFEVAP5A.215,216
     &,LEOLD_LAND(P_FIELD)   ! Used to store initial value of
C                            ! land latent heat flux from P244                  
*D SFEVAP5A.219,220
     &,RHOKH1_PRIME_LAND(P_FIELD)
C                            ! Modified forward time-weighted transfer
C                            ! coefficient over land.                
     &,RHOKH1_PRIME_SICE(P_FIELD)
C                            ! Modified forward time-weighted transfer
C                            ! coefficient over sea/sea-ice.
*D SFEVAP5A.250   
C                          ! ation (-ve), averaged over land

*/.......................................................................
*/-----------------------------------------------------------------------
*/
*I SFEVAP5A.268
     &,SE,SI,SNI
*/
*/ Set all variables to zero to start with:
*/
*D SFEVAP5A.279,281
        EI_GB(I) = 0.0
        EI_LAND(I) = 0.0
        EI_SICE(I) = 0.0
        DIFF_SENS_HTF_LAND(I) = 0.0
        DIFF_SENS_HTF_SICE(I) = 0.0
        DFQW_LAND(I) = 0.0
        DFQW_SICE(I) = 0.0
        ES(I) = 0.0
        T1P5M(I)= 0.0
        T1P5M_LAND(I)= 0.0
        T1P5M_SSI(I)= 0.0
        Q1P5M(I)= 0.0
        Q1P5M_LAND(I)= 0.0
        Q1P5M_SSI(I)= 0.0
*/*I SFEVAP5A.282
*/      DO L=LAND1,LAND1+LAND_PTS-1
*/      ENDDO
*D SFEVAP5A.611,612
*D SFEVAP5A.614,622   
*/
*D SFEVAP5A.303
          IF (FQW_LAND(L).EQ.0.0) THEN 
*D SFEVAP5A.307,308
            EA = FQW_LAND(L) / RESFT(I) * FRACA(I)
            ESL = FQW_LAND(L) / RESFT(I) * RESFS(I)
*/
*D SFEVAP5A.335,336
              EOLD_LAND(I) = FQW_LAND(L)
              LEOLD_LAND(I) = FQW_LAND(L) * LC
*D SFEVAP5A.404
                EI_LAND(I) = 0.0
*D SFEVAP5A.412
              ELSEIF (TSTAR_LAND(I).GT.TM) THEN     ! ELSE of evaporation 
*D SFEVAP5A.417
                ECAN(I) = FQW_LAND(L)
*D SFEVAP5A.420
                EI_LAND(I) = 0.0
*D SFEVAP5A.431
                EI_LAND(I) = FQW_LAND(L)
*D SFEVAP5A.448
C Store initial value of land evaporation and latent heat flux
*D SFEVAP5A.451,452
              EOLD_LAND(I) = FQW_LAND(L)
              LEOLD_LAND(I) = FQW_LAND(L) * ( LC + LF )
*D SFEVAP5A.467
              EI_LAND(I) = LYING_SNOW(I) / TIMESTEP
*D SFEVAP5A.540
              EI_LAND(I) = FQW_LAND(L)
*D SFEVAP5A.544
C Store initial value of land evaporation and latent heat flux
*D SFEVAP5A.547,548
              EOLD_LAND(I) = FQW_LAND(L)
              LEOLD_LAND(I) = FQW_LAND(L) * ( LC + LF )
*D SFEVAP5A.555
            FQW_LAND(L) = EW(I) + EI_LAND(I)
*/
*D SFEVAP5A.572,575
C  2.4 Calculate increments to land surface and subsurface
C      temperatures, surface heat and moisture fluxes and soil heat
C      flux. Apply increments to TSTAR_LAND to give interim values
C      before any snowmelt.
*/
*D SFEVAP5A.582
          RHOKH1_PRIME_LAND(I) = 1.0 / ( 1.0 / RHOKH_LAND(I)
*D SFEVAP5A.584,587
          DIFF_LAT_HTF = (LC + LF) * EI_LAND(I) + LC * EW(I)
     &                                  - LEOLD_LAND(I)
          DFQW_LAND(I) = FQW_LAND(L) - EOLD_LAND(I)
          DIFF_SENS_HTF_LAND(I) = - DIFF_LAT_HTF /
     &             ( 1. + ASHTF_LAND(L) /(RHOKH1_PRIME_LAND(I) * CP) )
*D SFEVAP5A.589,592
     &                    RHOKH1_PRIME_LAND(I) * CP / ASHTF_LAND(L) )
          SURF_HT_FLUX_LAND(I) = SURF_HT_FLUX_LAND(I) + DIFF_SURF_HTF
          DTSTAR = DIFF_SURF_HTF / ASHTF_LAND(L)
          TSTAR_LAND(I) = TSTAR_LAND(I) + DTSTAR
*/
*D SFEVAP5A.627
      DO 25 SI=1,SICE_PTS
            I=SICE_INDEX(SI)
*D SFEVAP5A.637
*D SFEVAP5A.642   
*D SFEVAP5A.628,629
              EOLD_SSI(I) = FQW_SSI(I)  
              EI_SICE(I) = FQW_SSI(I) - E_SEA(I)
*D SFEVAP5A.635
              RHOKH1_PRIME_SICE(I) = 1.0 / ( 1.0 / RHOKH_SICE(I) 
*/
*/ call sfmelt
*I SFEVAP5A.654   
     &,SEANOICE_PTS,SEANOICE_INDEX,SICE_PTS,SICE_INDEX
     &,FLANDG
*D SFEVAP5A.656,658
     &,ALPHA1_LAND,ALPHA1_SICE,ASHTF_LAND,ASHTF_SICE
     &,ASURF_SICE,ICE_FRACT
     &,RHOKH1_PRIME_LAND,RHOKH1_PRIME_SICE
     &,TIMESTEP,SIMLT,SMLT,DFQW_LAND,DFQW_SICE
     &,DIFF_SENS_HTF_LAND,DIFF_SENS_HTF_SICE
     &,EI_LAND,EI_SICE,LYING_SNOW
     &,SURF_HT_FLUX_LAND
     &,TSTAR_LAND,TSTAR_SEA,TSTAR_SICE,TSTAR_SSI,TI
*/
*D SFEVAP5A.666,675
      DO L=LAND1,LAND1+LAND_PTS-1
        I = LAND_INDEX(L)
        DQW_LAND(I) = DTRDZ_1(I) * DFQW_LAND(I)
        DTL_LAND(I) = DTRDZ_1(I) * DIFF_SENS_HTF_LAND(I) / CP
        TL(I,1) = TL(I,1) + DTL_LAND(I)*FLANDG(I)
        QW(I,1) = QW(I,1) + DQW_LAND(I)*FLANDG(I)
        FTL_LAND(L) = FTL_LAND(L) + DIFF_SENS_HTF_LAND(I)     
        FQW_LAND(L) = EOLD_LAND(I) + DFQW_LAND(I)
      ENDDO                      ! Loop over land points
      DO SI=1,SICE_PTS
        I=SICE_INDEX(SI)
        DQW_SICE(I) = DTRDZ_1(I) * DFQW_SICE(I)
        DTL_SICE(I) = DTRDZ_1(I) * DIFF_SENS_HTF_SICE(I) / CP
        TL(I,1) = TL(I,1) + DTL_SICE(I)*(1.-FLANDG(I))
        QW(I,1) = QW(I,1) + DQW_SICE(I)*(1.-FLANDG(I))
        FTL_SSI(I) = FTL_SSI(I) + DIFF_SENS_HTF_SICE(I)     
        FQW_SSI(I) = EOLD_SSI(I) + DFQW_SICE(I)
      ENDDO                      ! Loop over sea-ice points
*/
*D SFEVAP5A.681,693
        DO L=LAND1,LAND1+LAND_PTS-1
          I = LAND_INDEX(L)
          IF ( K .LE. NRML(I) ) THEN 
            TL(I,K) = TL(I,K) + DTL_LAND(I)*FLANDG(I)
            QW(I,K) = QW(I,K) + DQW_LAND(I)*FLANDG(I)
            DIFF_SENS_HTF_LAND(I) = DIFF_SENS_HTF_LAND(I)
     &                         - CP * DTL_LAND(I) / DTRDZ(I,KM1)
            DFQW_LAND(I) = DFQW_LAND(I) - DQW_LAND(I) / DTRDZ(I,KM1)
            FTL_LAND(L) = FTL_LAND(L) + DIFF_SENS_HTF_LAND(I)
            FQW_LAND(L) = FQW_LAND(L) + DFQW_LAND(I)
          ENDIF  ! Rapidly mixing layer
        ENDDO                   ! Loop over land points 
        DO SI=1,SICE_PTS
          I=SICE_INDEX(SI)
          IF ( K .LE. NRML(I) ) THEN 
            TL(I,K) = TL(I,K) + DTL_SICE(I)*(1.-FLANDG(I))
            QW(I,K) = QW(I,K) + DQW_SICE(I)*(1.-FLANDG(I))
            DIFF_SENS_HTF_SICE(I) = DIFF_SENS_HTF_SICE(I)
     &                         - CP * DTL_SICE(I) / DTRDZ(I,KM1)
            DFQW_SICE(I) = DFQW_SICE(I) - DQW_SICE(I) / DTRDZ(I,KM1)
            FTL_SSI(I) = FTL_SSI(I) + DIFF_SENS_HTF_SICE(I)
            FQW_SSI(I) = FQW_SSI(I) + DFQW_SICE(I)
          ENDIF  ! Rapidly mixing layer
        ENDDO                   ! Loop over sea-ice points 
*/
*I SFEVAP5A.699
      DO L=LAND1,LAND1+LAND_PTS-1
        I = LAND_INDEX(L)
        EI_GB(I)=FLANDG(I)*EI_LAND(I)
        FQW(I,1)=FLANDG(I)*FQW_LAND(L)
        FTL(I,1)=FLANDG(I)*FTL_LAND(L)
        TSTAR_GB(I)=FLANDG(I)*TSTAR_LAND(I)
      ENDDO
C
      DO SI=1,SICE_PTS
        I=SICE_INDEX(SI)
        IF(LAND_MASK(I))THEN
          EI_GB(I)=EI_GB(I)+(1.-FLANDG(I))*EI_SICE(I)
        ELSE
          EI_GB(I)=EI_SICE(I)
        ENDIF
      ENDDO
C
      DO SE=1,SEA_PTS
        I=SEA_INDEX(SE)
        IF(LAND_MASK(I))THEN
          FQW(I,1)=FQW(I,1)+(1.-FLANDG(I))*FQW_SSI(I)
          FTL(I,1)=FTL(I,1)+(1.-FLANDG(I))*FTL_SSI(I)
          TSTAR_GB(I)=TSTAR_GB(I)+(1.-FLANDG(I))*TSTAR_SSI(I)
        ELSE
          FQW(I,1)=FQW_SSI(I)
          FTL(I,1)=FTL_SSI(I)
          TSTAR_GB(I)=TSTAR_SSI(I)
        ENDIF
      ENDDO
*/
*/
*D SFEVAP5A.701,708
      IF (SQ1P5 .OR. ST1P5) THEN
       IF (SQ1P5) CALL QSAT(QS(P1),TSTAR_LAND(P1),PSTAR(P1),POINTS)
      DO L=LAND1,LAND1+LAND_PTS-1
        I = LAND_INDEX(L)
c          IF (SQ1P5) CALL QSAT(QS(P1),TSTAR_LAND(P1),PSTAR(P1),POINTS)
          IF (ST1P5) T1P5M_LAND(I) = TSTAR_LAND(I) - GRCP*Z1P5M 
     &               + CHR1P5M_LAND(I) * ( TL(I,1) - TSTAR_LAND(I)
     &               + GRCP*(Z1(I)+Z0M_LAND(I)-Z0H_LAND(I)) )
          IF (SQ1P5) Q1P5M_LAND(I) = QW(I,1) + CER1P5M_LAND(I)
     &               *( QW(I,1) - QS(I) )
          T1P5M(I) =FLANDG(I)*T1P5M_LAND(I)
          Q1P5M(I) =FLANDG(I)*Q1P5M_LAND(I)
        ENDDO
        IF (SQ1P5) CALL QSAT(QS(P1),TSTAR_SSI(P1),PSTAR(P1),POINTS)
      DO SE=1,SEA_PTS
        I = SEA_INDEX(SE)
c          IF (SQ1P5) CALL QSAT(QS(P1),TSTAR_SSI(P1),PSTAR(P1),POINTS)
          IF (ST1P5) T1P5M_SSI(I) = TSTAR_SSI(I) - GRCP*Z1P5M + 
     &               CHR1P5M_SSI(I) *( TL(I,1) - TSTAR_SSI(I) 
     &               + GRCP*(Z1(I)+Z0M_SSI(I)-Z0H_SSI(I)) )
          IF (SQ1P5) Q1P5M_SSI(I) = QW(I,1) + CER1P5M_SSI(I)
     &               *( QW(I,1) - QS(I) )
          T1P5M(I) =T1P5M(I) + (1.0-FLANDG(I))*T1P5M_SSI(I)
          Q1P5M(I) =Q1P5M(I) + (1.0-FLANDG(I))*Q1P5M_SSI(I)
        ENDDO
*/
      ENDIF
*/
*/
*/.......................................................................
*/-----------------------------------------------------------------------





*ID CTILE3
*DECLARE BDYLYR5A
*/
*/---------------------------------------------------------------------------
*/---------------------------------------------------------------------------
*/  Modifications to IMPLCA4A and SICEHT4A
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*/.......................................................................
*/---------------------------------------------------------------------------
*DECLARE SICEHT4A
*/
*I SICEHT4A.13
CLL            08/99  Allow for the inclusion of coastal tiles, i.e.
CLL                  land and sea and sea-ice may coexist on the same
CLL                  grid box. Requires the splitting up of all the surface
CLL                  fluxes into land, sea and sea-ice components. Separate
CLL                  temperatures are also required.
CLL                                            N. Gedney
*/
*D SICEHT4A.34,35
      SUBROUTINE SICE_HTF(ASHTF_SICE,
     &                    DI,ICE_FRACTION,SURF_HT_FLUX_SICE,
     &                    TIMESTEP,
     &                    LAND1,LAND_MASK,P1,POINTS,
     &                    SEA_PTS,SEA_INDEX,SICE_PTS,SICE_INDEX,
     &                    SEANOICE_PTS,SEANOICE_INDEX,
     &                    COAST_PTS,COAST_INDEX,
     &                    LAND_PTS,LAND_INDEX,FLANDG,
     &                    TI,TSTAR_LAND,TSTAR_SEA,TSTAR_SSI,TSTAR_SICE,
     &                    ASURF_SICE,SEA_ICE_HTF,
*/
*I SICEHT4A.39
     &,LAND1      ! LOCAL First land-point to be processed.
     &,P1         ! LOCAL First P-point to be processed.
     &,PFIELD
*I SICEHT4A.49
      INTEGER
     & COAST_INDEX(POINTS)       ! IN COAST_INDEX(I)=J => the Jth
!                                !    point in P_POINTS is the Ith
!                                !    coast point.
     &,COAST_PTS                 ! IN No of coastal points processed.
     &,LAND_INDEX(POINTS)        ! IN LAND_INDEX(I)=J => the Jth
!                                !    point in P_POINTS is the Ith
!                                !    land point.
     &,LAND_PTS                  ! IN No of land points processed.
     &,SEA_INDEX(POINTS)         ! IN SEA_INDEX(I)=J => the Jth
!                                !    point in P_POINTS is the Ith
!                                !    sea point.
     &,SEA_PTS                   ! IN No of sea points processed.
     &,SICE_INDEX(POINTS)        ! IN SICE_INDEX(I)=J => the Jth
!                                !    point in P_POINTS is the Ith
!                                !    sea-ice point.
     &,SICE_PTS                  ! IN No of sea-ice points processed.
     &,SEANOICE_INDEX(POINTS)    ! IN SEANOICE_INDEX(I)=J => the Jth
!                                !    point in P_POINTS is the Ith
!                                !    sea-ice free sea point.
     &,SEANOICE_PTS              ! IN No of sea-ice free sea points
!                                !    processed.
      REAL
     & FLANDG(POINTS)        ! IN Fraction of land in grid box. 
*D SICEHT4A.51,53
     & TI(POINTS)           ! INOUT  Sea-ice surface layer temperature
C                           !        (K). Set to TSTAR for unfrozen sea,
C                           !        missing data for land.
*D SICEHT4A.54    
     &,TSTAR_LAND(POINTS)        ! IN Land surface temperature (K)  
     &,TSTAR_SEA(POINTS)         ! IN Sea only surface temperature (K)  
     &,TSTAR_SICE(POINTS)        ! INOUT Mean sea sfc temperature (K)  
     &,TSTAR_SSI(POINTS)         ! INOUT Mean sea sfc temperature (K)  
*D SICEHT4A.55,56
     &,ASURF_SICE(POINTS)   ! OUT Reciprocal areal heat capacity of
C                           !     sea-ice surface layer (Km2/J).
*D SICEHT4A.57,58
     &,SEA_ICE_HTF(POINTS)  ! OUT Heat flux through sea-ice. Weighted
C                           !     by sea-ice fraction in sea portion
C                           !     of gridbox. (W/m2,positive downwards).
*/.......................................................................
*/-----------------------------------------------------------------------
*/
*D SICEHT4A.41,42
     & ASHTF_SICE(POINTS)   ! IN Coefficient to calculate surface
C                           !    heat flux into sea-ice (W/m2/K).
*D SICEHT4A.44,46
     &,ICE_FRACTION(POINTS) ! IN Fraction of sea covered by sea-ice.
     &,SURF_HT_FLUX_SICE(POINTS)
C                           ! IN Net downward heat flux at surface
C                           !    over sea-ice fraction of sea 
C                           !    portion of gridbox (W/m2).               
*I SICEHT4A.69
     &,L                    ! Loop Counter; land field index.
     &,SI                   ! Loop Counter; sea-ice field index.
     &,SNI                  ! Loop Counter; sea without sea-ice field index.
*/
*I SICEHT4A.75
      DO L=LAND1,LAND1+LAND_PTS-1
        I = LAND_INDEX(L)-(P1-1)
        SEA_ICE_HTF(I) = 0.0
        IF(ICE_FRACTION(I).LE.0.0)TI(I) = 0.0
      ENDDO
C
      DO SNI=1,SEANOICE_PTS
        I = SEANOICE_INDEX(SNI)-(P1-1)
        SEA_ICE_HTF(I) = 0.0
        TI(I) = TFS
        TSTAR_SICE(I) = TFS
      ENDDO
*/
*D SICEHT4A.76,91
      DO SI=1,SICE_PTS
        I = SICE_INDEX(SI)-(P1-1)
        ASURF_SICE(I) = AI / ICE_FRACTION(I)
        SEA_ICE_HTF(I) = KAPPAI*ICE_FRACTION(I)*
     &                  (TI(I) - TSTAR_SEA(I))/DI(I)
        TSTAR_SSI(I) = (1.-ICE_FRACTION(I))*TSTAR_SEA(I)
     &                +ICE_FRACTION(I)*TI(I)
     &                + SURF_HT_FLUX_SICE(I)/ASHTF_SICE(I)
        TI(I) = TI(I) + ASURF_SICE(I)*TIMESTEP*
     &                  (SURF_HT_FLUX_SICE(I) - SEA_ICE_HTF(I))
      ENDDO
*/---------------------------------------------------------------------------
*/---------------------------------------------------------------------------
*/ START code for IMPLCA4A:
*/---------------------------------------------------------------------------
*/---------------------------------------------------------------------------
*/.......................................................................
*/-----------------------------------------------------------------------
*/
*DECLARE IMPLCA4A
*D IMPLCA4A.42,44
     & LAND_FIELD,P_FIELD,U_FIELD,LAND1,P1,U1
     &,LAND_PTS,P_POINTS,U_POINTS,LAND_INDEX
     &,BL_LEVELS,ROW_LENGTH,P_ROWS,U_ROWS
     &,ALPHA1_LAND,ALPHA1_SICE
     &,ASHTF_LAND,ASHTF_SICE
     &,CDR10M_LAND,CDR10M_SSI
     &,DELTA_AK,DELTA_BK
*D ANG1F405.171   
     &,ICE_FRACT,LYING_SNOW,PSTAR,RADNET_SICE,RADNET_C_LAND,RESFT
     &,RHOKPM_LAND,RHOKPM_SICE
     &,RHOKPM_POT_LAND,RHOKPM_POT_SICE
*I IMPLCA4A.47 
     &,SEA_PTS,SEA_INDEX,SICE_PTS,SICE_INDEX
     &,SEANOICE_PTS,SEANOICE_INDEX,COAST_PTS,COAST_INDEX
     &,FLANDG,FLANDG_UV,FLAND
*D IMPLCA4A.49
     &,GAMMA_RHOKH_LAND,GAMMA_RHOKH_SICE
     &,GAMMA_RHOKM_1,GAMMA_RHOKM_LAND,GAMMA_RHOKM_SSI,TL,U,V
*D IMPLCA4A.96,99
     &,CDR10M_LAND(U_FIELD)        ! IN Used in calc 10m land wind -
C                                  !    P243 (routine SF_EXCH).  First
C                                  !    and last rows are "missing data"
C                                  !    and not used.  UV-grid.
     &,CDR10M_SSI(U_FIELD)         ! IN Used in calc 10m mean sea wind -
C                                  !    P243 (routine SF_EXCH).  First
C                                  !    and last rows are "missing data"
C                                  !    and not used.  UV-grid.
*D IMPLCA4A.145,150
     &,E_SEA(P_FIELD)              ! INOUT Evaporation from sea times leads
C                                  !       fraction of total sea portion
C                                  !       of grid box. Zero over land-only
C                                  !       points. (kg/m2/s).
     &,H_SEA(P_FIELD)              ! INOUT Surface sensible heat flux over
C                                  !       sea times leads fraction of
C                                  !       total sea portion of grid box.
C                                  !       Zero over land-only points.
C                                  !       (W/m2).
*D ANG1F405.172
     &,EPOT_ICE,EPOT_LAND,EPOT_SSI,FQW,FQW_LAND,FQW_SSI
     &,FTL,FTL_LAND,FTL_SSI,E_SEA,H_SEA,QW
*D IMPLCA4A.50
     &,DTRDZ,DTRDZ_RML,TAUX,TAUY
     &,TAUX_LAND,TAUX_SSI,TAUY_LAND,TAUY_SSI
     &,SURF_HT_FLUX_LAND,SURF_HT_FLUX_SICE
     &,U10M,U10M_LAND,U10M_SSI,V10M,V10M_LAND,V10M_SSI,NRML
*D IMPLCA4A.56
     & LAND_FIELD                  ! IN No. of points in Land grid.
     &,P_FIELD                     ! IN No. of points in P-grid.
*I IMPLCA4A.57
     &,LAND1                       ! IN First point to be processed in
*I IMPLCA4A.61
     &,LAND_PTS                    ! IN Number of LAND grid points to be
C                                  !    processed.
*I IMPLCA4A.67 
     &,LAND_INDEX(P_FIELD)         ! IN Index for Land points.
*D IMPLCA4A.89,92
     & ALPHA1_LAND(P_FIELD)        ! IN Gradient of saturated specific
C                                  !    humidity with respect to 
C                                  !    temperature between the bottom
C                                  !    model layer and the land sfc.
     &,ALPHA1_SICE(P_FIELD)         ! IN Gradient of saturated specific
C                                  !    humidity with respect to    
C                                  !    temperature between the bottom
C                                  !    model layer and the sfc.
*D IMPLCA4A.93,95
     &,ASHTF_LAND(LAND_FIELD)      ! IN Coefficient to calculate surface
C                                  !    heat flux into soil
C                                  !    (W/m2/K).
     &,ASHTF_SICE(P_FIELD)         ! IN Coefficient to calculate surface
C                                  !    heat flux into sea-ice
C                                  !    (W/m2/K).
*D IMPLCA4A.117,118
     & ICE_FRACT(P_FIELD)          ! IN Fraction of sea which is
C                                  !    sea-ice (decimal fraction).
*D IMPLCA4A.125
     +,RHOKPM_LAND(P_FIELD)        ! IN Land surface exchange coeff.
     +,RHOKPM_SICE(P_FIELD)        ! IN Sea-ice surface exchange coeff.
*D IMPLCA4A.153,156
*D ANG1F405.173,174
     +,RHOKPM_POT_LAND(LAND_FIELD) ! IN Surface exchange coeff. for
!                                       potential evaporation.
     +,RHOKPM_POT_SICE(P_FIELD)    ! IN Surface exchange coeff. for
!                                       potential evaporation.
*/
*D IMPLCA4A.121,123
     &,RADNET_C_LAND(P_FIELD)      ! IN Land component of corrected 
C                                  !    surface net radiation.
C                                  !    (+ve downwards, W per sq m)
     &,RADNET_SICE(P_FIELD)        ! IN Sea-ice component
C                                  !    of surface net radiation.
C                                  !    (+ve downwards, W per sq m)
C                                  !    Weighted by sea-ice fraction
C                                  !    in sea portion of grid box.
*/
*D IMPLCA4A.132
     & LAND_MASK(P_FIELD)          ! IN T for any land, F elsewhere.
*I IMPLCA4A.135
      INTEGER
     & COAST_INDEX(P_FIELD)      ! IN COAST_INDEX(I)=J => the Jth
!                                !    point in P_FIELD is the Ith
!                                !    coast point.
     &,COAST_PTS                 ! IN No of coastal points processed.
     &,SEA_INDEX(P_FIELD)        ! IN SEA_INDEX(I)=J => the Jth
!                                !    point in P_FIELD is the Ith
!                                !    sea point.
     &,SEA_PTS                   ! IN No of sea points processed.
     &,SICE_INDEX(P_FIELD)       ! IN SICE_INDEX(I)=J => the Jth
!                                !    point in P_FIELD is the Ith
!                                !    sea-ice point.
     &,SICE_PTS                  ! IN No of sea-ice points processed.
     &,SEANOICE_INDEX(P_FIELD)   ! IN SEANOICE_INDEX(I)=J => the Jth
!                                !    point in P_FIELD is the Ith
!                                !    sea-ice free sea point.
     &,SEANOICE_PTS              ! IN No of sea-ice free sea points
!                                !    processed.
      REAL
     & FLANDG(P_FIELD)       ! IN Fraction of land in grid box
C                            !    on global P grid. 
     &,FLANDG_UV(U_FIELD)    ! IN Fraction of land in grid box
C                            !    on UV grid. 
     &,FLAND(LAND_FIELD)     ! IN Fraction of land in grid box
C                            !    on land P grid. 

*D IMPLCA4A.140,141
     & FQW(P_FIELD,BL_LEVELS)      ! INOUT Flux of QW (ie., for surface,
C                                  !       total evaporation). Kg/sq m/s
     &,FQW_LAND(LAND_FIELD)        ! INOUT Land flux of QW. Kg/sq m/s
     &,FQW_SSI(P_FIELD)            ! INOUT Mean sea flux of QW.
C                                  !       Kg/sq m/s
*D ANG1F405.175
     &,EPOT_ICE(P_FIELD)           ! OUT Sea-ice potential
!                                  !evaporation rate.
     &,EPOT_LAND(LAND_FIELD)       ! INOUT Land potential
!                                  !evaporation rate.
     &,EPOT_SSI(P_FIELD)           ! INOUT Sea potential
!                                  !evaporation rate.
*D IMPLCA4A.142,144
     &,FTL(P_FIELD,BL_LEVELS)      ! INOUT Flux of TL (ie., for surface,
C                                  !       H/Cp where H is sensible heat
C                                  !       in W per sq m).          
     &,FTL_LAND(LAND_FIELD)        ! INOUT Sensible heat flux
C                                  !       over LAND (W/m2).

     &,FTL_SSI(P_FIELD)            ! INOUT Sensible heat flux
C                                  !       over SEA/SEA-ICE (W/m2).     
*D IMPLCA4A.157,160   
     &,GAMMA_RHOKH_LAND(P_FIELD) ! IN    Surface exchange coeff for
C                                  !       FTL_LAND,=GAMMA(1)*RHOKH_LAND
C                                  !       from P243 (SF_EXCH).
C                                  ! OUT   =RHOKH_LAND to satisfy
C                                  !       STASH.
     &,GAMMA_RHOKH_SICE(P_FIELD) ! IN    Surface exchange coeff for
C                                  !       FTL_SSI, =GAMMA(1)*RHOKH_SICE
C                                  !       from P243 (SF_EXCH).
C                                  ! OUT   =RHOKH_SICE to satisfy STASH.
*I IMPLCA4A.166   
     &,GAMMA_RHOKM_LAND(U_FIELD) ! IN    Land surface exchange
C                                  !       coeff for momentum, on UV-
C                                  !       grid with first and last rows
C                                  !       ignored.=GAMMA(1)*RHOKM_LAND
C                                  !       from P243 (SF_EXCH).
C                                  !   OUT =RHOKM_LAND to satisfy
C                                  !       STASH.
     &,GAMMA_RHOKM_SSI(U_FIELD)  ! IN    Mean sea surface exchange
C                                  !       coeff for momentum, on UV-
C                                  !       grid with first and last rows
C                                  !       ignored.=GAMMA(1)*RHOKM_SSI
C                                  !       from P243 (SF_EXCH).
C                                  !   OUT =RHOKM_SSI to satisfy
C                                  !       STASH.
*I IMPLCA4A.182
     &,TAUX_LAND(U_FIELD)        ! INOUT x-component of turbulent
C                                  !     land stress. 
C                                  !     UV-grid, 1st and last rows set
C                                  !     to "missing data". (N/sq m)
     &,TAUX_SSI(U_FIELD)         ! INOUT x-component of turbulent
C                                  !     mean sea stress. 
C                                  !     UV-grid, 1st and last rows set
C                                  !     to "missing data". (N/sq m)
*I IMPLCA4A.187
     &,TAUY_LAND(U_FIELD)        ! INOUT y-component of turbulent
C                                  !     land stress.
C                                  !     UV-grid, 1st and last rows set
C                                  !     to "missing data". (N/sq m)
     &,TAUY_SSI(U_FIELD)        ! INOUT y-component of turbulent
C                                  !     mean sea stress.
C                                  !     UV-grid, 1st and last rows set
C                                  !     to "missing data". (N/sq m)
*/
*D IMPLCA4A.188,190
     &,SURF_HT_FLUX_LAND(P_FIELD)
C                                  ! OUT Net downward heat flux at
C                                  !     surface over land (W/m2).
     &,SURF_HT_FLUX_SICE(P_FIELD)  ! OUT Net downward heat flux at
C                                  !     surface over sea-ice
C                                  !     fraction of sea portion of
C                                  !     gridbox (W/m2).
*D IMPLCA4A.191,194
     +,U10M(U_FIELD)               ! OUT Westerly wind at 10m (m/s).
C                                  !     1st & last rows "missing data".
     +,V10M(U_FIELD)               ! OUT Southerly wind at 10m (m/s).
C                                  !     1st & last rows "missing data".
     +,U10M_LAND(U_FIELD)          ! OUT Westerly land wind at 10m (m/s).
C                                  !     1st & last rows "missing data".
     +,V10M_lAND(U_FIELD)          ! OUT Southerly land wind at 10m (m/s).
C                                  !     1st & last rows "missing data".
     +,U10M_SSI(U_FIELD)           ! OUT Westerly ave sea wind
C                                  !     at 10m (m/s).
C                                  !     1st & last rows "missing data".
     +,V10M_SSI(U_FIELD)           ! OUT Southerly ave sea wind
C                                  !     at 10m (m/s).
C                                  !     1st & last rows "missing data".
*I IMPLCA4A.229
     +,AAQ_AM(U_FIELD)             ! Grid box mean of ALPHA1(I)*AQ_AM(I,1)
*I IMPLCA4A.232
     +,AAQ_RML(U_FIELD)            ! Grid box mean of ALPHA1(I)*AQ_RML(I)
*/.......................................................................
*/-----------------------------------------------------------------------
*D IMPLCA4A.238,239
     &,BPM_LAND(P_FIELD)           ! Used in calculating elements of
C                                  ! TL(1) and QW(1) rows of matrix.
     &,BPM_SSI(P_FIELD)            ! Used in calculating elements of
C                                  ! TL(1) and QW(1) rows of matrix.
*D IMPLCA4A.263,265
     &,LAT_HEAT_LAND(P_FIELD)      ! Latent heat of evaporation for
C                                  ! snow-free land or sublimation for
C                                  ! snow-covered land.
     &,LAT_HEAT_SSI(P_FIELD)       ! Latent heat of evaporation
C                                  ! or sublimation for sea
*/
*I IMPLCA4A.327
     &,ALPHA1                      !    Gradient of saturated specific
C                                  !    humidity with respect to  
C                                  !    temperature between the bottom
C                                  !    model layer and the surface.
     &,ALPHCT
     &,ALPHCT_RML
     &,BPM
     &,TEMP1
     &,TEMP2
     &,RESBPM
*I IMPLCA4A.336
     &,L        ! Loop counter (land index).
     &,SE       ! Loop counter (sea index).
     &,SI       ! Loop counter (sea ice index).
     &,SNI      ! Loop counter (sea, ice free index).
*/
*/ ----------------------------------------------------------------------------
*/
*I IMPLCA4A.390
CL     Set latent heat for land and sea.
C-----------------------------------------------------------------------
C
      DO I=P1,P1+P_POINTS-1
        LAT_HEAT_LAND(I) = 0.0
        LAT_HEAT_SSI(I) = 0.0
      ENDDO
C
      DO L=LAND1,LAND1+LAND_PTS-1
        I = LAND_INDEX(L)
        LAT_HEAT_LAND(I) = LC
        IF (LYING_SNOW(I).GT.0.0) LAT_HEAT_LAND(I) = LS
        BPM_SSI(I)=0.0
      ENDDO
C
      DO SI=1,SICE_PTS
        I=SICE_INDEX(SI)
        LAT_HEAT_SSI(I) = LS
        BPM_LAND(I)=0.0
      ENDDO
C
      DO SNI=1,SEANOICE_PTS
        I=SEANOICE_INDEX(SNI)
        LAT_HEAT_SSI(I) = LC
        BPM_LAND(I)=0.0
      ENDDO
*/
*D IMPLCA4A.397,402
*/.......................................................................
*/-----------------------------------------------------------------------
*/*D ANG1F405.176,179
*/*D IMPLCA4A.526,549

*D IMPLCA4A.526,533
*D ANG1F405.176,177
*D IMPLCA4A.534,544
*D ANG1F405.178
*D IMPLCA4A.545,547
*D ANG1F405.179
*D IMPLCA4A.548,549
*/
*I IMPLCA4A.552
      DO L=LAND1,LAND1+LAND_PTS-1
        I = LAND_INDEX(L) 
        FQW_ICE(I)=0.0
        FTL_ICE(I)=0.0
        IF ((NRML(I) .GE. 2)) THEN
          GAMMA_RKE_DQ = GAMMA_RHOKH_LAND(I)*RESFT(I)*
     &                   (DQW_DU(I,1) - ALPHA1_LAND(I)*DTL_DV(I,1))
          FTL_LAND(L) = FTL_LAND(L) + RHOKPM_LAND(I)*(LAT_HEAT_LAND(I)
     &              *GAMMA_RKE_DQ- GAMMA(1)*ASHTF_LAND(L)*DTL_DV(I,1))
          FQW_LAND(L) = FQW_LAND(L) - RHOKPM_LAND(I)*(CP*GAMMA_RKE_DQ
     &                  + GAMMA(1)*RESFT(I)*ASHTF_LAND(L)*DQW_DU(I,1))
          EPOT_LAND(L) = EPOT_LAND(L) - RHOKPM_POT_LAND(L)*
     &          (CP*GAMMA_RKE_DQ + GAMMA(1)*ASHTF_LAND(L)*DQW_DU(I,1))
        ENDIF
      ENDDO
C
      DO SI=1,SICE_PTS
        I=SICE_INDEX(SI)
        FQW_ICE(I)=FQW_SSI(I)-E_SEA(I)
        FTL_ICE(I)=FTL_SSI(I)-H_SEA(I)/CP
        IF ((NRML(I) .GE. 2)) THEN
          GAMMA_RKE_DQ = GAMMA_RHOKH_SICE(I) *
     &                   (DQW_DU(I,1) - ALPHA1_SICE(I)*DTL_DV(I,1))
          FQW_ICE(I) = FQW_ICE(I) - E_SEA(I) - RHOKPM_SICE(I) * 
     &         (CP*GAMMA_RKE_DQ + GAMMA(1)*ASHTF_SICE(I)*DQW_DU(I,1))
          FTL_ICE(I) = FTL_ICE(I) - H_SEA(I)/CP + RHOKPM_SICE(I) *
     &          (LS*GAMMA_RKE_DQ - GAMMA(1)*ASHTF_SICE(I)*DTL_DV(I,1))
          E_SEA(I) = E_SEA(I) - (1.0 - ICE_FRACT(I)) *
     &                               GAMMA_RHOKH_SICE(I)*DQW_DU(I,1)
          H_SEA(I) = H_SEA(I) - (1.0 - ICE_FRACT(I)) * CP *        
     &                               GAMMA_RHOKH_SICE(I)*DTL_DV(I,1)
        EPOT_ICE(I) = FQW_ICE(I)
        EPOT_SSI(I) = FQW_ICE(I) + E_SEA(I)
        ENDIF
      ENDDO
C
      DO SNI=1,SEANOICE_PTS
        I=SEANOICE_INDEX(SNI)
        FQW_ICE(I)=0.0
        FTL_ICE(I)=0.0
        IF ((NRML(I) .GE. 2)) THEN
          E_SEA(I) = E_SEA(I) - GAMMA_RHOKH_SICE(I)*DQW_DU(I,1)
          H_SEA(I) = H_SEA(I) -  CP *
     &                  GAMMA_RHOKH_SICE(I)*DTL_DV(I,1)  
          EPOT_SSI(I) = EPOT_SSI(I) -
     &                  GAMMA_RHOKH_SICE(I)*DQW_DU(I,1)
        ENDIF 
      ENDDO
C
      DO L=LAND1,LAND1+LAND_PTS-1
        I = LAND_INDEX(L)
        FTL(I,1) = FLAND(L)*FTL_LAND(L)
     &            +(1.-FLAND(L))*(FTL_ICE(I) + H_SEA(I)/CP)
        FQW(I,1) = FLAND(L)*FQW_LAND(L)
     &            +(1.-FLAND(L))*(FQW_ICE(I) + E_SEA(I))
*/
      ENDDO    
C
      DO SE=1,SEA_PTS
        I=SEA_INDEX(SE)
        IF(.NOT.LAND_MASK(I))THEN
          FTL(I,1) = FTL_ICE(I) + H_SEA(I)/CP
          FQW(I,1) = FQW_ICE(I) + E_SEA(I)
        ENDIF
      ENDDO
C
*I IMPLCA4A.608
      DO L=LAND1,LAND1+LAND_PTS-1
        I = LAND_INDEX(L)
        BPM_LAND(I) = GAMMA(1)*ASHTF_LAND(L)*RHOKPM_LAND(I)
      ENDDO
C
      DO SE=1,SEA_PTS
        I=SEA_INDEX(SE)
        BPM_SSI(I) = (1. - ICE_FRACT(I))*GAMMA_RHOKH_SICE(I) +
     &                      GAMMA(1)*ASHTF_SICE(I)*RHOKPM_SICE(I)
      ENDDO
C
*/
*D IMPLCA4A.610,615
         TEMP1=FLANDG(I)*RESFT(I)*GAMMA_RHOKH_LAND(I)
     &         *CP*RHOKPM_LAND(I)
         TEMP1=TEMP1+(1.0-FLANDG(I))*GAMMA_RHOKH_SICE(I)
     &         *CP*RHOKPM_SICE(I)
         RESBPM=FLANDG(I)*RESFT(I)*BPM_LAND(I)
     &           +(1.-FLANDG(I))*BPM_SSI(I)

*/
*D IMPLCA4A.630  
          AQ_RML(I) = - DTRDZ_RML(I)*TEMP1
*D IMPLCA4A.633
     &                                + DTRDZ_RML(I)*RESBPM)
*/
*D IMPLCA4A.643
          AQ_AM(I,1) = - DTRDZ(I,1)*TEMP1
*D IMPLCA4A.646
     &                               + DTRDZ(I,1)*RESBPM)
*/
*/-----------------------------------------------------------------------
*/.......................................................................
*/
*I IMPLCA4A.663
          TEMP1=FLANDG(I)*ALPHA1_LAND(I)*RESFT(I)*GAMMA_RHOKH_LAND(I)
     &          *LAT_HEAT_LAND(I)*RHOKPM_LAND(I)
          TEMP1=TEMP1+(1.0-FLANDG(I))*ALPHA1_SICE(I)*GAMMA_RHOKH_SICE(I)
     &          *LAT_HEAT_SSI(I)*RHOKPM_SICE(I)
          TEMP2=FLANDG(I)*RESFT(I)*GAMMA_RHOKH_LAND(I)
     &          *LAT_HEAT_LAND(I)*RHOKPM_LAND(I)
          TEMP2=TEMP2+(1.0-FLANDG(I))*GAMMA_RHOKH_SICE(I)
     &          *LAT_HEAT_SSI(I)*RHOKPM_SICE(I)
          BPM=FLANDG(I)*BPM_LAND(I)+(1.-FLANDG(I))*BPM_SSI(I)
*/
*D IMPLCA4A.671,673
          ALPHCT_RML = - DTRDZ_RML(I)*TEMP1
          CT_RML = - DTRDZ_RML(I)*TEMP2
          RBT_RML = 1./(1. - AT_RML(I) - ALPHCT_RML*(1.+AQ_RML(I))
     &                                 + DTRDZ_RML(I)*BPM)
*/
*D IMPLCA4A.682
*D IMPLCA4A.684,685
          ALPHCT = - DTRDZ(I,1)*TEMP1
          CT = - DTRDZ(I,1)*TEMP2
          RBT = 1./( 1. - AT_ATQ(I,1) - ALPHCT*(1. + AQ_AM(I,1))
     &                                + DTRDZ(I,1)*BPM)
*/
*/.......................................................................
*/-----------------------------------------------------------------------
*/
*I IMPLCA4A.777
        ALPHA1=FLANDG(I)*ALPHA1_LAND(I)+(1.-FLANDG(I))*ALPHA1_SICE(I)
*D IMPLCA4A.781,782
          DQW_RML(I) = DQW_RML(I) - AQ_RML(I) * ALPHA1 * DTL_RML(I)
*D IMPLCA4A.791
          DQW_DU(I,1) = DQW_DU(I,1) - ALPHA1*AQ_AM(I,1)*DTL_DV(I,1)
*/
*/.......................................................................
*/-----------------------------------------------------------------------
*/
*D IMPLCA4A.829
      DO L=LAND1,LAND1+LAND_PTS-1
        I = LAND_INDEX(L)
*D IMPLCA4A.837
*D IMPLCA4A.838,844
*D ANG1F405.180,181
*D IMPLCA4A.845,857
*D ANG1F405.182
*D IMPLCA4A.858,861
*D ANG1F405.183
*D IMPLCA4A.862,869
        GAMMA_RKE_DQ = GAMMA_RHOKH_LAND(I)*RESFT(I)
     :                  *(DQW - ALPHA1_LAND(I)*DTL)
        FTL_LAND(L) = FTL_LAND(L) + RHOKPM_LAND(I)*( LAT_HEAT_LAND(I)
     &                *GAMMA_RKE_DQ - GAMMA(1)*ASHTF_LAND(L)*DTL )
        FQW_LAND(L) = FQW_LAND(L) - RHOKPM_LAND(I)*( CP*GAMMA_RKE_DQ
     &                      + GAMMA(1)*RESFT(I)*ASHTF_LAND(L)*DQW )
        EPOT_LAND(L) = EPOT_LAND(L) - RHOKPM_POT_LAND(L)*
     &                ( CP*GAMMA_RKE_DQ  + GAMMA(1)*ASHTF_LAND(L)*DQW )
        SURF_HT_FLUX_LAND(I) = RADNET_C_LAND(I)
     &                                - LAT_HEAT_LAND(I)*FQW_LAND(L)
     &                                - CP*FTL_LAND(L)
        GAMMA_RHOKH_LAND(I) = GAMMA_RHOKH_LAND(I) / GAMMA(1)
      ENDDO
C
      DO SI=1,SICE_PTS
        I=SICE_INDEX(SI)
        IF ( NRML(I) .GE. 2 ) THEN
           DTL =  DTL_RML(I)
           DQW = DQW_RML(I)
        ELSE
           DTL = DTL_DV(I,1)
           DQW = DQW_DU(I,1)
        ENDIF
        GAMMA_RKE_DQ = GAMMA_RHOKH_SICE(I)*(DQW - ALPHA1_SICE(I)*DTL)
        FQW_ICE(I) = FQW_ICE(I) - RHOKPM_SICE(I) *
     &              (CP*GAMMA_RKE_DQ + GAMMA(1)*ASHTF_SICE(I)*DQW)
        FTL_ICE(I) =  FTL_ICE(I) + RHOKPM_SICE(I) *
     &               (LS*GAMMA_RKE_DQ - GAMMA(1)*ASHTF_SICE(I)*DTL)
        E_SEA(I) = E_SEA(I) - (1.0 - ICE_FRACT(I)) *
     &                       GAMMA_RHOKH_SICE(I)*DQW   
        H_SEA(I) = H_SEA(I) - (1.0 - ICE_FRACT(I)) * CP *
     &             GAMMA_RHOKH_SICE(I)*DTL
        EPOT_ICE(I) = FQW_ICE(I)
        EPOT_SSI(I) = FQW_ICE(I) + E_SEA(I)
        SURF_HT_FLUX_SICE(I) =RADNET_SICE(I)-LS*FQW_ICE(I)-CP*FTL_ICE(I)
        GAMMA_RHOKH_SICE(I) = GAMMA_RHOKH_SICE(I) / GAMMA(1)
      ENDDO
C
      DO SNI=1,SEANOICE_PTS
        I=SEANOICE_INDEX(SNI)
        IF ( NRML(I) .GE. 2 ) THEN
           DTL =  DTL_RML(I)
           DQW = DQW_RML(I)
        ELSE
           DTL = DTL_DV(I,1)
           DQW = DQW_DU(I,1)
        ENDIF
        EPOT_SSI(I) = EPOT_SSI(I) - GAMMA_RHOKH_SICE(I)*DQW
        E_SEA(I) = E_SEA(I) - GAMMA_RHOKH_SICE(I)*DQW
        H_SEA(I) = H_SEA(I) - CP*GAMMA_RHOKH_SICE(I)*DTL
        FTL_ICE(I) = 0.0
        FQW_ICE(I) = 0.0
        GAMMA_RHOKH_SICE(I) = GAMMA_RHOKH_SICE(I) / GAMMA(1)
      ENDDO
C
*I IMPLCA4A.870
C
      DO L=LAND1,LAND1+LAND_PTS-1
        I = LAND_INDEX(L)
        FTL(I,1) = FLAND(L)*FTL_LAND(L)
        FQW(I,1) = FLAND(L)*FQW_LAND(L)
        IF(FLAND(L).LT.1.0)THEN
          FTL_SSI(I)=FTL_ICE(I) + H_SEA(I)/CP
          FQW_SSI(I)=FQW_ICE(I) + E_SEA(I)
          FTL(I,1) = FTL(I,1)+(1.-FLAND(L))*FTL_SSI(I)
          FQW(I,1) = FQW(I,1)+(1.-FLAND(L))*FQW_SSI(I)
        ENDIF
        FTL_LAND(L) = FTL_LAND(L)*CP
*/
      ENDDO    
C
      DO SE=1,SEA_PTS
        I=SEA_INDEX(SE)
        IF(.NOT.LAND_MASK(I))THEN
          FTL_SSI(I)=FTL_ICE(I) + H_SEA(I)/CP
          FQW_SSI(I)=FQW_ICE(I) + E_SEA(I)
          FTL(I,1) = FTL_SSI(I)
          FQW(I,1) = FQW_SSI(I)
        ENDIF
        FTL_SSI(I) = FTL_SSI(I)*CP
      ENDDO
*/
*D ANG1F405.185,193
*/
*I IMPLCA4A.1074
        TAUX_LAND(I)=TAUX_LAND(I)+GAMMA_RHOKM_LAND(I)*DQW_DU(I,1)
        TAUX_SSI(I)=TAUX_SSI(I)+GAMMA_RHOKM_SSI(I)*DQW_DU(I,1)
*I IMPLCA4A.1077
        TAUY_LAND(I)=TAUY_LAND(I)+GAMMA_RHOKM_LAND(I)*DTL_DV(I,1)
        TAUY_SSI(I)=TAUY_SSI(I)+GAMMA_RHOKM_SSI(I)*DTL_DV(I,1)
*/C Calculate the grid box means:
*/        TAUX_LAND(I) = TAUX_LAND(I)*FLANDG_UV(I)
*/        TAUX_SSI(I) = TAUX_SSI(I)*(1.-FLANDG_UV(I))
*/        TAUY_LAND(I) = TAUY_LAND(I)*FLANDG_UV(I)
*/        TAUY_SSI(I) = TAUY_SSI(I)*(1.-FLANDG_UV(I))
*/
*/
*I IMPLCA4A.1079
        GAMMA_RHOKM_LAND(I) = GAMMA_RHOKM_LAND(I) / GAMMA(1)
        GAMMA_RHOKM_SSI(I) = GAMMA_RHOKM_SSI(I) / GAMMA(1)
*/
*D IMPLCA4A.1154,1157
          IF (SU10) THEN
            U10M_SSI(I) = U0(I) + CDR10M_SSI(I)*( U(I,1) - U0(I) )
C                                                        ! P244.96
            U10M_LAND(I) = CDR10M_LAND(I)*U(I,1)         ! P244.96
            U10M(I)= FLANDG_UV(I)*U10M_LAND(I) + 
     &               ( 1.-FLANDG_UV(I) )*U10M_SSI(I) 
          ENDIF
          IF (SV10) THEN
            V10M_SSI(I) = V0(I) + CDR10M_SSI(I)*( V(I,1) - V0(I) )
C                                                        ! P244.97
            V10M_LAND(I) = CDR10M_LAND(I)*V(I,1)         ! P244.97
            V10M(I)= FLANDG_UV(I)*V10M_LAND(I) + 
     &               ( 1.-FLANDG_UV(I) )*V10M_SSI(I) 
          ENDIF
*/
*I GPB1F403.209
            U10M_LAND(I)=1.E30
            U10M_SSI(I)=1.E30
*I GPB1F403.212
            V10M_LAND(I)=1.E30
            V10M_SSI(I)=1.E30
*I GPB1F403.222
            U10M_LAND(I)=1.E30
            U10M_SSI(I)=1.E30
*I GPB1F403.225
            V10M_LAND(I)=1.E30
            V10M_SSI(I)=1.E30
*/
*/.......................................................................
*/-----------------------------------------------------------------------




*ID CTILE4
*/---------------------------------------------------------------------------
*/---------------------------------------------------------------------------
*/ Deals with the passing od variable from bottom level routines e.g. sfflux
*/ to next level e.g.implca
*/---------------------------------------------------------------------------
*/---------------------------------------------------------------------------
*/.......................................................................
*/-----------------------------------------------------------------------
*DECLARE SFEXCH5A
*I SFEXCH5A.35
CLL
CLL          08/99  Allow for the inclusion of coastal tiles, i.e.
CLL                 land and sea and sea-ice may coexist on the same
CLL                 grid box. Requires the splitting up of all the surface
CLL                 fluxes into land, sea and sea-ice components. Separate
CLL                 temperatures are also required.
CLL                                            N. Gedney
*/
*I SFEXCH5A.52
     &,SEA_PTS,SEA_INDEX,SICE_PTS,SICE_INDEX
     &,SEANOICE_PTS,SEANOICE_INDEX,COAST_PTS,COAST_INDEX
     &,FLANDG,FLANDG_UV
*D APA1F405.388   
     &,PSTAR,Q_1,QCF_1,QCL_1,RADNET_SICE,RADNET_C_LAND
     &,GC,RESIST,ROOTD,SMC
*D SFEXCH5A.60    
     &,T_1,TIMESTEP,TI,TS1,TSTAR,TSTAR_LAND
     &,TSTAR_SEA,TSTAR_SICE,TSTAR_SSI
*D SFEXCH5A.69  
     &,FME
     &,CDR10M_LAND,CHR1P5M_LAND,CER1P5M_LAND
     &,CDR10M_SSI,CHR1P5M_SSI,CER1P5M_SSI
*D ADM3F404.75    
     &,ALPHA1_LAND,ALPHA1_SICE,ASHTF_LAND,ASHTF_SICE
     &,BQ_1,BT_1,BF_1,CD,CD_LAND,CD_SSI,CH,CH_LAND,CH_SSI
*D ANG1F405.92,93    
     &,EPOT_LAND,EPOT_SSI,EPOT_ICE
     &,FQW_1,FQW_LAND,FQW_SSI,FSMC
     &,FTL_1,FTL_LAND,FTL_SSI,E_SEA,H_SEA
     &,TAUX_1,TAUY_1
     &,TAUX_LAND,TAUX_SSI,TAUY_LAND,TAUY_SSI
     &,QW_1
     &,FRACA,RESFS,F_SE,RESFT
     &,RHOKH_1,RHOKH_LAND,RHOKH_SICE
     &,RHOKM_1,RHOKM_LAND,RHOKM_SSI
*D SFEXCH5A.66    
     &,RIB,RIB_LAND,RIB_SSI
     &,TL_1,VSHR,VSHR_LAND,VSHR_SSI,Z0H,Z0H_LAND,Z0H_SSI
     &,Z0M,Z0M_LAND,Z0M_SSI,Z0M_EFF,H_BLEND
*D SFEXCH5A.70 
     &,SU10,SV10,SQ1P5,ST1P5,SFME
*D ANG1F405.94   
     &,RHOKPM_LAND,RHOKPM_SICE,RHOKPM_POT_LAND,RHOKPM_POT_SICE
*/
*I SFEXCH5A.177
C
      LOGICAL LLAND       !TRUE if LAND calculations of interpolation
C                         !     coefficients (SFLINT), otherwise FALSE.
     &,LOROG_GB           !TRUE If want grid box mean/orography-related
!                         !     calculations.
     &,L_NEWMOMENTUM      !TRUE if want new momentum scheme 
C                         !     - dont think IMPLCA4A needs to be changed?
C
      INTEGER
     & COAST_INDEX(P_POINTS)     ! IN COAST_INDEX(I)=J => the Jth
!                                !    point in P_POINTS is the Ith
!                                !    coast point.
     &,COAST_PTS                 ! IN No of coastal points processed.
     &,SEA_INDEX(P_POINTS)       ! IN SEA_INDEX(I)=J => the Jth
!                                !    point in P_POINTS is the Ith
!                                !    sea point.
     &,SEA_PTS                   ! IN No of sea points processed.
     &,SICE_INDEX(P_POINTS)      ! IN SICE_INDEX(I)=J => the Jth
!                                !    point in P_POINTS is the Ith
!                                !    sea-ice point.
     &,SICE_PTS                  ! IN No of sea-ice points processed.
     &,SEANOICE_INDEX(P_POINTS)  ! IN SEANOICE_INDEX(I)=J => the Jth
!                                !    point in P_POINTS is the Ith
!                                !    sea-ice free sea point.
     &,SEANOICE_PTS              ! IN No of sea-ice free sea points
!                                !    processed.
      REAL
     & FLANDG(P_POINTS)       ! IN Fraction of land in grid box. 
*D SFEXCH5A.213 
     &,ICE_FRACT(P_POINTS) ! IN Fraction of sea which is sea-ice.
*D SFEXCH5A.249
     &,TSTAR(P_POINTS)     ! IN Mean gridsquare surface temperature (K).
     &,TSTAR_LAND(P_POINTS)! IN Land surface temperature (K).
     &,TSTAR_SSI(P_POINTS) ! IN Mean sea surface temperature (K).
     &,TSTAR_SICE(P_POINTS)! IN Sea-ice surface temperature (K).
     &,TSTAR_SEA(P_POINTS) ! IN Open sea surface temperature (K).
*/
*D SFEXCH5A.274
     &,VFRAC(LAND_PTS)    ! IN Fraction of Vegetation in land
C                         !    portion of grid box.
*D SFEXCH5A.282
     & LAND_MASK(P_POINTS) ! IN .TRUE. if any land;else .FALSE.
*/
*D SFEXCH5A.301,303
     & ALPHA1_LAND(P_POINTS)
C                       ! OUT Gradient of saturated specific humidity
C                       !     with respect to temperature between the
C                       !     bottom model layer and land surface.
     &,ALPHA1_SICE(P_POINTS)
C                       ! OUT Gradient of saturated specific humidity
C                       !     with respect to temperature between the
C                       !     bottom model layer and sea-ice surface.
*D SFEXCH5A.304,305
     &,ASHTF_LAND(LAND_PTS)
C                       ! OUT Coefficient to calculate surface 
C                       !     heat flux into soil (W/m2/K).
     &,ASHTF_SICE(P_POINTS)  
C                       ! OUT Coefficient to calculate surface 
C                       !     heat flux into sea-ice (W/m2/K).
*/
*I SFEXCH5A.310 
     &,CD_LAND(P_POINTS)! OUT CD over land
     &,CD_SSI(P_POINTS) ! OUT CD over sea-ice, or sea where no sea-ice.
*I SFEXCH5A.312
     &,CH_LAND(P_POINTS)! OUT CH over land
     &,CH_SSI(P_POINTS) ! OUT CH over sea-ice, or sea where no sea-ice.
*D SFEXCH5A.313,321
     &,CDR10M_LAND(U_POINTS) 
C                       ! OUT ***Reqd for calc of land 10m wind (u & v).
C                       !     NBB: This is output on the UV-grid, but
C                       !     with the first and last rows set to a
C                       !     "missing data indicator".
     &,CDR10M_SSI(U_POINTS)
C                       ! OUT ***Reqd for calc of sea 10m wind (u & v).
C                       !     NBB: This is output on the UV-grid, but
C                       !     with the first and last rows set to a
C                       !     "missing data indicator".
C                       !     Sea for non-sea-ice points.
C                       !     Sea-ice leads ignored. See 3.D.7 below.
     &,CHR1P5M_LAND(P_POINTS)
C                       ! OUT Reqd for calc of 1.5m land temperature.
     &,CHR1P5M_SSI(P_POINTS)
C                       ! OUT Reqd for calc of 1.5m temperature.
C                       !     Sea for non-sea-ice points.
C                       !     Sea-ice leads ignored. See 3.D.7 below.
     &,CER1P5M_LAND(P_POINTS)
C                       ! OUT Reqd for calc of 1.5m land sp humidity.
     &,CER1P5M_SSI(P_POINTS)
C                       ! OUT Reqd for calculation of 1.5m sp humidity.
C                       !     Sea for non-sea-ice points.
C                       !     Sea-ice leads ignored. See 3.D.7 below.
*D ANG1F405.95,96
     & EPOT_LAND(LAND_PTS)
C                       ! OUT Land potential evaporation on P-grid
C                       !      (kg/m2/s).
     &,EPOT_SSI(P_POINTS)
C                       ! OUT Mean sea potential evaporation on P-grid
C                       !      (kg/m2/s).
     &,EPOT_ICE(P_POINTS)
C                       ! OUT Sea-ice potential evaporation on P-grid
C                       !      (kg/m2/s).
*I ANG1F405.98
     &,FQW_LAND(LAND_PTS)
C                       ! OUT "Explicit" land surface flux of QW
C                       !      (i.e. evaporation), on P-grid (kg/m2/s).
     &,FQW_SSI(P_POINTS)! OUT "Explicit" mean sea surface flux of QW
C                       !      (i.e. evaporation), on P-grid (kg/m2/s).
*I SFEXCH5A.329
     &,FTL_LAND(LAND_PTS)
C                       ! OUT "Explicit" land surface flux of 
C                       !     TL = H/CP. (sensible heat / CP).
     &,FTL_SSI(P_POINTS)! OUT "Explicit" mean sea surface flux of 
C                       !     TL = H/CP. (sensible heat / CP).
*/
*D SFEXCH5A.330,331
     &,FRACA(P_POINTS)  ! OUT Fraction of land surface moisture flux
C                       !     with only aerodynamic resistance.
*/
*D SFEXCH5A.332,336
     &,E_SEA(P_POINTS)  ! OUT Evaporation from sea times leads
C                       !     fraction of total sea portion
C                       !     of grid box. Zero over land-only
C                       !     points. (kg/m2/s).
     &,H_SEA(P_POINTS)  ! OUT Surface sensible heat flux over
C                       !     sea times leads fraction of
C                       !     total sea portion of grid box.
C                       !     Zero over land-only points.
C                       !     (W/m2).
*/
*I SFEXCH5A.340
     &,FLANDG_UV(U_POINTS)
C                       ! OUT Fraction of land in grid box on UV-grid. 
C ***TEMPORARY for testing:
     &,TAUX_TEMP(U_POINTS)
     &,TAUY_TEMP(U_POINTS)
C
     &,TAUX_LAND(U_POINTS)
C                       ! OUT "Explicit" x-component of land surface
C                       !     turbulent stress; on UV-grid; first and
C                       !     last rows set to a "missing data
C                       !     indicator". (Newtons per square metre)
     &,TAUX_SSI(U_POINTS)
C                       ! OUT "Explicit" x-component of mean sea surface
C                       !     turbulent stress; on UV-grid; first and
C                       !     last rows set to a "missing data
C                       !     indicator". (Newtons per square metre)
*I SFEXCH5A.344
     &,TAUY_LAND(U_POINTS)
C                       ! OUT "Explicit" y-component of land surface
C                       !     turbulent stress; on UV-grid; first and
C                       !     last rows set to a "missing data
C                       !     indicator". (Newtons per square metre)
     &,TAUY_SSI(U_POINTS)
C                       ! OUT "Explicit" y-component of mean sea surface
C                       !     turbulent stress; on UV-grid; first and
C                       !     last rows set to a "missing data
C                       !     indicator". (Newtons per square metre)
*/
*D SFEXCH5A.347,353
     &,RESFS(P_POINTS)  ! OUT Combined soil, stomatal and aerodynamic
C                       !     resistance factor = PSIS/(1+RS/RA) for
C                       !     fraction (1-FRACA). Over land only.
     &,F_SE(P_POINTS)   ! OUT Fraction of the evapotranspiration which
C                       !     is bare soil evaporation. Over land only.
     &,RESFT(P_POINTS)  ! OUT Total resistance factor over land
C                       !     FRACA+(1-FRACA)*RESFS.
*/
*D SFEXCH5A.356,357
     & RHOKH_1(P_POINTS) ! OUT For FTL,then *GAMMA(1) for implicit calcs
     &,RHOKH_LAND(P_POINTS)
C                        ! OUT For FTL_LAND,then *GAMMA(1)
C                        !     for implicit calcs.
     &,RHOKH_SICE(P_POINTS)
C                        ! OUT For FTL_SSI,then *GAMMA(1)
C                        !     for implicit calcs.
*I SFEXCH5A.361
     &,RHOKM_TEMP(U_POINTS) ! ***TEMPORARY for testing***
     &,RHOKM_LAND(U_POINTS)
C                        ! OUT For momentum over land,
C                        !     then *GAMMA(1) for implicit
C                        !     calculations. NBB: This is output on the
C                        !     UV-grid, but with the first and last
C                        !     rows set to a "missing data indicator".
     &,RHOKM_SSI(U_POINTS)
C                        ! OUT For mean momentum over mean sea,
C                        !     then *GAMMA(1) for implicit
C                        !     calculations. NBB: This is output on the
C                        !     UV-grid, but with the first and last
C                        !     rows set to a "missing data indicator".
*D SFEXCH5A.362
     &,RHOKPM_LAND(P_POINTS)
C                        ! OUT Land surface exchange coefficient.
C                        !     NB NOT * GAMMA for implicit calcs.
     &,RHOKPM_SICE(P_POINTS)
C                        ! OUT Sea-ice surface exchange coefficient.
C                        ! OUT NB NOT * GAMMA for implicit calcs.
*D SFEXCH5A.363
     &,Z0M_EFF(P_POINTS)  ! OUT Effective grid box mean
C                         !     roughness length for momentum (m).
     &,Z0M_EFF_LAND(P_POINTS)
C                         ! OUT Effective land
C                         !     roughness length for momentum (m).
     &,Z0M_EFF_SSI(P_POINTS)
C                         ! OUT Effective sea/sea-ice
C                         !     roughness length for momentum (m).
C                         !     Sea-ice values used when sea-ice present
*D SFEXCH5A.364
     &,H_BLEND(P_POINTS)  ! OUT Blending height
*D ANG1F405.100,102
     &,RHOKPM_POT_LAND(LAND_PTS)
C                         ! OUT Surface exchange coeff. for
C                               land potential evaporation.
     &,RHOKPM_POT_SICE(P_POINTS)
C                         ! OUT Surface exchange coeff. for
C                               sea-ice potential evaporation.
*/
*D SFEXCH5A.371   
     &,RIB(P_POINTS)     ! OUT Mean Bulk Richardson number
C                        !     for lowest layer. Based on land and
C                        !     open sea or sea-ice values.
C                         ! Sea-ice values used when sea-ice present.
*/
*D SFEXCH5A.374   
     &,VSHR(P_POINTS)    ! OUT Magnitude of surface-to-lowest-lev. wind
     &,VSHR_LAND(P_POINTS)
!                        ! OUT Magnitude of land surface-to-lowest
!                        !     -lev. wind
     &,VSHR_SSI(P_POINTS)! OUT Magnitude of mean sea surface-to-lowest
!                        !     -lev. wind
*D SFEXCH5A.375  
     &,Z0H(P_POINTS)     ! OUT Grid box mean roughness length for
C                        !     heat and moisture (m).
     &,Z0H_LAND(P_POINTS)! OUT Land roughness length for 
C                        !     heat and moisture (m).
     &,Z0H_SSI(P_POINTS) ! OUT Sea or sea-ice roughness length for
C                        !     heat and moisture (m).
C                        !     Sea-ice values used when sea-ice present.
*D SFEXCH5A.376 
     &,Z0M(P_POINTS)     ! OUT Grid box mean
C                        !     roughness length for momentum (m).
     &,Z0M_LAND(P_POINTS)! OUT Land roughness length for momentum (m).
     &,Z0M_SSI(P_POINTS) ! OUT Sea or sea-ice roughness length 
C                        !     for momentum (m).
C                        !     Sea-ice values used when sea-ice present.
*I SFEXCH5A.380
C ***TEMPORARY: NEEDS TO SORTED OUT***
     &,RHO_ARESIST_LAND(LAND_PTS)
C                             ! OUT, RHOSTAR*CD_STD*VSHR  for SCYCLE
     &,ARESIST_LAND(LAND_PTS) ! OUT, 1/(CD_STD*VSHR)      for SCYCLE
     &,RESIST_B_LAND(LAND_PTS)! OUT, (1/CH-1/CD_STD)/VSHR for SCYCLE
     &,RHO_ARESIST_SSI(P_POINTS)
C                             ! OUT, RHOSTAR*CD_SSI*VSHR  for SCYCLE
     &,ARESIST_SSI(P_POINTS)  ! OUT, 1/(CD_SSI*VSHR)      for SCYCLE
     &,RESIST_B_SSI(P_POINTS) ! OUT, (1/CH-1/CD_SSI)/VSHR for SCYCLE
*/
*D APA1F405.392   
     &,RADNET_C_LAND(P_POINTS)
C                         ! INOUT Adjusted net radiation for vegetation
*I APA1F405.393
     &,RADNET_SICE(P_POINTS)
C                         ! IN    Net radiation over sea-ice (W/m2).
C                         !       Weighted by sea-ice fraction
C                         !       in sea portion of grid box.
*/
*I SFEXCH5A.398
*CALL BLEND_H
*/
*D SFEXCH5A.445,446
     & CD_SEA(P_POINTS)  ! Bulk transfer coefficient for momentum
C                        !  over open sea.
     &,CD_SICE(P_POINTS) ! OUT Bulk transfer coefficient for momentum.
C                        !  over sea-ice.
*/
*D SFEXCH5A.451,453
     &,CH_SEA(P_POINTS)  ! Bulk transfer coefficient for heat and
C                        !  or moisture over open sea.
     &,CH_SICE(P_POINTS) ! Bulk transfer coefficient for heat and
C                        !  over sea-ice.
*/
*D SFEXCH5A.457,458
     &,CD_STD(P_POINTS)   ! Local drag coefficient for
C                         !  calculation of interpolation coefficients
     &,CD_STD_LAND(P_POINTS)
C                         ! Local land drag coefficient for
C                         !  calculation of interpolation coefficients
     &,CD_STD_SSI(P_POINTS)
C                         ! Local sea or sea-ice drag coefficient for
C                         !  calculation of interpolation coefficients.
C                         !  Sea-ice values used when sea-ice present.
*D SFEXCH5A.459,462 
     &,DQ_LAND(P_POINTS)  ! Sp humidity difference between land
C                         !  surface and lowest atmospheric
C                         !  level (Q1 - Q*).
*/
*D SFEXCH5A.463,464
     &,DQ_SEA(P_POINTS)  ! DQ for sea fraction of gridsquare.
*/
*D ADM3F404.86,90
*D ADM3F404.91,93
*/
*D SFEXCH5A.465,470
*D SFEXCH5A.471,472
     &,DTEMP_SEA(P_POINTS)! Liquid/ice static energy difference
C                         !  between open sea surface and lowest atmos
C                         !  level, divided by CP (a modified
C                         !  temperature difference).
*/
*D SFEXCH5A.482,486
     &,QSTAR_LAND(P_POINTS)
C                         ! Surface saturated sp humidity over land.
     &,QSTAR_SEA(P_POINTS)
C                         ! Surface saturated sp humidity over open sea.
     &,QSTAR_SICE(P_POINTS)
C                         ! Surface saturated sp humidity over sea-ice.
*D SFEXCH5A.488,491
     &,RIB_LAND(P_POINTS) ! Land bulk Richardson no.
C                         ! for lowest layer.
C
     &,RIB_SEA(P_POINTS)  ! Open sea bulk Richardson no.
C                         ! for lowest layer.
C
     &,RIB_SICE(P_POINTS) ! Sea-ice bulk Richardson no.
C                         ! for lowest layer.
C
     &,RIB_SSI(P_POINTS)  ! Bulk Richardson no. for open sea or sea-ice
C                         ! at lowest layer.
C                         ! Sea-ice values used when sea-ice present.
*D SFEXCH5A.492   
     &,RA(P_POINTS)       ! Land aerodynamic resistance.
*/
*D SFEXCH5A.494,496  
*/
*I SFEXCH5A.502   
     &,U_0_P_TEMP(P_POINTS)!***TEMPORARY for testing
C      West-to-east component of ocean surface        SFEXCH5A.497   
C                         ! current (m/s; zero over land if U_0 OK).
C                         ! P grid.  F615.
     &,V_0_P_TEMP(P_POINTS)!***TEMPORARY for testing
C      South-to-north component of ocean surface
C                         ! current (m/s; zero over land if V_0 OK).
C                         ! P grid.  F616.
*/
*D SFEXCH5A.503,505
     &,WIND_PROFILE_FACT_LAND(P_POINTS)
C                         ! For transforming effective land 
C                         ! surface transfer coefficients to those
C                         ! excluding form drag.
     &,WIND_PROFILE_FACT_SSI(P_POINTS)
C                         ! For transforming effective sea
C                         ! surface transfer coefficients to those
C                         ! excluding form drag.
*D SFEXCH5A.507,508
     &,Z0F_LAND(P_POINTS) ! Land roughness length for free-convective
C                         ! heat and moisture transport.
     &,Z0F_SSI(P_POINTS)  ! Sea or sea-ice roughness length for 
C                         ! free-convective heat and moisture transport.
C                         ! Sea-ice values used when sea-ice present.
*/
*I SFEXCH5A.512
     &, TEMPY(P_POINTS)  ! Workspace for FLANDG_UV calculation
*/.......................................................................
*/-----------------------------------------------------------------------
*/ Start to get rid of old sea-ice index, NSICE,SICE_INDEX:
*D SFEXCH5A.515,516
*D SFEXCH5A.594
     &,SE          ! Loop counter (sea field index).
*/th     &,SI          ! Loop counter (sea ice field index).
     &,SNI         ! Loop counter (sea no sea-ice field index).
*/
*I SFEXCH5A.604   
     &,Z0          ! Store for roughness length calculation
*/
*I SFEXCH5A.647
C-----------------------------------------------------------------------
CL  1.  Initialise fields for zero.
C-----------------------------------------------------------------------
C
        DO I=1,P_POINTS
          RIB_LAND(I) = 0.0
          RIB_SEA(I) = 0.0
          RIB_SICE(I) = 0.0
          RIB_SSI(I) = 0.0
          RIB(I) = 0.0
        ENDDO
*D SFEXCH5A.648,661
*D GSS2F402.293,300
*/
*D SFEXCH5A.669,670
C        QSTAR_LAND 'borrowed' to store P at level 1 (just this once).
*/
*D SFEXCH5A.678,679
CL       are required for the open sea (QSTAR_SEA) and sea-ice (QSTAR_SICE)
CL       fractions respectively.
*/
*D SFEXCH5A.684  
CL       As above with QSTAR_SEA done on full field.
*/
*D SFEXCH5A.690,692
          QSTAR_LAND(I) = AK_1 + BK_1*PSTAR(I)
C
*D SFEXCH5A.694   
        IF (SICE_PTS.GT.0) THEN
*D SFEXCH5A.696
          DO SI = 1,SICE_PTS 
*/
*D SFEXCH5A.697,699
            I = SICE_INDEX(SI)-(P1-1)
*D SFEXCH5A.700
*/
*D ADM3F404.100   
          CALL QSAT_WAT(QSL,TL_1,QSTAR_LAND,P_POINTS) 
*D ADM3F404.102   
          CALL QSAT(QSL,TL_1,QSTAR_LAND,P_POINTS)
*/
*D SFEXCH5A.706   
        CALL QSAT(QSTAR_SICE,TSTAR_SICE,PSTAR,P_POINTS)
        CALL QSAT(QSTAR_LAND,TSTAR_LAND,PSTAR,P_POINTS)
        CALL QSAT(QSTAR_SEA,TSTAR_SEA,PSTAR,P_POINTS)
*D SFEXCH5A.708,710
*/
*D SFEXCH5A.717,718
CL       specific humidity are required for open sea (QSTAR_SEA)
CL       and sea-ice (QSTAR_SICE) fractions respectively.
*/
*D SFEXCH5A.726   
          QSTAR_LAND(I) = AK_1 + BK_1*PSTAR(I)
*D SFEXCH5A.728,732
        ENDDO
*D SFEXCH5A.733,736
*D  ADM3F404.110
          CALL QSAT_WAT(QSL,TL_1,QSTAR_LAND,P_POINTS) 
*D ADM3F404.112   
          CALL QSAT(QSL,TL_1,QSTAR_LAND,P_POINTS)
*D SFEXCH5A.739   
        CALL QSAT(QSTAR_SICE,TSTAR_SICE,PSTAR,P_POINTS)
        CALL QSAT(QSTAR_LAND,TSTAR_LAND,PSTAR,P_POINTS)
        CALL QSAT(QSTAR_SEA,TSTAR_SEA,PSTAR,P_POINTS)
*D SFEXCH5A.741,746
*/
*D SFEXCH5A.751   
CL  2.2  Set components of ocean surface current. Calculate the
CL       fraction of land on the UV grid.
*/
*I AJC1F405.107
        FLANDG_UV(I) = FLANDG(I)
*/
*I SFEXCH5A.758
C
      DO I=1,P_POINTS
        FLANDG_UV(I)=FLANDG(I)
        TEMPY(I)=1.0
      ENDDO
C
*IF DEF,MPP
      CALL SWAPBOUNDS(FLANDG_UV,ROW_LENGTH,U_POINTS/ROW_LENGTH,1,0,1)
*ENDIF
C
      CALL P_TO_UV_LAND
     &    (FLANDG_UV,PSIS,P_POINTS,U_POINTS,TEMPY,ROW_LENGTH,P_ROWS)
C
      DO I=1,U_POINTS-2*ROW_LENGTH
        J = I+ROW_LENGTH
        FLANDG_UV(J) = PSIS(I)
      ENDDO
C
*IF DEF,MPP
      CALL SWAPBOUNDS(FLANDG_UV,ROW_LENGTH,U_POINTS/ROW_LENGTH,1,1,1)
*ENDIF
C
*IF DEF,MPP
        IF (attop) THEN
*ENDIF
          DO I=1,ROW_LENGTH
            FLANDG_UV(I) = 1.0E30
          ENDDO
*IF DEF,MPP
        ENDIF

        IF (atbase) THEN
*ENDIF
          DO I= (U_ROWS-1)*ROW_LENGTH + 1 , U_ROWS*ROW_LENGTH
            FLANDG_UV(I) = 1.0E30
          ENDDO
*IF DEF,MPP
        ENDIF
*ENDIF
C
      CALL UV_TO_P_SEA
     &  (U_0,U_0_P_TEMP,U_POINTS,P_POINTS,FLANDG_UV,ROW_LENGTH,U_ROWS)
      CALL UV_TO_P_SEA
     &  (V_0,V_0_P_TEMP,U_POINTS,P_POINTS,FLANDG_UV,ROW_LENGTH,U_ROWS)
C
*/
*I SFEXCH5A.769
      LOROG_GB=.FALSE.
*/ call sfrugh
*I SFEXCH5A.770
     & LOROG_GB,
*I SFEXCH5A.773  
     & COAST_PTS,COAST_INDEX,
     & SEA_PTS,SEA_INDEX,
*D SFEXCH5A.776,777   
     & FLANDG,LYING_SNOW,Z0V,SIL_OROG,HO2R2_OROG,RIB,RIB_LAND,
     & Z0M_EFF,Z0M_EFF_LAND,Z0M_EFF_SSI,
     & Z0M,Z0M_LAND,Z0M_SSI,Z0H,Z0H_LAND,Z0H_SSI,
     & WIND_PROFILE_FACT_LAND,WIND_PROFILE_FACT_SSI,H_BLEND,CD_SEA,
     & Z0HS,Z0F_LAND,Z0F_SSI,Z0FS,
*/
*D SFEXCH5A.786
C Reset QSTAR_LAND to missing data over non land points.
C Reset QSTAR_SICE to missing data over non sea-ice points.

C
      DO SE=1,SEA_PTS
        I=SEA_INDEX(SE)-(P1-1)         
        IF(.NOT.LAND_MASK(I))QSTAR_LAND(I)=RMDI
      ENDDO
C
      DO L = 1,LAND_PTS 
        I = LAND_INDEX(L)-(P1-1)
        IF(ICE_FRACT(I).LE.0.0)QSTAR_SICE(I)=RMDI
      ENDDO
C
      DO SNI=1,SEANOICE_PTS
        I=SEANOICE_INDEX(SNI)-(P1-1)
        QSTAR_SICE(I)=RMDI
      ENDDO
*/
*/ call sfrib
*D SFEXCH5A.794 
     & SEA_PTS,SEA_INDEX,SEANOICE_PTS,SEANOICE_INDEX,
     & SICE_PTS,SICE_INDEX,ICE_FRACT, 
     & FLANDG,
*D SFEXCH5A.796,798
     & CF_1,T_1,TL_1,QSL,
     & QSTAR_LAND,QSTAR_SEA,QSTAR_SICE,
     & QS1,TSTAR_LAND,TSTAR_SEA,TSTAR_SICE,
     & Z1,Z0M_EFF_LAND,Z0M_EFF_SSI,
     & Z0H_LAND,Z0H_SSI,Z0HS,Z0MSEA,
     & WIND_PROFILE_FACT_LAND,U_1_P,U_0_P,V_1_P,V_0_P,
*D SFEXCH5A.800   
     & LYING_SNOW,GC,RESIST,
     & RIB_LAND,RIB_SEA,RIB_SICE,
     & PSIS,VSHR_LAND,VSHR_SSI,ALPHA1_LAND,ALPHA1_SICE,
*D ADM3F404.114,115   
     & BT_1,BQ_1,BF_1,FRACA,RESFS,DQ_LAND,DQ_SEA,
     & DTEMP_SEA,L_BL_LSPICE,
*/
*/
*I  SFEXCH5A.803 
C
C Set RIB_SSI to bulk Richardson no. of the sea-ice, where present,
C otherwise open sea.
C
      IF (SICE_PTS.GT.0) THEN
        DO SI = 1,SICE_PTS 
          I = SICE_INDEX(SI)-(P1-1)
          RIB_SSI(I)=RIB_SICE(I)
        ENDDO
      ENDIF
C
      DO SNI=1,SEANOICE_PTS
        I=SEANOICE_INDEX(SNI)-(P1-1)
        RIB_SSI(I)=RIB_SEA(I)
      ENDDO
C
      DO I = 1,P_POINTS
        RIB(I)=FLANDG(I)*RIB_LAND(I)+(1.-FLANDG(I))*RIB_SSI(I)
      ENDDO
C
C ***TEMPORARY*** need until sulphate resistances have been sorted out.
      DO I=1,P_POINTS
        VSHR(I)=FLANDG(I)*VSHR_LAND(I)+(1.-FLANDG(I))*VSHR_SSI(I)
      ENDDO
C
*/
*I SFEXCH5A.810 
      LOROG_GB=.TRUE.
*/ call sfrugh
*I SFEXCH5A.811 
     & LOROG_GB,
*I SFEXCH5A.814
     & COAST_PTS,COAST_INDEX,
     & SEA_PTS,SEA_INDEX,
*D SFEXCH5A.817,818  
     & FLANDG,LYING_SNOW,Z0V,SIL_OROG,HO2R2_OROG,RIB,RIB_LAND,
     & Z0M_EFF,Z0M_EFF_LAND,Z0M_EFF_SSI,
     & Z0M,Z0M_LAND,Z0M_SSI,Z0H,Z0H_LAND,Z0H_SSI,
     & WIND_PROFILE_FACT_LAND,WIND_PROFILE_FACT_SSI,H_BLEND,CD_SEA,
     & Z0HS,Z0F_LAND,Z0F_SSI,Z0FS,
*/
*D SFEXCH5A.823,825
CL  3.4 Calculate CD, CH via routine FCDCH for LAND, SEA, SICE and MIZ.
CL  Calculate all on full field then set
CL  non-relevant points to missing data (contain nonsense after FCDCH).
*/
*D SFEXCH5A.832
C   NB CD_SEA stores Z0MIZ for calculation of CD_MIZ,CH_MIZ.
*/
*D SFEXCH5A.835
      CALL FCDCH(RIB_SICE,CD_SEA,CD_SEA,CD_SEA,Z1,
     &           WIND_PROFILE_FACT_SSI,
*D SFEXCH5A.838,839
      CALL FCDCH(RIB_SEA,Z0MSEA,Z0HS,Z0FS,Z1,WIND_PROFILE_FACT_SSI,
     &           P_POINTS,CD_SEA,CH_SEA,CD_STD_SSI,LTIMER)
C
*D SFEXCH5A.841,842
      CALL FCDCH(RIB_LAND,Z0M_EFF_LAND,Z0H_LAND,Z0F_LAND,Z1,
     &           WIND_PROFILE_FACT_LAND,
     &           P_POINTS,CD_LAND,CH_LAND,CD_STD_LAND,LTIMER)
C
      CALL FCDCH(RIB_SICE,Z0M_EFF_SSI,Z0H_SSI,Z0F_SSI,Z1,
     &           WIND_PROFILE_FACT_SSI,
     &           P_POINTS,CD_SICE,CH_SICE,CD_STD_SSI,LTIMER)
C
*/
*D SFEXCH5A.843,845
      DO L = 1,LAND_PTS
          I = LAND_INDEX(L)-(P1-1)
          IF(FLANDG(I).GE.1.0)THEN
*D SFEXCH5A.848,850
            CD_SEA(I) = 1.E30
            CH_SEA(I) = 1.E30
            RIB_SEA(I) = 1.E30
            CD_SICE(I) = 1.E30
            CH_SICE(I) = 1.E30
            RIB_SICE(I) = 1.E30
            CD_SSI(I) = 0.0
            CH_SSI(I) = 1.E30
            RIB_SSI(I) = 1.E30
          ENDIF
*D SFEXCH5A.851
*I SFEXCH5A.852
      DO SNI=1,SEANOICE_PTS
          I = SEANOICE_INDEX(SNI)-(P1-1)
          CD_MIZ(I) = 1.E30
          CH_MIZ(I) = 1.E30
          CD_SICE(I) = 1.E30
          CH_SICE(I) = 1.E30
      ENDDO
C initialise all points with sea as missing data: 
      DO I=1,P_POINTS
        IF(.NOT.LAND_MASK(I))CH_LAND(I) = 0.0
      ENDDO
*/
*D SFEXCH5A.871   
          EPDT(I) = -PSTAR(I)/(R*TSTAR_LAND(I))*CH_LAND(I)
     &              *VSHR_LAND(I)*DQ_LAND(I)*TIMESTEP
*/
*D SFEXCH5A.885   
! Calculate the land aerodynamic resistance
*/
*D SFEXCH5A.888
          IF(LAND_MASK(I))THEN
            RA(I) = 1.0 / (CH_LAND(I) * VSHR_LAND(I))
          ELSE
            RA(I) = 1.E30
          ENDIF
*/
*/----------------------------------------------------------------
*/ call sfstom:
*D SFEXCH5A.917   
     &,                Q_1,RA,ROOT,TSTAR_LAND,SMVCCL,V_ROOT,SMVCWT
*/----------------------------------------------------------------
*/
*D SFEXCH5A.921   
! Convert carbon fluxes to gridbox mean values 
*D SFEXCH5A.933,935   
            GPP(L) = FLANDG(I) * VFRAC(L) * GPP(L)
            NPP(L) = FLANDG(I) * VFRAC(L) * NPP(L)
            RESP_P(L) = FLANDG(I) * VFRAC(L) * RESP_P(L)
*/
*/ call sfres
*D SFEXCH5A.952,953
     & ROOTD,SMVCCL,SMVCWT,SMC,V_SOIL,VFRAC,CANOPY,CATCH,DQ_LAND,
     & EPDT,LYING_SNOW,GC,RESIST,VSHR_LAND,CH_LAND,PSIS,FRACA,RESFS,
*/
*D SFEXCH5A.958
CL  4.D Call SFL_INT to calculate CDR10M, CHR1P5M and CER1P5M 
Cl      for land (*_LAND) and mean sea (*_SSI). These are
*/
*D SFEXCH5A.965,970
C Calculate land coefficients:
        LLAND=.TRUE.
        CALL SFL_INT (
     &  P_POINTS,U_POINTS,RIB_LAND,Z1,LLAND,
     &  Z0M_LAND,Z0M_EFF_LAND,Z0H_LAND,Z0F_LAND,
     &  CD_STD_LAND,CD_LAND,CH_LAND,
     &  RESFT,WIND_PROFILE_FACT_LAND,
     &  CDR10M_LAND,CHR1P5M_LAND,CER1P5M_LAND,
     &  SU10,SV10,ST1P5,SQ1P5,LTIMER
     & )
*/
*/.......................................................................
*/-----------------------------------------------------------------------
*/
*D SFEXCH5A.976,977
      DO SNI=1,SEANOICE_PTS
          I = SEANOICE_INDEX(SNI)-(P1-1)
          CD_SSI(I)     = CD_SEA(I)
          CD_STD_SSI(I) = CD_SSI(I)
          CH_SSI(I)     = CH_SEA(I)
      ENDDO
C
      IF (SICE_PTS.GT.0) THEN
        DO SI = 1,SICE_PTS 
          I = SICE_INDEX(SI)-(P1-1)
          CD_SSI(I)     = CD_SICE(I)
          CD_STD_SSI(I) = CD_SSI(I)
          CH_SSI(I)     = CH_SICE(I)
        ENDDO
      ENDIF
C
      IF (SU10 .OR. SV10 .OR. SQ1P5 .OR. ST1P5) THEN
C
C Calculate mean sea coefficients:
        LLAND=.FALSE.
        CALL SFL_INT (
     &  P_POINTS,U_POINTS,RIB_SSI,Z1,LLAND,
     &  Z0M_SSI,Z0M_EFF_SSI,Z0H_SSI,Z0F_SSI,
     &  CD_STD_SSI,CD_SSI,CH_SSI,
     &  RESFT,WIND_PROFILE_FACT_SSI,
     &  CDR10M_SSI,CHR1P5M_SSI,CER1P5M_SSI,
     &  SU10,SV10,ST1P5,SQ1P5,LTIMER
     & )
C
      ENDIF
C
      IF (SICE_PTS.GT.0) THEN
        DO SI = 1,SICE_PTS 
          I = SICE_INDEX(SI)-(P1-1)
*/
*D SFEXCH5A.979,980
            CD_SSI(I)     = ( ICE_FRACT(I)*CD_MIZ(I) +
     &                (0.7-ICE_FRACT(I))*CD_SEA(I) ) / 0.7  ! P2430.5
*/
*D SFEXCH5A.981,983
            CD_STD_SSI(I) = CD_SSI(I)     ! for SCYCLE: no orog. over sea+ice
            CH_SSI(I)     = ( ICE_FRACT(I)*CH_MIZ(I) +
     &                (0.7-ICE_FRACT(I))*CH_SEA(I) ) / 0.7  ! P2430.4
*/
*D SFEXCH5A.985,989
            CD_SSI(I)     = ( (1.0-ICE_FRACT(I))*CD_MIZ(I) +
     &              (ICE_FRACT(I)-0.7)*CD_SICE(I) ) / 0.3      ! P2430.7
            CD_STD_SSI(I) = CD_SSI(I)     ! for SCYCLE: no orog. over sea+ice
            CH_SSI(I)     = ( (1.0-ICE_FRACT(I))*CH_MIZ(I) +
     &              (ICE_FRACT(I)-0.7)*CH_SICE(I) ) / 0.3      ! P2430.7
*D SFEXCH5A.991
        ENDDO
      ENDIF
C
      DO L = 1,LAND_PTS 
        RHO_ARESIST_LAND(L) = 0.0
        ARESIST_LAND(L)     = 0.0
        RESIST_B_LAND(L)    = 0.0
      ENDDO
C
      DO I = 1,P_POINTS
        RHOKH_LAND(I)     = 0.0
        RHOKH_SICE(I)     = 0.0
        RHO_ARESIST_SSI(I)  = 0.0
        ARESIST_SSI(I)      = 0.0
        RESIST_B_SSI(I)     = 0.0
C***TEMPORARY: these are output as diagnostics, so set to zero:
        RHO_ARESIST(I) = 0.0
        ARESIST(I)     = 0.0
        RESIST_B(I)    = 0.0
C
        CD(I) = FLANDG(I)*CD_LAND(I)+(1.-FLANDG(I))*CD_SSI(I)
        CH(I) = FLANDG(I)*CH_LAND(I)+(1.-FLANDG(I))*CH_SSI(I)
C
*/
*D SFEXCH5A.993   
CL  4.3 Calculate the surface exchange coefficients RHOK*.

*/
*D SFEXCH5A.997,1002
*D SFEXCH5A.1003,1004
        RHOKM_LAND(I) = RHOSTAR(I) * CD_LAND(I) * VSHR_LAND(I)
        RHOKM_SSI(I) = RHOSTAR(I) * CD_SSI(I) * VSHR_SSI(I)  ! P243.124    
        RHOKM_1(I) = FLANDG(I)*RHOKM_LAND(I)
     &   +(1.-FLANDG(I))*RHOKM_SSI(I)
*D SFEXCH5A.1005
*/
*/.......................................................................
*/-----------------------------------------------------------------------
*I SFEXCH5A.1014
C  Calculate resistances for use in Sulphur Cycle.
C  Calculate heat and moisture exchange coefficients.
C  (Note that CD_STD_*, CH_* and VSHR_* should never = 0)
C
      DO L = 1,LAND_PTS 
        I = LAND_INDEX(L)-(P1-1)
        RHO_ARESIST_LAND(L) = RHOSTAR(I) * CD_STD_LAND(I) * VSHR_LAND(I)
        ARESIST_LAND(L) = RHOSTAR(I)/RHO_ARESIST_LAND(L)
        RESIST_B_LAND(L)= (CD_STD_LAND(I)/CH_LAND(I)
     &                    - 1.0) * ARESIST_LAND(L)
C
        RHOKH_LAND(I) = RHOSTAR(I) * CH_LAND(I) * VSHR_LAND(I)
C                                                             ! P243.125
      ENDDO
C
      DO SE=1,SEA_PTS
        I=SEA_INDEX(SE)-(P1-1)
        RHO_ARESIST_SSI(I) = RHOSTAR(I) * CD_SSI(I) * VSHR_SSI(I)
        ARESIST_SSI(I) = RHOSTAR(I)/RHO_ARESIST_SSI(I)
        RESIST_B_SSI(I)= (CD_SSI(I)/CH_SSI(I) - 1.0) * ARESIST_SSI(I)
C
        RHOKH_SICE(I) = RHOSTAR(I) * CH_SSI(I) * VSHR_SSI(I)
C                                                            ! P243.125
      ENDDO
C  
*/.......................................................................
*/-----------------------------------------------------------------------
*/
*/ call sfflux:
*I SFEXCH5A.1019
     & SEA_PTS,SEA_INDEX,SICE_PTS,SICE_INDEX,
     & SEANOICE_PTS,SEANOICE_INDEX,COAST_PTS,COAST_INDEX,
     & FLANDG,
*D SFEXCH5A.1021  
     & ALPHA1_LAND,ALPHA1_SICE,
     & DQ_SEA,DTEMP_SEA,DZSOIL,HCONS,ICE_FRACT,
*D APA1F405.395   
     & LYING_SNOW,QS1,QW_1,RADNET_SICE,RADNET_C_LAND,RESFT,
     & RHOKH_LAND,RHOKH_SICE,TI,TL_1,TS1,
*D SFEXCH5A.1023  
     & Z0H_LAND,Z0H_SSI,Z0M_EFF_LAND,Z0M_EFF_SSI,Z1,
*D ANG1F405.103   
     & ASHTF_LAND,ASHTF_SICE,
     & E_SEA,EPOT_LAND,EPOT_SSI,EPOT_ICE,
     & FQW_1,FQW_LAND,FQW_SSI,FTL_1,FTL_LAND,FTL_SSI,
     & H_SEA,RHOKPM_LAND,RHOKPM_SICE,RHOKPM_POT_LAND,RHOKPM_POT_SICE,
*D APA1F405.396   
     & TSTAR_LAND,VFRAC,TIMESTEP,CANCAP,
*/
*D SFEXCH5A.1039,1045
*I SFEXCH5A.1026 
C-----------------------------------------------------------------------
CL  4.4.1 Multiply surface exchange coefficients that are on the P-grid
CL        by GAMMA(1).Needed for implicit calculations in P244(IMPL_CAL).
CL        RHOKM_1 dealt with in section 4.1 below.
C         Calculate grid box mean of RHOKH_1:
C-----------------------------------------------------------------------  
C-----------------------------------------------------------------------
      DO L = 1,LAND_PTS 
        I = LAND_INDEX(L)-(P1-1)
        RHOKH_LAND(I) = RHOKH_LAND(I) * GAMMA(1)
	RHOKH_1(I)=FLANDG(I)*RHOKH_LAND(I)
      ENDDO
      DO SE=1,SEA_PTS
        I=SEA_INDEX(SE)-(P1-1)
        RHOKH_SICE(I) = RHOKH_SICE(I) * GAMMA(1)
        IF(LAND_MASK(I))THEN
          RHOKH_1(I)=RHOKH_1(I)+(1.-FLANDG(I))*RHOKH_SICE(I)
        ELSE
	  RHOKH_1(I)=RHOKH_SICE(I)
        ENDIF
      ENDDO
*/
*D SFEXCH5A.1028
CL  4.5 Set indicator for unstable suface layer (buoyancy flux +ve.).   
*/
*D SFEXCH5A.1051  
C Use TAU to temporarily store the grid box mean stress
        TAU = FLANDG(I)*RHOKM_LAND(I)*VSHR_LAND(I) +
     &        (1.-FLANDG(I))*RHOKM_SSI(I)*VSHR_SSI(I)
        VS = SQRT (TAU/RHOSTAR(I))
*/
*I SFEXCH5A.1064
      ENDDO
*D SFEXCH5A.1070,1074
C
      DO SE=1,SEA_PTS
        I=SEA_INDEX(SE)-(P1-1)
          TAU = RHOKM_SSI(I) * VSHR_SSI(I)                      ! P243.130
          IF (ICE_FRACT(I) .GT. 0.0)
     &      TAU = RHOSTAR(I) * CD_SEA(I) * VSHR_SSI(I) * VSHR_SSI(I)
          IF (SFME) FME(I) = (1.0-ICE_FRACT(I)) * TAU * SQRT(TAU/RHOSEA)
*/
*D SFEXCH5A.1084 
*D SFEXCH5A.1086,1087
      DO I=1,P_POINTS
*/
*D SFEXCH5A.1090,1095
CL  4.7 FME to zero for land only points.
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      IF(FLANDG(I).EQ.1.0)THEN
        IF (SFME) FME(I) = 0.0                                            
      ENDIF
*/
*D SFEXCH5A.1114,1115  
! RHOKM_LAND and RHOKM_SSI contain duff data in halos.
! The P_TO_UV can interpolate this into the real data,
! so first we must update east/west halos.
*/
*D SFEXCH5A.1116  
*IF DEF,MPP
      CALL SWAPBOUNDS(RHOKM_LAND,ROW_LENGTH,U_POINTS/ROW_LENGTH,1,0,1)
      CALL SWAPBOUNDS(RHOKM_SSI,ROW_LENGTH,U_POINTS/ROW_LENGTH,1,0,1)
*ENDIF
*D SFEXCH5A.1119
*/
*/...............................................
C OLD MOMENTUM SCHEME:
      L_NEWMOMENTUM=.TRUE.
      IF(.NOT.L_NEWMOMENTUM)THEN
*IF DEF,MPP
      CALL SWAPBOUNDS(RHOKM_1,ROW_LENGTH,U_POINTS/ROW_LENGTH,1,0,1)
*ENDIF
      CALL P_TO_UV(RHOKM_1,PSIS,P_POINTS,U_POINTS,ROW_LENGTH,P_ROWS)
      DO I=1,U_POINTS-2*ROW_LENGTH
        J = I+ROW_LENGTH
        RHOKM_1(J) = PSIS(I)
        TAUX_1(J) = RHOKM_1(J) * ( U_1(J) - U_0(J) ) ! P243.132
        TAUY_1(J) = RHOKM_1(J) * ( V_1(J) - V_0(J) ) ! P243.133
        TAUX_LAND(J)=TAUX_1(J)
        TAUX_SSI(J)=TAUX_1(J)
        TAUY_LAND(J)=TAUY_1(J)
        TAUY_SSI(J)=TAUY_1(J)
        RHOKM_1(J) = GAMMA(1) * RHOKM_1(J)
      ENDDO
*/...............................................
*/
      ELSE
C NEW MOMENTUM SCHEME:
C Convert RHOKM_LAND from P grid to UV grid
C
      CALL P_TO_UV_LAND
     &    (RHOKM_LAND,PSIS,P_POINTS,U_POINTS,FLANDG,ROW_LENGTH,P_ROWS)
*D SFEXCH5A.1122,1125
        RHOKM_LAND(J) = PSIS(I) 
C
C Set the surface wind to zero by default:
        TAUX_LAND(J) = RHOKM_LAND(J) * U_1(J)            ! P243.132
        TAUY_LAND(J) = RHOKM_LAND(J) * V_1(J)            ! P243.133
C
        RHOKM_LAND(J) = GAMMA(1) * RHOKM_LAND(J)
*/
*I SFEXCH5A.1126  
C Convert RHOKM_SSI from P grid to UV grid
C
      CALL P_TO_UV_SEA
     &    (RHOKM_SSI,PSIS,P_POINTS,U_POINTS,FLANDG,ROW_LENGTH,P_ROWS)
      DO I=1,U_POINTS-2*ROW_LENGTH
        J = I+ROW_LENGTH
        RHOKM_SSI(J) = PSIS(I)
C
        TAUX_SSI(J) = RHOKM_SSI(J) * ( U_1(J) - U_0(J) ) ! P243.132
        TAUY_SSI(J) = RHOKM_SSI(J) * ( V_1(J) - V_0(J) ) ! P243.133
        RHOKM_SSI(J) = GAMMA(1) * RHOKM_SSI(J)
C
C Now calculate the grid box mean:
        TAUX_1(J)=FLANDG_UV(J)*TAUX_LAND(J) +
     &            (1.-FLANDG_UV(J))*TAUX_SSI(J)
        TAUY_1(J)=FLANDG_UV(J)*TAUY_LAND(J) +
     &            (1.-FLANDG_UV(J))*TAUY_SSI(J)
C
        RHOKM_1(J)=FLANDG_UV(J)*RHOKM_LAND(J) +
     &                  (1.-FLANDG_UV(J))*RHOKM_SSI(J)
C
      ENDDO
      ENDIF    !end of choice of which momentum scheme
*/
*/----------------------------------------------
*/
*D SFEXCH5A.1140  
CL  5.D Interpolate CDR10M_LAND and CDR10M_SSI to UV-grid.
*D ASJ1F403.24    
*IF DEF,MPP
        CALL SWAPBOUNDS(CDR10M_LAND
     &        ,ROW_LENGTH,U_POINTS/ROW_LENGTH,1,0,1)
*ENDIF 
*D SFEXCH5A.1143,1147
        CALL P_TO_UV_LAND
     &   (CDR10M_LAND,PSIS,P_POINTS,U_POINTS,FLANDG,ROW_LENGTH,P_ROWS)
        DO I=1,U_POINTS-2*ROW_LENGTH
          J = I + ROW_LENGTH
          CDR10M_LAND(J) = PSIS(I)
        ENDDO
*IF DEF,MPP
        CALL SWAPBOUNDS(CDR10M_SSI
     &        ,ROW_LENGTH,U_POINTS/ROW_LENGTH,1,0,1)
*ENDIF
        CALL P_TO_UV_SEA
     &   (CDR10M_SSI,PSIS,P_POINTS,U_POINTS,FLANDG,ROW_LENGTH,P_ROWS)
        DO I=1,U_POINTS-2*ROW_LENGTH
          J = I + ROW_LENGTH
          CDR10M_SSI(J) = PSIS(I)
        ENDDO
*D GPB1F403.76    
            CDR10M_LAND(I) = 1.0E30
            CDR10M_SSI(I) = 1.0E30
*D GPB1F403.84    
            CDR10M_LAND(I) = 1.0E30
            CDR10M_SSI(I) = 1.0E30
*/
*/----------------------------------------------
*/
*I GPB1F403.57
          RHOKM_LAND(I) = 1.0E30
          TAUX_LAND(I) = 1.0E30
          TAUY_LAND(I) = 1.0E30
          RHOKM_SSI(I) = 1.0E30
          TAUX_SSI(I) = 1.0E30
          TAUY_SSI(I) = 1.0E30
*I GPB1F403.67
          RHOKM_LAND(I) = 1.0E30
          TAUX_LAND(I) = 1.0E30
          TAUY_LAND(I) = 1.0E30
          RHOKM_SSI(I) = 1.0E30
          TAUX_SSI(I) = 1.0E30
          TAUY_SSI(I) = 1.0E30
*/
*D SFEXCH5A.1167,1169
*/
*/
        TAUX_LAND(I) = RHOKM_LAND(I) * U_1(I)            ! P243.132
        TAUY_LAND(I) = RHOKM_LAND(I) * V_1(I)            ! P243.133
C
        RHOKM_LAND(I) = GAMMA(1) * RHOKM_LAND(I)
C
        TAUX_SSI(I) = RHOKM_SSI(I) * ( U_1(I) - U_0(I) ) ! P243.132
        TAUY_SSI(I) = RHOKM_SSI(I) * ( V_1(I) - V_0(I) ) ! P243.133
        RHOKM_SSI(I) = GAMMA(1) * RHOKM_SSI(I)
C
C Now calculate the grid box mean:
        TAUX_1(I)=FLANDG_UV(I)*TAUX_LAND(I) +
     &            (1.-FLANDG_UV(I))*TAUX_SSI(I)
        TAUY_1(I)=FLANDG_UV(I)*TAUY_LAND(I) +
     &            (1.-FLANDG_UV(I))*TAUY_SSI(I)
C
        RHOKM_1(I)=FLANDG_UV(I)*RHOKM_LAND(I) +
     &                  (1.-FLANDG_UV(I))*RHOKM_SSI(I)
*/
*/.......................................................................
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*/.......................................................................
*/ To effectively set RESFT to 1.0 if sea calcs
*DECLARE SFLINT3A
*/
*I ARN1F400.88    
CLL   4.2      08/99   Either land or sea calculation.
CLL                                                    N. Gedney
CLL
*/
*D ARN1F400.89  
     & P_POINTS,U_POINTS,RIB,Z1,LLAND,
     & Z0M,Z0M_EFF,Z0H,Z0F,CD_STD,CD,CH 

*/
*I SFLINT3A.58
     &,LLAND                     ! IN TRUE if land calculation.
C                                !    Else FALSE if sea calculation.
*/
*D SFLINT3A.186
            IF(LLAND)THEN
              CER1P5M(I) = ( CHR1P5M(I) - 1.0 ) * RESFT(I)    ! P243.123
            ELSE
              CER1P5M(I) = ( CHR1P5M(I) - 1.0 )               ! P243.123
            ENDIF
*/.......................................................................
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*/.......................................................................
*DECLARE BLEND_H  
*D BLEND_H.2
*IF DEF,A03_5A,OR,DEF,A03_7A,OR,DEF,A19_1A,OR,DEF,A19_2A
*/.......................................................................
*/-----------------------------------------------------------------------
*/.......................................................................
*/-----------------------------------------------------------------------
 
*ID CTILE5
*/---------------------------------------------------------------------------
*/---------------------------------------------------------------------------
*/ Modifications to SFFLUX5A and SFRIB5A
*/---------------------------------------------------------------------------
*/---------------------------------------------------------------------------
*/.......................................................................
*/-----------------------------------------------------------------------
*DECLARE SFFLUX5A
*I AJC1F405.73
CLL
CLL           08/99   Calculate separate surface msmoisture and heat
CLL                   fluxes for land, open sea and sea-ice.
CLL                                     N. Gedney
CLL
*I SFFLUX5A.24
     & SEA_PTS,SEA_INDEX,SICE_PTS,SICE_INDEX,
     & SEANOICE_PTS,SEANOICE_INDEX,COAST_PTS,COAST_INDEX,
     & FLANDG,
*D SFFLUX5A.26    
     & ALPHA1_LAND,ALPHA1_SICE,
     & DQ_SEA,DTEMP_SEA,DZ1,HCONS,ICE_FRACT,
*D APA1F405.397   
     & LYING_SNOW,QS1,QW_1,RADNET_SICE,RADNET_C_LAND,RESFT,
     & RHOKH_LAND,RHOKH_SICE,TI,TL_1,TS1,
*D SFFLUX5A.28   
     & Z0H_LAND,Z0H_SSI,Z0M_EFF_LAND,Z0M_EFF_SSI,Z1,
*D ANG1F405.138
     & ASHTF_LAND,ASHTF_SICE,
     & E_SEA,EPOT_LAND,EPOT_SSI,EPOT_ICE,
     & FQW_1,FQW_LAND,FQW_SSI,FTL_1,FTL_LAND,FTL_SSI,
     & H_SEA,RHOKPM_LAND,RHOKPM_SICE,RHOKPM_POT_LAND,RHOKPM_POT_SICE,
*D APA1F405.398   
     & TSTAR_LAND,VFRAC,TIMESTEP,CANCAP,
*I SFFLUX5A.43
      INTEGER
     & COAST_INDEX(P_POINTS)     ! IN COAST_INDEX(I)=J => the Jth
!                                !    point in P_POINTS is the Ith
!                                !    coast point.
     &,COAST_PTS                 ! IN No of coastal points processed.
     &,SEA_INDEX(P_POINTS)       ! IN SEA_INDEX(I)=J => the Jth
!                                !    point in P_POINTS is the Ith
!                                !    sea point.
     &,SEA_PTS                   ! IN No of sea points processed.
     &,SICE_INDEX(P_POINTS)      ! IN SICE_INDEX(I)=J => the Jth
!                                !    point in P_POINTS is the Ith
!                                !    sea-icepoint.
     &,SICE_PTS                  ! IN No of sea-ice points processed.
     &,SEANOICE_INDEX(P_POINTS)  ! IN SEANOICE_INDEX(I)=J => the Jth
!                                !    point in P_POINTS is the Ith
!                                !    sea-ice free sea point.
     &,SEANOICE_PTS              ! IN No of sea-ice free sea points
!                                !    processed.
      REAL
     & FLANDG(P_POINTS)       ! IN Fraction of land in grid box. 
*D SFFLUX5A.47,49
     & ALPHA1_LAND(P_POINTS)
C                       ! IN Gradient of saturated specific humidity
C                       !     with respect to temperature between the
C                       !     bottom model layer and land surface.
     &,ALPHA1_SICE(P_POINTS)
C                       ! IN Gradient of saturated specific humidity
C                       !     with respect to temperature between the
C                       !     bottom model layer and sea-ice surface.
*/
*D SFFLUX5A.50    
     &,DQ_SEA(P_POINTS)   ! Sp humidity difference between
C                         ! open sea surface and lowest
C                         ! atmospheric level (Q1 - Q*).
     &,DQ_SICE(P_POINTS)  ! Sp humidity difference between
C                         ! sea-ice surface and lowest
C                         ! atmospheric level (Q1 - Q*).
*/
*D SFFLUX5A.54    
*/
*D SFFLUX5A.56    
     &,DTEMP_SEA(P_POINTS)! Liquid/ice static energy difference
C                         !  between open sea surface and lowest
C                         !  atmospheric level, divided by CP (a
C                         !  modified temperature difference).
     &,DTEMP_SICE(P_POINTS)
C                         ! Liquid/ice static energy difference
C                         !  between sea-ice surface and lowest
C                         !  atmospheric level, divided by CP (a
C                         !  modified temperature difference).
*/
*D SFFLUX5A.62
*/
*D SFFLUX5A.67
     &,ICE_FRACT(P_POINTS) ! IN Fraction of sea which is sea-ice.
*D SFFLUX5A.74    
     &,RESFT(P_POINTS)  ! IN Total resistance factor over land
*/
*D SFFLUX5A.76
*D SFFLUX5A.77
     &,RHOKH_LAND(P_POINTS)
C                        ! IN For FTL_LAND,
C                        !    then *GAMMA(1) for implicit calc.
     &,RHOKH_SICE(P_POINTS)
C                        ! IN For FTL_SSI,
C                        !    then *GAMMA(1) for implicit calc.
*D SFFLUX5A.82 
     &,Z0H_LAND(P_POINTS) ! IN Land roughness length for
C                         !    heat and moisture (m).
     &,Z0H_SSI(P_POINTS)  ! IN Mean sea roughness length for
C                         !    heat and moisture (m).
*D SFFLUX5A.83    
     &,Z0M_EFF_LAND(P_POINTS)
C                         ! IN Land effective roughness length
C                         !    for momentum (m).
     &,Z0M_EFF_SSI(P_POINTS)
C                         ! IN Mean sea effective roughness length
C                         !    for momentum (m). 
*/
*D SFFLUX5A.87    
     & LAND_MASK(P_POINTS) ! IN .TRUE. for points containing any land;
C                          !    .FALSE. elsewhere.
*/
*D SFFLUX5A.92,93
     & ASHTF_LAND(LAND_PTS)
C                       ! OUT Coefficient to calculate surface
C                       !     heat flux into soil (W/m2/K).
     &,ASHTF_SICE(P_POINTS)
C                       ! OUT Coefficient to calculate surface
C                       !     heat flux into sea-ice (W/m2/K).
*/
*D SFFLUX5A.94,95
     &,E_SEA(P_POINTS)  ! OUT Evaporation from sea times leads
C                       !     fraction of total sea portion
C                       !     of grid box. Zero over land-only
C                       !     points. (kg/m2/s).
*D  ANG1F405.139,140
     &,EPOT_LAND(LAND_PTS)   
C                       ! OUT potential evaporation on P-grid
C                       !      (kg/m2/s).
     &,EPOT_SSI(P_POINTS)
C                       ! OUT potential evaporation on P-grid
C                       !      (kg/m2/s).
     &,EPOT_ICE(P_POINTS)
C                       ! OUT potential evaporation on P-grid
C                       !      (kg/m2/s).
*I SFFLUX5A.97
     &,FQW_LAND(LAND_PTS)
C                       ! OUT "Explicit" land surface flux of QW
C                       !      (i.e. land evaporation), 
C                       !      on P-grid (kg/m2/s).
     &,FQW_SSI(P_POINTS)! OUT "Explicit" sea+sea-ice surface flux of QW
C                       !      (i.e. sea+sea-ice evaporation), 
C                       !      on P-grid (kg/m2/s).
*I SFFLUX5A.99
     &,FTL_LAND(LAND_PTS)
C                       ! OUT "Explicit" land surface flux
C                       !      of TL = H/CP. (land sensible heat / CP).
     &,FTL_SSI(P_POINTS)! OUT "Explicit" sea+sea-ice surface flux
C                       !      of TL = H/CP. (sea sensible heat / CP).
*D SFFLUX5A.100,103
     &,H_SEA(P_POINTS)  ! OUT Surface sensible heat flux over
C                       !     sea times leads fraction of
C                       !     total sea portion of grid box.
C                       !     Zero over land-only points.
C                       !     (W/m2).
     &,RHOKPM_LAND(P_POINTS)
C                       ! OUT NB NOT * GAMMA for implicit calcs.
     &,RHOKPM_SICE(P_POINTS)
C                       ! OUT NB NOT * GAMMA for implicit calcs.
*D ANG1F405.141,143
     &,RHOKPM_POT_LAND(LAND_PTS)
C                       ! OUT Land surface exchange coeff. for
C                       !     potential evaporation.
     &,RHOKPM_POT_SICE(P_POINTS)
C                       ! OUT Sea-ice surface exchange coeff. for
C                       !     potential evaporation.
*/
*D APA1F405.403   
     & TSTAR_LAND(P_POINTS)
C                       ! IN Mean gridsquare surface temperature (K).
*D APA1F405.404
     &,VFRAC(LAND_PTS)  ! IN Fraction of vegetation in land portion
C                       !    of gridbox.
*D APA1F405.408,409
     &,RADNET_C_LAND(P_POINTS)
C                       ! INOUT Adjusted net radiation for vegetation
C                       !       over land (W/m2).
     &,RADNET_SICE(P_POINTS)
C                       ! IN Net radiation for sea-ice (W/m2).
C                       !    Weighted by sea-ice fraction
C                       !    in sea portion of grid box.
*/
*I SFFLUX5A.125   
     &,SE          ! Loop counter (sea point field index).
     &,SI          ! Loop counter (sea-ice point field index).
     &,SNI         ! Loop counter (sea-ice free sea point field index).
*/.......................................................................
*/-----------------------------------------------------------------------
*D SFFLUX5A.163
        ASHTF_LAND(L) = 2.0 * HCONS(L) / DZ1
C Initialise ASHTF_SICE to zero over all points containing land.
        ASHTF_SICE(I) = 0.0 
*D SFFLUX5A.168
            ASHTF_LAND(L) =  ASHTF_LAND(L) /
*D SFFLUX5A.171
            ASHTF_LAND(L) =  ASHTF_LAND(L)*SNOW_HCON / HCONS(L)
*D APA1F405.419
          ASHTF_LAND(L) = ASHTF_LAND(L)
*D APA1F405.423
          ASHTF_LAND(L) = (1.0-VFRAC(L))*ASHTF_LAND(L) +
*D APA1F405.428
          ASHTF_LAND(L) = (1.0-VFRAC(L))*ASHTF_LAND(L) +
*D APA1F405.433
        ASHTF_LAND(L) = ASHTF_LAND(L) + CANCAP(I)/TIMESTEP
*D SFFLUX5A.178,179  
        RHOKPM_LAND(I) = RHOKH_LAND(I) / ( RHOKH_LAND(I) *
     &           (LAT_HEAT*ALPHA1_LAND(I)*RESFT(I) + CP)
     &           + ASHTF_LAND(L) )
*D SFFLUX5A.182
     &                          + Z0M_EFF_LAND(I) - Z0H_LAND(I)) )
*D SFFLUX5A.184,188
     &            GRCP * ALPHA1_LAND(I) *
     &            (Z1(I) + Z0M_EFF_LAND(I) - Z0H_LAND(I))
        FQW_LAND(L) = RESFT(I)*RHOKPM_LAND(I)*( ALPHA1_LAND(I) *
     &          RAD_REDUC + (CP*RHOKH_LAND(I) + 
     &          ASHTF_LAND(L))* DQ1(I) )
        FTL_LAND(L) = RHOKPM_LAND(I) *
     &          ( RAD_REDUC - 
     &          LAT_HEAT*RESFT(I)*RHOKH_LAND(I)*DQ1(I) )
*D APA1F405.435,436  
        RADNET_C_LAND(I)=RADNET_C_LAND(I) + CANCAP(I)*(TSTAR_LAND(I)
     &             -TS1(L))/TIMESTEP
        RAD_REDUC = RADNET_C_LAND(I) - ASHTF_LAND(L) *
*D ANG1F405.144,147
        RHOKPM_POT_LAND(L)=RHOKH_LAND(I) / ( RHOKH_LAND(I) *
     &            (LAT_HEAT*ALPHA1_LAND(I) + CP) + ASHTF_LAND(L) )
        EPOT_LAND(L) = RHOKPM_POT_LAND(L)*( ALPHA1_LAND(I) *
     &          RAD_REDUC + (CP*RHOKH_LAND(I) +
     &          ASHTF_LAND(L))* DQ1(I) )
*/
*D SFFLUX5A.189,193
*D SFFLUX5A.199,200
!
!***********************************************************************
!  Calculate sensible and latent heat fluxes for sea and sea-ice
!  over all points containing sea-ice.
!***********************************************************************
!
      DO SI=1,SICE_PTS
            I=SICE_INDEX(SI)-(P1-1)
*D SFFLUX5A.202,203
            ASHTF_SICE(I) = 2 * KAPPAI / DE
            E_SEA(I) = - (1. - ICE_FRACT(I))*
     &                 RHOKH_SICE(I)*DQ_SEA(I)
*D SFFLUX5A.205
            H_SEA(I) = - (1. - ICE_FRACT(I))*
     &                 RHOKH_SICE(I)*CP*DTEMP_SEA(I)
*/
*D SFFLUX5A.209
! of sea-ice fraction of gridbox. Weight RHOKPM_SICE by
! ICE_FRACT for use in IMPL_CAL.
*/
*D  SFFLUX5A.212,213
             RHOKPM_SICE(I) = RHOKH_SICE(I) / ( RHOKH_SICE(I) * 
     &                  (LS * ALPHA1_SICE(I) + CP) + ASHTF_SICE(I) )
*D SFFLUX5A.216
     &                                 + Z0M_EFF_SSI(I) - Z0H_SSI(I)) )
*D  SFFLUX5A.218,223
     &          GRCP * ALPHA1_SICE(I) *
     &          (Z1(I) + Z0M_EFF_SSI(I) - Z0H_SSI(I))
            FQW_ICE = RHOKPM_SICE(I) * ( ALPHA1_SICE(I) * RAD_REDUC +
     &                (CP * RHOKH_SICE(I) + ASHTF_SICE(I)) * 
     &                DQ1(I) * ICE_FRACT(I) )
            FTL_ICE = RHOKPM_SICE(I) * ( RAD_REDUC -
     &                     ICE_FRACT(I) * LS * 
     &                     RHOKH_SICE(I) * DQ1(I) ) 
            RHOKPM_SICE(I) = ICE_FRACT(I) * RHOKPM_SICE(I)
*D ANG1F405.148   
            RHOKPM_POT_SICE(I)=RHOKPM_SICE(I)
*/
*D SFFLUX5A.226   
! Calculate the total flux over the sea+sea-ice fraction of gridbox.
*/
*D SFFLUX5A.229,230
            FTL_SSI(I) = H_SEA(I)/CP + FTL_ICE
            FQW_SSI(I) = E_SEA(I) + FQW_ICE
*D ANG1F405.149   
            EPOT_SSI(I) = E_SEA(I) + FQW_ICE
*D SFFLUX5A.236,237
      ENDDO
!***********************************************************************
! Calculate the sensible and latent heat fluxes in sea points which do
! not contain any sea-ice.
!***********************************************************************
      DO SNI=1,SEANOICE_PTS
            I=SEANOICE_INDEX(SNI)-(P1-1)
*D SFFLUX5A.239,241   
            E_SEA(I) = - RHOKH_SICE(I) * DQ_SEA(I)
            H_SEA(I) = - RHOKH_SICE(I) * CP * DTEMP_SEA(I)
            FQW_SSI(I) = E_SEA(I)
*D ANG1F405.150
            EPOT_SSI(I) = E_SEA(I)
*D ANG1F405.151
            RHOKPM_POT_SICE(I)=RHOKPM_SICE(I)
*D SFFLUX5A.242,243   
            FTL_SSI(I) =  H_SEA(I) / CP
            RHOKPM_SICE(I) = 0.0
*D SFFLUX5A.244  
            ASHTF_SICE(I) = 1.0
*D APA1F405.437
            RAD_REDUC = RADNET_SICE(I) - ICE_FRACT(I) * ASHTF_SICE(I) *
*D SFFLUX5A.249
*/
*I SFFLUX5A.252
!***********************************************************************
! Calculate the total flux over the gridbox
!***********************************************************************
      DO L = 1,LAND_PTS                                                 
        I = LAND_INDEX(L) - (P1-1)                                      
        FTL_1(I) = FLANDG(I)*FTL_LAND(L)
        FQW_1(I) = FLANDG(I)*FQW_LAND(L)
      ENDDO    
C
      DO SE=1,SEA_PTS
        I=SEA_INDEX(SE)-(P1-1)
        IF(LAND_MASK(I))THEN
          FTL_1(I) = FTL_1(I)+(1.-FLANDG(I))*FTL_SSI(I)
          FQW_1(I) = FQW_1(I)+(1.-FLANDG(I))*FQW_SSI(I)
        ELSE
          FTL_1(I) = FTL_SSI(I)
          FQW_1(I) = FQW_SSI(I)
        ENDIF
      ENDDO
C     
*/
*/.......................................................................
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*/.......................................................................
*/
*DECLARE SFRIB5A
*/
*I AJC1F405.56 
CLL
CLL            08/99   Split up bulk richardson number, wind shear and
CLL                    fields relating for temperature and humidity into
CLL                    land, open sea and sea-ice components.
CLL                                              N. Gedney
CLL                    
*/
*D SFRIB5A.33 
     & SEA_PTS,SEA_INDEX,SEANOICE_PTS,SEANOICE_INDEX,
     & SICE_PTS,SICE_INDEX,ICE_FRACT,
     & FLANDG,
*D SFRIB5A.35,37
     & CF_1,T_1,TL_1,QSL,
     & QSTAR_LAND,QSTAR_SEA,QSTAR_SICE,
     & QS1,TSTAR_LAND,TSTAR_SEA,TSTAR_SICE,Z1,
     & Z0M_EFF_LAND,Z0M_EFF_SSI,
     & Z0H_LAND,Z0H_SSI,Z0HS,Z0MSEA,
     & WIND_PROFILE_FACT_LAND,U_1_P,U_0_P,V_1_P,V_0_P,
*D SFRIB5A.39    
     & LYING_SNOW,GC,RESIST,
     & RIB_LAND,RIB_SEA,RIB_SICE,
     & PSIS,VSHR_LAND,VSHR_SSI,ALPHA1_LAND,ALPHA1_SICE,
*D ADM3F404.118,119
     & BT_1,BQ_1,BF_1,FRACA,RESFS,DQ_LAND,DQ_SEA,
     & DTEMP_SEA,L_BL_LSPICE,
*/
*D SFRIB5A.48,50
     &,SEA_INDEX(P_POINTS)      ! IN SEA_INDEX(I)=J => the Jth
!                               !    point in P_POINTS is the Ith
!                               !    sea point.
     &,SEA_PTS                  ! IN No of sea points processed.
     &,SEANOICE_PTS             ! IN Number of sea-ice free sea points.
     &,SEANOICE_INDEX(P_POINTS) ! IN Index vector for gather to sea-ice
     &,SICE_PTS                 ! IN Number of sea-ice points.
     &,SICE_INDEX(P_POINTS)     ! IN Index vector for gather to sea-ice
!                               !    free sea points.
*I SFRIB5A.57
      REAL
     & FLANDG(P_POINTS)          ! IN Fraction of land in grid box. 
*D SFRIB5A.77
     &,ICE_FRACT(P_POINTS) ! IN Fraction of sea which is sea-ice.
*/
*D SFRIB5A.90,94
     &,QSTAR_LAND(P_POINTS)! IN Surface saturated sp humidity over land.
     &,QSTAR_SEA(P_POINTS) ! IN Surface saturated sp humidity over
C                          !    open sea.
     &,QSTAR_SICE(P_POINTS)! IN Surface saturated sp humidity over
C                          !    sea ice.
*/
*D SFRIB5A.114,116
     &,TSTAR_SEA(P_POINTS)! IN Surface temperature over open sea.
     &,TSTAR_LAND(P_POINTS)
C                         ! IN Surface temperature over land.
     &,TSTAR_SICE(P_POINTS)
C                         ! IN Surface temperature over sea ice.
*/
*D SFRIB5A.135
     &,VFRAC(LAND_PTS)    ! IN Fraction of vegetation in land portion
C                         !    of gridbox.
*D SFRIB5A.136,138
     &,WIND_PROFILE_FACT_LAND(P_POINTS)     
C                         ! IN For transforming effective land surface
C                         !    transfer coefficients to those
C                         !    excluding form drag.
*/
*D SFRIB5A.139
     &,Z0H_LAND(P_POINTS) ! IN Land roughness length
C                         !    for heat and moisture (m).
     &,Z0H_SSI(P_POINTS)  ! IN Mean sea roughness length
C                         !    for heat and moisture (m).
*D SFRIB5A.142
*D SFRIB5A.145
     &,Z0M_EFF_LAND(P_POINTS)
C                         ! IN Effective roughness length for momentum
     &,Z0M_EFF_SSI(P_POINTS)
C                         ! IN Effective roughness length for momentum
*D SFRIB5A.153 ,155  
     & ALPHA1_LAND(P_POINTS)
C                         ! OUT Gradient of saturated specific humidity
C                         !     with respect to temperature between the
C                         !     bottom model layer and the land surface.
     &,ALPHA1_SICE(P_POINTS)
C                         ! OUT Gradient of saturated specific humidity
C                         !     with respect to temperature between the
C                         !     bottom model layer and sea-ice surface.
*/
*D SFRIB5A.160,164
     &,DQ_LAND(P_POINTS)  ! OUT Sp humidity difference between land
C                         !     surface and lowest atmos level (Q1 - Q*)
     &,DQ_SEA(P_POINTS)   ! OUT Sp humidity difference between open sea
C                         !     surface and lowest atmos level (Q1 - Q*)
     &,DQ_SICE(P_POINTS)  ! OUT Sp humidity difference between sea-ice
C                         !     surface and lowest atmos level (Q1 - Q*)
*D SFRIB5A.165,166
     &,DTEMP_LAND(P_POINTS)
C                         ! WORK Liquid/ice static energy difference 
C                         !     between land surface and lowest 
C                         !     atmospheric level
     &,DTEMP_SEA(P_POINTS)! OUT Liquid/ice static energy difference
C                         !     between open sea surface and lowest
C                         !     atmospheric level
     &,DTEMP_SICE(P_POINTS)
C                         ! WORK Liquid/ice static energy difference
C                         !     between sea-ice surface and lowest
C                         !     atmospheric level
*/
*D SFRIB5A.173   
*D SFRIB5A.175 
     &,FRACA(P_POINTS)    ! OUT Frac of land sfc moisture flux with
*/
*D SFRIB5A.185,186   
     &,RIB_LAND(P_POINTS) ! OUT Land bulk Richardson number
C                         !     for lowest layer.
     &,RIB_SEA(P_POINTS)  ! OUT Open sea bulk Richardson number
C                         !     for lowest layer.
     &,RIB_SICE(P_POINTS) ! OUT Sea-ice bulk Richardson number
C                         !     for lowest layer.
*/
*D SFRIB5A.190  
     &,VSHR_LAND(P_POINTS)! OUT Magnitude of land surface-to-
!                         !     lowest-level wind (m/s).
     &,VSHR_SSI(P_POINTS) ! OUT Magnitude of mean sea surface-to-
!                         !     lowest-level wind (m/s).
*I SFRIB5A.226
     &,SE          ! Loop counter (sea field index).
*I SFRIB5A.227
     &,SNI          ! Loop counter (sea, ice free field index).
*I SFRIB5A.296
      ENDDO
*/
*D SFRIB5A.299,301
CL  2. Calculate ALPHA1_* {qsat(T*,P*) -qsat(TL1,P*)}/
CL     {T*-TL1} for land and sea-ice points only -
CL     set to zero over sea only points.
CL     Set remaining fields for missing data over non-relevent points.
*/
*I SFRIB5A.303
      DO SE=1,SEA_PTS
        I = SEA_INDEX(SE)-(P1-1)
        DQ_LAND(I)=RMDI                 ! Missing data indicator
        DTEMP_LAND(I)= RMDI             ! Missing data indicator
        VSHR_LAND(I)=RMDI               ! Missing data indicator
        ALPHA1_LAND(I)=0.0
        DTEMP_SICE(I) = RMDI            ! Missing data indicator
        DQ_SICE(I) = RMDI               ! Missing data indicator
C CHN and EPDT are only required over land points:
        CHN(I)=0.0
        EPDT(I)=0.0
      ENDDO
C
      DO L=1,LAND_PTS
        I=LAND_INDEX(L)-(P1-1)
        VSHR_SSI(I)=RMDI               ! Missing data indicator
        ALPHA1_SICE(I) = 0.0
        DTEMP_SEA(I) = RMDI            ! Missing data indicator
        DQ_SEA(I) = RMDI               ! Missing data indicator
        DTEMP_SICE(I) = RMDI           ! Missing data indicator
        DQ_SICE(I) = RMDI              ! Missing data indicator
C
*/
*D SFRIB5A.304
        D_T = TSTAR_LAND(I)-TL_1(I)
*D SFRIB5A.306
          ALPHA1_LAND(I) = (QSTAR_LAND(I) - QS1(I)) / D_T
*D SFRIB5A.308
          ALPHA1_LAND(I) = (EPSILON*LC*QS1(I)*(1.0+C_VIRTUAL*QS1(I)))
*D SFRIB5A.311
          ALPHA1_LAND(I) = (EPSILON*LS*QS1(I)*(1.0+C_VIRTUAL*QS1(I)))
*D SFRIB5A.314,315
*I SFRIB5A.316
C
      DO SI=1,SICE_PTS
        I = SICE_INDEX(SI)-(P1-1)
        D_T = TSTAR_SICE(I)-TL_1(I)
        IF (D_T .GT. 0.05 .OR. D_T .LT. -0.05) THEN
          ALPHA1_SICE(I) = (QSTAR_SICE(I) - QS1(I)) / D_T
*/          ALPHA1_SICE(I) = (QSTAR(I) - QS1(I)) / D_T
        ELSE IF (TL_1(I).GT.TM) THEN           
          ALPHA1_SICE(I) = (EPSILON*LC*QS1(I)*(1.0+C_VIRTUAL*QS1(I)))
     &              / (R*TL_1(I)*TL_1(I))
        ELSE
          ALPHA1_SICE(I) = (EPSILON*LS*QS1(I)*(1.0+C_VIRTUAL*QS1(I)))
     &              / (R*TL_1(I)*TL_1(I))
        ENDIF
      ENDDO
C
      DO SNI=1,SEANOICE_PTS
        I = SEANOICE_INDEX(SNI)-(P1-1)
        ALPHA1_SICE(I) = 0.0   ! Sea only points
      ENDDO
*/
*D SFRIB5A.320,321
CL    Separate values are required for open sea, sea-ice fractions
CL    and land grid boxes.
*/
*D SFRIB5A.325,327
        DO L=1,LAND_PTS
          I=LAND_INDEX(L)-(P1-1)
          DTEMP_LAND(I) = TL_1(I) - TSTAR_LAND(I)
     &              + GRCP * ( Z1(I) + Z0M_EFF_LAND(I) - Z0H_LAND(I) )
*D SFRIB5A.329
          DQ_LAND(I) = QW_1(I) - QSTAR_LAND(I)                ! P243.119
*/
*D SFRIB5A.331,334
C Set the surface wind to zero by default:
          USHEAR = U_1_P(I)
          VSHEAR = V_1_P(I)
*/
*D SFRIB5A.336
          VSHR_LAND(I) = SQRT(VSHR2)
*I SFRIB5A.338
C
      DO SNI=1,SEANOICE_PTS
        I = SEANOICE_INDEX(SNI)-(P1-1)
          DTEMP_SEA(I) = TL_1(I) - TSTAR_SEA(I)
     &             + GRCP * ( Z1(I) + Z0M_EFF_SSI(I) - Z0H_SSI(I) )
C                                                             ! P243.118
          DQ_SEA(I) = QW_1(I) - QSTAR_SEA(I)                  ! P243.119
C
          USHEAR = U_1_P(I) - U_0_P(I)
          VSHEAR = V_1_P(I) - V_0_P(I)
          VSHR2 = MAX (1.0E-6 , USHEAR*USHEAR + VSHEAR*VSHEAR)
          VSHR_SSI(I) = SQRT(VSHR2)
C                                ... P243.120 (previous 4 lines of code)
        ENDDO
*/
*D SFRIB5A.344,347
        DO SI=1,SICE_PTS
          I = SICE_INDEX(SI)-(P1-1) 
          DTEMP_SEA(I) = TL_1(I)-TSTAR_SEA(I)
     &                   + GRCP*(Z1(I)+Z0MSEA(I)-Z0HS(I))
          DQ_SEA(I) = QW_1(I) - QSTAR_SEA(I)
C
          DTEMP_SICE(I) = TL_1(I) - TSTAR_SICE(I)
     &             + GRCP * ( Z1(I) + Z0M_EFF_SSI(I) - Z0H_SSI(I) )
C
          DQ_SICE(I) = QW_1(I) - QSTAR_SICE(I)
C
          USHEAR = U_1_P(I) - U_0_P(I)
          VSHEAR = V_1_P(I) - V_0_P(I)
          VSHR2 = MAX (1.0E-6 , USHEAR*USHEAR + VSHEAR*VSHEAR)
          VSHR_SSI(I) = SQRT(VSHR2)
*/
*D SFRIB5A.351,356
        DO SE=1,SEA_PTS
          I = SEA_INDEX(SE)-(P1-1)
          USHEAR = U_1_P(I) - U_0_P(I)
          VSHEAR = V_1_P(I) - V_0_P(I)

          VSHR2 = MAX (1.0E-6 , USHEAR*USHEAR + VSHEAR*VSHEAR)
          VSHR_SSI(I) = SQRT(VSHR2)
*D SFRIB5A.358,359
C
          DTEMP_SEA(I) = TL_1(I) - TSTAR_SEA(I)
     &             + GRCP * ( Z1(I) + Z0M_EFF_SSI(I) - Z0H_SSI(I) )
C                                                             ! P243.118
          DQ_SEA(I) = QW_1(I) - QSTAR_SEA(I)                  ! P243.119
C
          IF ( ICE_FRACT(I).GT.0.0) THEN
*/
*D SFRIB5A.361
C
            DTEMP_SICE(I) = TL_1(I) - TSTAR_SICE(I)
     &             + GRCP * ( Z1(I) + Z0M_EFF_SSI(I) - Z0H_SSI(I) )
            DQ_SICE(I) = QW_1(I) - QSTAR_SICE(I)                  ! P243.119
*D SFRIB5A.363,371
          ENDIF
C
        ENDDO
*/
        DO L=1,LAND_PTS
          I=LAND_INDEX(L)-(P1-1)
C Set the surface wind to zero by default:
          USHEAR = U_1_P(I)
          VSHEAR = V_1_P(I)

          VSHR2 = MAX (1.0E-6 , USHEAR*USHEAR + VSHEAR*VSHEAR)
          VSHR_LAND(I) = SQRT(VSHR2)
C
          DTEMP_LAND(I) = TL_1(I) - TSTAR_LAND(I)
     &            + GRCP * ( Z1(I) + Z0M_EFF_LAND(I) - Z0H_LAND(I) )
C                                                             ! P243.118
          DQ_LAND(I) = QW_1(I) - QSTAR_LAND(I)                  ! P243.119
C
        ENDDO
*/
*D SFRIB5A.386
      DO L=1,LAND_PTS
        I=LAND_INDEX(L)-(P1-1)
*/
*D SFRIB5A.392,394
        ZETAM = LOG ( (Z1(I) + Z0M_EFF_LAND(I))/Z0M_EFF_LAND(I) )
        ZETAH = LOG ( (Z1(I) + Z0M_EFF_LAND(I))/Z0H_LAND(I) )
        CHN(I) = (VKMAN/ZETAH) * (VKMAN/ZETAM) * 
     &           WIND_PROFILE_FACT_LAND(I)
*/
*D SFRIB5A.406,407
     & ROOTD,SMVCCL,SMVCWT,SMC,V_SOIL,VFRAC,CANOPY,CATCH,DQ_LAND,
     & EPDT,LYING_SNOW,GC,RESIST,VSHR_LAND,CHN,PSIS,FRACA,
*/
*D SFRIB5A.413,416
CL  7 Calculate bulk Richardson numbers for land and sea points.
*/
*D SFRIB5A.419
*D SFRIB5A.420
        DO L=1,LAND_PTS
          I=LAND_INDEX(L)-(P1-1)
*/
*D  SFRIB5A.421,423
          RIB_LAND(I) = G * Z1(I) *
     &                 ( BT_1(I)*DTEMP_LAND(I) + 
     &                 BQ_1(I)*RESFT(I)*DQ_LAND(I) ) /
     &                 ( VSHR_LAND(I)*VSHR_LAND(I) )
*D SFRIB5A.424   
*I SFRIB5A.425
C
        DO SE=1,SEA_PTS
          I = SEA_INDEX(SE)-(P1-1) 
          RIB_SEA(I) = G * Z1(I) *
     &                      ( BT_1(I) * DTEMP_SEA(I) +
     &                        BQ_1(I) * DQ_SEA(I) ) /
     &                      ( VSHR_SSI(I) * VSHR_SSI(I) ) 
        ENDDO
*/
*D SFRIB5A.427,428
CL  7.1  Calculate bulk Richardson no. for sea-ice points.
*/
*D SFRIB5A.431,436
        DO SI = 1,SICE_PTS
          I = SICE_INDEX(SI)-(P1-1)
          RIB_SICE(I) = G * Z1(I) *
     &                      ( BT_1(I) * DTEMP_SICE(I) +
     &                        BQ_1(I) * DQ_SICE(I) ) /
     &                      ( VSHR_SSI(I) * VSHR_SSI(I) ) 
*D SFRIB5A.439
*D SFRIB5A.441,456
*D SFRIB5A.458
*/       
*/.......................................................................
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*/.......................................................................
*DECLARE SFRUGH5A
*I SFRUGH5A.25
CLL  4.5     08/99    Separate land and sea roughness lengths
CLL                   and wind profile factors.
CLL                                            N. Gedney
CLL
*/
*I SFRUGH5A.29  
     & LOROG_GB,
*I SFRUGH5A.32
     & COAST_PTS,COAST_INDEX,
     & SEA_PTS,SEA_INDEX,
*D SFRUGH5A.35,36    
     & FLANDG,LYING_SNOW,Z0V,SIL_OROG,HO2R2_OROG,RIB,RIB_LAND,
     & Z0M_EFF_GB,Z0M_EFF_LAND,Z0M_EFF_SSI,
     & Z0M_GB,Z0M_LAND,Z0M_SSI,Z0H_GB,Z0H_LAND,Z0H_SSI,
     & WIND_PROFILE_FACT_LAND,WIND_PROFILE_FACT_SSI,H_BLEND,CD_SEA,
     & Z0HS,Z0F_LAND,Z0F_SSI,Z0FS,
*/
*I SFRUGH5A.50
     &,COAST_PTS           ! IN Number of coast points to be processed.
C
     &,COAST_INDEX(LAND_PTS)
C                          ! IN Index for compressed coast point array;
C                          !    i'th element holds position in the FULL
C                          !    field of the ith coast pt to be
C                          !    processed
     &,SEA_PTS             ! IN Number of sea points to be processed.
C
     &,SEA_INDEX(P_POINTS) ! IN Index for compressed sea point array;
C                          !    i'th element holds position in the FULL
C                          !    field of the ith sea pt to be
C                          !    processed
*/
*I SFRUGH5A.54    
     &,LOROG_GB            ! IN TRUE if want grid box mean
!                          !    /orography-related calculations.
*/
*D SFRUGH5A.59
     &,FLANDG(P_POINTS)     ! IN Fraction of land in grid box. 
     &,WIND_PROFILE_FACT_LAND(P_POINTS)
C                          ! For transforming effective land surface 
C                          ! transfer coefficients to those excluding
C                          ! form drag.
     &,WIND_PROFILE_FACT_SSI(P_POINTS)
C                          ! For transforming effective sea(coast)
C                          ! surface transfer coefficients to those
C                          ! excluding form drag. Set to 1.0 everywhere.
     &,ICE_FRACT(P_POINTS) ! IN Fraction of sea which is sea-ice.
*D SFRUGH5A.61
     &,RIB(P_POINTS)       ! IN Grid box mean bulk Richardson number
C                          !    for lowest layer.
     &,RIB_LAND(P_POINTS)  ! IN Land bulk Richardson number
C                          !    for lowest layer.
*D SFRUGH5A.83
     &,Z0M_EFF_GB(P_POINTS)
C                          ! OUT Effective grid box mean roughness
C                          ! length for momentum (m).
     &,Z0M_EFF_LAND(P_POINTS)
C                          ! OUT Effective roughness length for momentum
C                          ! for land points (m).
     &,Z0M_EFF_SSI(P_POINTS)
C                          ! OUT Effective roughness length for momentum
C                          ! for sea points (m).
*/
*D SFRUGH5A.76    
     & CD_SEA(P_POINTS)  ! Bulk transfer coefficient for momentum 
*/
*D SFRUGH5A.80,82
*/
*D SFRUGH5A.84
     &,Z0F(P_POINTS)       ! OUT Grid box mean roughness length
C                          !     for free-convective heat (m).
     &,Z0F_LAND(P_POINTS)  ! OUT Land roughness length
C                          !     for free-convective heat (m).
     &,Z0F_SSI(P_POINTS)   ! OUT Sea roughness length
C                          !     for free-convective heat (m).
*D SFRUGH5A.86
     &,Z0H_GB(P_POINTS)    ! OUT Grid box mean roughness length
C                          !     for heat and moisture (m).
     &,Z0H_LAND(P_POINTS)  ! OUT Land roughness length
C                          !     for heat and moisture (m).
     &,Z0H_SSI(P_POINTS)   ! OUT Sea roughness length
C                          !     for heat and moisture (m).
*D SFRUGH5A.87
     &,Z0M_GB(P_POINTS)    ! OUT Grid box mean roughness length for 
C                          ! momentum (m).
     &,Z0M_LAND(P_POINTS)  ! OUT Land roughness length for momentum (m).
     &,Z0M_SSI(P_POINTS)   ! OUT Sea roughness length for momentum (m).
*I SFRUGH5A.99
     &,SE           ! Another loop counter - this time for sea points
     &,CO           ! Another loop counter - this time for coast points
*/
*/ include blending height LB:
*I SFRUGH5A.122
C*----------------------------------------------------------------------
*CALL BLEND_H
C*----------------------------------------------------------------------
*/
*D SFRUGH5A.129
C Initialise land values over sea points and sea values over land points.
C This is required for FCDCH.
      DO SE=1,SEA_PTS
        I = SEA_INDEX(SE) - (P1-1)
        Z0M_LAND(I) = Z0MSEA(I)
        Z0H_LAND(I) = Z0HSEA
        Z0M_EFF_LAND(I) = Z0MSEA(I)
        Z0F_LAND(I) = Z0FSEA
C
        WIND_PROFILE_FACT_LAND(I) = 1.0E30
      ENDDO
C      
      DO L=1,LAND_PTS
        I=LAND_INDEX(L)-(P1-1)
        CD_SEA(I) = Z0V(I)
        Z0HS(I) = Z0V(I)
        Z0FS(I) = Z0V(I)
        Z0M_SSI(I) = Z0V(I)
        Z0H_SSI(I) = Z0V(I)
        Z0M_EFF_SSI(I) = Z0V(I)
        Z0F_SSI(I) = Z0V(I)
C
        WIND_PROFILE_FACT_SSI(I) = 1.0E30
      ENDDO
C
      DO SE=1,SEA_PTS
        I = SEA_INDEX(SE) - (P1-1)
*/
*D SFRUGH5A.133,136
        Z0M_SSI(I) = Z0MSEA(I)                                     ! P243.B5
        Z0H_SSI(I) = Z0HSEA                                        !    " 
        Z0M_EFF_SSI(I) = Z0MSEA(I)                                        
        Z0F_SSI(I) = Z0FSEA                                        !    " 
*/
*D SFRUGH5A.140   
CL        CD_SEA,CH_SEA calculations. Z0SICE for CD,CH over sea-ice.
CL        Set Z0M_EFF_SSI equal to Z0M_SSI over all sea points.
*D SFRUGH5A.142   
        CD_SEA(I) = Z0MIZ
*/
*D SFRUGH5A.145,149
        IF (ICE_FRACT(I).GT.0.0) THEN
          Z0M_SSI(I) = Z0SICE                                      ! P243.B4
          Z0H_SSI(I) = Z0SICE                                      !    "
          Z0M_EFF_SSI(I) = Z0SICE                                        
          Z0F_SSI(I) = Z0SICE                                      !    "
*I SFRUGH5A.150
        Z0M_EFF_GB(I) = Z0M_EFF_SSI(I) 
        Z0M_GB(I) = Z0M_SSI(I)
*/
*D SFRUGH5A.152   
CL  1.2a Specify blending height for sea points. Set to minimum value
*/
*D SFRUGH5A.155,156
CL         Also set the sea wind profile factor to the default value
CL         of 1.0 for all sea points.
*/
*D SFRUGH5A.160
        WIND_PROFILE_FACT_SSI(I) = 1.0
*/
*D SFRUGH5A.166   
CL  1.3 Land.
CL      Specify blending height for sea points. Set to minimum value.
CL      Reduce roughness if there is any snow lying.
*/
*I SFRUGH5A.175
        H_BLEND(I) = H_BLEND_MIN
        WIND_PROFILE_FACT_LAND(I) = 1.0
C
*/
*D SFRUGH5A.183,185
          Z0M_LAND(I) = MAX( ZETA1 , Z0 )
          Z0H_LAND(I) = MIN( Z0V(I) , Z0M_LAND(I) )
          Z0F_LAND(I) = Z0H_LAND(I)
*D SFRUGH5A.187,189
          Z0M_LAND(I) = Z0V(I)    ! P243.B1, based on P243.B2 (2nd case)
          Z0H_LAND(I) = Z0V(I)    !    "   ,   "    "    "    ( "    " )
          Z0F_LAND(I) = Z0V(I)    !    "   ,   "    "    "    ( "    " )
*/
*D SFRUGH5A.193
CL  1.4 Orographic roughness. Calculate Z0M_EFF_LAND in neutral case.
*/
*D SFRUGH5A.202  
          ZETA2 = LOG ( 1.0 + Z1(I)/Z0M_LAND(I) )
*D SFRUGH5A.215
             RIB_FN =  ( 1.0 - RIB_LAND(I) / RI_CRIT )
*D SFRUGH5A.222,224 
          Z0M_EFF_LAND(I) = H_BLEND(I) / EXP ( VKMAN / SQRT ( ZETA1 +
     &                 (VKMAN / LOG ( H_BLEND(I) / Z0M_LAND(I) ) ) *
     &                 (VKMAN / LOG ( H_BLEND(I) / Z0M_LAND(I) ) ) ) )
*D SFRUGH5A.227
          IF (RIB_LAND(I).GT.RI_CRIT) Z0M_EFF_LAND(I)=Z0M_LAND(I)
*D SFRUGH5A.229,230
          WIND_PROFILE_FACT_LAND(I) = 
     &                              LOG ( H_BLEND(I) / Z0M_EFF_LAND(I) )
     &                              / LOG ( H_BLEND(I) / Z0M_LAND(I) )
*D SFRUGH5A.237
          Z0M_EFF_LAND(I) = Z0M_LAND(I)
*/
*I SFRUGH5A.246 
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
CL  1.5 Calculate grid box mean roughness lengths in non-neutral case.
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      IF(LOROG_GB)THEN
        DO L = 1,LAND_PTS
          I = LAND_INDEX(L) - (P1-1)
C
C Calculate grid box mean momentum roughness length:
*/ ***This reduces bit comparison:
          Z0=FLANDG(I)/( LOG(LB/Z0M_LAND(I))**2 )
     &     +(1.-FLANDG(I))/( LOG(LB/Z0M_SSI(I))**2 )
          Z0M_GB(I)=LB*EXP(-SQRT(1./Z0) )
C
C Calculate grid box mean heat roughness length:
          Z0=FLANDG(I)/( LOG(LB/Z0H_LAND(I))**2 )
     &     +(1.-FLANDG(I))/( LOG(LB/Z0H_SSI(I))**2 )
          Z0H_GB(I)=LB*EXP(-SQRT(1./Z0) )
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
CL  1.6 Orographic roughness. Calculate Z0M_EFF_LAND in non-neutral case
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          IF (L_Z0_OROG) THEN
C
C           ! Set blending height, grid box mean effective 
C           ! roughness length at land points.
C
            ZETA1 = 0.5 * OROG_DRAG_PARAM * SIL_OROG(L)
            ZETA2 = LOG ( 1.0 + Z1(I)/Z0M_GB(I) )
            ZETA3 = 1.0 / SQRT (ZETA1/(VKMAN*VKMAN)+1.0/(ZETA2*ZETA2) )
            ZETA2 = 1.0 / EXP(ZETA3)
            H_BLEND(I) = MAX ( Z1(I) / (1.0 - ZETA2) ,
     &                         HO2R2_OROG(L) * SQRT(2.0) )
            H_BLEND(I) = MIN ( H_BLEND_MAX, H_BLEND(I) )


! Apply simple stability correction to form drag if RIB is stable

            IF (SIL_OROG(L) .EQ. RMDI) THEN
               ZETA1 = 0.0
            ELSE
               RIB_FN =  ( 1.0 - RIB(I) / RI_CRIT )
               IF (RIB_FN.GT.1.0) RIB_FN = 1.0
               IF (RIB_FN.LT.0.0) RIB_FN = 0.0
               ZETA1 = 0.5 * OROG_DRAG_PARAM * SIL_OROG(L) * RIB_FN
            ENDIF

            Z0M_EFF_GB(I) = H_BLEND(I) / EXP ( VKMAN / SQRT ( ZETA1 +
     &                   (VKMAN / LOG ( H_BLEND(I) / Z0M_GB(I) ) ) *
     &                   (VKMAN / LOG ( H_BLEND(I) / Z0M_GB(I) ) ) ) )

            IF (RIB(I).GT.RI_CRIT) Z0M_EFF_GB(I)=Z0M_GB(I)

          ELSE ! Orographic roughness not represented so
C              ! leave blending height and wind profile factor at their
C              ! default values and set effective roughness length to
C              ! its grid box mean value roughness length.
C
            Z0M_EFF_GB(I) = Z0M_GB(I)
          ENDIF
        ENDDO
      ENDIF
C
*/
*/.......................................................................
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*/.......................................................................
*/
*/ comment out C_ROUGH lines - these changes clashed with
*/  "params_in_namelist.mod" so these changes are now made in there.
*/ CDJ - 3/9/02
*/
*/*DECLARE C_ROUGH
*/*D C_ROUGH.11
*/C Need to initialise the momentum roughness length over sea
*/C since this is no longer done in RPANCA1A.
*/      REAL Z0FSEA,Z0MSEA_VAL,Z0HSEA,Z0MIZ,Z0SICE
*/*I C_ROUGH.13
*/     &          Z0MSEA_VAL = 10.0E-4,
*/.......................................................................
*/-----------------------------------------------------------------------
*ID CTILE6
*/---------------------------------------------------------------------------
*/---------------------------------------------------------------------------
*/ Set up separate land and sea surface temperatures in the reconfiguration
*/
*/---------------------------------------------------------------------------
*/---------------------------------------------------------------------------
*/.......................................................................
*/-----------------------------------------------------------------------
*DECLARE CONTROL1
*/
*I UDG7F405.11    
!            08/99  Allow for land and sea to co-exist in the same
!                   gridbox. This requires the land and sea temperatures
!                   and roughness lengths to be split into separate
!                   components. Land, mean sea and sea-ice surface
!                   temperaturesare read in from the input dump if they
!                   are availableand horizontal interpolation is not to
!                   be carried out. Otherwise they are initialised with
!                   the gridbox mean TSTAR.
!                   The restriction that the leads temperature is set to
!                   TFS is removed by setting LTLEADS to TRUE.
!                   This results in the need for a prognostic
!                   sea-ice temperature.
!                   Rougness length has been split into land and sea
!                   components.
!                                                             N. Gedney
*/
*I CONTROL1.353
     &     ,TSTAR_LAND(P_FIELD_OUT) ! Land surface temperature
     &     ,TSTAR_SEA(P_FIELD_OUT)  ! Open sea surface temperature
     &     ,TSTAR_SICE(P_FIELD_OUT) ! Sea-ice surface temperature
     &     ,TSTAR_SSI(P_FIELD_OUT)  ! Mean sea surface temperature
*/
*I UDG1F304.21
     &,LTSTAR_LAND      ! Switch for TSTAR_LAND.
C                       ! .TRUE. if initialised from input dump,
C                       ! otherwise set to gridbox mean TSTAR.
     &,LTSTAR_SICE      ! Switch for TSTAR_SICE.
C                       ! .TRUE. if initialised from input dump,
C                       ! otherwise set to gridbox mean TSRAT.
     &,LTSTAR_SEA       ! Switch for TSTAR_SEA.
C                       ! .TRUE. if initialised from input dump,
C                       ! otherwise set to gridbox mean TSRAT.
*/
*I CONTROL1.307 
     &,LAND0P5(P_FIELD_OUT)       ! LAND MASK (TRUE if land frac>0.5)
*/
*I CONTROL1.1034
C Tstar for land, if not directly available set from old Tstar 
C i.e. land/sea

      LTSTAR_LAND =.TRUE.
      IF(.NOT.HORIZ)THEN
        CALL LOCATE(406,PP_ITEMC_IN,N_TYPES_IN,POS)
        IF(POS.EQ.0)THEN
          WRITE(6,'('' *Warning*  Land Tstar not in input file:'')')
          WRITE(6,'(''            trying Tstar instead'')')
          LTSTAR_LAND =.FALSE.
C
        ELSE
          CALL READFLDS(NFTIN,1,PP_POS_IN(POS),LOOKUP_IN,LEN1_LOOKUP_IN,
     &                  D1_IN,P_FIELD_IN,FIXHD_IN,
*CALL ARGPPX
     &                  ICODE,CMESSAGE)
          IF(ICODE.EQ.1501)THEN 
            IF(LPOLARCHK)THEN
              write(6,*) 'Averaging polar rows to make them constant'
C
!   North polar row
              RP_ROW_SUM=0
              DO I=1,ROW_LENGTH_IN
                RP_ROW_SUM=RP_ROW_SUM+D1_IN(I)
              END DO
              DO I=1,ROW_LENGTH_IN
                D1_IN(I)=RP_ROW_SUM/ROW_LENGTH_IN
              END DO 
!   South polar row
              RP_ROW_SUM=0
              DO I=1,ROW_LENGTH_IN
                RP_ROW_SUM=
     &            RP_ROW_SUM+D1_IN((P_ROWS_IN-1)*ROW_LENGTH_IN+I)
              END DO 
              DO I=1,ROW_LENGTH_IN
                D1_IN((P_ROWS_IN-1)*ROW_LENGTH_IN+I)=
     &          RP_ROW_SUM/ROW_LENGTH_IN
              END DO
            END IF
          ELSE IF(ICODE.NE.0)THEN 
            CALL ABORT_IO('CONTROL',CMESSAGE,ICODE,NFTIN)
          END IF
          DO I=1,P_FIELD_OUT
            TSTAR_LAND(I)=D1_IN(I)
          ENDDO
        ENDIF
      ELSE
        WRITE(6,'('' *Warning*  Land Tstar MAY be in input:'')')
        WRITE(6,'(''  file but using Tstar instead because'')')
        WRITE(6,'(''  horizontal interpolation is switched on.'')')
        LTSTAR_LAND =.FALSE.
      ENDIF
C
C Tstar for open sea, if not directly available set from old Tstar
C i.e. land/sea

      LTSTAR_SEA =.TRUE.
      IF(.NOT.HORIZ)THEN
        CALL LOCATE(407,PP_ITEMC_IN,N_TYPES_IN,POS)
        IF(POS.EQ.0)THEN
          WRITE(6,'('' *Warning*  Open sea Tstar not in input file:'')')
          WRITE(6,'(''            trying Tstar instead'')')
          LTSTAR_SEA =.FALSE.
C
        ELSE
          CALL READFLDS(NFTIN,1,PP_POS_IN(POS),LOOKUP_IN,LEN1_LOOKUP_IN,
     &                  D1_IN,P_FIELD_IN,FIXHD_IN,
*CALL ARGPPX
     &                  ICODE,CMESSAGE)
          IF(ICODE.EQ.1501)THEN 
            IF(LPOLARCHK)THEN
              write(6,*) 'Averaging polar rows to make them constant'
C
!   North polar row
              RP_ROW_SUM=0
              DO I=1,ROW_LENGTH_IN
                RP_ROW_SUM=RP_ROW_SUM+D1_IN(I)
              END DO
              DO I=1,ROW_LENGTH_IN
                D1_IN(I)=RP_ROW_SUM/ROW_LENGTH_IN
              END DO 
!   South polar row
              RP_ROW_SUM=0
              DO I=1,ROW_LENGTH_IN
                RP_ROW_SUM=
     &            RP_ROW_SUM+D1_IN((P_ROWS_IN-1)*ROW_LENGTH_IN+I)
              END DO 
              DO I=1,ROW_LENGTH_IN
                D1_IN((P_ROWS_IN-1)*ROW_LENGTH_IN+I)=
     &          RP_ROW_SUM/ROW_LENGTH_IN
              END DO
            END IF
          ELSE IF(ICODE.NE.0)THEN 
            CALL ABORT_IO('CONTROL',CMESSAGE,ICODE,NFTIN)
          END IF
          DO I=1,P_FIELD_OUT
            TSTAR_SEA(I)=D1_IN(I)
          ENDDO
        ENDIF
      ELSE
        WRITE(6,'('' *Warning*  Mean sea Tstar MAY be in input:'')')
        WRITE(6,'(''  file but using Tstar instead because'')')
        WRITE(6,'(''  horizontal interpolation is switched on.'')')
        LTSTAR_SEA =.FALSE.
      ENDIF
*/
C
C Tstar for sea-ice, if not directly available set from old Tstar
C i.e. land/sea

      LTSTAR_SICE =.TRUE.
      IF(.NOT.HORIZ)THEN
        CALL LOCATE(408,PP_ITEMC_IN,N_TYPES_IN,POS)
        IF(POS.EQ.0)THEN
          WRITE(6,'('' *Warning*  Sea-ice Tstar not in input file:'')')
          WRITE(6,'(''            trying Tstar instead'')')
          LTSTAR_SICE =.FALSE.
C
        ELSE
          CALL READFLDS(NFTIN,1,PP_POS_IN(POS),LOOKUP_IN,LEN1_LOOKUP_IN,
     &                  D1_IN,P_FIELD_IN,FIXHD_IN,
*CALL ARGPPX
     &                  ICODE,CMESSAGE)
          IF(ICODE.EQ.1501)THEN 
            IF(LPOLARCHK)THEN
              write(6,*) 'Averaging polar rows to make them constant'
C
!   North polar row
              RP_ROW_SUM=0
              DO I=1,ROW_LENGTH_IN
                RP_ROW_SUM=RP_ROW_SUM+D1_IN(I)
              END DO
              DO I=1,ROW_LENGTH_IN
                D1_IN(I)=RP_ROW_SUM/ROW_LENGTH_IN
              END DO 
!   South polar row
              RP_ROW_SUM=0
              DO I=1,ROW_LENGTH_IN
                RP_ROW_SUM=
     &            RP_ROW_SUM+D1_IN((P_ROWS_IN-1)*ROW_LENGTH_IN+I)
              END DO 
              DO I=1,ROW_LENGTH_IN
                D1_IN((P_ROWS_IN-1)*ROW_LENGTH_IN+I)=
     &            RP_ROW_SUM/ROW_LENGTH_IN
              END DO
            END IF
          ELSE IF(ICODE.NE.0)THEN 
            CALL ABORT_IO('CONTROL',CMESSAGE,ICODE,NFTIN)
          END IF
          DO I=1,P_FIELD_OUT
            TSTAR_SICE(I)=D1_IN(I)
          ENDDO
        ENDIF
      ELSE
        WRITE(6,'('' *Warning*  Sea-ice Tstar MAY be in input '')')
        WRITE(6,'(''  file but using Tstar instead because'')')
        WRITE(6,'(''  horizontal interpolation is switched on.'')')
        LTSTAR_SICE =.FALSE.
      ENDIF
*/
*I UDG2F400.27
C
      IF(.NOT.LTSTAR_LAND)THEN
        DO I=1,P_FIELD_OUT
          TSTAR_LAND(I)=TSTAR(I)
        END DO
      ENDIF
C
      IF(.NOT.LTSTAR_SEA)THEN
        DO I=1,P_FIELD_OUT
          TSTAR_SEA(I)=TSTAR(I)
        END DO
      ENDIF
C
      IF(.NOT.LTSTAR_SICE)THEN
        DO I=1,P_FIELD_OUT
          TSTAR_SICE(I)=TSTAR(I)
       END DO
      ENDIF
*/
*/.......................................................................
*/-----------------------------------------------------------------------
*/
*/ call rplanca
*/
*I GDG0F401.282
     &              LAND_POINTS_OUT,
*D GRS2F404.231 
     &              LAND0P5,ICE_FRAC,
     &              TSTAR,TSTAR_LAND,TSTAR_SEA,
     &              TSTAR_SICE,TSTAR_SSI,
     &              TSTAR_ANOM,
     &              LTSTAR_SICE,
*/
*/.......................................................................
*/-----------------------------------------------------------------------
*D CONTROL1.1152 
*D GDG0F401.299,302
*D CONTROL1.1155
C
      CALL LOCATE(24,PP_ITEMC_OUT,N_TYPES_OUT,POS)
      CALL WRITFLDS(NFTOUT,1,PP_POS_OUT(POS),LOOKUP_OUT,LEN1_LOOKUP_OUT,
     &              TSTAR,P_FIELD_OUT,FIXHD_OUT,
*CALL ARGPPX
     &              ICODE,CMESSAGE)
      IF(ICODE.NE.0)CALL ABORT_IO('CONTROL',CMESSAGE,ICODE,NFTOUT)
C
C  
      WRITE(6,*)'WRITING LAND TSTAR TO START DUMP'
      CALL LOCATE(406,PP_ITEMC_OUT,N_TYPES_OUT,POS)
      CALL WRITFLDS(NFTOUT,1,PP_POS_OUT(POS),LOOKUP_OUT,LEN1_LOOKUP_OUT,
     &              TSTAR_LAND,P_FIELD_OUT,FIXHD_OUT,
*CALL ARGPPX 
     &              ICODE,CMESSAGE)
      IF(ICODE.NE.0)CALL ABORT_IO('CONTROL',CMESSAGE,ICODE,NFTOUT)
C
C
      WRITE(6,*)'WRITING OPEN SEA TSTAR TO START DUMP'
      CALL LOCATE(407,PP_ITEMC_OUT,N_TYPES_OUT,POS)
      CALL WRITFLDS(NFTOUT,1,PP_POS_OUT(POS),LOOKUP_OUT,LEN1_LOOKUP_OUT,
     &              TSTAR_SEA,P_FIELD_OUT,FIXHD_OUT,
*CALL ARGPPX 
     &              ICODE,CMESSAGE)
      IF(ICODE.NE.0)CALL ABORT_IO('CONTROL',CMESSAGE,ICODE,NFTOUT)
C
C
      WRITE(6,*)'WRITING SEA-ICE TSTAR TO START DUMP'
      CALL LOCATE(408,PP_ITEMC_OUT,N_TYPES_OUT,POS)
      CALL WRITFLDS(NFTOUT,1,PP_POS_OUT(POS),LOOKUP_OUT,LEN1_LOOKUP_OUT,
     &              TSTAR_SICE,P_FIELD_OUT,FIXHD_OUT,
*CALL ARGPPX 
     &              ICODE,CMESSAGE)
      IF(ICODE.NE.0)CALL ABORT_IO('CONTROL',CMESSAGE,ICODE,NFTOUT)
C
C
      WRITE(6,*)'WRITING MEAN SEA TSTAR TO START DUMP'
      CALL LOCATE(409,PP_ITEMC_OUT,N_TYPES_OUT,POS)
      CALL WRITFLDS(NFTOUT,1,PP_POS_OUT(POS),LOOKUP_OUT,LEN1_LOOKUP_OUT,
     &              TSTAR_SSI,P_FIELD_OUT,FIXHD_OUT,
*CALL ARGPPX 
     &              ICODE,CMESSAGE)
      IF(ICODE.NE.0)CALL ABORT_IO('CONTROL',CMESSAGE,ICODE,NFTOUT)
C
C
      WRITE(6,*)'WRITTEN LAND, SEA AND GB MEAN TSTARS TO START DUMP'
C
C
      WRITE(6,*)'WRITING 2nd LAND MASK TO START DUMP'
      CALL LOCATE(410,PP_ITEMC_OUT,N_TYPES_OUT,POS)
      CALL WRITFLDS(NFTOUT,1,PP_POS_OUT(POS),LOOKUP_OUT,LEN1_LOOKUP_OUT,
     &              LAND0P5,P_FIELD_OUT,FIXHD_OUT,
*CALL ARGPPX 
     &              ICODE,CMESSAGE)
      IF(ICODE.NE.0)CALL ABORT_IO('CONTROL',CMESSAGE,ICODE,NFTOUT)
C
      WRITE(6,*)'WRITTEN 2nd LAND MASK TO START DUMP'
C
*/
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*/ New prognostics added, which may or may not be read in from initial
*/ dump.
*/
*I CONTROL1.1416  
     &.OR.PP_ITEMC_OUT(J).EQ.406.OR.PP_ITEMC_OUT(J).EQ.407
     &.OR.PP_ITEMC_OUT(J).EQ.408.OR.PP_ITEMC_OUT(J).EQ.409
     &.OR.PP_ITEMC_OUT(J).EQ.410
*/
*/-----------------------------------------------------------------------
*/ This concerns the setting up of TFS. Cannot assume that leads
*/ temperature is TFS if LTLEADS is TRUE.
*/
*D CONTROL1.1616
C CANNOT Calculate sea-ice fraction from TSTAR < TFS if LTLEADS is TRUE
*I CONTROL1.1619 
          IF(LTLEADS)THEN
            WRITE(6,'('' *ERROR* 1 HAVE LET LEADS TEMPERATURE VARY'')')
            CALL ABORT
          ENDIF
*/
*D CONTROL1.1624  
C CANNOT Calculate sea-ice thickness from TSTAR < TFS if LTLEADS is TRUE
*I CONTROL1.1632
          IF(LTLEADS)THEN
            WRITE(6,'('' *ERROR* 1 HAVE LET LEADS TEMPERATURE VARY'')')
            CALL ABORT
          ENDIF
*/
*I CONTROL1.1639
          IF(LTLEADS)THEN
            WRITE(6,'('' *ERROR* 2 HAVE LET LEADS TEMPERATURE VARY'')')
            CALL ABORT
          ENDIF
*/
*I CONTROL1.1647
          IF(LTLEADS)THEN
           WRITE(6,'('' *ERROR* 3 HAVE LET LEADS TEMPERATURE VARY'')')
           CALL ABORT
          ENDIF
*/
*I CONTROL1.1652
          IF(LTLEADS)THEN
            WRITE(6,'('' *ERROR* 4 HAVE LET LEADS TEMPERATURE VARY'')')
            CALL ABORT
          ENDIF
*/
*D UDR1F400.102   
          IF(LTLEADS)THEN
!           CANNOT Derive Slab Temperature from T* and Ice Fraction
            WRITE(6,'('' *ERROR* 5 HAVE LET LEADS TEMPERATURE VARY'')')
            CALL ABORT
          ENDIF
*D UDR1F400.105 
                D1_TEMP(I) = TSTAR_SSI(I)-273.15
*/
*/........................................................................
*/
*/ Now read in sea or land T* for initialisation:
*D UDR1F400.33
            CALL LOCATE (408,PP_ITEMC_OUT,N_TYPES_OUT,POS)
*D UDR1F400.37
              WRITE (6,*) 'Sea T* not found in output dump.' 
*/ Initialise sea ice temperature:
*D UDR1F400.43
     &        LEN1_LOOKUP_OUT,TSTAR_SICE,P_FIELD_OUT,FIXHD_OUT,
*D UDR1F400.51
     &        LEN1_LOOKUP_OUT,TSTAR_SICE,P_FIELD_OUT,FIXHD_OUT,
*/
*D UDR1F400.66,67
!           Get Sea T* field from output dump
            CALL LOCATE (409,PP_ITEMC_OUT,N_TYPES_OUT,POS)
*D UDR1F400.71
              WRITE (6,*) 'Sea T* not found in output dump.'
*D UDR1F400.76
     &        LEN1_LOOKUP_OUT,TSTAR_SSI,P_FIELD_OUT,FIXHD_OUT,
*/
*/ Land surface:
*D GDR7F404.396,397
!           Find land surface temperature in output dump
            CALL LOCATE (406,PP_ITEMC_OUT,N_TYPES_OUT,POS)
*D GDR7F404.399
              WRITE (6,*) ' Land Surf Temperature not in output dump.'
*/
*I GDR7F404.61
!         Sea roughness Length
     &    .or. (PP_ITEMC_OUT(J).eq.412 .and. MODEL.eq. ATMOS_IM )
*/
*I GDR7F404.115  
C
          ELSEIF (PP_ITEMC_OUT(J).EQ.412.AND.  !  Initialise SEA 
!                                              !  roughness
     &      MODEL.EQ.ATMOS_IM .AND.
     &      PP_SOURCE_OUT(J).EQ.8) THEN   !  if not in dump

!           S=8 is not set in the UMUI for this field. It is set in
!           loop 1400 if no field is found in the input dump.

            WRITE (6,*) ' '
            WRITE (6,*) ' No Sea roughness in input dump'
            WRITE (6,*) ' Sea roughness being initialised to 10E-4'
C
              DO I=1,P_FIELD_OUT
                D1_TEMP(I) = 10.E-4
              ENDDO
C
              CALL LOCATE (412,PP_ITEMC_OUT,N_TYPES_OUT,POS)
              CALL WRITFLDS (NFTOUT,1,PP_POS_OUT(POS),LOOKUP_OUT,
     &        LEN1_LOOKUP_OUT,D1_TEMP,P_FIELD_OUT,FIXHD_OUT,
*CALL ARGPPX
     &        ICODE,CMESSAGE)
              IF (ICODE.GT.0) THEN 
                WRITE (6,*) ' Problem with writing sea Z0 field'
                CALL ABORT_IO ('CONTROL',CMESSAGE,ICODE,NFTOUT)
              ENDIF
              WRITE (6,*) ' SEA ROUGHNESS (Stash Code 412) has ',
     &        'been initialised.'
C
*/.......................................................................
*/-----------------------------------------------------------------------
*/.......................................................................
*DECLARE UPANCIL1
*/
*D GHM2F405.11  
!LL          09/99  Pass new variables related to land fraction
!LL                 and surface temperatures to REPLANCA.   N. Gedney
*/
*I UPANCIL1.34
      INTEGER I
*/
*/ call RPANCA1A
*D GDG0F401.1492
     &                STEPim(I_AO),A_STEPS_PER_HR,D1(JUSER_ANC1),
*I GDG0F401.1493
     &                LAND_FIELD,
*D GDG0F401.1494
     &                D1(JLAND0P5),D1(JICE_FRACTION),
     &                D1(JTSTAR),D1(JTSTAR_LAND),D1(JTSTAR_SEA),
     &                D1(JTSTAR_SICE),D1(JTSTAR_SSI),
*/
*/.......................................................................
*/-----------------------------------------------------------------------
*/.......................................................................
*/
*DECLARE RPANCA1A
*I GDR1F405.2     
!LL           08/99   Allow for land and sea to coexist on same gridbox.
!LL                   Requires TSTAR to be split into land, sea
!LL                   and sea-ice fields. Leads temperature is no longer
!LL                   fixed to TFS, which results in us requiring a
!LL                   prognostic sea-ice surface temperature.
*/
*D GDG0F401.1361
     &                     A_STEP,STEPS_PER_HR,FLAND,
*I GDG0F401.1362
     &                     LAND_FIELD,
*D GDG0F401.1363
     &                     LAND0P5,ICE_FRACTION,
     &                     TSTAR,TSTAR_LAND,TSTAR_SEA,
     &                     TSTAR_SICE,TSTAR_SSI,
     &                     TSTAR_ANOM,
*IF DEF,RECON
     &                     LTSTAR_SICE,
*ENDIF
*/
*D RPANCA1A.83
     &       A_STEP,STEPS_PER_HR,
*I RPANCA1A.85                            
     &       LAND_FIELD,
*D RPANCA1A.111,112
     &       ICE_FRACTION(P_FIELD), !INOUT  Ice frac of sea part of grid
C                                   !       box, updated if requested
     &       FLAND(LAND_FIELD),     !IN  Fractional land.
     &       FLAND_G(P_FIELD),      !WORK Frac land over all points.
*D RPANCA1A.113
     &       TSTAR(P_FIELD),     !INOUT  TSTAR:updated if requested
     &       TSTAR_LAND(P_FIELD),!INOUT  as above, but for land.
     &       TSTAR_SEA(P_FIELD), !INOUT  as above, but for open sea.
     &       TSTAR_SICE(P_FIELD),!INOUT  as above, but for sea-ice.
     &       TSTAR_SSI(P_FIELD), !INOUT  as above, but for sea.
*I UDG4F402.255
     &       L,                     ! Land index
*D RPANCA1A.120
     &       LAND(P_FIELD),      ! WORK LAND mask
     &       LAND0P5(P_FIELD),   ! OUT LAND mask (TRUE if land 
!                                !   fraction>0.5)
     &       SEA(P_FIELD),       ! WORK SEA mask
     &       LTSTAR_SICE         ! IN TRUE if TSTAR_SICE has been read 
C                                ! in from input dump.
C                                ! If FALSE set to TSTAR_SEA.
*/
*I RPANCA1A.132   
*CALL CNTLATM
*/
*I RPANCA1A.332  
C Read in fractional land field first (in the first user ancillary):
C use ANCIL1 as temporary storage
*IF DEF,RECON
        FILE=FILEANCIL(48)
        NFTIN=FTNANCIL(FILE)
        WRITE(6,*)'READING IN LAND FRACTION'
        CALL READFLDS(NFTIN,1,NLOOKUP(48),LOOKUP(1,LOOKUP_START(FILE)),
     &                LEN1_LOOKUP,ANCIL1,P_FIELD,FIXHD(1,FILE),
*CALL ARGPPX
     &                      ICODE,CMESSAGE)
        WRITE(6,*)'READ IN LAND FRACTION'

      DO I=1,P_FIELD
        FLAND_G(I)=0.0
        IF(LAND(I))FLAND_G(I)=ANCIL1(I)
*/
C If land or sea fraction is less than machine tolerance print warning
        IF(LAND(I).AND.FLAND_G(I).LE.1.42E-14)THEN
          WRITE(6,*)'*****************WARNING********************'
          WRITE(6,*)'LAND FRACTION IS LESS THAN MACHINE TOLERANCE'
        ENDIF
        IF(.NOT.LAND(I).AND.1.0-FLAND_G(I).LE.1.42E-14)THEN
          WRITE(6,*)'*****************WARNING********************'
          WRITE(6,*)'SEA FRACTION IS LESS THAN MACHINE TOLERANCE'
        ENDIF
C
*/
        IF(FLAND_G(I).LE.0.0.AND.LAND(I))THEN
          WRITE(6,*)'*ERROR* a) LAND FRACT & LAND MASK ARE INCONSISTENT'
          CALL ABORT
        ENDIF
        IF(FLAND_G(I).GT.0.0.AND..NOT.LAND(I))THEN
          WRITE(6,*)'*ERROR* b) LAND FRACT & LAND MASK ARE INCONSISTENT'
          CALL ABORT
        ENDIF
        SEA(I)=.FALSE.
        IF(FLAND_G(I).LT.1.0)SEA(I)=.TRUE.
        LAND0P5(I)=.FALSE.
        IF(FLAND_G(I).GT.0.5)LAND0P5(I)=.TRUE.

      ENDDO
*/
*/
*ELSE
C Set up global fractional land field
         L=0
         DO I=1,P_FIELD
           FLAND_G(I)=0.0
           IF(LAND(I))THEN
             L=L+1
             FLAND_G(I)=FLAND(L)
          ENDIF
         ENDDO
C
         DO I=1,P_FIELD
           SEA(I)=.FALSE.
           IF(FLAND_G(I).LT.1.0)SEA(I)=.TRUE.
         ENDDO
C
*ENDIF
C
*/
*D GRS2F404.52 
            IF(SEA(I)) THEN 
*/
*D GRS2F404.164,168
! For AMIP II strictly ice concentrations should range between
! 0.0 and 1.0 but because of assumptions on T* made by the boundary
! layer and radiation schemes ice concentrations are restricted to
! 0.3 to 1.0. This is because ORIGINALLY the SSTs in areas of less
! than 30% ice were to be used rather than TFS=-1.8C.
*/
*/
*I GRS2F404.180 
            IF(.NOT.LTLEADS)THEN
*I GRS2F404.183
            ENDIF
*/
*I GRS2F404.186
            IF(.NOT.LTLEADS)THEN
*I RPANCA1A.968
            ELSE
            CALL T_INT (ANCIL1,TIME1,ANCIL2,TIME2,ANCIL_DATA,
     &              TIME,P_FIELD)
            ENDIF
*/
*D GRS2F404.192,196
! For AMIP II strictly ice concentrations should range between
! 0.0 and 1.0 but because of assumptions on T* made by the boundary
! layer and radiation schemes ice concentrations are restricted to
! 0.3 to 1.0. This will allow SSTs in areas of less than 30% ice to
! be used rather than TFS=-1.8C when LTLEADS=FALSE.
*/
*D GRS2F404.209
            IF (.NOT.LTLEADS.AND.ANCIL_DATA(I).LT.TFS) ANCIL_DATA(I)=TFS
*/
*D RPANCA1A.1022  
*/***TEMPORARY:  Set value of Z0 over non-land points to 0.1, for testing
*D RPANCA1A.1025,1026
            IF(SEA(I).AND.FIELD.EQ.26) THEN
              D1(D1_ANCILADD(FIELD)+I-1+(LEVEL-1)*P_FIELD)=0.1
*/
*D RPANCA1A.1031
            IF (LAND(I)) THEN
*D RPANCA1A.1039
              IF (LAND(I).AND.ANCIL_DATA(I).GT.0.0) THEN
*/
*D RPANCA1A.1040  
                IF(TSTAR_LAND(I).GT.TM) TSTAR_LAND(I)=TM
*D RPANCA1A.1051
              IF(LAND(I)) THEN
*D RPANCA1A.1053,1054
                IF(TSTAR_LAND(I).GT.TM.AND.ANCIL_DATA(I).GT.0.0) THEN
                  TSTAR_LAND(I)=TM
*/
*D RPANCA1A.1074
            IF (SEA(I)) THEN
*/
*/
*D RPANCA1A.1079
*D GRS2F404.211,212
*/
*D RPANCA1A.1081,1085  
*/
*/
*D RPANCA1A.1101,1111
            IF (SEA(I)) THEN
              IF (L_SSTANOM) THEN
*IF -DEF,RECON
                TSTAR_SEA(I)=ANCIL_DATA(I)+TSTAR_ANOM(I)
*ELSE
                TSTAR_ANOM(I)=TSTAR_SEA(I)-ANCIL_DATA(I)
*ENDIF
              ELSE
                TSTAR_SEA(I)=ANCIL_DATA(I)
              END IF 
            IF (ICE_FRACTION(I).EQ.0.0) TSTAR_SSI(I)=TSTAR_SEA(I)
            END IF
*/
*D GJT1F304.121
            IF (SEA(I)) THEN
*D TJ240293.40
              D1(D1_ANCILADD(FIELD)+I-1)=TSTAR_LAND(I)

*D RPANCA1A.1121
            IF(SEA(I)) THEN
*D RPANCA1A.1130
            IF(SEA(I)) THEN
*D RPANCA1A.1141
            IF(SEA(I)) THEN
*/
*I RPANCA1A.1161
          DO I=1,P_FIELD

C TEMPORARY BUG FIX:
            IF(SEA(I).AND.TSTAR_SEA(I).LT.1.E-5)THEN
              WRITE(6,*)'****WARNING***TEMP BUG FIX**MUST BE REMOVED***'
              TSTAR_SEA(I)=300.0
              TSTAR_SSI(I)=TSTAR_SEA(I)
              ICE_FRACTION(I)=0.0
            ENDIF

            IF(LTLEADS.AND.SEA(I))THEN
              IF(ICE_FRACTION(I).GT.0.0)THEN
                TSTAR_SSI(I)=ICE_FRACTION(I)*TSTAR_SICE(I)
     &            +(1.-ICE_FRACTION(I))*TSTAR_SEA(I)
              ENDIF
            ENDIF
            IF(.NOT.LTLEADS.AND.SEA(I))THEN
              IF(ICE_FRACTION(I).GT.0.0)THEN
                TSTAR_SEA(I)=TFS
                TSTAR_SICE(I)=AMIN1(TSTAR_SICE(I),TFS)
                TSTAR_SSI(I)=ICE_FRACTION(I)*TSTAR_SICE(I)
     &            +(1.-ICE_FRACTION(I))*TSTAR_SEA(I)
              ENDIF
            ENDIF
            TSTAR(I)=FLAND_G(I)*TSTAR_LAND(I)
     &        +(1.-FLAND_G(I))*TSTAR_SSI(I)
          ENDDO
C
*/
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*/ Set up new pointers for land and sea temperatures
*DECLARE TYPPTRA
*I GDR7F405.111
!            08/99 Allow land and sea to co-exist in the same
!                  gridbox: Add pointers for surface temperatures.
!                  Modify roughness length pointer to only
!                  include land. Add new threshhold land mask
!                                                        N. Gedney
*/
*D GRB0F304.270   
     &       JTSTAR,                 ! surface temperature
     &       JTSTAR_LAND,            ! land surface temperature
     &       JTSTAR_SICE,            ! sea-ice surface temperature
     &       JTSTAR_SEA,             ! open sea surface temperature
     &       JTSTAR_SSI,             ! mean sea surface temperature
*D GRB0F304.272   
*/ Change title: was land and sea.
     &       JZ0,                    ! vegetation roughness length
     &       JZ0_SSI,                ! sea roughness length
*D TYPPTRA.39 
     &       JLAND,                  ! land mask (TRUE if land frac>0.0)
     &       JLAND0P5,               ! land mask (TRUE if land frac>0.5)
*D TYPPTRA.40    
     &       JICE_FRACTION,         ! fraction of sea-ice in sea portion
C                                   ! of gridbox
*/
*D AJS1F400.175   
     &  JPSTAR, JSMC,  JCANOPY_WATER, JSNODEP, 
     &  JTSTAR, JTSTAR_LAND, JTSTAR_SEA, JTSTAR_SICE, JTSTAR_SSI,
     &  JTI,
*D AJS1F401.24
     &  JTSTAR_ANOM, JZH, JZ0,  JZ0_SSI, 
     &  JLAND, JLAND0P5, JICE_FRACTION,
*/
*DECLARE STATMPT1
*I GDR6F405.64    
!            08/99 Allow land and sea to co-exist in the same
!                  gridbox: Add pointers for surface temperatures.
!                  Modify roughness length pointer to only
!                  include land. Add new threshhold land mask
!                                                        N. Gedney
*/
*I GDR4F305.313 
C
      JTSTAR_LAND    = SI(406,Sect_No,im_index)
      JTSTAR_SEA     = SI(407,Sect_No,im_index)
      JTSTAR_SICE    = SI(408,Sect_No,im_index)
      JTSTAR_SSI     = SI(409,Sect_No,im_index)
      JLAND0P5       = SI(410,Sect_No,im_index)
      JZ0_SSI        = SI(412,Sect_No,im_index)
*/
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*DECLARE CANCLSTA
*I  GDG2F405.16
!          08/99  Comment on the first User ancill so it's clear that
!                 this contains the land fraction.
!                 N. Gedney
*/
*D CANCLSTA.69 
!  48  1  301  15  LAND FRACTION: User ancillary field 1
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*DECLARE GRIB_UM1
*I GRIB_UM1.534
            WRITE(7,'('' *ERROR* 5 HAVE LET LEADS TEMPERATURE VARY'')')
            CALL ABORT
*/
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*/ Replace JLAND with JLAND0P5 in physics routines that dont have tiling:
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*DECLARE CHEMCTL1
*D CHEMCTL1.168   
     &             D1(JLAND0P5),
*/
*DECLARE CONV_CT1
*D APB1F405.41
     &  D1(JTHETA(1)),D1(JQ(1)),D1(JPSTAR),D1(JLAND0P5),
*D AAD1F304.70   
     &       D1(JPSTAR+JS_LOCAL(I)),D1(JLAND0P5+JS_LOCAL(I)),
*/
*DECLARE LSPP_CT1
*D ADR1F305.107
     &     D1(JLAND0P5),CW_SEA,CW_LAND,
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*/ Correct the land zonal mean diagnostics so they use land/sea fraction:
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*DECLARE ZONMCTL1
*/
*I NF171193.138
     &   ,FLAND_GLO(P_FIELDDA)     ! Global land fraction
*/
*I ZONMCTL1.314
C  Set up GLOBAL fractional land field:
      CALL FROM_LAND_POINTS(FLAND_GLO,D1(JUSER_ANC1),D1(JLAND),
     & P_FIELDDA,NLANDPT)
*/
*D ZONMCTL1.321
     2                 D1(JTSTAR), D1(JTSTAR_LAND), D1(JTSTAR_SSI),
     &                 SOILT,
*D @DYALLOC.3939
     7                 D1(JLAND), FLAND_GLO,
*/
*DECLARE  ZONMAT1A
*D ZONMAT1A.36 
     2                 U, V, TSTAR, TSTAR_LAND, TSTAR_SSI,
     &                 SOILT, SOILM, SNOWD, CANOPYW,
*D ZONMAT1A.44
     4                 LAND, FLAND_GLO,
*I ZONMAT1A.70
      REAL
     1    FLAND_GLO(P_FIELD)       ! IN  - Land fraction
*D ZONMAT1A.79
     1    TSTAR(P_FIELD),          ! IN  - Surface temperature
     1    TSTAR_LAND(P_FIELD),     ! IN  - Land surface temperature
     1    TSTAR_SSI(P_FIELD),      ! IN  - Sea surface temperature
*/
*I ZONMAT1A.152   
     &    LMASKW(P_FIELD),         ! LOC - Land mask with land
                                   !       fraction weighting (p-grid)
*I ZONMAT1A.153   
     &    SMASKW(P_FIELD)          ! LOC - Sea mask with sea
                                   !       fraction weighting (p-grid)
*/
*I ZONMAT1A.502
        LMASKW(I) = FLAND_GLO(I)   ! Set weighted land mask 
        SMASKW(I) = 1.0-LMASKW(I)  ! Set weighted sea mask
*/
*D ZONMAT1A.736,737
      CALL ZONM(TSTAR_LAND,Z_L_TSTAR,LMASK,S_PMASS,LLPTS(1,1),
     &                                             ROW_LENGTH,P_ROWS)
*D ZONMAT1A.754,755
      CALL ZONM(TSTAR_SSI,Z_S_TSTAR,SMASK,S_PMASS,LSPTS(1,1),
     &                                             ROW_LENGTH,P_ROWS)
*/
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*DECLARE CNTLATM
*/
*I CNTLATM.112   
     &   LTLEADS        ,           !  Let leads temp vary if .TRUE.
*D CNTLATM.136   
     & LFROUDE, LGWLINP, LLINTS, LWHITBROM, LEMCORR, LTLEADS,
*D CNTLATM.166   
     & LFROUDE, LGWLINP, LLINTS, LWHITBROM, LEMCORR, LTLEADS,
*/
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*ID CTILE7
*/---------------------------------------------------------------------------
*/---------------------------------------------------------------------------
*/ Start putting in a fractional land-sea mask from the CTL level down.
*/
*/---------------------------------------------------------------------------
*/---------------------------------------------------------------------------
*/.......................................................................
*/-----------------------------------------------------------------------
*/-----------------------------------------------------------------------
*DECLARE BL_IC5A
*I BL_IC5A.61    
     + FLAND,
*/ *I BL_IC5A.213   
*/     +,FLAND(LAND_FIELD)         ! IN Fraction of land in grid box
*/-----------------------------------------------------------------------



*ID CTILE8
*/----------------------------------------------------------------------
*/ Changes required to the radiation code to diagnose SW and BLUE BAND
*/ RADN separately over land and sea fractions of a grid box.
*/
*/ Since the start of this modifications to the net PAR have been made
*/ relating to DIAG3A (~t20db/mod45/adb1f406).
*/ Hence many of the changes between this version and   ctile8.13.bc.
*/----------------------------------------------------------------------
*/----------------------------------------------------------------------
*DECLARE RAD_CTL1
*/ subroutine RAD_CTL1
*I ALR3F405.17
!LL           08/99 Allow for land and sea to co-exist in same gridbox.
!LL                 Split surface net radiation and SW up into land and
!LL                 sea-ice components. Pass land and sea-ice surface 
!LL                 net radiation to ATMPHYS.
!LL                                                  N.Gedney.
*/
*D RAD_CTL1.50    
     &             COS_ZENITH_ANGLE, NETSW,
     &             SURF_RADFLUX_LAND, SURF_RADFLUX_SICE, LIST, SWITCH,
*/
*I @DYALLOC.3031   
     &     ,SURF_RADFLUX_LAND(P_FIELDDA)  ! net down local land flux
     &     ,SURF_RADFLUX_SICE(P_FIELDDA)  ! net down local seaice flux
     &     ,SURF_LWFLUX_SOL(P_FIELDDA)    ! net dn local LW sol sfc flux
*D AWI1F403.143
     &      LAND_AND_ICE_ALBEDO(P_FIELDDA,NLALBS),
     &      LAND_ALB(P_FIELDDA,NLALBS),   ! land albedo
     &      SICE_ALB(P_FIELDDA,NLALBS),   ! sea-ice albedo
     &      FLANDG(P_FIELDDA),            ! land fraction
*/
*I ALR3F405.24
     &,ICE_FRACTION(P_FIELDDA)
!              FRACTION OF SEA-ICE IN SEA PART OF GRID BOX.
*/
*I ADB1F400.70  
      REAL
     &       FRACSOLID      ! fraction of sea-ice+land in grid box
     &      ,ALBEDOSOLID    ! mean sea-ice+land albedo
!
*/
*D ARE2F404.84,86
C Include extra levels in RADINCS to hold band 1 net surface SW before
C zenith angle adjustment and land and sea-ice surface albedo
C or surface radiative temp
     &      RADINCS((P_FIELDDA*(P_LEVELSDA+4)+511)/512*512),
*/
*D RAD_CTL1.172   
C  INITIALISE VARIOUS ARRAYS TO ZERO
*D RAD_CTL1.175   
        SURF_RADFLUX(I) = 0.0
        SURF_RADFLUX_LAND(I) = 0.0
        SURF_RADFLUX_SICE(I) = 0.0
        SURF_LWFLUX_SOL(I)=0.0
*/
*I ABX1F405.129
C  Set up GLOBAL fractional land field:
      CALL LAND_TO_GLOBAL
     & (D1(JLAND),D1(JUSER_ANC1),FLANDG,LAND_PTS,P_FIELDDA)
C
*/
*D ARE2F404.107,108
CL and land and sea-ice surface albedos.
        LEN=(P_FIELDDA*(P_LEVELS+4)+511)/512*512  !no words for SW incs
*/
*D ARE2F404.140 
         DO LEVEL=0,P_LEVELS+3
*/
*I ARE2F404.98 
      WRITE(6,*)'***ERROR 3:THE COASTAL TILE SCHEME CANNOT YET DEAL'
      WRITE(6,*)'WITH DIFFERING DIRECT AND DIFFUSE LAND ALBEDOS'
      CALL ABORT
*/
*/
*D ABX1F405.138   
            TSTAR_SNOW(LAND_LIST(L)) = D1(JTSTAR_LAND+LAND_LIST(L)-1)
*/
*/
*I AWI1F403.246
          WRITE(6,*)'***SW ERROR 1:TILING CODE NOT SET UP'
          WRITE(6,*)'FOR THIS SW RAD VERSION'
          CALL ABORT      
*/
*/
*/----------------------------------------------------------------------
*/    
*/ ie the calls to these SWRAD are NOT made......
*I ADB2F404.979
          WRITE(6,*)'***SW ERROR 2:TILING CODE NOT SET UP'
          WRITE(6,*)'FOR THIS SW RAD VERSION'
          CALL ABORT      
*/*/
*/ call ftsa1a
*D @DYALLOC.3042  
     &      D1(JLAND+JS),D1(JICE_FRACTION+JS),D1(JTSTAR_SICE+JS),
*D GHM5F405.5     
     &      LAND_ALB(FIRST_POINT,1),
     &      SICE_ALB(FIRST_POINT,1),
     &      FLANDG(FIRST_POINT),
*/
*/*/
*/ call r2_swrad (from rad_ctl)
*D GHM5F405.77 
     &        LAND_ALB(FIRST_POINT,1),SICE_ALB(FIRST_POINT,1),
     &        FLANDG(FIRST_POINT),
*D ADB2F404.991   
     &D1(JICE_FRACTION+JS),D1(JLAND+JS),D1(JLAND0P5+JS),D1(JSNODEP+JS),
*D ADB1F401.823   
     &STASHWORK(JS+SI(249,1,im_index)),STASHWORK(JS+SI(250,1,im_index)),
     &L_FLUX_BELOW_690NM_SURF,
*/
*/
*D  ARE2F404.151
CL Store surface albedos
*D ARE2F404.154 
*/
        RADINCS(I+(P_LEVELS+2)*P_FIELD) = RMDI
        RADINCS(I+(P_LEVELS+3)*P_FIELD) = RMDI
        IF(D1(JICE_FRACTION+I-1).GT.0.0)THEN
          RADINCS(I+(P_LEVELS+2)*P_FIELD) = SICE_ALB(I,1)
        ENDIF 
        IF(FLANDG(I).GT.0.0)THEN
          RADINCS(I+(P_LEVELS+3)*P_FIELD) = LAND_ALB(I,1)
        ENDIF
*/
*D ARE2F404.158
        LEN=(P_FIELDDA*(P_LEVELS+4)+511)/512*512  !no words for SW incs
*/
*/ Multiply diagnostics 1,203 (net sw sea mean) to make gbm
*/ for LEMCORR
*I GRB4F305.400   
     &                   *(1.-FLANDG(I))
*/
*/
*D ABX1F405.153
          IF (LAND_ALB(I,1) .LT. 1. )
*D ABX1F405.155
     &                                  (1. - LAND_ALB(I,1))
*/
*/
*/
*D WI200893.30    
CL Set up net down local land and sea weighted sea-ice surface 
CL SW radiation fluxes in SURF_RADFLUX_LAND and SURF_RADFLUX_SICE.
CL
*D RAD_CTL1.696   
C
C Need to diagnose the separate land and sea-ice net short-wave
C radiation. Do this by using the respective albedos
C and assuming the same net downward flux.
C
C ***NB*** This only works if the direct and diffuse albedos are
C the same.
C
C Currently Shortwave flux (SURF_RADFLUX) is weighted by solid
C fraction. For the boundary layer need land component unweighted
C and sea-ice component weighted by fraction of sea-ice in sea
C portion of grid box.
C 
        SURF_RADFLUX(I) = RADINCS(I) * COS_ZENITH_ANGLE(I)
*/
*/
C Calculate the total land and sea-ice in the gridbox:
        FRACSOLID=FLANDG(I)+(1.-FLANDG(I))*D1(JICE_FRACTION+I-1)
C Calculate the mean land and sea-ice albedo:
        IF(FRACSOLID.GT.0.0)THEN
          ALBEDOSOLID=          
     &     (FLANDG(I)*LAND_ALB(I,1)+(FRACSOLID-FLANDG(I))*SICE_ALB(I,1))
     &     /FRACSOLID
C
          IF(FLANDG(I).GT.0.0)SURF_RADFLUX_LAND(I)=
     &     SURF_RADFLUX(I)/FRACSOLID
     &     *(1.-LAND_ALB(I,1))/(1.-ALBEDOSOLID)
C
          IF(D1(JICE_FRACTION+I-1).GT.0.0)SURF_RADFLUX_SICE(I)
     &     =SURF_RADFLUX(I)/FRACSOLID*D1(JICE_FRACTION+I-1)
     &     *(1.-SICE_ALB(I,1))/(1.-ALBEDOSOLID)
C
        ENDIF
*/
*/ Delete mean solid flux:
*D RAD_CTL1.705,706
*D GRB4F305.401,402
*D RAD_CTL1.708,709
C Calculate new diagnostics for down sw land and sea-ice portions:

        IF(SF(247,1)) THEN
          DO I=FIRST_POINT, LAST_POINT
            STASHWORK(SI(247,1,im_index)+I-1) =
     &                                   SURF_RADFLUX_LAND(I)
          ENDDO
        END IF

        IF(SF(248,1)) THEN
          DO I=FIRST_POINT, LAST_POINT
            STASHWORK(SI(248,1,im_index)+I-1) =
     &                                   SURF_RADFLUX_SICE(I)
          ENDDO
        END IF
*D GRB4F305.404   
     &      STASHWORK(SI(203,1,im_index)+I-1)*(1.-FLANDG(I))
*/
*/ ..............................................................
*/ Section not relevent cos MOSESII not in 5A
*D ABX1F405.144
        WRITE(6,*)'COASTAL TILING NOT ALLOWED WITH MOSESII'
        CALL ABORT
CL Set the SW flux over the snow-free surface to the land mean
*D ABX1F405.147
          RAD_NO_SNOW(I) = SURF_RADFLUX_LAND(I)
*D ABX1F405.154
     &      RAD_NO_SNOW(I) = (1. - ALBSNF(I)) * SURF_RADFLUX_LAND(I) /
*D ABX1F405.157
     &      RAD_SNOW(I) = ( SURF_RADFLUX_LAND(I) -
*/ ..............................................................
*/
*D ARE2F404.174 
        OFFSET=(P_FIELDDA*(P_LEVELS+4)+511)/512*512
*D ARE2F404.175
        LEN=(P_FIELDDA*(P_LEVELS+4)+511)/512*512  !no words for LW incs
*D ARE2F404.209 
        LEN=(P_FIELDDA*(P_LEVELS+4)+511)/512*512  !no words for LW incs
*/
*/
*/ Multiply diagnostics 2,203 (net lw sea mean) to make gbm
*/ for LEMCORR
*I GRB4F305.419   
     &                   *(1.-FLANDG(I))
*/
*/
*D RAD_CTL1.939 
CL Set up total net down surface radiation flux in SURF_RADFLUX.
CL Use this to diagnose the land and sea-ice components.
*D RAD_CTL1.942
C Calculate fraction of land and sea-ice in grid box:
        FRACSOLID=FLANDG(I)
     &   +(1.-FLANDG(I))*D1(JICE_FRACTION+I-1)
C
        SURF_RADFLUX(I)=RADINCS(I+OFFSET)+SURF_RADFLUX(I)
C
C
C Currently Longwave is weighted by solid fraction.
C Calculate local flux (SURF_LWFLUX_SOL). For the
C boundary layer need land component unweighted and sea-ice
C component weighted by fraction of sea-ice in sea portion of
C grid box.
        IF(FRACSOLID.GT.0.0)THEN
          SURF_LWFLUX_SOL(I)=RADINCS(I+OFFSET)/FRACSOLID
C
          SURF_RADFLUX_LAND(I)=SURF_LWFLUX_SOL(I) +
     &                        SURF_RADFLUX_LAND(I)
          SURF_RADFLUX_SICE(I)=SURF_LWFLUX_SOL(I)*
     &                        D1(JICE_FRACTION+I-1) +
     &                        SURF_RADFLUX_SICE(I)
C
*/
        ENDIF
C
*D RAD_CTL1.953 
CL  Surface radiative flux over solid surface fraction
*/
*D GRB4F305.420
        CALL COPYDIAG (STASHWORK(SI(202,2,im_index)),SURF_LWFLUX_SOL,
*/
*D GRB4F305.422   
     &          STASHWORK(SI(203,2,im_index)+I-1)*(1.-FLANDG(I))
*/
*/
*/...........................................
*/ Section not relevent cos MOSESII not in 5A
*D ABX1F405.165  
CL Set the SW+LW flux over the snow-free surface to the land mean

*D ABX1F405.168
          RAD_NO_SNOW(I) = SURF_RADFLUX_LAND(I)
*D ARE1F405.9
CL Overwrite SURF_RADFLUX_LAND with the land average for land pts
*D ARE1F405.12
          SURF_RADFLUX_LAND(I) = (1. - SNOW_FRAC(I))*RAD_NO_SNOW(I)
*/...........................................
*/
*D APBBF401.83    
C Call swapbounds for all RADINCS fields, including the additional
C albedo field:
      CALL SWAPBOUNDS(RADINCS,ROW_LENGTH,P_ROWS,
*D ABX1F405.182   
     &                EW_Halo,NS_Halo,P_LEVELS+4)
*/
*I APBBF401.90
      CALL SWAPBOUNDS(SURF_RADFLUX_LAND,ROW_LENGTH,P_ROWS,
     &                EW_Halo,NS_Halo,1)
      CALL SWAPBOUNDS(SURF_RADFLUX_SICE,ROW_LENGTH,P_ROWS,
     &                EW_Halo,NS_Halo,1)
*/...........................................
*/-----------------------
*/ call r2_lwrad  
*I ARE2F404.202   
     &       D1(JTSTAR_SEA+JS_LOCAL(I)),
*/
*D ADB1F400.322,323   
C Only want the 0.5 threshold LAND mask and fractional land:
     &        D1(JLAND0P5+JS_LOCAL(I)),FLANDG(JS_LOCAL(I)+1),
     &        D1(JICE_FRACTION+JS_LOCAL(I)),
*/
*/ Now set calculation of 690nm flux if 249 or 250 are required
*D ADB1F401.811   
           IF(SF(249, 1).OR.SF(250, 1))
     &       L_FLUX_BELOW_690NM_SURF=.TRUE.
*/----------------------------------------------------------------------
*/----------------------------------------------------------------------
*/----------------------------------------------------------------------
*DECLARE FTSA1A
*/ subroutine ftsa1a (called from rad_ctl)
*I AJG1F405.33 
CLL            08/99     Split albedo into land and sea-ice.
CLL         Use TSTAR_SICE prognostic.       N Gedney
*/
*D ARE2F404.307   
     &     LAND, AICE, TSTAR_SICE,
     &     TSTAR_SNOW, SNOW_FRAC, SFA, MDSA, COSZ,
*D ARE2F404.309
     &     L1, L2, L_SNOW_ALBEDO, SAL_DIM, SAL_VIS, SAL_NIR,
     &      SAL, SASI,
     &      FLANDG,
     &      SAOS)
*/
*/
*D FTSA1A.39
     &     LAND(L1)                       ! Land mask (land .TRUE.)
*/
*D FTSA1A.41    
     &     AICE(L1),                      ! Sea-ice fraction of sea part
C                                         ! of gridbox
*I FTSA1A.42    
     &     TSTAR_SICE(L1),                ! Sea-ice surface temperature
*/
*D FTSA1A.50,51
     &     SAL(L1),                       ! Surface Albedos for Land
     &     SASI(L1),                      ! Surface Albedos for Sea-ice
     &     SAOS(L1,2),                    ! Surface Albedo for Open Sea
     &     FLANDG(L1)                     ! Fraction of land in gridbox 
*/
*/
*I FTSA1A.57
     & ,SE                                ! Loops over sea points
      REAL DSA                            ! Deep-snow albedo (alphasubD)
*/
*D FTSA1A.58,60
*/
*/----------------------------------------------------------------------
*/
*D FTSA1A.83    
       IF (LAND(J)) THEN

*D ARE2F404.336   
        SAL(J) = 0.
        SASI(J) = 0.
*/
*D ARE2F404.393,394  
        SAL(J) = 0.
        SASI(J) = 0.
        IF (LAND(J)) THEN 
          SAL(J) = SFA(J)
*D ARE2F404.401
            SAL(J) = (1. - SNOW_FRAC(J))*SFA(J) +
*D AJS1F401.1477,1478
C Initialise potentially non-relevant open sea albedos points
C containing land:
          SAOS(J,1) = SAL(J)
          SAOS(J,2) = SAL(J)
*D ARE2F404.410 
        IF(FLANDG(J).LT.1.0 ) THEN
*/
*D FTSA1A.97
C         ! Note that the following will add ICE1*(TSTAR-TSTAR_SEA)
C           to CSSA
*D FTSA1A.103 
             SASI(J) = 0.0
*/
*D FTSA1A.105,106
*/
*D FTSA1A.108 
             IF ( TSTAR_SICE(J) .LT. TCICE ) THEN
*D AJG1F405.63,64
                 if (TSTAR_SICE(J).gt.tcice) then
                   snow_albedo=ice2+ice1*TSTAR_SICE(J)
*D AJG1F405.68
                 sasi(j)=alphab
*D AJG1F405.71 
                 sasi(j)=alphab
*D FTSA1A.109     
                SASI(J) = ALPHAC
*D FTSA1A.111   
                SASI(J) = ICE1 * TSTAR_SICE(J) + ICE2
*/
*/----------------------------------------------------------------------
*/----------------------------------------------------------------------
*/----------------------------------------------------------------------
*/
*DECLARE SWRAD3A
*/
*/ subroutine r2_swrad - called from rad_ctl
*I ASK1F405.276 
!            08/99  Allow for land and sea to co-exist in same gridbox.
!                   Calculate land 690nm flux.
!                   Average land, sea-ice and open sea albedos.
!                                                  N.Gedney
*D SWRAD3A.36    
     &   , LAND_ALB, SICE_ALB
     &   , FLANDG
     &   , OPEN_SEA_ALBEDO, ICE_FRACTION, LAND, LAND0P5
*D SWRAD3A.46    
     &   , FL_LAND_BELOW_690NM_SURF
     &   , FL_SEA_BELOW_690NM_SURF
     &   , L_FLUX_BELOW_690NM_SURF
*/
*/
*I SWRAD3A.252
     &   , LAND0P5(NPD_FIELD)
!             LAND MASK (TRUE if land fraction >0.5)
     &   , SEA(NPD_FIELD)
!             SEA MASK
*/
*D SWRAD3A.255
!             FRACTION OF SEA ICE IN SEA PORTION OF GRID BOX
*D SWRAD3A.256   
*/
*D ADB1F401.1045  
     &   , LAND_ALB(NPD_FIELD)
!             SURFACE ALBEDO OF LAND
     &   , SICE_ALB(NPD_FIELD)
!             SURFACE ALBEDO OF SEA-ICE
     &   , FLANDG(NPD_FIELD)
!             Fractional land 
     &   , FLANDG_G(NPD_FIELD)
!             Gathered Fractional land 
     &   , ICE_FRACTION_G(NPD_FIELD)
!             Gathered Fractional sea-ice
*/
*/
*/*D AJS1F401.1423  
*/     &     SWOUT(NPD_FIELD, NLEVS+4)
*/*D SWRAD3A.274   
*/!             NET DOWNWARD FLUXES + various extra levels
*D SWRAD3A.276   
!             SEA-SURFACE COMPONENTS OF FLUX
!             WEIGHTED BY (OPEN SEA)/(TOTAL SEA) FRACTION
*/
*D SWRAD3A.309
*D ADB1F401.1049,1050  
     &   , FL_GBM_BELOW_690NM_SURF(NPD_FIELD)
!             GRID BOX MEAN NET SURFACE FLUX BELOW 690NM
     &   , FL_LAND_BELOW_690NM_SURF(NPD_FIELD)
!             LAND NET SURFACE FLUX BELOW 690NM
     &   , FL_SEA_BELOW_690NM_SURF(NPD_FIELD)
!             OPEN SEA NET SURFACE FLUX BELOW 690NM
!             (AT POINTS WHERE THERE THIS IS SEA-ICE THIS IS 
!             WEIGHTED BY THE FRACTION OF OPEN SEA.)
*/
*D ADB1F401.1069,1070
     &     N_FRAC_SOL_POINT
     &   , I_FRAC_SOL_POINT(NPD_PROFILE)
*/
*I SWRAD3A.432
     &   , LAND0P5_G(NPD_PROFILE)
!             GATHERED LAND MASK (TRUE if land fraction >0.5) 
*D SWRAD3A.484,485
     &   , FL_GBM_BELOW_690NM_SURF_G(NPD_PROFILE)
!             GATHERED GRID BOX MEAN DOWNWARD SURFACE FLUX BELOW 690NM
     &   , FL_SEA_BELOW_690NM_SURF_G(NPD_PROFILE)
!             GATHERED OPEN SEA NET SURFACE FLUX BELOW 690NM
*/
*I SWRAD3A.486
!     TEMPORARY FIELDS ASSOCIATED WITH 690NM FLUX OVER MEAN SOLID SURF.
      REAL 
     &     ALBEDOSOLID
     &    ,FRACSOLID
     &    ,FLUXSOLID
*/
*I SWRAD3A.530  
!     SET UP THE SEA MASK
      DO I=1,NPD_FIELD
        SEA(I)=.TRUE.
*/        IF(FLANDG(I).LT.1.0 ) THEN
*/          SEA(I)=.TRUE.
*/        ENDIF
      ENDDO
*/
*/
*/ call R2_SET_SURFACE_FIELD_SW (from r2_swrad)
*D SWRAD3A.543   
     &   , LAND, LAND0P5, OPEN_SEA_ALBEDO
     &   , LAND_ALB, SICE_ALB
     &   , FLANDG
     &   , ICE_FRACTION
*D SWRAD3A.545   
     &   , LAND_G, LAND0P5_G, FLANDG_G, ICE_FRACTION_G
     &   , ALBEDO_SEA_DIFF_G, ALBEDO_SEA_DIR_G 
*/
*/
*/ call R2_SET_THERMODYNAMIC
*D ADB2F404.1571  
     &   , PSTAR, DUMMY, DUMMY, AB, BB, AC, BC
*D ADB2F404.1573
     &   , P, T, DUMMY, DUMMY, DUMMY, D_MASS
*/
*/ call R2_SET_AEROSOL_FIELD (from r2_swrad)
*D ADB1F402.725   
     &      , LAND0P5, LYING_SNOW, PSTAR, AB, BB, TRINDX
*/
*/ call R2_SET_CLOUD_FIELD (from r2_swrad)
*D AYY1F404.372   
     &   , L_CLOUD_WATER_PARTITION,  LAND0P5_G
*/
*/ call flux_calc (from swrad)
*D ADB2F404.1604  
     &   , P, T, DUMMY, DUMMY, DUMMY, D_MASS
*D SWRAD3A.764   
     &   , FL_GBM_BELOW_690NM_SURF_G, FL_SEA_BELOW_690NM_SURF_G 
*D ADB1F401.1105  
     &   , N_FRAC_SOL_POINT, I_FRAC_SOL_POINT, ICE_FRACTION_G
*/
*D SWRAD3A.892   
         CALL R2_ZERO_1D(N_PROFILE, FL_GBM_BELOW_690NM_SURF)
         CALL R2_ZERO_1D(N_PROFILE, FL_LAND_BELOW_690NM_SURF)
         CALL R2_ZERO_1D(N_PROFILE, FL_SEA_BELOW_690NM_SURF)
*/
*D ADB1F401.1107,1113
               FL_GBM_BELOW_690NM_SURF(LIST(L))
     &            =FL_GBM_BELOW_690NM_SURF_G(L)
            ENDIF
*/            IF (SEA(LIST(L))) THEN
            IF (FLANDG(LIST(L)).LT.1.0) THEN
               FL_SEA_BELOW_690NM_SURF(LIST(L))
     &            =FL_SEA_BELOW_690NM_SURF_G(L)
     &            *(1.0E+00-ICE_FRACTION(LIST(L)))
            ENDIF
C
            FRACSOLID=FLANDG(LIST(L))
     &        +(1.-FLANDG(LIST(L)))*ICE_FRACTION(LIST(L))
            FLUXSOLID=0.0
            IF(FRACSOLID.GT.0.0)THEN
              FLUXSOLID=(FL_GBM_BELOW_690NM_SURF(LIST(L))-
     &         (1.-FLANDG(LIST(L)))*FL_SEA_BELOW_690NM_SURF(LIST(L)))
     &         /FRACSOLID
C
C Mean solid surface albedo:
               ALBEDOSOLID=
     &           (FLANDG(LIST(L))*LAND_ALB(LIST(L))
     &           +(FRACSOLID-FLANDG(LIST(L)))*SICE_ALB(LIST(L)))
     &           /FRACSOLID
C Land surface flux below 690NM:
               IF (LAND(LIST(L)))
     &           FL_LAND_BELOW_690NM_SURF(LIST(L))=FLUXSOLID*
     &           (1.-LAND_ALB(LIST(L)))/(1.-ALBEDOSOLID)
*/
             ENDIF
*/
*/
*D SWRAD3A.960   
*/         IF (SEA(LIST(L))) THEN
             IF (FLANDG(LIST(L)).LT.1.0) THEN
*/
*/ Weight open sea flux with open sea fraction
*I SWRAD3A.957
C Weight open sea flux with open sea fraction over total sea
*D SWRAD3A.963   
*/
            SWOUT(LIST(L), 1)=SWOUT(LIST(L), 1)
     &        -(1.0E+00-FLANDG(LIST(L)))*SWSEA(LIST(L))
*/
*D AJS1F401.1424  
!     DIVIDE FL_LAND_BELOW_690NM_SURF BY LAND ALBEDO TO GIVE TOTAL
*/
*D AJS1F401.1430,1431
           SWOUT(L, NLEVS+2)=0.0
           IF(LAND(L))THEN
             SWOUT(L, NLEVS+2)=FL_LAND_BELOW_690NM_SURF(L) / 
     &        (1 - LAND_ALB(L))
*/
           ENDIF
*/
*/----------------------------------------------------------------------
*/ subroutine R2_SET_SURFACE_FIELD_SW (called from r2_swrad)
*/
*D SWRAD3A.1006 
     &   , LAND, LAND0P5, OPEN_SEA_ALBEDO
     &   , LAND_ALB, SICE_ALB
     &   , FLANDG
     &   , ICE_FRACTION
*/
*D SWRAD3A.1008  
     &   , LAND_G, LAND0P5_G, FLANDG_G, ICE_FRACTION_G
     &   , ALBEDO_SEA_DIFF, ALBEDO_SEA_DIR
*I SWRAD3A.1057
     &   , LAND0P5(NPD_FIELD)
!             LAND MASK (TRUE if land fraction >0.5)
*/
*D SWRAD3A.1061
     &   , LAND_ALB(NPD_FIELD)
     &   , SICE_ALB(NPD_FIELD)
     &   , FLANDG(NPD_FIELD)
     &   , FLANDG_G(NPD_FIELD)
!             GATHERED LAND FRACTION 
     &   , ICE_FRACTION_G(NPD_FIELD)
!             GATHERED SEA-ICE FRACTION IN SEA PORTION OF GRID BOX
*/
*D SWRAD3A.1064  
!             FRACTION OF SEA ICE IN SEA PORTION OF GRID BOX
*/
*I SWRAD3A.1084
     &   , LAND0P5_G(NPD_PROFILE)
!             GATHERED LAND MASK (TRUE if land fraction >0.5)
*I SWRAD3A.1113  
            LAND0P5_G(L)=LAND0P5(LIST(L))
            FLANDG_G(L)=FLANDG(LIST(L))
            ICE_FRACTION_G(L)=ICE_FRACTION(LIST(L))
*/
*D SWRAD3A.1118,1121
!     SET THE ALBEDO FIELDS: AN AVERAGE ALBEDO IS REQUIRED OVER WHERE
!     THERE IS A COMBINATION OF OPEN SEA, SEA-ICE AND LAND. SEPARATE
!     ALBEDOS ARE PROVIDED FOR FOR OPEN SEA. BAND-DEPENDENT COPIES
!     OF THE ALBEDOS MUST BE MADE FOR CALCULATING COUPLING FLUXES.
*/
*I SWRAD3A.1126
               ALBEDO_SEA_DIR(L, I)=0.0E+00
               ALBEDO_SEA_DIFF(L, I)=0.0E+00
               ALBEDO_FIELD_DIFF(L, I)=0.0E+00
               ALBEDO_FIELD_DIR(L, I)=0.0E+00
*D SWRAD3A.1128,1130
*/            IF (SEA(LIST(L))) THEN
            IF (FLANDG(LIST(L)).LT.1.0) THEN
               ALBEDO_FIELD_DIFF(L, I)
     &            =SICE_ALB(LIST(L))*ICE_FRACTION(LIST(L))
*D SWRAD3A.1133,1134
               ALBEDO_FIELD_DIR(L, I)
     &            =SICE_ALB(LIST(L))*ICE_FRACTION(LIST(L))
*D SWRAD3A.1139,1143
            ENDIF
            IF (LAND(LIST(L))) THEN
               ALBEDO_FIELD_DIFF(L, I)=
     &           ALBEDO_FIELD_DIFF(L, I)*(1.-FLANDG_G(L))
     &           +LAND_ALB(LIST(L))*FLANDG_G(L)
               ALBEDO_FIELD_DIR(L, I)=
     &           ALBEDO_FIELD_DIR(L, I)*(1.-FLANDG_G(L))
     &           +LAND_ALB(LIST(L))*FLANDG_G(L)
*/
*/----------------------------------------------------------------------
*/----------------------------------------------------------------------
*/----------------------------------------------------------------------
*/ Add Total downward and diffuse blue band radiation
*/ These are required for diagnosing the blue band radiation
*/ over open sea
*DECLARE DIAG3A
*/
*/ subroutine r2_init_couple_diag
*I DIAG3A.65
!                          09-99    Add two new "blue band" fluxes.
!                                               (N. Gedney)
*B DIAG3A.77
     &  , FL_GBM_BELOW_690NM_SURF, FL_SEA_BELOW_690NM_SURF
*I DIAG3A.119
     &   , FL_GBM_BELOW_690NM_SURF(NPD_PROFILE)
!          GRID BOX MEAN NET SURFACE FLUX BELOW 690NM
     &   , FL_SEA_BELOW_690NM_SURF(NPD_PROFILE)
!          OPEN SEA NET SURFACE FLUX BELOW 690NM
*/
*D DIAG3A.136   
*D DIAG3A.138
*/
*I DIAG3A.139
      IF (L_FLUX_BELOW_690NM_SURF) THEN 
        CALL R2_ZERO_1D(N_PROFILE, FL_GBM_BELOW_690NM_SURF)
        CALL R2_ZERO_1D(N_PROFILE, FL_SEA_BELOW_690NM_SURF)
      ENDIF
!
*/ subroutine r2_couple_diag
*I DIAG3A.158
!                          09-99    Add two new "blue band" fluxes.
!                                               (N. Gedney)
*B DIAG3A.175   
     &  , FL_GBM_BELOW_690NM_SURF, FL_SEA_BELOW_690NM_SURF
*/
*B DIAG3A.263  
     &   , FL_GBM_BELOW_690NM_SURF(NPD_PROFILE)
!          GRID BOX MEAN NET SURFACE FLUX BELOW 690NM
     &   , FL_SEA_BELOW_690NM_SURF(NPD_PROFILE)
!          OPEN SEA NET SURFACE FLUX BELOW 690NM
*/
*B DIAG3A.414
!     The diagnostics below are available only in solar region. Over
!     sea-points one refers only to the flux over the open sea
!     (see the comments about sea_flux above). Over land, both the
!     upward and downward fluxes are taken as uniform.
        IF (ISOLIR.EQ.IP_SOLAR) THEN
          DO L=1, N_PROFILE
            FL_GBM_BELOW_690NM_SURF(L)=FL_GBM_BELOW_690NM_SURF(L)
     &        +WEIGHT_690NM*(FLUX_DOWN(L)-FLUX_UP(L))
          IF (FLANDG(L).LT.1.0.AND.ICE_FRACTION(L).LT.1.0) THEN
              FL_SEA_BELOW_690NM_SURF(L)
     &          =FL_SEA_BELOW_690NM_SURF(L)
     &          +WEIGHT_690NM
     &          *(FLUX_DOWN(L)*(1.0E+00-ALBEDO_SEA_DIFF(L))
     &          +FLUX_DIRECT(L)*(ALBEDO_SEA_DIFF(L)
     &          -ALBEDO_SEA_DIR(L)))
            ENDIF
          ENDDO
        ENDIF
*/
*/----------------------------------------------------------------------
*/----------------------------------------------------------------------
*/----------------------------------------------------------------------
*/ 
*DECLARE FXCA3A
*/ subroutine flux_calc
*I ADB1F405.294   
!                          08/99        Allow for land and sea
!                                       to co-exist in same gridbox.
!                                       Replace fractional sea-ice
!                                       points with fraction open-sea
!                                       points so that fractional land
!                                       is catered for. Replace TFS 
!                                       with general sea temperature.
!                                       (N. Gedney)

*D FXCA3A.38
     &   , P, T, T_GROUND, T_SEA, T_LEVEL, D_MASS
*D ADB1F401.433   
     &   , N_FRAC_SOL_POINT, I_FRAC_SOL_POINT, ICE_FRACTION 
*/
*D ADB1F401.435   
     &   , FL_GBM_BELOW_690NM_SURF, FL_SEA_BELOW_690NM_SURF
*/
*/ declare variables
*I FXCA3A.232   
     &   , T_SEA(NPD_PROFILE)
!             SURFACE TEMPERATURE OVER OPEN SEA
*I FXCA3A.463   
     &   , FLANDG(NPD_PROFILE)
!             LAND FRACTION
*/
*D ADB1F401.440,443
     &     N_FRAC_SOL_POINT
!             NUMBER OF POINTS WITH FRACTIONAL ICE/LAND COVER
     &   , I_FRAC_SOL_POINT(NPD_PROFILE)
!             INDICES OF POINTS WITH FRACTIONAL ICE/LAND COVER
*/
*D ADB1F401.449,450
     &   , FL_GBM_BELOW_690NM_SURF(NPD_PROFILE)
!             GRID BOX MEAN NET SURFACE FLUX BELOW 690NM
     &   , FL_SEA_BELOW_690NM_SURF(NPD_PROFILE)
!             OPEN SEA NET SURFACE FLUX BELOW 690NM
*/
*D ADB1F401.453,454
     &     PLANCK_LEADS_SEA(NPD_PROFILE)
!             PLANCK FUNCTION OVER SEA LEADS
*/
*/ call r2_init_couple_diag 
*D ADB1F401.462 
     &   , L_FLUX_BELOW_690NM_SURF
     &   , FL_GBM_BELOW_690NM_SURF, FL_SEA_BELOW_690NM_SURF
*/
*/ call dfpln3a/call DIFF_PLANCK_SOURCE
*D FXCA3A.1090  
     &         , T_REF_PLANCK, T_LEVEL, T_GROUND, T_SEA
*D ADB1F401.464,465   
     &         , N_FRAC_SOL_POINT, I_FRAC_SOL_POINT, ICE_FRACTION
     &         , FLANDG, PLANCK_LEADS_SEA
*/
*/ call r2_couple_diag 
*/*D ADB1F406B.34
*/     &      , LAND, PLANCK_FREEZE_SEA
*D ADB1F401.473   
     &   , L_FLUX_BELOW_690NM_SURF
     &   , FL_GBM_BELOW_690NM_SURF, FL_SEA_BELOW_690NM_SURF
*/
*/
*/----------------------------------------------------------------------
*/----------------------------------------------------------------------
*/----------------------------------------------------------------------
*/ subroutine r2_lwrad
*DECLARE LWRAD3A
*I ASK1F405.289
!                    08/99    Allow for land and sea to co-exist in
!                             same gridbox. Replace fractional sea-ice
!                             points with fraction open-sea points so
!                             that fractional land is catered for.
!                             Replace TFS with general sea temperature.
!                                                          N. Gedney
*D LWRAD3A.27    
     &   , TAC, PEXNER, TSTAR, TSTAR_SEA
     &   , PSTAR, AB, BB, AC, BC
*/
*D LWRAD3A.33    
     &   , LAND, FLANDG, ICE_FRACTION 
*/
*I LWRAD3A.224   
     &   , TSTAR_SEA(NPD_FIELD)
!             OPEN SEA SURFACE TEMPERSTURES
*/
*D LWRAD3A.226   
!             SEA ICE FRACTION OF SEA PORTION OF GRID BOX
*/
*I ADB1F402.500   
     &   , FLANDG(NPD_FIELD)
!             LAND FRACTION
*/
*I ADB1F401.534   
     &   , T_SEA(NPD_PROFILE)
!             GATHERED OPEN SEA TEMPERATURE
*/
*D ADB1F401.537,540
     &     N_FRAC_SOL_POINT
!             NUMBER OF POINTS WITH FRACTIONAL ICE/LAND COVER
     &   , I_FRAC_SOL_POINT(NPD_PROFILE)
!             INDICES OF POINTS WITH FRACTIONAL ICE/LAND COVER
*/
*/ call R2_SET_THERMODYNAMIC
*D ADB1F401.556,557
     &   , PSTAR, TSTAR, TSTAR_SEA
     &   , AB, BB, AC, BC, PEXNER, TAC 
     &   , P, T, T_BDY, T_SURFACE, T_SEA, D_MASS
*/
*/ call R2_SET_SURFACE_FIELD_LW
*I LWRAD3A.506   
     &   , FLANDG
*D ADB1F401.568   
     &   , N_FRAC_SOL_POINT, I_FRAC_SOL_POINT, ICE_FRACTION
*/
*/ call flux_calc(from lwrad3a)
*D ADB1F401.574   
     &   , P, T, T_SURFACE, T_SEA, T_BDY, D_MASS 
*/
*/ call flux_calc(from lwrad3a)
*D ADB1F401.575   
     &   , N_FRAC_SOL_POINT, I_FRAC_SOL_POINT, ICE_FRACTION
*/
*D ADB1F401.579   
     &   , N_FRAC_SOL_POINT, I_FRAC_SOL_POINT, ICE_FRACTION
*/
*D ADB1F401.585   
!              FRACTION OF SEA-ICE IN SEA PART OF GRID BOX.
*/
*/ (blue-band SW fluxes are dummies in LW calc)
*D LWRAD3A.631   
     &   , L_DUMMY, DUMMY
     &   , DUMMY, DUMMY 
*/
*D ADB1F401.587,590
     &     N_FRAC_SOL_POINT
!             NUMBER OF POINTS WITH FRACTIONAL ICE/LAND COVER
     &   , I_FRAC_SOL_POINT(NPD_PROFILE)
!             INDICES OF POINTS WITH FRACTIONAL ICE/LAND COVER
*/
*/
*D LWRAD3A.703,706
!     SEPARATE THE CONTRIBUTIONS OVER OPEN SEA AND LAND/SEA-ICE.
!     LWSEA IS WEIGHTED WITH THE FRACTION OF OPEN SEA TO TOTAL SEA.
      DO L=1, N_PROFILE
         IF (FLANDG(L).EQ.1.0.OR.ICE_FRACTION(L).EQ.1.0) THEN
*/
*D ADB1F401.576,577
!           LWSEA MUST BE SCALED BY THE FRACTION OF OPEN SEA TO
!           TOTAL SEA FOR CONSISTENCY WITH UPPER LEVELS IN THE MODEL. 
*D LWRAD3A.708
         ELSEIF(FLANDG(L).LT.TOL_TEST.AND.
     &     ICE_FRACTION(L).LT.TOL_TEST)THEN
*D LWRAD3A.714 
            LWOUT(L, 1)=LWOUT(L, 1)-(1.0E+00-FLANDG(L))*LWSEA(L) 
*/
*/ ------------------------------------------------------------------ 
*/ subroutine R2_SET_SURFACE_FIELD_LW
*I LWRAD3A.745   
     &   , FLANDG
*/
*D ADB1F401.582 
!     VARIABLES CONCERNED WITH FRACTIONAL OPEN SEA
*I  ADB1F401.584 
     &   , FLANDG(NPD_PROFILE)
!                  LAND FRACTION
*/
*D ADB1F401.598,602
!     SET THE FRACTIONAL OPEN SEA COVERAGE. POINTS ARE REQUIRED WHERE
!     THIS IS NEITHER 0 NOR 1.
      DO L=1, N_PROFILE
         SEARCH_ARRAY(L)=(1.-FLANDG(L))*(1.0E+00-ICE_FRACTION(L))
         SEARCH_ARRAY(L)=SEARCH_ARRAY(L)*(1.-SEARCH_ARRAY(L))
      ENDDO
*/
*D GSS2F402.246   
      N_FRAC_SOL_POINT=0
*D GSS2F402.249,250
          N_FRAC_SOL_POINT                  =N_FRAC_SOL_POINT+1
          I_FRAC_SOL_POINT(N_FRAC_SOL_POINT)=L
*/
*/
*/----------------------------------------------------------------------
*/----------------------------------------------------------------------
*/----------------------------------------------------------------------
*DECLARE CLDCTL1
*I ASK1F405.145   
!LL          08/99  Allow for land and sea to co-exist in same gridbox.
!LL                 Split surface net radiation and SW up into land and
!LL                 sea-ice components. Pass land and sea-ice surface 
!LL                 net radiation to ATMPHY1.
!LL                                                  N.Gedney
*/
*D AJS1F401.1445  
      SUBROUTINE CLD_CTL(CLOUD_FRACTION,
     &           SURF_RADFLUX_LAND,SURF_RADFLUX_SICE,
     &           PHOTOSYNTH_ACT_RAD,
*/
*I ASK1F405.148   
     &       FLANDG(P_FIELDDA),         ! Land fraction
!              FRACTION OF LAND IN GRID BOX.
     &       ICE_FRACTION(P_FIELDDA),
!              FRACTION OF SEA-ICE IN SEA PART OF GRID BOX.
*I CLDCTL1.56 
C
      REAL
     &       FRACSOLID(P_FIELDDA)
C                           ! fraction of sea-ice+land in grid box 
     &      ,ALBEDOSOLID    ! mean sea-ice+land albedo
*/
*I @DYALLOC.753
     &       SURF_RADFLUX_LAND(P_FIELDDA),
     &       SURF_RADFLUX_SICE(P_FIELDDA),
*/
*D ARE2F404.29 
     &     ,RADINCS((P_FIELDDA*(P_LEVELSDA+4)+511)/512*512*2)
*D ARE2F404.31,32
C          zenith angle adjustment, land and sea-ice surface albedo
C          and surface radiative temperature.
*D ARE2F404.38,40
        LEN=(P_FIELDDA*(P_LEVELS+4)+511)/512*512*2 !no. words for LW/SW
C (The above includes extra levels for net surface SW (band 1) without
C zenith angle adjustment, land and sea-ice surface albedos and
C surface radiative temp).
*D ARE2F404.41,43
        LEN=(P_FIELDDA*(P_LEVELS+4)+511)/512*512 ! offset to 2nd RADINCS
C (The above includes extra levels for net surface SW (band 1) without
C zenith angle adjustment and land and sea-ice surface albedos).
*/
*I GRB4F305.38 
C
C  Set up GLOBAL fractional land field:
      CALL LAND_TO_GLOBAL
     & (D1(JLAND),D1(JUSER_ANC1),FLANDG,LAND_PTS,P_FIELDDA)
C
*/
*D CLDCTL1.295
CL     surface increments to SURF_RADFLUX_LAND and SURF_RADFLUX_SICE.
*D CLDCTL1.396,397
C consider sw flux first:
          SURF_RADFLUX(I) = RADINCS(I) * COS_ZENITH_ANGLE(I)
          SURF_RADFLUX_LAND(I) = 0.0
          SURF_RADFLUX_SICE(I) = 0.0
C
        FRACSOLID(I)=FLANDG(I)+(1.-FLANDG(I))*D1(JICE_FRACTION+I-1)
C
        IF(FRACSOLID(I).GT.0.0)THEN
          ALBEDOSOLID=
     &    (FLANDG(I)*RADINCS(I+(P_LEVELS+3)*P_FIELD)
     &    +(FRACSOLID(I)-FLANDG(I))*RADINCS(I+(P_LEVELS+2)*P_FIELD))
     &    /FRACSOLID(I)
C
           IF(FLANDG(I).GT.0.0)SURF_RADFLUX_LAND(I)=
     &      SURF_RADFLUX(I)/FRACSOLID(I)
     &      *(1.-RADINCS(I+(P_LEVELS+3)*P_FIELD))/(1.-ALBEDOSOLID)
C
           IF(D1(JICE_FRACTION+I-1).GT.0.0)SURF_RADFLUX_SICE(I)=
     &      SURF_RADFLUX(I)*D1(JICE_FRACTION+I-1)/FRACSOLID(I)
     &      *(1.-RADINCS(I+(P_LEVELS+2)*P_FIELD))/(1.-ALBEDOSOLID)
C
*/
         ENDIF
        ENDDO
C 
C Output SW land and sea-ice surface:
        IF(SF(247,1)) THEN
          DO I=FIRST_POINT, LAST_POINT
            STASHWORK(si(247,1,im_index)+I-1) =
     &                                 SURF_RADFLUX_LAND(I)
          ENDDO
        CALL EXTDIAG (STASHWORK,si(1,1,im_index),SF(1,1),247,247,INT9,
     &     ROW_LENGTH, STLIST, LEN_STLIST, STINDEX(1,1,1,im_index), 2,
     &     STASH_LEVELS, NUM_STASH_LEVELS+1,
     &     STASH_PSEUDO_LEVELS, NUM_STASH_PSEUDO,
     &     im_ident,1,
*CALL ARGPPX
     &     ICODE, CMESSAGE)
        ENDIF
C
C
        IF(SF(248,1)) THEN
          DO I=FIRST_POINT, LAST_POINT
            STASHWORK(si(248,1,im_index)+I-1) =
     &                                 SURF_RADFLUX_SICE(I)
          ENDDO
        CALL EXTDIAG (STASHWORK,si(1,1,im_index),SF(1,1),248,248,INT9,
     &     ROW_LENGTH, STLIST, LEN_STLIST, STINDEX(1,1,1,im_index), 2,
     &     STASH_LEVELS, NUM_STASH_LEVELS+1,
     &     STASH_PSEUDO_LEVELS, NUM_STASH_PSEUDO,
     &     im_ident,1,
*CALL ARGPPX
     &     ICODE, CMESSAGE)
        ENDIF

C
C      add lw flux:
C
        DO I=FIRST_POINT,LAST_POINT 
          SURF_RADFLUX(I) = SURF_RADFLUX(I)+RADINCS(I+LEN)
          IF(FRACSOLID(I).GT.0.0)THEN
            SURF_RADFLUX_LAND(I) = RADINCS(I+LEN)/FRACSOLID(I) +
     &                        SURF_RADFLUX_LAND(I)
            SURF_RADFLUX_SICE(I) = RADINCS(I+LEN)*
     &                        D1(JICE_FRACTION+I-1)/FRACSOLID(I) +
     &                        SURF_RADFLUX_SICE(I)
*/
          ENDIF
C
*/
*/
*D ABX1F405.97  
CL Set the SW+LW flux over the snow-free surface to the land mean
*/
*D ABX1F405.101
          RAD_NO_SNOW(I) = SURF_RADFLUX_LAND(I)
*D ABX1F405.102
          RAD_SNOW(I) = SURF_RADFLUX_LAND(I)
*D ARE1F405.2
C Overwrite SURF_RADFLUX with the gridbox average for land points
*D ARE1F405.5
             SURF_RADFLUX_LAND(I) = (1. - SNOW_FRAC(L))*RAD_NO_SNOW(I)
*/
*/
*/ ------------------------------------------------------------------
*/ ------------------------------------------------------------------
*/ ------------------------------------------------------------------
*/
*DECLARE ATMPHY1
*/
*I @DYALLOC.363
     &     WORK6A(P_FIELDDA),
     &     WORK6B(P_FIELDDA),
*D ATMPHY1.126
CL WORK6A holds land surface net down radn flux (at radiation tsteps).
CL WORK6B holds sea-ice surface net down radn flux (at radn tsteps).
*D ASK1F405.100 
      CALL CLD_CTL(WORK1,WORK6A,WORK6B,WORK15,LSCLD_AREA
*D ATMPHY1.195
CL WORK6A holds landsurface net down radiation flux
CL WORK6B holds sea-ice surface net down radiation flux
*D ATMPHY1.209
      CALL RAD_CTL(WORK1,WORK2,WORK3,WORK4,WORK5,WORK6A,WORK6B,
     &             WORK7,WORK8,
*D ATMPHY1.228
CL WORK6A holds landsurface net down radiation flux
CL WORK6B holds sea-ice surface net down radiation flux
*D AJS1F401.195
     &            WORK14,WORK6A,WORK6B,WORK9,WORK10,WORK5,
*/
*/----------------------------------------------------------------------
*/----------------------------------------------------------------------
*/----------------------------------------------------------------------
*DECLARE CRADINCS
*D ARE2F404.69
C Add one extra level to store sea-ice albedo in
C to calculate separate SW fluxes on non-radiation time-steps
     &        RADINCS ( (P_FIELD*(P_LEVELS+4)+511)/512*512*2 )
*/
*/----------------------------------------------------------------------
*/----------------------------------------------------------------------
*/----------------------------------------------------------------------
*DECLARE U_MODEL1
*D ARE2F404.530   
     &    RADINCS ( (P_FIELDDA*(P_LEVELSDA+4)+511)/512*512*2 )
*/
*/----------------------------------------------------------------------
*/----------------------------------------------------------------------
*/----------------------------------------------------------------------
*/
*DECLARE FILL3A
*I ALR3F405.68    
!                          08/99   Gather land, sea and
!                                  sea-ice temperatures and
!                                  land fraction. Replace TFS
!                                  with general sea temperature.
!                                       (N. Gedney)
*/
*/ R2_SET_THERMODYNAMIC
*D ADB1F401.205,206
     &   , PSTAR, TSTAR, TSTAR_SEA
     &   , AB, BB, AC, BC, PEXNER, TAC
     &   , P, T, T_BDY, T_SURFACE, T_SEA, D_MASS
*I FILL3A.466
     &   , TSTAR_SEA(NPD_FIELD)
!             OPEN SEA SURFACE TEMPERSTURES
*I ADB1F401.208   
     &   , T_SEA(NPD_PROFILE)
!             GATHERED OPEN SEA TEMPERATURE
*/
*/*I AYY1F404.402   
     &   , FLANDG_G(NPD_PROFILE)
!             GATHERED LAND FRACTION
*/
*I ADB1F401.213   
            T_SEA(L)=TSTAR_SEA(LG)
*/
*/ ------------------------------------------------------------------ 
*/ ------------------------------------------------------------------ 
*/ ------------------------------------------------------------------ 
*DECLARE DFPLN3A
*/
*I ADB1F401.53 
!                           08/99        Allow for land and sea
!                                        to co-exist in same gridbox.
!                                        Replace fractional sea-ice
!                                        points with fraction open-sea
!                                        points so that fractional land
!                                        is catered for. Replace TFS
!                                        with general sea temperature.
!                                        (N. Gedney)
*/
*D DFPLN3A.25    
     &   , T_REF_PLANCK, T_LEVEL, T_GROUND, T_SEA
*D ADB1F401.54,55    
     &   , N_FRAC_SOL_POINT, I_FRAC_SOL_POINT, ICE_FRACTION
     &   , FLANDG, PLANCK_LEADS_SEA
*I DFPLN3A.63    
     &   , T_SEA(NPD_PROFILE)
!             SURFACE TEMPERATURE OVER OPEN SEA
*D ADB1F401.67 
!             FRACTION OF SEA-ICE IN SEA PORTION OF GRID BOX
*I DFPLN3A.75
     &   , FLANDG(NPD_PROFILE)
!             GATHERED LAND FRACTION
*/
*D ADB1F401.61,64
     &     N_FRAC_SOL_POINT
!             NUMBER OF POINTS WITH FRACTIONAL ICE/LAND COVER
     &   , I_FRAC_SOL_POINT(NPD_PROFILE)
!             INDICES OF POINTS WITH FRACTIONAL ICE/LAND COVER
*/
*D ADB1F401.70,71
     &     PLANCK_LEADS_SEA(NPD_PROFILE)
!             PLANCK FUNCTION OVER SEA LEADS
     &   , SEAFRAC(NPD_PROFILE) 
!             FRACTION OF OPEN SEA IN GRID-BOX
*/
*D ADB1F401.81
!             TEMPERATURE OF ICE SURFACE
!             (GATHERED OVER FRACTIONAL OPEN SEA POINTS)
*D ADB1F401.83
!             PLANCKIAN OF ICE SURFACE 
!             (GATHERED OVER FRACTIONAL OPEN SEA POINTS) 
*/
*D ADB1F401.88,93 
!     CALCULATE THE SOURCE FUNCTION OVER OPEN SEA.
*/
*D ADB1F401.94,95 
C
C Initialise to zero:
      DO LG=1,NPD_PROFILE
        PLANCK_LEADS_SEA(LG)=0.0
      ENDDO
C
      DO L=1, N_FRAC_SOL_POINT
        LG=I_FRAC_SOL_POINT(L)
        T_RATIO(L)=T_SEA(LG)/T_REF_PLANCK
        PLANCK_LEADS_SEA(LG)=THERMAL_COEFFICIENT(N_DEG_FIT)
      ENDDO
*/
*D ADB1F401.97,98
         DO L=1, N_FRAC_SOL_POINT
           LG=I_FRAC_SOL_POINT(L)
           PLANCK_LEADS_SEA(LG)=PLANCK_LEADS_SEA(LG)*T_RATIO(L)
     &        +THERMAL_COEFFICIENT(J)
         ENDDO
*D ADB1F401.99    
      ENDDO
*/
*D ADB1F401.101,103
!     DETERMINE THE TEMPERATURE OF THE NON-SEA FRACTION.
      DO L=1, N_FRAC_SOL_POINT
         LG=I_FRAC_SOL_POINT(L)
         SEAFRAC(LG)=(1.-FLANDG(LG))*(1.0E+00-ICE_FRACTION(LG))
*/
*D ADB1F401.105
     &      -T_SEA(LG)*SEAFRAC(LG))/(1.-SEAFRAC(LG))
C
*D ADB1F401.109   
      DO L=1, N_FRAC_SOL_POINT
*D ADB1F401.114   
         DO L=1, N_FRAC_SOL_POINT
*D ADB1F401.121,122   
      DO L=1, N_FRAC_SOL_POINT
         LG=I_FRAC_SOL_POINT(L)
*/
*D ADB1F401.123,124
         PLANCK_GROUND(LG)=(1.-SEAFRAC(LG))*PLANCK_GROUND_G(L)
     &      +PLANCK_LEADS_SEA(LG)*SEAFRAC(LG)
*/
*/----------------------------------------------------------------------
*/----------------------------------------------------------------------
*/----------------------------------------------------------------------


















*IDENT CTILE9
*/-------------------------------------------------------------------------
*/ Changes required to the Gravity wave drag scheme to allow for sea and
*/ land fractions in a grid box. GWD should only act over the LAND part.
*/-------------------------------------------------------------------------
*DECLARE GWAV_CT1
*/ call GWAV_INTCTL
*I ASW1F403.18    
CLL          08/99   Weight fluxes with fraction of land in
CLL                  gridbox. Pass land fraction through to this
CLL                  subroutine.
CLL                                                 N. Gedney
*D AMJ1F304.138
     &    D1(JOROG_GRAD_YY+JSL),D1(JUSER_ANC1+JSL),

*/-------------------------------------------------------------------------
*DECLARE GWVICT3A
*/ subroutine GWAV_INTCTL
*I ASW1F403.24  
CLL           08/99  Pass land fraction through to this
CLL                  subroutine.
CLL                                                 N. Gedney
*I GWVICT3A.9 
     &  FLAND,
*/
*I GWVICT3A.107
     &,FLAND(LAND_POINTS)     !IN    FRACTION OF LAND ON LAND POINTS
*/
*/ call G_WAVE 
*I GWVICT3A.162
     &  FLAND,
*/
*/-------------------------------------------------------------------------
*DECLARE GWAVE3A
*/ subroutine gwave3a
*I AJC1F405.191   
CLL           08/99  Weight fluxes with fraction of land in
CLL                  gridbox. Pass land fraction through to this
CLL                  subroutine.
CLL                                                 N. Gedney
*I GWAVE3A.9
     &  FLAND,
*/
*I GWAVE3A.111
     *, FLAND(LAND_POINTS)              ! Land fraction on LAND POINTS
*/
*D GWAVE3A.343,344
*/          write(6,*)'***fland in gwave3a',i,FLAND(I)
C Weight with land fraction
          WORK(LAND_INDEX(I),1)= DU_DT(I,K)*FLAND(I)
          WORK(LAND_INDEX(I),2)= DV_DT(I,K)*FLAND(I)
*D GWAVE3A.370 
C Weight with land fraction
                WORK(LAND_INDEX(I),1)=STRESS_UD_LAND(I,K)*FLAND(I)
*D GWAVE3A.382
C Weight with land fraction
                WORK(LAND_INDEX(I),2)=STRESS_VD_LAND(I,K)*FLAND(I)
*D GWAVE3A.404
C Weight with land fraction
                WORK(LAND_INDEX(I),1)=DU_DT_SATN_LAND(I,K)*FLAND(I)
*D GWAVE3A.416 
C Weight with land fraction
                WORK(LAND_INDEX(I),2)=DV_DT_SATN_LAND(I,K)*FLAND(I)
*D GWAVE3A.438
C Weight with land fraction
                WORK(LAND_INDEX(I),1)=DU_DT_JUMP_LAND(I,K)*FLAND(I)
*D GWAVE3A.450
C Weight with land fraction
                WORK(LAND_INDEX(I),2)=DV_DT_JUMP_LAND(I,K)*FLAND(I)
*D GWAVE3A.472 
C Weight with land fraction
                WORK(LAND_INDEX(I),1)=DU_DT_LEE_LAND(I,K)*FLAND(I)
*D GWAVE3A.484
C Weight with land fraction
                WORK(LAND_INDEX(I),2)=DV_DT_LEE_LAND(I,K)*FLAND(I)
*D GWAVE3A.497 
C Weight with land fraction
          WORK(LAND_INDEX(I),2)=TRANS_D_LAND(I)*FLAND(I)
*/
*/-------------------------------------------------------------------------
*/-------------------------------------------------------------------------
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/Orginal mod:  inlansea_biogeo.mod
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*DECLARE ROWCALC
*B ROWCALC.843
     &,D1(joc_vflux_mask),RMDI
*DECLARE TRACER
*B TRACER.31 
     &,vflux_mask,RMDI
*B TRACER.201
      REAL vflux_mask(IMT,JMT),RMDI
*B TRACER.1267
c do for actual inland seas, as specified by the salmask
      if (L_OCARBON) then
         DO I=1,IMT
           IF (vflux_mask(i,j).lt.0 .AND. FM(I,1).gt.0) THEN
               do n=3,nt
               do k=1,km
                 TA(I,k,n)=RMDI
               end do
               end do
               CO2_FLUX(I)=0.
               VTCO2_FLUX(I)=0.
               VALK_FLUX(I)=0.
               INVADE(I)=0.
               EVADE(I)=0.
           ENDIF
         END DO
      end if
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/Orginal mod:  ozone_mod-3levcustom
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*ID CONSTANT O3
*DECLARE RAD_CTL1
*I ADB2F404.937
      DO ROW=1,P_ROWS
        DO I=1,ROW_LENGTH
          POINT=I+(ROW-1)*ROW_LENGTH
          DO LEVEL=1,OZONE_LEVELS
            IF(LEVEL.LT.TRINDX(POINT)) OZONE_1(POINT,LEVEL)=2.0E-8
            IF(LEVEL.EQ.TRINDX(POINT)) OZONE_1(POINT,LEVEL)=2.0E-7
            IF(LEVEL.GT.TRINDX(POINT)) OZONE_1(POINT,LEVEL)=1.0E-6

            IF(LEVEL.EQ.OZONE_LEVELS)  OZONE_1(POINT,LEVEL)=1.5E-6
          ENDDO
        ENDDO
      ENDDO
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/Orginal mod:  schmidt_bounds.mod
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*DECLARE FLUX_CO2
*I OJP0F404.586
        if (schmidt.le.50) schmidt=50
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/Orginal mod:  snowonice_coupling.mod
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*DECLARE FTSA1A
*D ARE2F404.308
     &     S, S_SEA, RGRAIN, SOOT,
*I AWI2F400.5
     &     ,S_SEA(L1)                         ! Snow amount on sea-ice
*D AJG1F405.62
               if (s_sea(j).gt.0.0) then
*D AJG1F405.69
     &           +(snow_albedo-alphab)*(1.0-exp(-maskd*s_sea(j)))
*DECLARE RAD_CTL1
*I RAD_CTL1.321 
     &      D1(JSNODEP_SEA+JS),
*I AWI1F403.293
     &      D1(JSNODEP_SEA+JS),
*DECLARE INITA2O1
*D INITA2O1.506,INITA2O1.507
CL 2.8 Snow depth on atmos grid (specifically over sea ice)
      JA_SNOWDEPTH=JSNODEP_SEA
*DECLARE STATMPT1
*I GDR4F305.312
      JSNODEP_SEA    = SI( 95,Sect_No,im_index) ! Snow depth on sea ice
*DECLARE TYPPTRA
*I GRB0F304.269  
     &       JSNODEP_SEA,                ! snow depth on sea-ice 
*B ABX1F404.46
     &  JSNODEP_SEA,
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/Orginal mod:  stratcap.mod
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*DECLARE SETFIL1A
*// simple cap to stop the stratosphere of FAMOUS_XDBUA (no top friction)
*// from exploding in very cold/spiky/low GWD climates
*//
*I SETFIL1A.147   
      LOGICAL L_CAP
*I APB7F401.214
! CAP top-level tropical easterlies that can pull the model down
      L_CAP=.FALSE.
      DO  K=P_LEVELS-3,P_LEVELS
!      DO K=1,P_LEVELS
      DO ROW=1,P_ROWS
        global_row=ROW+datastart(2)-Offy-1  ! global row number
        if (global_row.ge.18 .AND. global_row.le.22) then
          DO I=(ROW-1)*ROW_LENGTH+1+Offx,ROW*ROW_LENGTH-Offx
             if (U(I,K).lt.-125.) then
               U(I,K)=-125.
               L_CAP=.TRUE.
             endif
          ENDDO
        endif
      ENDDO
      ENDDO
      if (L_CAP) write(6,*)"capping u@-125"


*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/Orginal mod:  t20db_mod45_adb1f406
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*ID ADB1F406B
*/ 
*/ This is a FAMOUS mod.
*/
*/ Revised version of DIAG3A and its call from FXCA3A.
*/
*DECLARE LWRAD3A
*I ADB2F404.631
!       4.6             10-05-98                Land flag passed to
!                                               FLUX_CALC.
!                                               (J. M. Edwards)
*/ call flux_calc
*D LWRAD3A.629
*/CNG     &   , ALBEDO_SEA_DIFF, ALBEDO_SEA_DIR, LAND, LWSEA
*/C REPLACED BY Nic Gedney:
     &   , ALBEDO_SEA_DIFF, ALBEDO_SEA_DIR, LAND, FLANDG
     &   , LWSEA
*/
*DECLARE SWRAD3A
*I ADB2F404.1504
!       4.6             10-05-98                Land flag passed to
!                                               FLUX_CALC.
!                                               (J. M. Edwards)
*/ call flux_calc
*D SWRAD3A.760
*/CNG     &   , ALBEDO_SEA_DIFF_G, ALBEDO_SEA_DIR_G, LAND_G
*/C REPLACED BY Nic Gedney:
     &   , ALBEDO_SEA_DIFF_G, ALBEDO_SEA_DIR_G, LAND_G, FLANDG_G
*/
*/ subroutine flux_calc
*DECLARE FXCA3A
*I ADB2F404.557
!       4.6             10-05-98                Land flag added to
!                                               the argument list for
!                                               diagnostics.
!                                               (J. M. Edwards)
*D FXCA3A.80
*/CNG     &   , ALBEDO_SEA_DIFF, ALBEDO_SEA_DIR, LAND
*/C REPLACED BY Nic Gedney:
     &   , ALBEDO_SEA_DIFF, ALBEDO_SEA_DIR, LAND, FLANDG
*I FXCA3A.458
      LOGICAL   !, INTENT(IN)
     &     LAND(NPD_PROFILE)
!            Flag for land points
*/th      REAL     !, INTENT(IN)
*/th     &     FLANDG(NPD_PROFILE)
*/th!            Land fraction
*D ADB1F401.446
!             SEA-ICE FRACTION OF SEA PORTION OF GRID BOX
*D FXCA3A.1515,ADB1F401.471
         CALL R2_COUPLE_DIAG(N_PROFILE, ISOLIR
     &      , ALBEDO_FIELD_DIFF(1, I_BAND), ALBEDO_FIELD_DIR(1, I_BAND)
     &      , ALBEDO_SEA_DIFF(1, I_BAND), ALBEDO_SEA_DIR(1, I_BAND)
*/CNG     &      , LAND, PLANCK_FREEZE_SEA
*/C REPLACED BY Nic Gedney:
     &      , LAND, FLANDG, ICE_FRACTION
     &      , PLANCK_LEADS_SEA
     &      , PLANCK_SOURCE_BAND(1, N_LAYER), THERMAL_GROUND_BAND
     &      , FLUX_TOTAL_BAND(1, 2*N_LAYER+2)
     &      , FLUX_TOTAL_BAND(1, 2*N_LAYER+1)
     &      , FLUX_DIRECT_BAND(1, N_LAYER)
     &      , FLUX_TOTAL_CLEAR_BAND(1, 2*N_LAYER+2)
     &      , FLUX_TOTAL_CLEAR_BAND(1, 2*N_LAYER+1)
*DECLARE DIAG3A
*D DIAG3A.29
!     Dummy arguments
*D DIAG3A.31,DIAG3A.32   
     &    N
!           Length of array
*D DIAG3A.34,DIAG3A.35   
     &    X(N)
!           Array to be zeroed
*D DIAG3A.37
!     Local variables
*D DIAG3A.39,DIAG3A.40   
     &    I
!           loop variable
*D DIAG3A.45
        X(I)=0.0E+00
*D DIAG3A.72,DIAG3A.76  
     &  , SEA_FLUX
     &  , L_SURFACE_DOWN_FLUX, SURFACE_DOWN_FLUX
     &  , L_SURF_DOWN_CLR, SURF_DOWN_CLR
     &  , L_SURF_UP_CLR, SURF_UP_CLR
*/CNG     &  , L_FLUX_BELOW_690NM_SURF, FLUX_BELOW_690NM_SURF
*/CNG replaced by:
     &  , L_FLUX_BELOW_690NM_SURF
*D DIAG3A.85
!     Dummy arguments
*D DIAG3A.87
!     Dimensions of arrays
*D DIAG3A.89,DIAG3A.90   
     &    NPD_PROFILE
!           Maximum number of atmospheric profiles
*D DIAG3A.93,DIAG3A.94   
     &    N_PROFILE
!           Number of atmospheric profiles
*D DIAG3A.96
!     Switches for diagnostics:
*D DIAG3A.98,DIAG3A.105  
     &    L_FLUX_BELOW_690NM_SURF
!           Flux below 690nm at surface to be calculated
     &  , L_SURFACE_DOWN_FLUX
!           Downward surface flux required
     &  , L_SURF_DOWN_CLR
!           Calculate downward clear flux
     &  , L_SURF_UP_CLR
!           Calculate upward clear flux
*D DIAG3A.107
!     Surface fluxes for coupling or diagnostic use
*D DIAG3A.109,DIAG3A.118  
     &    SEA_FLUX(NPD_PROFILE)
!           Net downward flux into sea
     &  , SURFACE_DOWN_FLUX(NPD_PROFILE)
!           Downward flux at surface
     &  , SURF_DOWN_CLR(NPD_PROFILE)
!           Clear-sky downward flux at surface
     &  , SURF_UP_CLR(NPD_PROFILE)
!           Clear-sky upward flux at surface
*/CNG     &  , FLUX_BELOW_690NM_SURF(NPD_PROFILE)
*/CNG!           Surface flux below 690nm
*D DIAG3A.125
        CALL R2_ZERO_1D(N_PROFILE, SURFACE_DOWN_FLUX)
*D DIAG3A.129
        CALL R2_ZERO_1D(N_PROFILE, SURF_DOWN_CLR)
*D DIAG3A.133
        CALL R2_ZERO_1D(N_PROFILE, SURF_UP_CLR)
*D DIAG3A.137
*/CNG        CALL R2_ZERO_1D(N_PROFILE, FLUX_BELOW_690NM_SURF)
*I ADB1F401.131   
!       4.6             07-05-99                Calculation of fluxes
!                                               into the sea changed
!                                               to use albedos for
!                                               sea. Code for obsolete
!                                               net solvers removed.
!                                               (J. M. Edwards)
*D DIAG3A.163,DIAG3A.174  
      SUBROUTINE R2_COUPLE_DIAG(N_PROFILE, ISOLIR
     &  , ALBEDO_FIELD_DIFF, ALBEDO_FIELD_DIR
     &  , ALBEDO_SEA_DIFF, ALBEDO_SEA_DIR
*/CNG     &  , LAND, PLANCK_FREEZE_SEA
*/CNG Replaced by Nic Gedney:
     &  , LAND, FLANDG, ICE_FRACTION
     &  , PLANCK_LEADS_SEA
     &  , PLANCK_AIR_SURFACE, THERMAL_SOURCE_GROUND
     &  , FLUX_DOWN, FLUX_UP, FLUX_DIRECT
     &  , FLUX_DOWN_CLEAR, FLUX_UP_CLEAR, FLUX_DIRECT_CLEAR
     &  , WEIGHT_690NM
     &  , SEA_FLUX
     &  , L_SURFACE_DOWN_FLUX, SURFACE_DOWN_FLUX
     &  , L_SURF_DOWN_CLR, SURF_DOWN_CLR
     &  , L_SURF_UP_CLR, SURF_UP_CLR
*/CNG     &  , L_FLUX_BELOW_690NM_SURF, FLUX_BELOW_690NM_SURF
*/CNG replaced by:
     &  , L_FLUX_BELOW_690NM_SURF
*/
*D DIAG3A.183,DIAG3A.184  
!     Comdecks included
!     Spectral regions
*D DIAG3A.187
!     Dummy Arguments
*D DIAG3A.189
!     Dimensions of arrays
*D DIAG3A.191,DIAG3A.192  
     &    NPD_PROFILE
!           Maximum number of atmospheric profiles
*D DIAG3A.195,DIAG3A.198  
     &    N_PROFILE
!           Number of atmospheric profiles
     &  , ISOLIR
!           Spectral region
*D DIAG3A.200
!     Logical switches for the code
*D DIAG3A.202,DIAG3A.203  
     &    L_NET
!           Flag for net fluxes
*D DIAG3A.205
!     Switches for diagnostics:
*D DIAG3A.207,DIAG3A.214  
     &    L_FLUX_BELOW_690NM_SURF
!           Flux below 690nm at surface to be calculated
     &  , L_SURFACE_DOWN_FLUX
!           Downward surface flux required
     &  , L_SURF_DOWN_CLR
!           Calculate downward clear flux
     &  , L_SURF_UP_CLR
!           Calculate upward clear flux
*D DIAG3A.216
!     Albedos
*D DIAG3A.218,DIAG3A.225  
     &    ALBEDO_FIELD_DIFF(NPD_PROFILE)
!           Diffuse albedo meaned over grid box
     &  , ALBEDO_FIELD_DIR(NPD_PROFILE)
!           Direct albedo meaned over grid box
     &  , ALBEDO_SEA_DIFF(NPD_PROFILE)
!           Diffuse albedo of open sea
     &  , ALBEDO_SEA_DIR(NPD_PROFILE)
!           Direct albedo meaned of open sea
*D DIAG3A.228,ADB1F401.136  
     &    THERMAL_SOURCE_GROUND(NPD_PROFILE)
!           Thermal source at ground
     &  , PLANCK_AIR_SURFACE(NPD_PROFILE)
!           Planck function at near-surface air temperature in band
*D ADB1F401.137,ADB1F401.142  
!     Arguments relating to sea ice.
      LOGICAL   !, INTENT(IN)
     &    LAND(NPD_PROFILE)
!           Land-sea mask
*/CNG Next 5 lines added by N. Gedney:
      REAL      !, INTENT(IN)
     &     FLANDG(NPD_PROFILE)
!            Land fraction
     &   , ICE_FRACTION(NPD_PROFILE)
!            FRACTION OF SEA-ICE IN SEA PORTION OF GRID BOX!
*/
*D ADB1F401.144,ADB1F401.148  
*/CNG     &    PLANCK_FREEZE_SEA
*/CNG!           Planck function over freezing sea
     &    PLANCK_LEADS_SEA(NPD_PROFILE)
!           Planck function over sea leads
*D DIAG3A.232,DIAG3A.233  
     &    WEIGHT_690NM
!           Weighting applied to band for region below 690 nm
*D DIAG3A.235
!     Calculated fluxes
*D DIAG3A.237,DIAG3A.248  
     &    FLUX_DOWN(NPD_PROFILE)
!           Total downward or net flux at surface
     &  , FLUX_DIRECT(NPD_PROFILE)
!           Direct solar flux at surface
     &  , FLUX_UP(NPD_PROFILE)
!           Upward flux at surface
     &  , FLUX_DOWN_CLEAR(NPD_PROFILE)
!           Total clear-sky downward or net flux at surface
     &  , FLUX_UP_CLEAR(NPD_PROFILE)
!           Clear-sky upward flux at surface
     &  , FLUX_DIRECT_CLEAR(NPD_PROFILE)
!           Clear-sky direct solar flux at surface
*D DIAG3A.251
!     Surface fluxes for coupling or diagnostic use
*D DIAG3A.253,DIAG3A.262  
     &    SEA_FLUX(NPD_PROFILE)
!           Net downward flux into sea
     &  , SURFACE_DOWN_FLUX(NPD_PROFILE)
!           Downward flux at surface
     &  , SURF_DOWN_CLR(NPD_PROFILE)
!           Clear-sky downward flux at surface
     &  , SURF_UP_CLR(NPD_PROFILE)
!           Clear-sky upward flux at surface
*/CNG     &  , FLUX_BELOW_690NM_SURF(NPD_PROFILE)
*/CNG!           Surface flux below 690nm
*D DIAG3A.265
!     Local variables
*D DIAG3A.267,DIAG3A.268  
     &    L
!           Loop variable
*D DIAG3A.272,DIAG3A.313  
!     This is the flux into the sea over the ice-free parts of the
!     grid-box. The model is that the downward fluxes are uniform
!     across the grid-box, but the upward fluxes are not. At this
!     stage no weighting by the actual ice-free area is carried out:
!     that will be done later.
      IF (ISOLIR.EQ.IP_SOLAR) THEN
        DO L=1, N_PROFILE
*/CNG          IF (.NOT.LAND(L)) THEN
*/CNG Replaced by Nic Gedney:
          IF (FLANDG(L).LT.1.0.AND.ICE_FRACTION(L).LT.1.0) THEN
            SEA_FLUX(L)=SEA_FLUX(L)
     &        +FLUX_DOWN(L)*(1.0E+00-ALBEDO_SEA_DIFF(L))
     &        +FLUX_DIRECT(L)*(ALBEDO_SEA_DIFF(L)-ALBEDO_SEA_DIR(L))
*/
          ENDIF
        ENDDO
      ELSE IF (ISOLIR.EQ.IP_INFRA_RED) THEN
        DO L=1, N_PROFILE
*/CNG          IF (.NOT.LAND(L)) THEN
*/CNG Replaced by Nic Gedney:
          IF (FLANDG(L).LT.1.0.AND.ICE_FRACTION(L).LT.1.0) THEN
            SEA_FLUX(L)=SEA_FLUX(L)
     &        +(1.0E+00-ALBEDO_SEA_DIFF(L))
     &        *(FLUX_DOWN(L)+PLANCK_AIR_SURFACE(L)
     &        -PLANCK_LEADS_SEA(L))
*/
          ENDIF
         ENDDO
*D DIAG3A.317,DIAG3A.338  
        IF (ISOLIR.EQ.IP_SOLAR) THEN
          DO L=1, N_PROFILE
            SURFACE_DOWN_FLUX(L)=SURFACE_DOWN_FLUX(L)
     &        +FLUX_DOWN(L)
*/
          ENDDO
        ELSE IF (ISOLIR.EQ.IP_INFRA_RED) THEN
          DO L=1, N_PROFILE
            SURFACE_DOWN_FLUX(L)=SURFACE_DOWN_FLUX(L)
     &        +FLUX_DOWN(L)+PLANCK_AIR_SURFACE(L)
          ENDDO
        ENDIF
*D DIAG3A.342,DIAG3A.365  
        IF (ISOLIR.EQ.IP_SOLAR) THEN
          DO L=1, N_PROFILE
            SURF_DOWN_CLR(L)=SURF_DOWN_CLR(L)
     &        +FLUX_DOWN_CLEAR(L)
          ENDDO
        ELSE IF (ISOLIR.EQ.IP_INFRA_RED) THEN
          DO L=1, N_PROFILE
            SURF_DOWN_CLR(L)=SURF_DOWN_CLR(L)
     &        +FLUX_DOWN_CLEAR(L)+PLANCK_AIR_SURFACE(L)
          ENDDO
        ENDIF
*D DIAG3A.369,DIAG3A.393  
        IF (ISOLIR.EQ.IP_SOLAR) THEN
          DO L=1, N_PROFILE
            SURF_UP_CLR(L)=SURF_UP_CLR(L)
     &        +FLUX_UP_CLEAR(L)
          ENDDO
        ELSE IF (ISOLIR.EQ.IP_INFRA_RED) THEN
          DO L=1, N_PROFILE
            SURF_UP_CLR(L)=SURF_UP_CLR(L)
     &        +FLUX_UP_CLEAR(L)+PLANCK_AIR_SURFACE(L)
          ENDDO
        ENDIF

*D DIAG3A.396
*/CNG!     This diagnostic is available only in the solar region. Over
*/CNG!     sea-points it refers only to the flux over the open sea
*/CNG!     (see the comments about sea_flux above). Over land, both the
*/CNG!     upward and downward fluxes are taken as uniform.
*D DIAG3A.398,DIAG3A.413  
*/CNG        IF (ISOLIR.EQ.IP_SOLAR) THEN
*/CNG          DO L=1, N_PROFILE
*/CNG            IF (LAND(L)) THEN
*/CNG              FLUX_BELOW_690NM_SURF(L)=FLUX_BELOW_690NM_SURF(L)
*/CNG     &          +WEIGHT_690NM*(FLUX_DOWN(L)-FLUX_UP(L))
*/CNG            ELSE
*/CNG              FLUX_BELOW_690NM_SURF(L)=FLUX_BELOW_690NM_SURF(L)
*/CNG     &          +WEIGHT_690NM
*/CNG     &          *(FLUX_DOWN(L)*(1.0E+00-ALBEDO_SEA_DIFF(L))
*/CNG     &          +FLUX_DIRECT(L)*(ALBEDO_SEA_DIFF(L)-ALBEDO_SEA_DIR(L)))
*/CNG            ENDIF
*/CNG          ENDDO
*/CNG        ENDIF
*/CNG Replaced by Nic Gedney:






