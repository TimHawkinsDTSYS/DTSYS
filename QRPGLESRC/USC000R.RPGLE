      /TITLE Update Spoolfile TOC
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Create and maintain an IFS file used as an table-
      *              of-contents to the Archive Spoolfile process.
      *
      *  Notes   :
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  10/20/03  TimH        New program.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
     H DATFMT(*USA)
      *
     Fisp010p   if a e           k disk
     Fasc000p   uf a e           k disk
      *
      /COPY QSYSINC/QRPGLESRC,Qusrspla
      *
     D  PLarcfile      s                   like(ASarcfile)
     D  PLarcflib      s                   like(ASarcflib)
     D  PLarcmbr       s                   like(ASarcmbr )
     D  PLarcdat       s                   like(ASarcdat )
      *
     D  PLrptnam       s                   like(ASrptnam )
     D  PLrpttxt       s                   like(ASrpttxt )
     D  PLrptdes       s                   like(ASrptdes )
      *
     D  PLjobnam       s                   like(ASjobnam )
     D  PLjobusr       s                   like(ASjobusr )
     D  PLjobnbr       s                   like(ASjobnbr )
     D  PLsplnam       s                   like(ASsplnam )
     D  PLsplnbr       s                   like(ASsplnbr )
      *
     D  DteISO         S               d   datfmt(*iso)
      *
      *   Write table-of-contents record.
      *
     C                   if        PLmode = '*UPD'
     C                   exsr      $WrtTOC
     C                   endif
      *
      *   Delete table-of-contents records.
      *
     C                   if        PLmode = '*DLT'
     C                   exsr      $DltTOC
     C                   endif
      *
     C                   eval      *inLR = *on
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Write table-of-contents record.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $WrtTOC       BEGSR
      *
      *   Retrieve spoolfile attributes.
      *
     c                   reset                   QUSA010001
      *
     c                   eval      JobNam26 = PLjobnam + PLjobusr +
     c                                        PLjobnbr
      *
     c                   call(e)   'QUSRSPLA'
     c                   parm                    QUSA010001
     c                   parm                    QUSBR07
     c                   parm      'SPLA0100'    FmtNam            8
     c                   parm                    JobNam26         26
     c                   parm      *blanks       QUSIJID08
     c                   parm      *blanks       QUSISID00
     c                   parm      PLsplnam      QUSSN01
     c                   parm      PLsplnbr      QUSSNBR
      *
     c                   if        %error
     c                   eval      *inLR = *on
     c                   return
     c                   endif
      *--------------------------------------------------
      *
      *   Retrieve index spoolfile, set report text.
      *
     C                   if        PLrpttxt = '*STD'
     C     PLrptnam      chain     isp010r
     C                   if        %found
     C                   eval      PLrpttxt = ISrpttxt
     C                   endif
     C                   endif
      *--------------------------------------------------
      *
      *   Write table-of-contents record.
      *
     C                   eval      ASarcfile = PLarcfile
     C                   eval      ASarcflib = PLarcflib
     C                   eval      ASarcmbr  = PLarcmbr
     C                   eval      ASarcname = %trim(PLjobnam) + '/'       +
     C                                         %trim(PLjobusr) + '/'       +
     C                                         %trim(PLjobnbr) + '/'       +
     C                                         %trim(PLsplnam) + '/F'      +
     C                                         %trim(%editc(PLsplnbr:'X')) +
     C                                         '.SPLF'
     C                   eval      ASarcdat  = today
      *
     C                   eval      ASrptnam  = PLrptnam
     C                   eval      ASrpttxt  = PLrpttxt
     C                   eval      ASrptdes  = PLrptdes
      *
     C                   eval      ASrptpgm  = quspn
      *
     C                   move      qusdfilo      ASrptdat
     C                   if        %subst(qusdfilo:1:1) = '0'
     C                   moveL     '19'          ASrptdat
     C                   else
     C                   moveL     '20'          ASrptdat
     C                   endif
      *
     C                   move      qustfilo      ASrpttim
     C                   eval      ASnbrpag  = qustp
      *
     C                   eval      ASjobnam  = PLjobnam
     C                   eval      ASjobusr  = PLjobusr
     C                   eval      ASjobnbr  = PLjobnbr
     C                   eval      ASsplnam  = PLsplnam
     C                   eval      ASsplnbr  = PLsplnbr
      *
     C     ASkey4        setll     asc000r
     C                   if        not %equal
     C                   write     asc000r
     C                   endif
      *
     CSR   #WrtTOC       ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Delete table-of-contents record.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DltTOC       BEGSR
      *
     C                   eval      ASarcfile = PLarcfile
     C                   eval      ASarcflib = PLarcflib
     C                   eval      ASarcmbr  = PLarcmbr
      *
     C                   eval      ASarcname = %trim(PLjobnam) + '/'       +
     C                                         %trim(PLjobusr) + '/'       +
     C                                         %trim(PLjobnbr) + '/'       +
     C                                         %trim(PLsplnam) + '/F'      +
     C                                         %trim(%editc(PLsplnbr:'X')) +
     C                                         '.SPLF'
      *
     C                   dou       not %found
     C     ASkey4        delete    asc000r
     C                   enddo
      *
     CSR   #DltTOC       ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C     *usa          move      *date         DteISO
     C                   movel     DteISO        today             8 0
      *
     C     *entry        plist
     C                   parm                    PLmode            4
      *
     C                   parm                    PLjobnam
     C                   parm                    PLjobusr
     C                   parm                    PLjobnbr
     C                   parm                    PLsplnam
     C                   parm                    PLsplnbr
      *
     C                   parm                    PLarcfile
     C                   parm                    PLarcflib
     C                   parm                    PLarcmbr
      *
     C                   parm                    PLrptnam
     C                   parm                    PLrpttxt
     C                   parm                    PLrptdes
      *
     C     ASkey4        klist
     C                   kfld                    ASarcfile
     C                   kfld                    ASarcflib
     C                   kfld                    ASarcmbr
     C                   kfld                    ASarcname
      *
     CSR   #INZSR        ENDSR
