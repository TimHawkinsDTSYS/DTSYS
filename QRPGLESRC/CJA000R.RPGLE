      /TITLE Convert Job Accounting
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      * S: Converts job accounting records into a simpler format
      * S:  for use.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * M: MODIFICATIONS --
      *
      * M: YY/MM/DD  PROGRAMMER  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
      *
      /COPY QCPYSRC,Hspec
      *
     Fqajbacg   IP   e             disk    prefix(inp)
     Fcja000p   O  a e             disk
      *
     D IncIBM          s              4
     D IncSvr          s              4
     D WrtRec          s                   like(StdInd) inz
     D wkStrISO        s                   like(NumISO) inz
     D wkStrHMS        s                   like(NumHMS) inz
     D wkEndISO        s                   like(NumISO) inz
     D wkEndHMS        s                   like(NumHMS) inz
      *
      /COPY QCPYSRC,Dspec
      *
     C                   eval      WrtRec    = *on
      *
     C                   if        inpJAcpu  = -1            or
     C                             inpJAsdte = *zero
     C                   eval      WrtRec    = *off
     C                   endif
      *
     C                   if        IncIBM    = '*NO'
     C                   if        inpJAuser = 'QUSER'       or
     C                             inpJAuser = 'QTCP'        or
     C                             inpJAuser = 'QSYS'        or
     C                             inpJAuser = 'QSRV'        or
     C                             inpJAuser = 'QMSF'        or
     C                             inpJAuser = 'QGATE'       or
     C                             inpJAuser = 'QPGMR'       or
     C                             inpJAuser = 'QSNADS'      or
     C                             inpJAuser = 'QPM400'      or
     C                             inpJAuser = 'QLPAUTO'     or
     C                             inpJAuser = 'QSECOFR'     or
     C                             inpJAuser = 'QEJBSVR'     or
     C                             inpJAuser = 'QDIRSRV'     or
     C                             inpJAuser = 'QSPLJOB'     or
     C                             inpJAuser = 'QSRVAGT'     or
     C                             inpJAuser = 'QSYSOPR'     or
     C                             inpJAuser = 'QIBMHELP'    or
     C                             inpJAuser = 'QTMHHTTP'    or
     C                             inpJAuser = 'QYPSJSVR'    or
     C                             inpJAuser = 'QLPINSTALL'  or
     C                             inpJAjob  = 'QZSHSH'      or
     C                             inpJAjob  = 'QHXHDLTU'    or
     C                             inpJAjob  = 'QP0ZSPWP'
     C                   eval      WrtRec    = *off
     C                   endif
     C                   endif
      *
     C                   if        IncSvr    = '*NO'
     C                   if        inpJAuser = 'RITA'        or
     C                             inpJAuser = 'SSBOT'       or
     C                             inpJAuser = 'TSUSR'       or
     C                             inpJAuser = 'EXODUS'      or
     C                             inpJAuser = 'WBLUSER'     or
     C                             inpJAuser = 'DOCUMENTS'   or
     C                             inpJAuser = 'PAXREPRICE'  or
     C                             inpJAjob  = 'EXODUS'      or
     C                             inpJAjob  = 'THINCHILD'   or
     C                             inpJAjob  = 'WTCPCHILD'
     C                   eval      WrtRec    = *off
     C                   endif
     C                   endif
      *
     C                   if        WrtRec
     C                   exsr      $CpyRecord
     C                   endif
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Copy record.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CpyRecord    BEGSR
      *
      *    Job information.
      *
     C                   eval      JAjob  = inpJAjob
     C                   eval      JAuser = inpJAuser
     C                   eval      JAnbr  = %editc(inpJAnbr:'X')
     C                   eval      JAacgc = inpJAcde
     C                   eval      JAtype = inpJAtype
      *
      *    Start/End time.
      *
     C                   eval      wkStrISO = CvtMDYtoISO(num(inpJAsdte))
     C                   eval      wkStrHMS = num(inpJAstim)
     C                   eval      JAsdte   = CvtISOtoDte(wkStrISO)
     C                   eval      JAstim   = CvtHMStoTim(wkStrHMS)
     C                   eval      JAstsp   = CvtDteTimtoTSP(wkStrISO:
     C                                                       wkStrHMS)
      *
     C                   eval      wkEndISO = CvtMDYtoISO(num(inpJAdate))
     C                   eval      wkEndHMS = inpJAtime
     C                   eval      JAedte   = CvtISOtoDte(wkEndISO)
     C                   eval      JAetim   = CvtHMStoTim(wkEndHMS)
     C                   eval      JAetsp   = CvtDteTimtoTSP(wkEndISO:
     C                                                       wkEndHMS)
      *
      *    Elapsed time.
      *
     C                   eval      JAesec   = SecsDuration(wkEndISO:
     C                                                     wkEndHMS:
     C                                                     wkStrISO:
     C                                                     wkStrHMS)
      *
     C                   eval      JAehrs   = HoursDuration(wkEndISO:
     C                                                      wkEndHMS:
     C                                                      wkStrISO:
     C                                                      wkStrHMS)
      *
     C                   eval      JAemin = (JAesec-((JAehrs*60)*60))/60
      *
      *    Transaction counts.
      *
     C                   eval      JAtrns = inpJAtrns
     C                   eval      JAxpag = inpJAxpag
     C                   eval      JAxcpu = inpJAxcpu/1000
     C                   eval      JAxdbg = inpJAxdbg
     C                   eval      JAxdbp = inpJAxdbp
     C                   eval      JAxdbu = inpJAxdbu
     C                   eval      JAxttl = JAxdbg + JAxdbp + JAxdbu
     C                   eval      JAccde = inpJAccde
     C                   write     cja000r
      *
     CSR   #CpyRecord    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Initialization
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Definitions
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Define       BEGSR
      *
     C     *entry        plist
     C                   parm                    IncIbm
     C                   parm                    IncSvr
      *
     CSR   #Define       ENDSR
