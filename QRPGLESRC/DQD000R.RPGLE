      *****************************************************************
      * Copyright (c) 2000 by Multifoods Distribution Group, Inc.     *
      * All rights reserved.                                          *
      *                                                               *
      * Pgm:  DSPQRYD01R                                              *
      * Date: 08/24/00                                                *
      * Auth: Jeff Yanoviak                                           *
      * Desc: This program searches a list of queries for the ones    *
      *       that use the specified file.                            *
      *                                                               *
      * Parameters:                                                   *
      *   File - 10 Character file name                               *
      *   Lib  - 10 Character library name                            *
      *****************************************************************
     H DftActGrp(*No)
      *****************************************************************
      * File Definitions
      *****************************************************************
     FQADspObj  IF   E             Disk
     FDQD000P   O  A E             Disk
      *****************************************************************
      * Data Definitions
      *****************************************************************
      * Parameters
     D File            S             10A
     D Lib             S             10A

      * Working Variables
     D Idx             S             10I 0
     D ErrCode         S              1A
     D Msg             S             80A

      * Query Variables
     D QryIn           S           1280A

     D QryOut          DS
     D  QryOutFile                   10A
     D  QryOutFileLib                10A
     D  QryOutFileMbr                10A

      * Message Handling Variables
     D QMhErrCode      S               *   Inz(*Null)
     D MsgKey          S              4A

      * Prototypes
      * This program retrieves the query information
     D RtvQryF         PR                  ExtPgm('RQF000R')
     D  QueryName                    10A   Const
     D  QueryLib                     10A   Const
     D  QryIn                      1280A
     D  QryOut                       30A
     D  ErrCode                       1A

      * Resend Exception Message
     D/COPY QSYSINC/QRPGLESRC,QMHRSNEM
     D ReSndMsg        PR                  ExtPgm('QMHRSNEM')
     D  MessageKey                    4A   Const
     D  ErrCode                        *
     D  DS_ToCSE                   9999    Options(*VarSize)
     D  ToCSELen                      9B 0 Const
     D  ToCSEFmt                      8A   Const
     D  FromCSE                        *   Const
     D  FromCSECtr                    9B 0 Const

      * Send Program Message
     D SndPgmMsg       PR                  ExtPgm('QMHSNDPM')
     D  MsgId                         7A   Const
     D  QualMsfF                     20A   Const
     D  MsgData                    9999    Const Options(*VarSize)
     D  MsgDataLen                    9B 0 Const
     D  MsgType                      10A   Const
     D  ToCSE                      9999    Const Options(*VarSize)
     D  ToCSECtr                      9B 0 Const
     D  MsgKey                        4A
     D  ErrCode                        *   Const

      *****************************************************************
      * Main Line Calculations
      *****************************************************************
      * Entry Parms
     C     *Entry        PList
     C                   Parm                    File
     C                   Parm                    Lib

      * Populate the "static" information
     C                   Eval      QDPfNm = File
     C                   Eval      QDPfLb = Lib

      * Loop over the list of queries
     C                   Read(E)   QADspObj
     C                   DoW       Not %EOF(QADspObj)

      * Retrieve the query information
     C                   Eval      QryIn  = *BLANK
     C                   Eval      QryOut = *BLANK
     C                   CallP     RtvQryF(ODOBNM   : ODLBNM
     C                                    :QryIn    : QryOut
     C                                    :ErrCode)

      * Send general exception if an error occure with RtvQryF
     C                   If        ErrCode = '1'
     C                   Eval      Msg = 'An error has occurred with the +
     C                                   RTVQRYF program'
     C                   CallP     SndPgmMsg( 'CPF9898' : 'QCPFMSG   QSYS'
     C                                      : Msg       : %Len(Msg)
     C                                      : '*ESCAPE' : '*'
     C                                      : 0         : MsgKey
     C                                      : *Null)
     C                   EndIf

      * Check for a match on the output file.
     C                   If        (QryOutFile = File) and (QryOutFileLib = Lib)
     C                   Eval      QDPfTp = 'O'
     C                   Eval      QDQryN = ODOBNM
     C                   Eval      QDQryL = ODLBNM
     C                   Write     DQD000R
     C                   EndIf

      * Check for a match in the input files (file and lib found at some
      *   (file and library found at some multiple of 40)
     C                   If        %Rem(%Scan(File+Lib:QryIn)-1 : 40) = 0
     C                   Eval      QDPfTp = 'I'
     C                   Eval      QDQryN = ODOBNM
     C                   Eval      QDQryL = ODLBNM
     C                   Write     DQD000R
     C                   EndIf

     C                   Read(E)   QADspObj
     C                   EndDo

     C                   Eval      *InLr = *On
     C                   Return

      **************************************************************************
     C     *PSSR         BegSr
      *    Error Handler
      **************************************************************************

      * Pass error message to caller
     C                   Eval      QMHCSE00 = *Null
     C                   Eval      QMHCC00  = 2
     C                   Eval      QMHPQ    = '*NONE'
     C                   CallP     ReSndMsg(*Blank: QMhErrCode : QMHM020001
     C                                     :%Size(QMHM020001) : 'RSNM0200'
     C                                     :*Null : 0)

      * End
     C                   Eval      *InLr = *On
     C                   Return

     C                   EndSr
