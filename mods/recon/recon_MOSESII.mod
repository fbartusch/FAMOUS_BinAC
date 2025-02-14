*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/Orginal mod:  arerf406_ctile
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*IDENT ARERF406C
*/ 
*/ MOSES 2.2 + Coastal Tiling
*/ 
*/ Based on the MOSES 2.2 mod arerf406 (Richard Essery, July 99) 
*/ plus modifications to include new coastal tiling prognostics.
*/
*/ Reconfiguration assumes fields 505,506,507,508,509 and 510 are
*/ already in input dump.
*/ 
*/ Decks modified: TYPSIZE, RECONF1, SCONTROL, CONTROL1, ADDRES1,
*/  PSLIMS1, CNTLATM, TYPPTRA, STATMPT1
*/
*/ Annette Osprey 16 October 2007
*/
*/
*//-------------
*DECLARE TYPSIZE
*//-------------
*I TYPSIZE.25
     &      ,NTILES               ! IN: No of land surface tiles
*I TYPSIZE.127   
     & NTILES,
*//
*//
*//-------------
*DECLARE RECONF1
*//-------------
*I UDG2F305.554   
     &,               NTILES
*D UDG1F404.39    
     & ,POINTS_PER_OCEAN_LEVEL,DUMP_PACK,LAND_FIELD,NTILES   
*//
*//
*//--------------
*DECLARE SCONTROL
*//--------------
*D SCONTROL.53 
     & ,POINTS_PER_OCEAN_LEVEL,DUMP_PACK,LAND_POINTS_UMUI,NTILES,
*I SCONTROL.96    
      INTEGER      NTILES           ! No of land-surface tiles from
                                    ! namelist RECON
*D SCONTROL.366
     & ,POINTS_PER_OCEAN_LEVEL,DUMP_PACK,LAND_POINTS_UMUI,NTILES,
*//
*//   
*//--------------
*DECLARE CONTROL1
*//--------------
*D UDG1F404.4
     & ,POINTS_PER_OCEAN_LEVEL,DUMP_PACK,LAND_POINTS_UMUI,NTILES,
*I UDG1F404.6     
      INTEGER      NTILES           !No of land-surface tiles from
                                    !namelist RECON    
*D GDR7F404.44
!         Canopy Water on Tiles
*D GDR7F404.47
!         Canopy Capacity on Tiles
*I GDR7F404.61
!         Snow Amount on Tiles
     &    .or. (PP_ITEMC_OUT(J).eq.235 .and. MODEL.eq. ATMOS_IM .and.
     &          (L_TRIFFID.or.L_VEG_FRACS) )
!         Maximum infiltration rate on Tiles
     &    .or. (PP_ITEMC_OUT(J).eq.236 .and. MODEL.eq. ATMOS_IM .and.
     &          (L_TRIFFID.or.L_VEG_FRACS) )
*I GDR7F404.121 
     &             PP_ITEMC_OUT(J).EQ.236    .OR.  
*D GDR7F404.150,GDR7F404.151
            IF(PP_ITEMC_OUT(J).EQ.230) N_PSL=NTILES
            IF(PP_ITEMC_OUT(J).EQ.234) N_PSL=NTILES
            IF(PP_ITEMC_OUT(J).EQ.236) N_PSL=NTILES
*D GDR7F404.330
!           write out canopy water on tiles to output dump
*D GDR7F404.332  
            DO I=1,NTILES
            IF (I.GE.7) THEN
!           No canopy water on lake, soil or ice tiles
              DO K=1,LAND_POINTS
                D1_OUT(K) = 0.
              ENDDO
            ENDIF
*D GDR7F404.362
            DO I=1,LAND_POINTS
*D GDR7F404.367   
            DO I=1,NTILES
            CALL WRITFLDS (NFTOUT,1,PP_POS_OUT(POS)+I-1,
*D GDR7F404.369      
     &                     D1_TEMP,LAND_POINTS,FIXHD_OUT,
*D GDR7F404.376,GDR7F404.377   
            WRITE (6,*) ' SNOW GRAIN SIZE (Stash Code 231)',    
     &                  ' Pseudo Level ',I,' initialised to 50.0'
            ENDDO
*D ABX2F405.61    
            N_PSL = NTILES
*I GDR7F404.444

          ELSEIF ((PP_ITEMC_OUT(J).EQ.235)   .AND.                      
     &             MODEL.EQ.ATMOS_IM         .AND.                      
     &            (L_TRIFFID.OR.L_VEG_FRACS) .AND.                      
     &             PP_SOURCE_OUT(J).EQ.8) THEN                          
                                                                        
!           S=8 is not set in the UMUI for this field. It is set in     
!           loop 1400 if no field is found in the input dump.           
                                                                        
            WRITE (6,*) ' '                                             
            WRITE (6,*) ' Prognostic - Stash Code ',PP_ITEMC_OUT(J),    
     &                  ' - not found in input dump.'                   
                                                                        
! If not present in the input dump, item 235 (snow amount on tiles)    
! is initialised to item 23 (snow amount).               
                                                                        
!           Find snow amount in output dump                     
            CALL LOCATE (23,PP_ITEMC_OUT,N_TYPES_OUT,POS)               
            IF (POS.EQ.0) THEN                                          
              WRITE (6,*) ' Snow Amount not in output dump.'    
              WRITE (6,*) ' Prognostic - Stash Code ',PP_ITEMC_OUT(J),  
     &                    ' cannot be initialised.'                     
              CALL ABORT                                                
            ENDIF                                                       
                                                                        
!           Read in snow amount                                 
            CALL READFLDS (NFTOUT,1,PP_POS_OUT(POS),                    
     &                     LOOKUP_OUT,LEN1_LOOKUP_OUT,                  
     &                     D1_TEMP,P_FIELD_OUT,FIXHD_OUT,               
*CALL ARGPPX                                                            
     &                     ICODE,CMESSAGE)                              
            IF (ICODE.GT.0) THEN                                        
              WRITE (6,*) ' Problem in READFLDS for Snow Amount',     
     &                    ' Stash Code ',PP_ITEMC_OUT(J)                
              CALL ABORT_IO ('CONTROL',CMESSAGE,ICODE,NFTOUT)           
            END IF                                                      
                                                                        
!           Set up field on land points                                 
            CALL TO_LAND_POINTS(D1_TEMP,D1_TEMP,                        
     &                   LAND_SEA_MASK_OUT,P_FIELD_OUT,LAND_POINTS)     
                                                                        
!           Find position of field in output dump                       
            CALL LOCATE (PP_ITEMC_OUT(J),PP_ITEMC_OUT,N_TYPES_OUT,POS)  
                                                                        
!           Set no of pseudo levels                                     
            N_PSL = NTILES                                              
                                                                        
!           Write fields to output dump.                                
            DO I=1,N_PSL                                                
              CALL WRITFLDS (NFTOUT,1,PP_POS_OUT(POS)+I-1,              
     &                       LOOKUP_OUT,LEN1_LOOKUP_OUT,                
     &                       D1_TEMP,LAND_POINTS,FIXHD_OUT,             
*CALL ARGPPX                                                            
     &                       ICODE,CMESSAGE)                            
              IF (ICODE.GT.0) THEN                                      
                WRITE (6,*) ' Problem in WRITFLDS - ',                  
     &                      ' Stash Code ',PP_ITEMC_OUT(J),             
     &                      ' Pseudo level ',I                          
                CALL ABORT_IO ('CONTROL',CMESSAGE,ICODE,NFTOUT)         
              END IF                                                    
              WRITE (6,*) ' Prognostic - Stash Code ',PP_ITEMC_OUT(J),  
     &                    ' Pseudo level ',I,                           
     &                    ' initialised to Snow Amount'         
            ENDDO                                                       
*//
*//
*//-------------
*DECLARE ADDRES1
*//-------------
*D ABX2F404.79,ABX2F404.80        
! All surface tiles
          ILOUT = NTILES
*//
*//
*//-------------
*DECLARE PSLIMS1
*//-------------
*D ABX1F404.16,ABX1F404.17  
!Direct vegetation parametrization: all surface tiles
        ILAST=NTILES
*//
*//
*//-------------
*DECLARE CNTLATM
*//-------------
*I CNTLATM.112   
     &   LTLEADS        ,           !  Let leads temp vary if .TRUE.    
*D CNTLATM.136
     & LFROUDE, LGWLINP, LLINTS, LWHITBROM, LEMCORR, LTLEADS,           
*D CNTLATM.166
     & LFROUDE, LGWLINP, LLINTS, LWHITBROM, LEMCORR, LTLEADS,           
*//
*//
*//-------------
*DECLARE TYPPTRA
*//-------------
*D ABX1F404.24
*I TYPPTRA.36    
     &       JFRAC_LAND,             ! Land fraction in grid box
     &       JTSTAR_LAND,            ! Land surface temperature
     &       JTSTAR_SEA,             ! Sea surface temperature
     &       JTSTAR_SICE,            ! Sea-ice surface temperature
     &       JSICE_ALB,              ! Sea-ice albedo
     &       JLAND_ALB,              ! Mean land albedo
*D ABX1F404.41,ABX1F404.43   
     &       JCAN_WATER_TYP,         ! Canopy water content on tiles    
     &       JCATCH_TYP,             ! Canopy capacity on tiles         
     &       JINFIL_TYP,             ! Max infiltration rate on tiles   
     &       JRGRAIN_TYP,            ! Snow grain size on tiles         
     &       JSNODEP_TYP,            ! Snow depth on tiles              
*D ABX1F404.46,AJS1F401.24   
     &  JSNSOOT, JTSTAR_ANOM, 
     &  JFRAC_LAND, JTSTAR_LAND, JTSTAR_SEA, JTSTAR_SICE,
     &  JSICE_ALB, JLAND_ALB,
     &  JZH, JZ0, JLAND, JICE_FRACTION,                    
*D ABX1F404.50,ABX1F404.51   
     &  JRSP_S_ACC, JTSNOW, JCAN_WATER_TYP, JCATCH_TYP, JINFIL_TYP,     
     &  JRGRAIN_TYP, JSNODEP_TYP, JTSTAR_TYP, JZ0_TYP                   
*//
*//
*//-------------
*DECLARE STATMPT1
*//-------------
*I GSM3F404.7     

! Coastal tiling fields
      JFRAC_LAND     = SI(505,Sect_No,im_index)                         
      JTSTAR_LAND    = SI(506,Sect_No,im_index)                         
      JTSTAR_SEA     = SI(507,Sect_No,im_index)                         
      JTSTAR_SICE    = SI(508,Sect_No,im_index)                         
      JSICE_ALB      = SI(509,Sect_No,im_index)                         
      JLAND_ALB      = SI(510,Sect_No,im_index)                         
                             
*D ABX1F404.74,ABX1F404.78   
      JCAN_WATER_TYP= SI(229,Sect_No,im_index) ! Canopy water content   
C                                              ! on tiles               
      JCATCH_TYP    = SI(230,Sect_No,im_index) ! Canopy capacity on     
C                                              ! tiles                  
      JRGRAIN_TYP   = SI(231,Sect_No,im_index) ! Snow grain size on     
C                                              ! tiles                  
*I ABX1F404.81    
      JSNODEP_TYP   = SI(235,Sect_No,im_index) ! Tiled snow depth       
      JINFIL_TYP    = SI(236,Sect_No,im_index) ! Max tile infilt rate   
