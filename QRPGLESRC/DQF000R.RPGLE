      *****************************************************************
      * Copyright (c) 2000 by Multifoods Distribution Group, Inc.     *
      * All rights reserved.                                          *
      *                                                               *
      * Pgm:  DSPQRYF01R                                              *
      * Date: 08/23/00                                                *
      * Auth: Jeff Yanoviak                                           *
      * Desc: This program retrieves file information for a list of   *
      *       queries and outputs that information to a file.         *
      *                                                               *
      * Parameters:                                                   *
      *   None.                                                       *
      *****************************************************************
     H DftActGrp(*No)
      *****************************************************************
      * File Definitions
      *****************************************************************
     FQADspObj  IF   E             Disk
     FDQF000P   O    E             Disk
      *****************************************************************
      * Data Definitions
      *****************************************************************
      * Working Variables
     D Idx             S             10I 0
     D ErrCode         S              1A
     D Msg             S             80A

      * Query Variables
     D QryInTmp        S           1280A

     D QryIn           DS
     D  QryInFile                    10A
     D  QryInFileLib                 10A
     D  QryInFileMbr                 10A
     D  QryInFileFmt                 10A

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
      * Loop over the list of queries
     C                   Read(E)   QADspObj
     C                   DoW       Not %EOF(QADspObj)

      * Populate the 'static' output fields for this query
     C                   Eval      DQQryN = ODOBNM
     C                   Eval      DQQryL = ODLBNM

      * Retrieve the query information
     C                   Eval      QryInTmp = *BLANK
     C                   Eval      QryOut   = *BLANK
     C                   CallP     RtvQryF(DQQryN   : DQQryL
     C                                    :QryInTmp : QryOut
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

      * If there is an output file for the query, write a corresponding record
     C                   If        QryOutFile <> '*NONE'
     C                   Eval      DQPfTp = 'O'
     C                   Eval      DQPfNm = QryOutFile
     C                   Eval      DQPfLb = QryOutFileLib
     C                   Eval      DQPfMb = QryOutFileMbr
     C                   Eval      DQPfFm = *BLANK
     C                   Write     dqf000R
     C                   EndIf

      * Write a record for each input file
     C                   Eval      DQPfTp = 'I'
     C                   For       Idx = 0 to 31
     C                   Eval      QryIn = %Subst(QryInTmp
     C                                           :(40 * Idx) + 1
     C                                           :40)

     C                   If        QryInFile = *BLANK
     C                   Leave
     C                   EndIf

     C                   Eval      DQPfNm = QryInFile
     C                   Eval      DQPfLb = QryInFileLib
     C                   Eval      DQPfMb = QryInFileMbr
     C                   Eval      DQPfFm = QryInFileFmt
     C                   Write     dqf000R

     C                   Endfor

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

