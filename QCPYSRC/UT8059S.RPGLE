      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Message prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *  Messaging standard fields and structures.
      *
     D msgid           s              7
     D msg             s            132
     D msgdta          s          32767
     D seclvl          s          32767
      *
     D Std_msgid       s              7
     D Std_msgdta      s            512
      *
     D d_RtnMsg        DS
     D  RtnMsgid                           like(Std_msgid)
     D  RtnMsgdta                          like(Std_msgdta)
      * ---------------------------------------------------------
      * ClrPgmq() -- Clear program queue.
      *
     D ClrPgmq         PR
     D  CalStkEnt_p                        like(StdNam) const
     D                                     options(*omit:*nopass)
     D  CalStkCtr_p                        like(StdNam) const
     D                                     options(*omit:*nopass)
      * ---------------------------------------------------------
      * ClrMsgq() -- Clear message queue.
      *
     D ClrMsgq         PR
     D  Msgq                               like(StdNam) const
      * ---------------------------------------------------------
      * CrtMsgq() -- Create message queue.
      *
     D CrtMsgq         PR
     D  CrtMsgqNam                         like(StdNam) const
     D  CrtMsgqLib                         like(StdNam) const
     D                                     options(*omit:*nopass)
     D  CrtMsgqTxt                         like(StdTxt) const
     D                                     options(*omit:*nopass)
      * ---------------------------------------------------------
      * SndMsg() - Send message.
      *
     D SndMsg          PR
     D  msgid                         7                 const
     D  msgdta                    32767                 const
     D                                     options(*omit:*nopass:*varsize)
     D  msgq                               like(StdNam) const
     D                                     options(*omit:*nopass:*varsize)
     D  msgf                               like(StdNam) const
     D                                     options(*omit:*nopass:*varsize)
      * ---------------------------------------------------------
      * SndPgmMsg() -- Send program message.
      *
     D SndPgmMsg       PR
     D  Msgid                         7    value
     D  Msgdta                             like(StdBuf)
     D                                     const options(*omit:*nopass)
     D  Pgmq                               like(StdNam)
     D                                     const options(*omit:*nopass)
     D  Relship                       4    const options(*omit:*nopass)
     D  MsgTyp                             like(StdNam)
     D                                     const options(*omit:*nopass)
     D  Msgf                               like(StdNam)
     D                                     const options(*omit:*nopass)
      * ---------------------------------------------------------
      * SndBrkMsg() -- Send break message.
      *
     D SndBrkMsg       PR
     D  UserID                             like(StdNam) const
     D  Msg                                like(StdStr) const
      * ---------------------------------------------------------
      * RcvPgmMsg() - Receive program message.
      *
     D RcvPgmMsg       PR                  likeDS(t_RcvPgmMsg)
     D  CalStkEnt                          like(StdNam) const
     D                                     options(*omit:*nopass)
     D  CalStkCtr                          like(StdNam) const
     D                                     options(*omit:*nopass)
     D  MsgType                            like(StdNam) const
     D                                     options(*omit:*nopass)
     D  MsgKey                             like(StdNam) const
     D                                     options(*omit:*nopass)
     D  MsgAction                          like(StdNam) const
     D                                     options(*omit:*nopass)
     D  WaitTime                           like(StdInt) const
     D                                     options(*omit:*nopass)
      *
     D t_RcvPgmMsg     DS                  qualified template inz
     D  MsgID                         7a
     D  Msg                         132a
     D  SecLvl                    32712a
     D  MsgDta                    32767a
     D  MsgSev                             like(StdInt)
     D  MsgType                            like(StdNam)
     D  Msgf                               like(StdNam)
     D  MsgfLib                            like(StdNam)
     D  SndJob                             like(StdNam)
     D  SndUsr                             like(StdNam)
     D  SndJobNbr                          like(StdJobNbr)
     D  SndPgm                             like(StdNam)
      * ---------------------------------------------------------
      * RtvMsg() - Retrieve message.
      *
     D RtvMsg          PR                  likeDS(t_RtvMsg)
     D  msgid                         7                 const
     D  msgdta                    32767                 const
     D                                     options(*omit:*nopass)
     D  msgf                               like(StdNam) const
     D                                     options(*omit:*nopass)
      *
     D t_RtvMsg        DS                  qualified template inz
     D  Msg                         132a
     D  SecLvl                    32767a
     D  MsgSev                             like(StdInt)
      * ---------------------------------------------------------
      * RtvMsgqEnt() -- Retrieve message queue entries.
      * -- the return variable must be decimal.
      *
     D RtvMsgqEnt      PR                  like(StdCnt)
     D  i_msgq                             like(StdNam) const
     D  i_msgqlib                          like(StdNam) const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      * SndWakeUpMsg() -- Send wakeup message.
      *
     D SndWakeUpMsg    PR
     D   msgq                              like(StdNam) const
     D   WakeUpMsgID                       like(msgid)  const
     D   WakeUpMsgdta                      like(msgdta) const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      * RcvWakeUpMsg() -- Receieve wakeup message.
      *
     D RcvWakeUpMsg    PR                  like(d_RtnMsg)
     D  RcvWakeMsgq                        like(StdNam) const
     D  RcvWakeWait                        like(StdInt) const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      * RcvWakeUpMsgID() -- Receieve wakeup message ID.
      *
     D RcvWakeUpMsgID  PR                  like(msgid)
     D  RcvWakeMsgq                        like(StdNam) const
     D  RcvWakeWait                        like(StdInt) const
     D                                     options(*nopass)
      *----------------------------------------------------------
      * SetMsgf() -- Set message file name.
      *
     D SetMsgf         PR                  like(StdNam)
     D  MsgPfx                        3A   options(*varsize) const
      *----------------------------------------------------------
      * SetMsgTyp() -- Set message type.
      *
     D SetMsgTyp       PR                  like(StdNam)
     D  MsgTyp                        2A   options(*varsize) const
      * ---------------------------------------------------------
      * QMHMOVPM() - Move Program Messages API
      *
     D QMHMOVPM        PR                  extpgm('QMHMOVPM')
     D  pMsgKey                       4a   const
     D  pMsgtypes                    40a   const
     D  pNumMsgTypes                       like(StdInt) const
     D  pToCallStack                       like(StdNam) const
     D  pToCallCount                       like(StdInt) const
     D  pAPIerror                   256a   options(*varsize)
      * ---------------------------------------------------------
      * QMHRCVPM() - Receive Program Message API
      *
     D QMHRCVPM        Pr                  ExtPgm('QMHRCVPM')
     D  RcvVar                             likeds(t_RCVM0200)
     D  RcvVarLen                          like(StdInt) const
     D  FmtName                            like(StdFmt) const
     D  CalStkEnt                          like(StdNam) const
     D  CalStkCtr                          like(StdInt) const
     D  MsgType                            like(StdNam) const
     D  MsgKey                        4a                const
     D  WaitTime                           like(StdInt) const
     D  MsgAction                          like(StdNam) const
     D  APIError                           likeDS(dsEC)
     D                                     options(*omit:*nopass)

      * Optional parameter group 1
     D  CalStkEntLen                       like(StdInt) const
     D                                     options(*omit:*nopass)
     D  CalStkEntQual                      like(StdNamLib) const
     D                                     options(*omit:*nopass)
      *
     D t_RCVM0200      ds                  qualified template inz
     D  ByteProv                           like(StdInt)
     D  ByteAvail                          like(StdInt)
     D  MsgSev                             like(StdInt)
     D  MsgID                         7a
     D  MsgTyp                        2a
     D  MsgKey                        4a
     D  Msgf                               like(StdNam)
     D  MsgfLibSpf                         like(StdNam)
     D  MsgfLibUsd                         like(StdNam)
     D  SndJob                             like(StdNam)
     D  SndUsr                             like(StdNam)
     D  SndJobNbr                          like(StdJobNbr)
     D  SndPgm                       12a
     D  SndPgmInst                    4a
     D  DateSent                      7a
     D  TimeSent                      6a
     D  RcvPrg                             like(StdNam)
     D  RcvPrgInst                    4a
     D  SndType                            like(StdChr)
     D  RcvType                            like(StdChr)
     D  reserved1                          like(StdChr)
     D  CCSIDCvStTx                        like(StdInt)
     D  CCSIDCvStDa                        like(StdInt)
     D  AlertOption                   9a
     D  CCSIDMsg                           like(StdInt)
     D  CCSIDMsgRpl                        like(StdInt)
     D  LenMsgDta                          like(StdInt)
     D  LenMsgDtaAvl                       like(StdInt)
     D  LenMsg                             like(StdInt)
     D  LenMsgAvl                          like(StdInt)
     D  LenSecLvl                          like(StdInt)
     D  LenSecLvlAvl                       like(StdInt)
     D  RtnVar                    32767a
      * ---------------------------------------------------------
      * QMHRTVM() - Retrieve Message API
      *
     D QMHRTVM         PR                  extpgm('QMHRTVM')
     D  RtnDta                             likeDS(t_RTVM0200)
     D  RtnDtaLen                          like(StdInt) const
     D  FmtName                            like(StdFmt) const
     D  MsgId                         7a   const
     D  MsgFileLib                         like(StdNamLib) const
     D  MsgDta                    32767a   options(*varsize) const
     D  MsgDtaLen                          like(StdInt) const
     D  RplSubVar                          like(StdNam) const
     D  RtnCtlChr                          like(StdNam) const
     D  APIError                           likeDS(dsEC)
     D                                     options(*omit:*nopass)

      * Optional group
     D  RtvOption                          like(StdNam) const
     D                                     options(*omit:*nopass)
     D  CCSIDToCvtTo                       like(StdInt) const
     D                                     options(*omit:*nopass)
     D  CCSIDOfRplDta                      like(StdInt) const
     D                                     options(*omit:*nopass)
      *
     D t_RTVM0200      ds                  qualified template inz
     D  ByteProv                           like(StdInt)
     D  ByteAvail                          like(StdInt)
     D  MsgSev                             like(StdInt)
     D  AlertIndx                          like(StdInt)
     D  AlertOpt                      9a
     D  LogInd                             like(StdChr)
     D                                2a
     D  LenRpy                             like(StdInt)
     D  LenRpyAvl                          like(StdInt)
     D  LenMsg                             like(StdInt)
     D  LenMsgAvl                          like(StdInt)
     D  LenSecLvl                          like(StdInt)
     D  LenSecLvlAvl                       like(StdInt)
     D  RtnVar                    32767a
      * ---------------------------------------------------------
      * QMHRTVPM() - Remove Program Messages API
      *
     D QMHRMVPM        pr                  extpgm('QMHRMVPM')
     D  MsgQueue                           like(StdNam) const
     D  MsgStack                           like(StdInt) const
     D  MsgKey                        4a                const
     D  MsgRmvOpt                          like(StdNam) const
     D  APIError                           likeDS(dsEC)
     D                                     options(*omit:*nopass)

      * Optional parameter group 1
     D  CalStkEntLen                       like(StdInt)    const
     D                                     options(*omit:*nopass)
     D  CalStkEntQual                      like(StdNamLib) const
     D                                     options(*omit:*nopass)
     D  RmvUnHandExcp                      like(StdNam)    const
     D                                     options(*omit:*nopass)

      * Optional parameter group 2
     D  CallStkDtaTyp                      like(StdNam) const
     D                                     options(*omit:*nopass)

      * Optional parameter group 3
     D  AlowDftRplRej                      like(StdNam) const
     D                                     options(*omit:*nopass)
      * ---------------------------------------------------------
      * QMHRSNEM() - Resend Escape Message API
      *
     D QMHRSNEM        PR                  extpgm('QMHRSNEM')
     D  pMsgKey                       4a   const
     D  pAPIerror                   256a   options(*varsize)
     D  pToStack                     48a   const
     D                                     options(*omit:*nopass)
     D  pToStkLen                          like(StdInt) const
     D                                     options(*omit:*nopass)
     D  pFmtOfToStk                        like(StdFmt) const
     D                                     options(*omit:*nopass)
     D  pFrStkAdr                    16a   const
     D                                     options(*omit:*nopass)
     D  pFrStkCtr                          like(StdInt) const
     D                                     options(*omit:*nopass)
      * ---------------------------------------------------------
      * QMHSNDPM() - Send Program Message API
      *
     D QMHSNDPM        PR                  ExtPgm('QMHSNDPM')
     D  MsgId                              like(StdNam) const
     D  MsgFileLib                         like(StdNamLib) const
     D  MsgData                   32767a                   const
     D                                     options(*varsize)
     D  MsgDataLen                         like(StdInt) const
     D  MsgType                            like(StdNam) const
     D  CallStK                            like(StdNam) const
     D  CallStkCtr                         like(StdInt) const
     D  MsgKey                        4a   const
     D  APIError                           likeDS(dsEC)
     D                                     options(*omit:*nopass)

      * Optional group 1
     D  CallStkEnLen                       like(StdInt) const
     D                                     options(*omit:*nopass)
     D  CallStkEnQual                      like(StdNamLib) const
     D                                     options(*omit:*nopass)
     D  MsgWaitTime                        like(StdInt) const
     D                                     options(*omit:*nopass)

      * Optional group 2
     D  CallStkDtaTyp                      like(StdNam) const
     D                                     options(*omit:*nopass)
     D  CCSID                              like(StdInt) const
     D                                     options(*omit:*nopass)
      * ---------------------------------------------------------
      * QMHSNDM() - Send Non-Program Message API
      *
     D QMHSNDM         PR                  ExtPgm('QMHSNDM')
     D  MsgId                              like(StdNam)    const
     D  MsgfLib                            like(StdNamLib) const
     D  MsgData                   32767a                   const
     D                                     options(*varsize)
     D  MsgDataLen                         like(StdInt)    const
     D  MsgType                            like(StdNam)    const
     D  MsgqLib                            like(StdNamLib) const
     D  MsgqLibCnt                         like(StdInt)    const
     D  RpymsgqLib                         like(StdNamLib) const
     D  MsgKey                        4a   const
     D  APIError                           likeDS(dsEC)
     D                                     options(*omit:*nopass)

      * Optional group 1
     D  CCSID                              like(StdInt) const
     D                                     options(*omit:*nopass)
      * ---------------------------------------------------------
      * RcvMsg() - Receive message
      *
     D RcvMsg          PR                  likeds(t_RcvMsg)
     D  Msgq                               like(StdNam) const
     D  MsgType_p                          like(StdNam) const
     D                                     options(*omit:*nopass)
     D  MsgKey_p                           like(StdMsgKey) const
     D                                     options(*omit:*nopass)
     D  MsgWait_p                          like(StdInt) const
     D                                     options(*omit:*nopass)
     D  MsgAction_p                        like(StdNam) const
     D                                     options(*omit:*nopass)
      *
     D t_RcvMsg        DS                  qualified based(StdNulPtr)
     D  MsgID                              like(StdMsgID)
     D  Msg                                like(StdMsg)
     D  MsgDta                             like(StdMsgDta)
     D  SecLvl                             like(StdSecLvl)
     D  MsgType                            like(StdNam)
     D  MsgKey                             like(StdMsgKey)
     D  MsgSev                             like(StdInt)
     D  Msgf                               like(StdNam)
     D  MsgfLib                            like(StdNam)
     D  SndJob                             like(StdNam)
     D  SndUsr                             like(StdNam)
     D  SndJobNbr                          like(StdJobNbr)
     D  SndPgm                             like(StdNam)
     D  DateSent                           like(NumISO)
     D  TimeSent                           like(NumHMS)
      *
      *  -- Receive Non-Program Message (QMHRCVM) API
      *
     D/if not defined(P_QMHRCVM)
     D/define P_QMHRCVM
     D QMHRCVM         PR                  ExtPgm('QMHRCVM')
     D  RtnDta                    32767a   options(*varsize) const
     D  RtnDtaLen                          like(StdInt)      const
     D  FmtNam                             like(StdFmt)      const
     D  MsgqQual                           like(StdQnm)      const
     D  MsgTyp                             like(StdNam)      const
     D  MsgKey                             like(StdMsgKey)   const
     D  MsgWait                            like(StdInt)      const
     D  MsgAction                          like(StdNam)      const
     D  APIError                           likeDS(dsErrInfo)

      * Optional group 1
     D  CCSID                              like(StdInt) const
     D                                     options(*nopass)

      * Optional group 2
     D  AlwDftRpyRej                       like(StdNam) const
     D                                     options(*nopass)
     D/endif
