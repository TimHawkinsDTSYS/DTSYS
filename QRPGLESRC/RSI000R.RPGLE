      /TITLE Retrieve User Space Initialization
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Retrieves user space list information.
      *
      *  Notes   :  none
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  09/08/06  TimH        New program.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
      /COPY QCPYSRC,Hspec
      *
     D rcvDS           ds                  inz
     D  strpos                             like(StdInt)
     D  nbrent                             like(StdInt)
     D  entlen                             like(StdInt)
      *
     D  usrspc         s             20                 inz
     D  bgnpos         s                   like(StdInt) inz
     D  dtalen         s                   like(StdInt) inz
      *
      /COPY QCPYSRC,Dspec
      *
     C                   exsr      $RtvUsrSpc
      *
     C                   eval      RtnStrPos = StrPos + 1
     C                   eval      RtnNbrEnt = NbrEnt
     C                   eval      RtnEntLen = EntLen
      *
     C                   eval      *inLR = *on
     C                   return
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Retrieve user space.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $RtvUsrSpc    BEGSR
      *
     C                   eval      usrspc = usrspclib + usrspcnam
      *
     C                   call      'QUSRTVUS'
     C                   parm                    usrspc
     C                   parm      125           bgnpos
     C                   parm      16            dtalen
     C                   parm                    rcvDS
      *
     CSR   #RtvUsrSpc    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Initialize variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Define variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Define       BEGSR
      *
     C     *entry        plist
     C                   parm                    usrspcnam        10
     C                   parm                    usrspclib        10
     C                   parm                    Rtnstrpos         9 0
     C                   parm                    Rtnnbrent         9 0
     C                   parm                    Rtnentlen         9 0
      *
     CSR   #Define       ENDSR
