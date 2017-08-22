      /TITLE Write Source Tracking
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Writes a source tracking record to assist in
      *              tracking where source is being copied, moved
      *              and archived.
      *
      *  Notes   :  none
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  02/25/07  TimH        New program.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
      *COPY QCPYSRC,Hspec
      *
     Fsrctrk    o  a e             disk
      *
     D PIfromfile      s                   like(StdNam)
     D PIfromlib       s                   like(StdNam)
     D PIfrommbr       s                   like(StdNam)
     D PItofile        s                   like(StdNam)
     D PItolib         s                   like(StdNam)
     D PItombr         s                   like(StdNam)
     D PIoption        s                   like(StdNam)
     D PIcmd           s                   like(StdNam)
      *
      /COPY QCPYSRC,DSpgm
      *COPY QCPYSRC,Dspec
      /COPY QCPYSRC,StdTypd
      * ---------------------------------------------------------
      *
      *    Write source tracking.
      *
     C                   exsr      $WrtSrcTrk
      *
     C                   eval      *inLR = *on
     C                   return
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Write source tracking.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $WrtSrcTrk    BEGSR
      *
     C                   eval      FMsrcf   = PIfromfile
     C                   eval      FMsrclib = PIfromlib
     C                   eval      FMsrcmbr = PIfrommbr
     C                   eval      TOsrcf   = PItofile
     C                   eval      TOsrclib = PItolib
     C                   eval      TOsrcmbr = PItombr
     C                   eval      option   = PIoption
     C                   eval      cmd      = PIcmd
     C                   eval      user     = ZZusr
     C                   eval      date     = %date()
     C                   eval      time     = %time()
     C                   write     srctrkR
      *
     Csr   #WrtSrcTrk    ENDSR
      /SPACE 3
      *COPY QCPYSRC,$PSSR
      /SPACE 3
      *COPY QCPYSRC,$WrtPfrat
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Initialize variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *inzsr        begsr
      *
     CSR   #inzsr        endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Define variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $Define       begsr
      *
     C     *entry        plist
     C                   parm                    PIfromfile
     C                   parm                    PIfromlib
     C                   parm                    PIfrommbr
     C                   parm                    PItofile
     C                   parm                    PItolib
     C                   parm                    PItombr
     C                   parm                    PIoption
     C                   parm                    PIcmd
      *
     Csr   #Define       endsr
