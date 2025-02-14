*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/Orginal mod:  abort.mod
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*ID ABORTMOD
*/
*/ On some machines (e.g. hp,ibm) abort doesn't take any arguments
*/ this causes a compilation error. If you declare abort as external
*/ compiler doesn't give an error but abort is still called, without
*/ writing the error message.
*/
*DECLARE FIELDOP1
*D FIELDOP1.105
      External readff,setpos,ioerror,fieldop_main,abort
*/
*DECLARE FIELDCOS
*D FIELDCOS.35
      EXTERNAL READFF,SETPOS,IOERROR,READ_WRITE,ABORT
*/
*DECLARE DUMMYVEG
*I DUMMYVEG.30

      EXTERNAL ABORT
*/
*DECLARE RDLSM1A
*B RDLSM1A.60

      EXTERNAL ABORT
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/Orginal mod:  dummy.mod
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*ID DUMMY
*/
*/  Dummy routines to remove unresolved externals linking errors
*/
*DECK DUMMY1

*IF DEF,A18_1A,OR,DEF,A18_2A,OR,DEF,O35_1A
C
*ELSE
      subroutine buffin_shmem()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'buffin_shmem'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'buffin_shmem'
      call abort()

      stop
      end

      subroutine buffin_acobs()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'buffin_acobs'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'buffin_acobs'
      call abort()

      stop
      end

      subroutine swapbounds_shmem()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'swapbounds_shmem'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'swapbounds_shmem'
      call abort()

      stop
      end

      subroutine swapbounds_sum()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'swapbounds_sum'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'swapbounds_sum'
      call abort()

      stop
      end
*ENDIF

*IF DEF,A18_1A,OR,DEF,A18_2A,OR,DEF,RECON
C
*ELSE
      subroutine stratq()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'stratq'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'stratq'
      call abort()

      stop
      end
*ENDIF

*IF DEF,A18_1A,OR,DEF,A18_2A
C
*ELSE
      subroutine ac()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'ac'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'ac'
      call abort()

      stop
      end

      subroutine var_umprocessing()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'var_umprocessing'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'var_umprocessing'
      call abort()

      stop
      end

      subroutine var_umsetup()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'var_umsetup'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'var_umsetup'
      call abort()

      stop
      end

      subroutine ac_init()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'ac_init'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'ac_init'
      call abort()

      stop
      end

      subroutine iau_ctl()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'iau_ctl'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'iau_ctl'
      call abort()

      stop
      end
*ENDIF

*IF DEF,A11_1A
C
*ELSE
      subroutine set_trac()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'set_trac'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'set_trac'
      call abort()

      stop
      end

      subroutine trac_vert_adv()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'trac_vert_adv'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'trac_vert_adv'
      call abort()

      stop
      end

      subroutine trac_adv()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'trac_adv'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'trac_adv'
      call abort()

      stop
      end

      subroutine trbdry()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'trbdry'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'trbdry'
      call abort()

      stop
      end
*ENDIF

*IF DEF,A11_1A,OR,DEF,A03_7A,OR,DEF,A03_6A
C
*ELSE
      subroutine trsrce()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'trsrce'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'trsrce'
      call abort()

      stop
      end
*ENDIF

*IF DEF,A01_1A,OR,DEF,A01_1B,OR,DEF,A01_2A,OR,DEF,A01_2B
C
*ELSE
      subroutine swlkin()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'swlkin'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'swlkin'
      call abort()

      stop
      end

      subroutine swdkdi()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'swdkdi'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'swdkdi'
      call abort()

      stop
      end

      subroutine swrad()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'swrad'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'swrad'
      call abort()

      stop
      end
*ENDIF

*IF DEF,A02_1A,OR,DEF,A02_1B,OR,DEF,A02_1C
C
*ELSE
      subroutine lwlkin()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'lwlkin'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'lwlkin'
      call abort()

      stop
      end

      subroutine lwrad()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'lwrad'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'lwrad'
      call abort()

      stop
      end
*ENDIF

*IF DEF,A70_1A,OR,DEF,A70_1B
C
*IF DEF,A01_3A,OR,DEF,A02_3A
C
*ELSE
      subroutine r2_sw_specin()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'r2_sw_specin'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'r2_sw_specin'
      call abort()

      stop
      end

      subroutine r2_lw_specin()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'r2_lw_specin'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'r2_lw_specin'
      call abort()

      stop
      end

      subroutine tropin()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'tropin'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'tropin'
      call abort()

      stop
      end

      subroutine r2_global_cloud_top()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'r2_global_cloud_top'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'r2_global_cloud_top'
      call abort()

      stop
      end
*ENDIF
*ELSE
      subroutine r2_sw_specin()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'r2_sw_specin'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'r2_sw_specin'
      call abort()

      stop
      end

      subroutine r2_lw_specin()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'r2_lw_specin'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'r2_lw_specin'
      call abort()

      stop
      end

      subroutine tropin()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'tropin'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'tropin'
      call abort()

      stop
      end

      subroutine r2_global_cloud_top()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'r2_global_cloud_top'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'r2_global_cloud_top'
      call abort()

      stop
      end

      subroutine gas_calc()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'gas_calc'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'gas_calc'
      call abort()

      stop
      end
*ENDIF

*IF DEF,A01_3A
C
*ELSE
      subroutine r2_swrad()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'r2_swrad'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'r2_swrad'
      call abort()

      stop
      end
*ENDIF

*IF DEF,A02_3A
C
*ELSE
      subroutine r2_lwrad()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'r2_lwrad'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'r2_lwrad'
      call abort()

      stop
      end
*ENDIF

*IF DEF,A09_2A,OR,DEF,A09_2B
C
*ELSE
      subroutine area_cld()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'area_cld'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'area_cld'
      call abort()

      stop
      end
*ENDIF

*IF DEF,A07_1A,OR,DEF,A07_1B
C
*ELSE
      subroutine vdif_ctl()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'vdif_ctl'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'vdif_ctl'
      call abort()

      stop
      end

      subroutine vert_dif()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'vert_dif'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'vert_dif'
      call abort()

      stop
      end
*ENDIF

*IF DEF,A09_2B
C
*ELSE
      subroutine rhcrit_calc()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'rhcrit_calc'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'rhcrit_calc'
      call abort()

      stop
      end
*ENDIF

*IF DEF,CONTROL,AND,DEF,WAVE
C
*ELSE
      subroutine stwvgt()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'stwvgt'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'stwvgt'
      call abort()

      stop
      end
*ENDIF

*IF DEF,CONTROL,AND,DEF,OCEAN
C
*ELSE
      subroutine stocgt()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'stocgt'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'stocgt'
      call abort()

      stop
      end
*ENDIF

*IF DEF,CONTROL,AND,DEF,OCNASSM
C
*ELSE
      subroutine oc_ac_ctl()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'oc_ac_ctl'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'oc_ac_ctl'
      call abort()

      stop
      end
*ENDIF

*IF DEF,A03_7A
C
*ELSE
      subroutine rad_moses()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'rad_moses'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'rad_moses'
      call abort()

      stop
      end
*ENDIF

*IF DEF,A17_1A
C
*ELSE
      subroutine new2old()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'new2old'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'new2old'
      call abort()

      stop
      end

      subroutine sootscav()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'sootscav'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'sootscav'
      call abort()

      stop
      end

      subroutine sulphur()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'sulphur'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'sulphur'
      call abort()

      stop
      end

      subroutine gravsett()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'gravsett'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'gravsett'
      call abort()

      stop
      end
*ENDIF

*IF DEF,O35_1A
C
*ELSE
      subroutine oa_zero()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'oa_zero'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'oa_zero'
      call abort()

      stop
      end

      subroutine oa_int_lev()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'oa_int_lev'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'oa_int_lev'
      call abort()

      stop
      end

      subroutine oa_int_1d()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'oa_int_1d'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'oa_int_1d'
      call abort()

      stop
      end
*ENDIF

*IF DEF,C90_1A,OR,DEF,C90_2A,OR,DEF,C90_2B
C
*ELSE
      subroutine p_to_cv()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'p_to_cv'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'p_to_cv'
      call abort()

      stop
      end

      subroutine p_to_cu()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'p_to_cu'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'p_to_cu'
      call abort()

      stop
      end

      subroutine p_to_uv()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'p_to_uv'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'p_to_uv'
      call abort()

      stop
      end
*ENDIF

*IF DEF,SEAICE
C
*ELSE
      subroutine cnvstop()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'cnvstop'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'cnvstop'
      call abort()

      stop
      end
*ENDIF

*IF DEF,A87_1A
C
*ELSE
      subroutine zonm_atm()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'zonm_atm'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'zonm_atm'
      call abort()

      stop
      end
*ENDIF

*IF DEF,A14_1A,OR,DEF,A14_1B
C
*ELSE
      subroutine init_emcorr()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'init_emcorr'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'init_emcorr'
      call abort()

      stop
      end

      subroutine add_eng_corr()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'add_eng_corr'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'add_eng_corr'
      call abort()

      stop
      end

      subroutine eng_mass_diag()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'eng_mass_diag'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'eng_mass_diag'
      call abort()

      stop
      end

      subroutine cal_eng_mass_corr()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'cal_eng_mass_corr'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'cal_eng_mass_corr'
      call abort()

      stop
      end

      subroutine flux_diag()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'flux_diag'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'flux_diag'
      call abort()

      stop
      end
*ENDIF

*IF DEF,A06_1A,OR,DEF,A06_2A,OR,DEF,A06_3A,OR,DEF,A06_3B
C
*ELSE
      subroutine gwav_intctl()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'gwav_intctl'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'gwav_intctl'
      call abort()

      stop
      end

*ENDIF

*IF DEF,T3E,OR,DEF,CRAY
C
*ELSE
      subroutine ibm2cri()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'ibm2cri'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'ibm2cri'
      call abort()

      stop
      end

      subroutine cri2ibm()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'cri2ibm'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'cri2ibm'
      call abort()

      stop
      end

      subroutine strmov()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'strmov'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'strmov'
      call abort()

      stop
      end

      subroutine movbit()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'movbit'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'movbit'
      call abort()

      stop
      end
*ENDIF

      subroutine buffout_shmem()

      write(0,*) 'Error you have called an undefined subroutine ',
     :           'buffout_shmem'
      write(6,*) 'Error you have called an undefined subroutine ',
     :           'buffout_shmem'
      call abort()

      stop
      end
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/Orginal mod:  port_conv_f.mod
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*ID PORTCONVF
*/--------------------------------------------------------
*/
*/ Backport vn5.5 mod gqz3505 and vn6.0 mod gqz1600 to vn4.5
*/ Original author frqz (Paul Dando)
*/
*/ Jeff Cole 14/11/03
*/
*/ Provides portable data conversion routines to replace
*/ the Cray-specific routines on non-Cray platforms
*/--------------------------------------------------------
*/
*/-----
*DECLARE COEX1A
*/-----
*D UIE2F403.4
*IF DEF,CRAY
      INTEGER :: CRI2IBM
      INTEGER :: IBM2CRI
*ELSE
      INTEGER :: IEEE2IBM
      INTEGER :: IBM2IEEE
*ENDIF
*I UIE2F403.3
!LL   5.5  28/02/03 Insert code for portable data conversion routines
!LL                 to replace Cray-specific CRI2IBM etc.     P.Dando
!     6.0  10/09/03 Conversion of portable data conversion routines
!                   (IEEE2IBM etc) into functions with error return
!                   codes matching those of CRAY routines.   P.Dando
!LL
*I COEX1A.67
*IF DEF,CRAY
*I UIE2F403.7
*ELSE
          IER=IEEE2IBM(2,1,ICOMP(1),32,ISC,1,64,32)
          IER=IEEE2IBM(2,1,ICOMP(2),0,IX,1,64,16)
          IER=IEEE2IBM(2,1,ICOMP(2),16,IY,1,64,16)
*ENDIF
*I COEX1A.100
*IF DEF,CRAY
*I UIE2F403.10
*ELSE
          IER=IBM2IEEE(2,1,ICOMP(1),32,ISC,1,64,32)
          IER=IBM2IEEE(2,1,ICOMP(2),0,IX,1,64,16)
          IER=IBM2IEEE(2,1,ICOMP(2),16,IY,1,64,16)
*ENDIF
*D UIE2F403.11
*IF DEF,CRAY
      INTEGER :: CRI2IBM
      INTEGER :: IBM2CRI
*ELSE
      INTEGER :: IEEE2IBM
      INTEGER :: IBM2IEEE
*ENDIF
*I COEX1A.199
*IF DEF,CRAY
*I UIE2F403.14
*ELSE
              IERR1(JJ)=IEEE2IBM(3,1, JCOMP(1,JJ),0, BASE(JJ),1,64,32)
              IERR2(JJ)=IEEE2IBM(2,1,JCOMP(1,JJ),32,IBIT(JJ),1,64,16)
              IERR3(JJ)=IEEE2IBM(2,1,JCOMP(1,JJ),48,NOP(JJ),1,64,16)
*ENDIF
*I COEX1A.246
*IF DEF,CRAY
*I COEX1A.247
*ELSE
              CALL MOVEBYTES(JCOMP(1,JJ),1,NOB,ICOMP(ICX),IST)
*ENDIF
*I COEX1A.252
*IF DEF,CRAY
*I UIE2F403.15
*ELSE
          IER2=IEEE2IBM(2,1,ICOMP(1),0,NUM,1,64,32)
*ENDIF
*I COEX1A.273
*IF DEF,CRAY
*I UIE2F403.18
*ELSE
                  IERR=IBM2IEEE(3,1,ICOMP(ICX),32,BASE(JJ),1,64,32)
                  IERR=IBM2IEEE(2,1,ICOMP(ICX+1),0,IBIT(JJ),1,64,16)
                  IERR=IBM2IEEE(2,1,ICOMP(ICX+1),16,NOP(JJ),1,64,16)
*ENDIF
*I COEX1A.280
*IF DEF,CRAY
*I UIE2F403.21
*ELSE
                  IERR=IBM2IEEE(3,1,ICOMP(ICX),0,BASE(JJ),1,64,32)
                  IERR=IBM2IEEE(2,1,ICOMP(ICX),32,IBIT(JJ),1,64,16)
                  IERR=IBM2IEEE(2,1,ICOMP(ICX),48,NOP(JJ),1,64,16)
*ENDIF
*I COEX1A.306
*IF DEF,CRAY
*I COEX1A.307
*ELSE
              CALL MOVEBYTES(ICOMP(ICX),IST,NOB,JCOMP(1,JJ),1)
*ENDIF
*I COEX1A.815
*IF DEF,CRAY
*I COEX1A.816
*ELSE
          CALL MOVEBITS(INUM,1,1,ICOMP(1),ISCOMP)
*ENDIF
*I COEX1A.824
*IF DEF,CRAY
*I COEX1A.825
*ELSE
      CALL MOVEBITS(INUM,ISNUM,NUM,ICOMP(1),ISCOMP)
*ENDIF
*I COEX1A.873
*IF DEF,CRAY
*I COEX1A.874
*ELSE
          CALL MOVEBITS(ICOMP,ISCOMP,NUM,INUM,ISNUM)
*ENDIF
*I COEX1A.880
*IF DEF,CRAY
*I COEX1A.881
*ELSE
          CALL MOVEBITS(ICOMP,ISCOMP,1,INUM,1)
*ENDIF
*I COEX1A.885
*IF DEF,CRAY
*I COEX1A.886
*ELSE
          CALL MOVEBITS(ICOMP,ISCOMP,NUM,INUM,ISNUM)
*ENDIF
*I COEX1A.901
*IF DEF,CRAY
*I COEX1A.902
*ELSE
          CALL MOVEBITS(ICOMP,ISCOMP,NUM,INUM,ISNUM)
*ENDIF
*I GBCQF405.111
*IF DEF,CRAY
*I GBCQF405.112
*ELSE
      INTEGER IEEE2IBM
*ENDIF
*I GBCQF405.123
*IF DEF,CRAY
*I GBCQF405.126
*ELSE
      IERR=IEEE2IBM(2,1,ICOMP(1,1),32,ISC,1,64,32)
      IERR=IEEE2IBM(2,1,ICOMP(2,1),0,IX,1,64,16)
      IERR=IEEE2IBM(2,1,ICOMP(2,1),16,IY,1,64,16)
*ENDIF
*I GBCQF405.281
*IF DEF,CRAY
*I GBCQF405.282
*ELSE
      INTEGER IEEE2IBM
*ENDIF
*I GBCQF405.362
*IF DEF,CRAY
*D GBCQF405.365
            IERR=CRI2IBM(2,1,JCOMP_PROC(1,JJ),48,NOP_PROC(JJ),1,64,16)
*ELSE
            IERR=IEEE2IBM(3,1,JCOMP_PROC(1,JJ),0, BASE_PROC,1,64,32)
            IERR=IEEE2IBM(2,1,JCOMP_PROC(1,JJ),32,IBIT_PROC,1,64,16)
            IERR=IEEE2IBM(2,1,JCOMP_PROC(1,JJ),48,NOP_PROC(JJ),
     &                       1,64,16)
            IERR=0
*ENDIF
*I GBCQF405.437
*IF DEF,CRAY
*I GBCQF405.438
*ELSE
            CALL MOVEBYTES(JCOMP(1,JJ,K),1,NOB,ICOMP(ICX,K),IST)
*ENDIF

*I GBCQF405.444
*IF DEF,CRAY
*I GBCQF405.445
*ELSE
          IERR=IEEE2IBM(2,1,ICOMP(1,K),0,NUM,1,64,32)
*ENDIF
*/-----
*DECLARE FIELDCOS
*/-----
*B FIELDCOS.21
!LL  5.5  28/02/03  Insert code for portable data conversion routines
!LL                 to replace Cray-specific CRI2IBM etc.     P.Dando
!    6.0  10/09/03  Conversion of portable data conversion routines
!                   (IEEE2IBM etc) into functions with error return
!                   codes matching those of CRAY routines.    P.Dando
*D UIE1F402.1,UIE1F402.2
      EXTERNAL READFF,INT_FROM_REAL,TIME2SEC,SEC2TIME
*IF DEF,CRAY
      EXTERNAL CRI2IBM
      INTEGER CRI2IBM
*ELSE
      INTEGER IEEE2IBM
*ENDIF
      INTEGER INT_FROM_REAL
*I PS050793.211
*IF DEF,CRAY
*I UIE1F402.4
*ELSE
      IER = IEEE2IBM(2,LEN_ILABEL,IBM_LABEL(IBM_ADDR),BIT_OFF,
     &               ILABEL,1,64,32)
*ENDIF
*I PS050793.216
*IF DEF,CRAY
*I UIE1F402.6
*ELSE
      IER = IEEE2IBM(3,LEN_RLABEL,IBM_LABEL(IBM_ADDR),BIT_OFF,
     &               RLABEL,1,64,32)
*ENDIF
*I URR2F405.11
*IF DEF,CRAY
*I UIE1F402.10
*ELSE
            IER = IEEE2IBM(3,NUM_VALUES-IEXTRAW,IBM_FIELD,
     &                  BIT_OFF,FIELD,1,64,32)
*ENDIF
*I PS050793.220
*IF DEF,CRAY
*I UIE1F402.12
*ELSE
          IER = IEEE2IBM(2,NUM_VALUES-IEXTRAW,IBM_FIELD,
     &               BIT_OFF,FIELD,1,64,32)
*ENDIF
*I PS050793.221
*IF DEF,CRAY
*I UIE1F402.14
*ELSE
          IER = IEEE2IBM(5,NUM_VALUES-IEXTRAW,IBM_FIELD,
     &               BIT_OFF,FIELD,1,64,32)
*ENDIF
*I FIELDCOS.560
*IF DEF,CRAY
*I UIE1F402.16
*ELSE
          IER=IEEE2IBM(2,1,IBM_FIELD(IBM_ADDR),BIT_OFF,
     &             FIELD(ADDR),1,64,32)
*ENDIF
*I FIELDCOS.577
*IF DEF,CRAY
*I UIE1F402.18
*ELSE
          IER=IEEE2IBM(3,DATA_VALUES,IBM_FIELD(IBM_ADDR),
     &      BIT_OFF,FIELD(ADDR),1,64,32)
*ENDIF
*I PS050793.229
*IF DEF,CRAY
*I UIE1F402.20
*ELSE
        IER = IEEE2IBM(2,LEN_ILABEL,IBM_LABEL(IBM_ADDR),
     &               BIT_OFF,ILABEL,1,64,32)
*ENDIF
*I PS050793.239
*IF DEF,CRAY
*I UIE1F402.22
*ELSE
        IER = IEEE2IBM(3,LEN_RLABEL,IBM_LABEL(IBM_ADDR),
     &               BIT_OFF,RLABEL,1,64,32)
*ENDIF
*D UIE1F402.39,UIE1F402.40
      EXTERNAL READFF,INT_FROM_REAL,TIME2SEC,SEC2TIME
*IF DEF,CRAY
      EXTERNAL CRI2IEG
      INTEGER CRI2IEG
*ELSE
      INTEGER IEEE2IEG
*ENDIF
      INTEGER INT_FROM_REAL
*I PS050793.439
*IF DEF,CRAY
*I UIE1F402.42
*ELSE
      IER=IEEE2IEG(2,LEN_ILABEL,IEEE_LABEL(IEEE_ADDR),
     &           BIT_OFF,ILABEL,1,64,32)
*ENDIF
*I PS050793.444
*IF DEF,CRAY
*I UIE1F402.44
*ELSE
      IER=IEEE2IEG(3,LEN_RLABEL,IEEE_LABEL(IEEE_ADDR),
     &           BIT_OFF,RLABEL,1,64,32)
*ENDIF
*I GIE0F403.192
*IF DEF,CRAY
*I UIE1F402.46
*ELSE
          IER = IEEE2IEG(5,NUM_VALUES-IEXTRAW,IEEE_FIELD,
     &             BIT_OFF,FIELD,1,64,32)
*ENDIF
*I APS2F304.33
*IF DEF,CRAY
*I UIE1F402.48
*ELSE
          IER = IEEE2IEG(3,NUM_VALUES-IEXTRAW,IEEE_FIELD
     &             ,BIT_OFF,FIELD,1,64,32)
*ENDIF
*I FIELDCOS.1266
*IF DEF,CRAY
*I UIE1F402.50
*ELSE
          IER = IEEE2IEG(2,NUM_VALUES-IEXTRAW,IEEE_FIELD,
     &             BIT_OFF,FIELD,1,64,32)
*ENDIF
*I FIELDCOS.1273
*IF DEF,CRAY
*I UIE1F402.52
*ELSE
          IER = IEEE2IEG(5,NUM_VALUES-IEXTRAW,IEEE_FIELD,
     &             BIT_OFF,FIELD,1,64,32)
*ENDIF
*I FIELDCOS.1306
*IF DEF,CRAY
*I UIE1F402.54
*ELSE
          IER = IEEE2IEG(2,1,IEEE_FIELD(IEEE_ADDR),BIT_OFF,
     &             FIELD(ADDR),1,64,32)
*ENDIF
*I FIELDCOS.1323
*IF DEF,CRAY
*I UIE1F402.56
*ELSE
          IER=IEEE2IEG(3,DATA_VALUES,IEEE_FIELD(IEEE_ADDR),
     &     BIT_OFF,FIELD(ADDR),1,64,32)
*ENDIF
*I PS050793.454
*IF DEF,CRAY
*I UIE1F402.58
*ELSE
        IER=IEEE2IEG(2,LEN_ILABEL,IEEE_LABEL(IEEE_ADDR),
     &           BIT_OFF,ILABEL,1,64,32)
*ENDIF
*I PS050793.462
*IF DEF,CRAY
*I UIE1F402.60
*ELSE
        IER=IEEE2IEG(3,LEN_RLABEL,IEEE_LABEL(IEEE_ADDR),
     &           BIT_OFF,RLABEL,1,64,32)
*ENDIF
*/-----
*DECLARE PPTOANC1
*/-----
*B PPTOANC1.143
!   5.5   28/02/03 Insert code for portable data conversion routines
!                  to replace Cray-specific CRI2IBM etc.     P.Dando
!   6.0   10/09/03 Conversion of portable data conversion routines
!                  (IEEE2IBM etc) into functions with error return
!                  codes matching those of CRAY routines.    P.Dando
*I PPTOANC1.2341
*IF DEF,CRAY
*I PPTOANC1.2343
*ELSE
      integer ibm2ieee
*ENDIF
*I PPTOANC1.2367
*IF DEF,CRAY
*I PPTOANC1.2368
*ELSE
        ierr=ibm2ieee(3,rows*columns,levels_in,0,levels_array,
     &                   1,64,32)
*ENDIF
*I PPTOANC1.2606
*IF DEF,CRAY
*I PPTOANC1.2607
*ELSE
      integer ibm2ieee
*ENDIF
*I PPTOANC1.2644
*IF DEF,CRAY
*I PPTOANC1.2645
*ELSE
        ierr=ibm2ieee(3,rows*columns,levels_in,0,levels_array,
     &                   1,64,32)
*ENDIF
*I PPTOANC1.2854
*IF DEF,CRAY
*I PPTOANC1.2855
*ELSE
      INTEGER IBM2IEEE
*ENDIF
*I PPTOANC1.2865
*IF DEF,CRAY
*I PPTOANC1.2866
*ELSE
        ierr=ibm2ieee(3,rows*columns,datain,0,data_field,1,64,32)
*ENDIF
*I PPTOANC1.3385
*IF DEF,CRAY
*I PPTOANC1.3386
*ELSE
      integer ibm2ieee
*ENDIF
*I PPTOANC1.3394
*IF DEF,CRAY
*I PPTOANC1.3399
*ELSE
C Convert Integer part of header (Words 1-45)
        ier = ibm2ieee(2,45,pp_buffer,0,pp_int,1,64,32)

C Convert Real part of header (Words 46-64)
        ier = ibm2ieee(3,19,pp_buffer(23),32,pp_real,1,64,32)
*ENDIF
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/Orginal mod:  recon4837
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*ID R4837SIT
*/
*/  SEA ICE TEMPERATURE is not reconfigured properly when going from 96x73
*/  to 48x37 resolution.
*/
*/  This mod is a hack to the reconf code to initialise the field from
*/  T* rather than use values in the initial dump. Simply remove the check
*/  on PP_SOURCE_OUT(J).EQ.8 in CONTROL.
*/
*/  This is a FAMOUS mod.
*/
*/----------------------------------------------------------------------
*DECLARE CONTROL1
*D UCB1F402.1,UCB1F402.2
          IF (PP_ITEMC_OUT(J).EQ.49.AND.  !  Initialise SEA ICE temp
     &      MODEL.EQ.ATMOS_IM) THEN       !  always
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/Orginal mod:  recon_O.mod_xcggb
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*ID VFLUX_CORR
*DECLARE CNTLOCN
*I OJL1F405.80
     &,L_VFLUX_CORR
*I OJL1F405.83
     &,L_VFLUX_CORR
*I OJL1F405.86
     &,L_VFLUX_CORR
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/Orginal mod:  timerupd_new.mod
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*ID TIMUPD
*/
*/ TIMEF is an SGI intrinsic function and a UM subroutine name so to avoid
*/ confusion remove all calls to TIMEF, replace with call to TIMEFN.
*/ TIMEFN is the same as TIMEF subroutine with machine specific
*/ calls removed and replaced with f90 intrinsic function system_clock.
*/
*DECLARE TIMER1A
*D PXTIMEFN.26,PXTIMEFN.28
*D PXTIMEFN.29,PXTIMEFN.32
      CALL TIMEFN(ELPSTART)
*D PXTIMEFN.33,PXTIMEFN.36
      CALL TIMEFN(ELPEND)
*D PXTIMEFN.37,PXTIMEFN.40
         CALL TIMEFN(ELPEND)
*D PXTIMEFN.41,PXTIMEFN.44
      CALL TIMEFN(ELPSTART)
*D PXTIMEFN.45,PXTIMEFN.48
      CALL TIMEFN(ELPEND)
*D PXTIMEFN.49,PXTIMEFN.52
      CALL TIMEFN(ELPSTART)
*/
*DECLARE TIMER3A
*D PXTIMEFN.53,PXTIMEFN.59
      CALL TIMEFN(temp)
*/
*/ Replace the wallclock timer with vn5.X version
*/
*DECLARE TIMEFN2A
*D PXTIMEFN.14,PXTIMEFN.25
!----------------------------------------------------------------------
!
!+ Gets the elapsed time from the system

! Function Interface:
      SUBROUTINE TIMEFN(Get_Wallclock_Time)

      IMPLICIT NONE
!
! Description:
!   The system function SYSTEM_CLOCK is used to return the numbers of
!   seconds which have elapsed.
!
! Current Code Owner: Anette Van der Wal
!
! IE, PB, Richard Barnes  <- programmer of some or all of previous
!                            code or changes
!
! History:
! Version   Date      Comment
! -------   ----      -------
! 5.3       24/04/01  Complete re-write to simplify.  A Van der Wal
!
! Code Description:
!   Language: FORTRAN 77 plus some Fortran 90 features
!   This code is written to UMDP3 v6 programming standards
!
! System component covered:
! System Task:
!
!- End of header
      REAL Get_Wallclock_Time

! Local variables
      INTEGER, SAVE :: Start_Count=-1
      INTEGER, SAVE :: Old_Count=0
      REAL, SAVE    :: Rollover=0.0
      INTEGER       :: Count, Count_Rate, Count_Max, Elapsed_Count
      REAL, SAVE    :: OneOver_Count_Rate=0.0

! Intrinsic procedures called:
      INTRINSIC SYSTEM_CLOCK

      CALL SYSTEM_CLOCK(Count=Count,Count_Rate=Count_Rate,
     &                  Count_Max=Count_Max)

      IF ((Old_Count .LT. Start_Count) .AND.
     &    ((Count .LT. Old_Count) .OR. (Count .GT. Start_Count))) THEN
        Rollover=Rollover+(REAL(Count_Max)/REAL(Count_Rate))
      ENDIF

      IF (Start_Count .EQ. -1) THEN
        Start_Count=Count
        OneOver_Count_Rate=1.0/REAL(Count_Rate)
      ENDIF

      Elapsed_Count=Count-Start_Count
      IF (Elapsed_Count .LT. 0) Elapsed_Count=Elapsed_Count+Count_Max

      Get_Wallclock_Time = Rollover+
     &                    (REAL(Elapsed_Count)*OneOver_Count_Rate)
      Old_Count=Count

      RETURN
      END
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/Orginal mod:  fix_ancil_name.mod
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*/:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*ID FIX_NAME
*/ Allow environment variables to be used in use prognostic file
*DECLARE CONTROL1
*I  CONTROL1.378
      character*80 aname,bname,cname,dname
      integer index,len

*D GPB1F305.17 
        aname=C_NAMELIST(J)
        if (aname(1:1).eq."$") then
           index=scan(aname,'/')
           bname=aname(2:index-1)
           call get_environment_variable(bname,cname)
           len=len_trim(cname)
           dname=cname(1:len)//aname(index:)
           CALL FILE_OPEN(NFT_UPROG,dname,80,0,1,JERR)
        else
           CALL FILE_OPEN(NFT_UPROG,C_NAMELIST(J),80,0,1,JERR)
        endif
