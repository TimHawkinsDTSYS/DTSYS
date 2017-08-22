      /TITLE Settings for MONAPPERR Command
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:
      *
      *  Notes   :  none
      *
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  12/03/97  TimH        New program.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /COPY QCPYSRC,Hspec
      *
      * Arrays, defined to allow cleansing.
      *
     D AYusrnam        DS           502
     D  UsrNamCnt                     4b 0
     D  UsrNam                       10    dim(50)
      *
     D AYignjob        DS           502
     D  IgnJobCnt                     4b 0
     D  IgnJob                       10    dim(50)
      *
     D AYignusr        DS           502
     D  IgnUsrCnt                     4b 0
     D  IgnUsr                       10    dim(50)
      *
      * Structure for settings in user space.
      *
     DSETAPPERR        DS
     D SAEmsg                              like(msg)
     D SAEAYusrnam                         like(AYusrnam)
     D SAEwait                             like(wait)
     D SAEayignjob                         like(AYignjob)
     D SAEayignusr                         like(AYignusr)
      *
     D StrElem         S              5  0 inz
     D EndElem         S              5  0 inz
     D idx             S              5  0 inz
      *
      /COPY QCPYSRC,Dspec
      *
     C                   exsr      $CleanArrays
     C                   exsr      $SaveSettings
      *
     C                   eval      *inlr = *on
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Clean arrays.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CleanArrays  BEGSR
      *
     C                   eval      StrElem   = UsrNamCnt + 1
     C                   eval      EndElem   = %elem(usrnam)
      *
     C     StrElem       do        EndElem       idx
     C                   eval      usrnam(idx) = *blanks
     C                   enddo
      *
     C                   eval      StrElem   = IgnJobCnt + 1
     C                   eval      EndElem   = %elem(ignjob)
      *
     C     StrElem       do        EndElem       idx
     C                   eval      ignjob(idx) = *blanks
     C                   enddo
      *
     C                   eval      StrElem   = IgnUsrCnt + 1
     C                   eval      EndElem   = %elem(ignusr)
      *
     C     StrElem       do        EndElem       idx
     C                   eval      ignusr(idx) = *blanks
     C                   enddo
      *
     CSR   #CleanArrays  ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Save settings.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $SaveSettings BEGSR
      *
      *
     C                   eval      SAEmsg      = msg
     C                   eval      SAEAYusrnam = AYusrnam
     C                   eval      SAEwait     = wait
     C                   eval      SAEayignjob = AYignjob
     C                   eval      SAEayignusr = AYignusr
      *
     C                   callp     ChgUsrSpc(USspcnam:USspclib:
     C                                       1:%size(SetAppErr):
     C                                       SetAppErr)
      *
     CSR   #SaveSettings ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
      *    Bring in parameters.
      *
     C                   move      P1msg         msg             132
     C                   move      P1usrnam      AYusrnam
     C                   move      P1wait        wait              5 0
     C                   move      P1ignjob      AYIgnJob
     C                   move      P1ignusr      AYIgnUsr
      *
      *    Create user space for settings.
      *
     C                   eval      USspcnam = 'SETAPPERR'
     C                   eval      USspclib = ZZpgmlib
      *
     C                   callp     CrtUsrSpc(USspcnam:USspclib:
     C                                       %size(SetAppErr):*blanks:
     C                                       'Settings for MONAPPERR')
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Define       BEGSR
      *
     C     *ENTRY        PLIST
     C                   parm                    P1msg           132
     C                   parm                    P1usrnam        502
     C                   parm                    P1wait            5 0
     C                   parm                    P1IgnJob        502
     C                   parm                    P1IgnUsr        502
      *
     CSR   #Define       ENDSR
