      /TITLE Monitor for Application Errors
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:
      *
      *  Notes   :  I've change some of this to use the ILE procedures,
      *             but didn't have the time to complete it, for now
      *             I'll set the NEPS to held.
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
     D MsgLen          S              9b 0 inz(132)
      *
     D AYusrnam        DS           502
     D  UsrNamCnt                     2
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
      * Job list format JOBL0200
      *
     DQUSL020001       DS                  inz
     D JobNam                  1     10
     D JobUsr                 11     20
     D JobNbr                 21     26
     D JobInternalID          27     42
     D JobSts                 43     52
     D JobTypVal              53     53
     D JobSubTyp              54     54
     D JobInfoSts             57     57
     D KeysReturned           61     64b 0
     D KeyFields                     20
     D  KeyLen                        9b 0 OVERLAY(KeyFields:01)
     D  KeyFldID                      9b 0 OVERLAY(KeyFields:05)
     D  KeyFldTyp                     1    OVERLAY(KeyFields:09)
     D  KeyFldLen                     9b 0 OVERLAY(KeyFields:13)
     D  KeyFldDta                     4    OVERLAY(KeyFields:17)
      *
     D SndMsg          S              1n   inz(*off)
     D GenMsg          S              1n   inz(*off)
     D CurEnt          S              5  0 inz
      *
      * Storage area for settings.
      *
     DSETAPPERR        DS                  based(pSetAppErr)
     D SAEmsg                              like(msg)
     D SAEAYusrnam                         like(AYusrnam)
     D SAEwait                             like(wait)
     D SAEayignjob                         like(AYignjob)
     D SAEayignusr                         like(AYignusr)
      *
      /COPY QSYSINC/QRPGLESRC,QUSGEN
      /COPY QCPYSRC,Dspec
      *
     C                   do        *hival
     C                   exsr      $DlyJob
     C                   exsr      $RtvJobL
      *
     C                   eval      pRtvJobL = %addr(QUsh0100)
     C                   eval      pRtvJobL = GetUsrSpcP(ZZpgm)
     C
     C                   eval      USstrpos = 1
     C**                 exsr      $RtvUsrSpc
     C**                 eval      QUSH0100 = USdta
     C                   eval      USstrpos = QUSold + 1
      *
     C                   do        Qusnbrle
     C                   eval      pRtvJobL = %addr(QUsl020001) + USstrpos
     C                   eval      pRtvJobL = GetUsrSpcP(ZZpgm)
      *
     C**                 exsr      $RtvUsrSpc
     C**                 eval      QUSL020001 = USdta
     C                   exsr      $ChkJobInc
     C                   eval      USstrpos  += Qussee
     C**                 enddo
      *
     C                   enddo
      *
     C                   eval      *inlr = *on
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Retrieve job list.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $RtvJobL      BEGSR
      *
     C                   eval      RJLjobnam = '*ALL      *ALL      *ALL'
     C                   eval      USspcnam  = ZZpgm
     C                   eval      USspclib  = 'QTEMP'
      *
      *    (x'0065' = decimal 101 for status)
      *
     C                   call      'QUSLJOB'
     C                   parm      USspcnam20    RJLspcnam        20
     C                   parm      'JOBL0200'    RJLfmtnam         8
     C                   parm                    RJLjobnam        26
     C                   parm      '*ACTIVE'     RJLjobsts        10
     C                   parm      *loval        RJLerrcde         4
     C                   parm      '*'           RJLjobtyp         1
     C                   parm      x'00000001'   RJLnbrkey         4
     C                   parm      x'00000065'   RJLkeylst         4
      *
     CSR   #RtvJobL      ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Check job inclusion.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ChkJobInc    BEGSR
      *
     C                   eval      SndMsg = *off
      *
     C                   if        KeyFldDta = 'MSGW'
     C                   eval      SndMsg    = *on
     C                   endif
      *
     C                   if        SndMsg
     C                   do        IgnJobCnt     x
     C                   if        JobNam = IgnJob(x)
     C                   eval      SndMsg = *off
     C                   leave
     C                   endif
     C                   enddo
      *
     C                   if        SndMsg
     C                   do        IgnUsrCnt     x
     C                   if        JobUsr = IgnUsr(x)
     C                   eval      SndMsg = *off
     C                   leave
     C                   endif
     C                   enddo
     C                   endif
     C                   endif
      *
      *    Send message?
      *
     C                   if         SndMsg
     C                   exsr      $SndMsg
     C                   endif
      *
     CSR   #ChkJobInc    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Send message.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $SndMsg       BEGSR
      *
     C                   if        GenMsg
     C                   eval      msg = 'Job ' + %trim(JobNbr) +
     C                                      '/' + %trim(JobUsr) +
     C                                      '/' + %trim(JobNam) +
     C                                      ' is waiting on a message.'
     C                   endif
      *
     C                   move      *loval        UsrNamCnt4
     C                   move      UsrNamCnt     UsrNamCnt4
      *
     C                   call      'QEZSNDMG'
     C                   parm      '*INFO'       MsgType          10
     C                   parm      '*BREAK'      MsgMode          10
     C                   parm      msg           Msg132          132
     C                   parm                    MsgLen
     C                   parm                    UsrNam
     C                   parm                    UsrNamCnt4        4
     C                   parm      *loval        RtnMsgSnt         4
     C                   parm      *loval        RtnFunReq         4
     C                   parm      *loval        RtnErrCde         4
     C                   parm      'N'           ShwPrmScn         1
     C                   parm      *blanks       RpyMsgq          20
     C                   parm      '*USR'        NamTypeInd        4
      *
     CSR   #SndMsg       ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Wait for the specified time.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DlyJob       BEGSR
      *
     C                   eval      Cmd = 'dlyjob ' + %editc(wait:'Z')
      *
     C                   call      'QCMDEXC'
     C                   parm                    Cmd              30
     C                   parm      30            CmdLen           15 5
      *
     CSR   #DlyJob       ENDSR
      /SPACE 3
      *COPY QCPYSRC,$RtvUsrSpc
      /SPACE 3
      *COPY QCPYSRC,$CrtUsrSpc
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
      *    Create user space for ALCOBJ.
      *
     C                   callp     CrtUsrSpc('MONAPPERR':ZZpgmlib:
     C                                       512:ZZpgm:
     C                                     'Monitor for Application Errors')
      *
     C**                 eval      USspcnam = 'MONAPPERR'
     C**                 eval      USspclib = ZZpgmlib
     C**                 eval      USinlsiz = 512
     C**                 eval      UStext   =
     C**                             'Monitor for Application Errors'
     C**                 exsr      $CrtUsrSpc
      *
      *    Assure that only one is running.
      *
     C                   eval      msgid = ExecCmd('ALCOBJ wait(0) +
     C                              obj((monapperr *usrspc *excl)) ')
     C                   if        msgid <> *blanks
     C                   eval      *inLR = *on
     C                   return
     C                   endif
      *
      *    Create user space for Retrieve Job List.
      *
     C                   callp     CrtUsrSpc(ZZpgm:'QTEMP':
     C                                       5000000:ZZpgm:
     C                                     'Monitor for Application Errors')
      *
     C**                 eval      USspcnam = ZZpgm
     C**                 eval      USspclib = 'QTEMP'
     C**                 eval      USinlsiz = 5000000
     C**                 eval      UStext   =
     C**                             'Monitor for Application Errors'
     C**                 exsr      $CrtUsrSpc
      *
      *    Retrieve settings.
      *
     C                   eval      pSetAppErr =
     C                             GetUsrSpcP('SETAPPERR':'*LIBL')
      *
     C**                 eval      USspcnam  = 'SETAPPERR'
     C**                 eval      USspclib  = '*LIBL'
     C**                 eval      USdtalen  = %size(setapperr)
     C**                 exsr      $RtvUsrSpc
     C**                 eval      setapperr = %subst(USdta:1:USdtalen)
      *
     C                   if        msg        = '*SETAPPERR'
     C                   eval      msg        = SAEmsg
     C                   endif
      *
     C                   if        UsrNam(1)  = '*SETAPPERR'
     C                   eval      AYusrnam   = SAEAYusrnam
     C                   endif
      *
     C                   if        wait       = 99999
     C                   eval      wait       = SAEwait
     C                   endif
      *
     C                   if        IgnJob(1)  = '*SETAPPERR'
     C                   eval      AYignjob   = SAEayignjob
     C                   endif
      *
     C                   if        IgnUsr(1)  = '*SETAPPERR'
     C                   eval      AYignusr   = SAEayignusr
     C                   endif
      *
      *    If generating messages setup a switch for it.
      *
     C                   if        msg    = '*GEN'
     C                   eval      GenMsg = *on
     C                   endif
      *
      *    If default value clear the counts.
      *
     C                   if        IgnJob(1) = '*NONE'
     C                   eval      IgnJobCnt = *zero
     C                   endif
      *
     C                   if        IgnUsr(1) = '*NONE'
     C                   eval      IgnUsrCnt = *zero
     C                   endif
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Define       BEGSR
      *
     C                   clear                   x                15 0
     C                   clear                   wk002a            2
     C                   clear                   wk004a            4
      *
     C     *ENTRY        PLIST
     C                   parm                    P1msg           132
     C                   parm                    P1usrnam        502
     C                   parm                    P1wait            5 0
     C                   parm                    P1IgnJob        502
     C                   parm                    P1IgnUsr        502
      *
     CSR   #Define       ENDSR
