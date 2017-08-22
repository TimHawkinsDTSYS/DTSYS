      /TITLE Check IFS Object
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Check for IFS object existence.
      *
      *  Notes   :  none
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  12/11/03  ScottKlement
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *
      /copy qcpysrc,Hspec
      /copy qcpysrc,Dspec
      *
     D EscErrnoX       PR                  like(StdInd)
     D   errnum                            like(StdInt) value

     D stmfile         s            128A   varying
     D errint          s                   like(StdInt) inz
     D error           s                   like(StdInd) inz

     c     *entry        plist
     c                   parm                    stmfile

     c                   if        access(StmFile:F_OK) < *zero
     c                   eval      error = EscErrnoX(errno)
     c                   endif

     c                   eval      *inLR = *on
      * *********************************************************
      *  EscErrno( -- Escape and return an error.
      * *********************************************************
     P EscErrnoX       B                   export
      *
     D EscErrnoX       PI                  like(StdInd)
     D   errnum                            like(StdInt) value
      *
     D QMHSNDPM        PR                  ExtPgm('QMHSNDPM')
     D  MessageID                     7    Const
     D  QualMsgF                           like(StdQnm   ) Const
     D  MsgData                            like(StdChr) Const
     D  MsgDtaLen                          like(StdInt) Const
     D  MsgType                            like(StdNam) Const
     D  CallStkEnt                         like(StdNam) Const
     D  CallStkCnt                         like(StdInt) Const
     D  MessageKey                    4
     D  ErrorCode                   256
      *
     D dsEC            DS
     D  dsECBytesP             1      4i 0 inz(%size(dsEC))
     D  dsECBytesA             5      8i 0 inz(*zero)
     D  dsECMsgID              9     15
     D  dsECReserv            16     16
     D  dsECMsgDta            17    256
      *
     D TheKey          s              4
     D MsgID           s              7
      *
     C                   move      errnum        MsgID
     C                   movel     'CPE'         MsgID
      *
     C                   callp     QMHSNDPM(MsgID: 'QCPFMSG   *LIBL':
     C                               ' ': 0: '*ESCAPE':
     C                               '*': 3: TheKey: dsEC)
      *
     C                   return    *off
      *
     P EscErrnoX       E
