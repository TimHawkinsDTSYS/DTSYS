      /TITLE Retrieve Record Format Information
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Retrieves record format information for the
      *              specified file.
      *
      *  Notes   :  none
      *
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  04/13/98  TimH        New program to retrieve record format
      *                         information for the specified file.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      /COPY qcpysrc,Hspec
      *
      /COPY QSYSINC/QRPGLESRC,QUSGEN
      /COPY QSYSINC/QRPGLESRC,QUSLRCD
      /COPY qcpysrc,Dspec
      *
      *    Setup qualified name.
      *
     C                   movel     RFfilnam      RFfilnam20
     C                   move      RFfillib      RFfilnam20
      *
     C                   move      USspcnam20    RFspcnam20
      *
      *    List record format information.
      *
     C                   call      'QUSLRCD'
     C                   parm                    RFspcnam20       20
     C                   parm      'RCDL0200'    RFfmtnam         10
     C                   parm                    RFfilnam20       20
     C                   parm      *on           RFovrprc          1
      *
      *    Retrieve user space.
      *
     C                   exsr      $RtvUsrSpc
     C                   eval      Qush0100   = USdta
      *
      *    Retrieve list data (only first instance).
      *
     C                   eval      Qusl020000 = %subst(USdta:qusold+1)
      *
      *    Set parameters.
      *
     C                   eval      RFfmtID     = Qusfi
     C                   eval      RFreclen    = Qusrl00
     C                   eval      RFnbrfld    = Qusnbrf
     C                   eval      RFrectxt    = Qusrtd00
      *
     C                   return
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Create User Space.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CrtUsrSpc    BEGSR
      *
     C                   call      'QUSCRTUS'                           95
     C                   parm                    USspcnam20
     C                   parm                    USextatr
     C                   parm                    USinlsiz
     C                   parm                    USinlval
     C                   parm                    USpubaut
     C                   parm                    UStext
     C                   parm                    USreplace
     C                   parm                    USerrcde
      *
     CSR   #CrtUsrSpc    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Retrieve User Space.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $RtvUsrSpc    BEGSR
      *
     C                   call      'QUSRTVUS'                           95
     C                   parm                    USspcnam20
     C                   parm                    USstrpos
     C                   parm                    USdtalen
     C                   parm                    USdta
     C                   parm                    USerrcde
      *
     CSR   #RtvUsrSpc    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Initialize variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
      *    Create user space.
      *
     C                   eval      USspcnam = QUSLRCD
     C                   eval      USspclib = 'QTEMP'
     C                   exsr      $CrtUsrSpc
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Define variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Define       BEGSR
      *
     C     *ENTRY        PLIST
     C                   parm                    RFfilnam         10
     C                   parm                    RFfillib         10
     C                   parm                    RFfmtID          13
     C                   parm                    RFreclen          9 0
     C                   parm                    RFnbrfld          9 0
     C                   parm                    RFrectxt         50
      *
     CSR   #Define       ENDSR
