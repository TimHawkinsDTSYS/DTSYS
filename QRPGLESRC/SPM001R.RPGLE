      /TITLE Send Profile Message
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
      /copy qcpysrc,Hspec
      *
     D UsrCntBin       S              9B 0 INZ(0)
     D MsgLenBin       S              9B 0 INZ(494)
      *
      /copy qcpysrc,Dspec
      *
     C                   exsr      $SndMsg
      *
     C                   eval      *inlr = *on
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Send message.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $SndMsg       BEGSR
      *
      *    User list comes from job started after time.
      *
     C                   if        JobStrAftDte <> *zero or
     C                             JobStrAftTim <> *zero
     C                   exsr      $JobStrAft
     C                   endif
      *
      *    Shift users from right side of AYusers to left side.
      *
     C                   if        JobStrAftDte = *zero and
     C                             JobStrAftTim = *zero
     C                   eval      WK004a = *loval
     C                   eval      WK002a = %subst(AYusers:1:2)
     C                   move      WK002a        WK004a
     C                   move      WK004a        UsrCntBin
      *
     C                   eval      Users = %subst(AYusers:3:UsrCntBin*10)
     C                   endif
      *
      *    Show prompt screen is passed as only 1 byte.
      *
     C                   if        ShwPrmScn  = '*YES'
     C                   eval      ShwPrmScn1 = 'Y'
     C                   else
     C                   eval      ShwPrmScn1 = 'N'
     C                   endif
      *
      *    Clear reply message queue if not passed.
      *
     C                   if        %subst(RpyMsgq:1:10) = '*NONE'
     C                   eval      RpyMsgq = *blanks
     C                   endif
      *
      *    Retrieve message id.
      *
     C                   if        Msgid  <> '*NONE'
     C                   eval      Msgf    = %subst(QNmsgf:01:10)
     C                   eval      MsgfLib = %subst(QNmsgf:11:10)
     C                   exsr      $PMrtv
     C                   eval      Msg494 = Msg
     C                   endif
      *
      *    Send message (and prompt screen).
      *
     C                   call(e)   'QEZSNDMG'
     C                   PARM                    MsgType
     C                   PARM                    MsgMode
     C                   PARM                    Msg494
     C                   PARM                    MsgLenBin
     C                   PARM                    Users           500
     C                   PARM                    UsrCntBin
     C                   PARM      x'00000000'   RtnMsgSnt         4
     C                   PARM      x'00000000'   RtnFunReq         4
     C                   PARM      x'00000000'   RtnErrCde         4
     C                   PARM                    ShwPrmScn1        1
     C                   PARM                    RpyMsgq
     C                   PARM      '*USR'        NamTypeInd        4
      *
     CSR   #SndMsg       ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Job started after (retrieve job list).
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $JobStrAft    BEGSR
      **
     C**                 call      'SPF010C'
     C**                 parm                    JobStrAftDte
     C**                 parm                    JobStrAftTim
     C**                 parm                    Users
      *
     CSR   #JobStrAft    ENDSR
      /SPACE 3
      /COPY QCPYSRC,$PMrtv
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   eval      JobStrAftDte = %subst(JobStrAft:04:06)
     C                   eval      JobStrAftTim = %subst(JobStrAft:10:06)
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     C                   clear                   WK002a            2
     C                   clear                   WK004a            4
     C                   clear                   JobStrAftDte      6
     C                   clear                   JobStrAftTim      6
      *
     C     *ENTRY        PLIST
     C                   PARM                    MsgType          10
     C                   PARM                    MsgMode          10
     C                   PARM                    Msg494          494
     C                   PARM                    AYusers         502
     C                   PARM                    ShwPrmScn         4
     C                   PARM                    JobStrAft        15
     C                   PARM                    RpyMsgq          20
     C                   PARM                    Msgid             7
     C                   PARM                    QNmsgf           20
     C                   PARM                    Msgdta512       512
      *
     CSR   #DEFN         ENDSR
