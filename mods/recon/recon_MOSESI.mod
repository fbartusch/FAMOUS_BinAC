*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/Orginal mod:  ctile6
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*ID CTILE6
*/---------------------------------------------------------------------
*/---------------------------------------------------------------------
*/ Set up separate land and sea surface temperatures in the 
*/ reconfiguration
*/ This is a FAMOUS mod. 
*/---------------------------------------------------------------------
*/---------------------------------------------------------------------
*/.....................................................................
*/---------------------------------------------------------------------
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
     &,LAND0P5(P_FIELD_OUT)         ! LAND MASK (TRUE if land frac>0.5)
*/
*I CONTROL1.1034
C Tstar for land, if not directly available set from old Tstar 
C i.e.land/sea
 
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
*/.....................................................................
*/---------------------------------------------------------------------
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
*/.....................................................................
*/---------------------------------------------------------------------
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
*/---------------------------------------------------------------------
*/---------------------------------------------------------------------
*/---------------------------------------------------------------------
*/ New prognostics added, which may or may not be read in from initial
*/ dump.
*/
*I CONTROL1.1416
     &.OR.PP_ITEMC_OUT(J).EQ.406.OR.PP_ITEMC_OUT(J).EQ.407
     &.OR.PP_ITEMC_OUT(J).EQ.408.OR.PP_ITEMC_OUT(J).EQ.409
     &.OR.PP_ITEMC_OUT(J).EQ.410
*/
*/---------------------------------------------------------------------
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
*/.....................................................................
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
          ELSEIF (PP_ITEMC_OUT(J).EQ.412.AND. !Initialise SEA roughness
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
*/.....................................................................
*/---------------------------------------------------------------------
*/.....................................................................
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
*/.....................................................................
*/---------------------------------------------------------------------
*/.....................................................................
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
     &       LAND(P_FIELD),   ! WORK LAND mask
     &       LAND0P5(P_FIELD),! OUT LAND mask (TRUE if land fraction>0.5)
     &       SEA(P_FIELD),    ! WORK SEA mask
     &       LTSTAR_SICE      ! IN TRUE if TSTAR_SICE has been read in
C                             ! from input dump.
C                             ! If FALSE set to TSTAR_SEA.
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
*/***TEMPORARY:  Set value of Z0 over non-land points to 0.1,for testing
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
     &       JICE_FRACTION,          ! fraction of sea-ice in sea portion
C                                    ! of gridbox
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
*/--------------------------------------------------------------------
*/--------------------------------------------------------------------
*/--------------------------------------------------------------------
*DECLARE CANCLSTA
*I  GDG2F405.16
!          08/99  Comment on the first User ancill so it's clear that
!                 this contains the land fraction.
!                 N. Gedney
*/
*D CANCLSTA.69
!  48  1  301  15  LAND FRACTION: User ancillary field 1
*/--------------------------------------------------------------------
*/--------------------------------------------------------------------
*/--------------------------------------------------------------------
*DECLARE GRIB_UM1
*I GRIB_UM1.534
            WRITE(7,'('' *ERROR* 5 HAVE LET LEADS TEMPERATURE VARY'')')
            CALL ABORT
*/
*/--------------------------------------------------------------------
*/--------------------------------------------------------------------
*/--------------------------------------------------------------------
*/ Replace JLAND with JLAND0P5 in physics routines that dont have tiling
*/--------------------------------------------------------------------
*/--------------------------------------------------------------------
*/--------------------------------------------------------------------
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
*/---------------------------------------------------------------------
*/---------------------------------------------------------------------
*/---------------------------------------------------------------------
*/ Correct the land zonal mean diagnostics so they use land/sea fraction
*/---------------------------------------------------------------------
*/---------------------------------------------------------------------
*/---------------------------------------------------------------------
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
*/---------------------------------------------------------------------
*/---------------------------------------------------------------------
*/---------------------------------------------------------------------
*DECLARE CNTLATM
*/
*I CNTLATM.112
     &   LTLEADS        ,           !  Let leads temp vary if .TRUE.
*D CNTLATM.136
     & LFROUDE, LGWLINP, LLINTS, LWHITBROM, LEMCORR, LTLEADS,
*D CNTLATM.166
     & LFROUDE, LGWLINP, LLINTS, LWHITBROM, LEMCORR, LTLEADS,
*DECLARE FREEZE
*B FREEZE.127
              IF(-DPSIDT*TSL(I,N)/SATHH(I).LT.0) THEN
              WRITE(6,*)"OOOPS B PARAM",I,B(I)
              B(I)=-1.0
              ENDIF
*/
*/---------------------------------------------------------------------
*/---------------------------------------------------------------------
*/---------------------------------------------------------------------
