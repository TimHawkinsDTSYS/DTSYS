      *****************************************************************
      * Copyright (c) 2000 by Multifoods Distribution Group, Inc.     *
      * All rights reserved.                                          *
      *                                                               *
      * Pgm:  RTVQRYF                                                 *
      * Date: 04/21/00                                                *
      * Auth: Jeff Yanoviak                                           *
      * Desc: This program retreives the input and output file        *
      *       information from a query definition.                    *
      *                                                               *
      * Input Parameters:                                             *
      *  QryName - 10 character query name                            *
      *  QryLib  - 10 character library name where query exists       *
      * Output Parameters:                                            *
      *  QryIn - 1280 character "array" of input files (32 elements)  *
      *    QryInFile    - 10 character input file name                *
      *    QryInFileLib - 10 character input file library             *
      *    QryInFileMbr - 10 character input file member              *
      *    QryInFileFmt - 10 character input file format              *
      *  QryOut  - 30 character "data structure" of output file       *
      *    QryOutFile    - 10 character output file name              *
      *      Special value *NONE if query outputs to Display or Print *
      *      Special value *DFT if query outputs to QQRYOUT in QryLib *
      *    QryOutFileLib - 10 character output file library           *
      *    QryOutFileMbr - 10 character output file member            *
      *  ErrCode - 1 character completion code (0=Normal, 1=Error)    *
      *****************************************************************
     H DftActGrp(*No)
      *****************************************************************
      * Data Definitions
      *****************************************************************
      * These constants define the offsets in the query object (dump)
      * where the pertinent information is stored.  All offsets are
      * adjusted by +1 for the QUsRtvUs API.
     D QryOutTypeOff   C                   Const(261)
     D QryOutOffOff    C                   Const(381)
     D QryInCountOff   C                   Const(559)
     D QryInOff        C                   Const(563)

      * Entry Parameters
     D QryName         S             10A
     D QryLib          S             10A
     D QryIn           S           1280A
     D QryOut          DS
     D  QryOutFile                   10A
     D  QryOutFileLib                10A
     D  QryOutFileMbr                10A
     D ErrCode         S              1A

      * Working Variables
     D Idx             S             10I 0

      * User Space Variables
     D QUsQName        S             20A   Inz('QRYDMP    QTEMP     ')
     D QUsExtAtr       S             10A   Inz('QryDump')
     D QUsInzSiz       S              9B 0 Inz(x'1000')
     D QUsInzVal       S              1A   Inz(x'00')
     D QUsAut          S             10A   Inz('*ALL')
     D QUsTxt          S             50A   Inz('User Space for RtvQryF')
     D QUsLib          S             10A
     D QUsErrCode      S               *   Inz(*Null)

      * Messaging Variables
     D QMhErrCode      S               *   Inz(*Null)

      * Query Variables
     D QryOutType      S              1A
     D QryOutTmp       S             34A
     D QryInTmp        S             80A

      * The following numeric query variables are declared as data structures to
      * conform to the QUsRtvUs prototype (DS type is passed as character data)
     D QryOutOffDS     DS
     D  QryOutOff                    10U 0
     D QryInCountDS    DS
     D  QryInCount                    5U 0

      * Working data structure for QUsChgUsA API
     D QUsAttr         DS
     D  QUsNumRec                     9B 0 Inz(1)
     D  QUsKey                        9B 0 Inz(3)
     D  QUsRecLen                     9B 0 Inz(1)
     D  QUsRecData                    1A   Inz('1')

      * Prototypes
      * This program dumps a Query object to a user space
     D DmpQry          PR                  ExtPgm('RQF005R')
     D  QueryName                    10A   Const
     D  QueryLib                     10A   Const
     D  QualUSName                   20A   Const

      * Retreive User Space
     D QUsRtvUs        PR                  ExtPgm('QUSRTVUS')
     D  QualifiedName                20A   Const
     D  StartingPos                   9B 0 Const
     D  DataRcvLength                 9B 0 Const
     D  DataRcv                    9999    Options(*Varsize)

      * Receive Message
     D QMhRmvPm        PR                  ExtPgm('QMHRMVPM')
     D  CSE                          16A   Const
     D  CSECtr                        9B 0 Const
     D  MessageKey                    4A   Const
     D  MsgToRmv                     10A   Const
     D  ErrCode                        *

      *****************************************************************
      * Main Line Calculations
      *****************************************************************
      * Entry Parms
     C     *Entry        PList
     C                   Parm                    QryName
     C                   Parm                    QryLib
     C                   Parm                    QryIn
     C                   Parm                    QryOut
     C                   Parm                    ErrCode

      * Dump query to user space
     C                   CallP     DmpQry(QryName : QryLib : QUsQName)

      * Retreive the output type
     C                   CallP     QUsRtvUs(QUsQName : QryOutTypeOff :
     C                                      %Size(QryOutType) : QryOutType)

      * Check to see if an outfile is defined for this query
     C                   If        QryOutType <> '3'
     C                   Eval      QryOutFile = '*NONE'
     C                   Else

      * Get the offsite for the outfile information in the query
     C                   CallP     QUsRtvUs(QUsQName : QryOutOffOff :
     C                                      %Size(QryOutOffDS) : QryOutOffDS)

      * Check to see if this query uses the default output file (denoted by a
      * null offset)
     C                   If        QryOutOff = 0
     C                   Eval      QryOutFile = '*DFT'
     C                   Else

      * If the program reaches this point, there is an outfile.  Get it's info
      * from the 5th position after the specified offset to account for padding
      * and the adjustment for QUsRtvUS.
     C                   CallP     QUsRtvUs(QUsQName : QryOutOff + 5 :
     C                                      %Size(QryOutTmp) : QryOutTmp)
     C                   Eval      QryOutFile    = %Subst(QryOutTmp :  1 : 10)
     C                   Eval      QryOutFileLib = %Subst(QryOutTmp : 13 : 10)
     C                   Eval      QryOutFileMbr = %Subst(QryOutTmp : 25 : 10)

     C                   EndIf
     C                   EndIf

      * Get the number of input files
     C                   CallP     QUsRtvUs(QUsQName : QryInCountOff :
     C                                      %Size(QryInCountDS) : QryInCountDS)

      * Loop once for each input file
     C                   For       Idx = 0 To QryInCount - 1

      * The input file information is stored in 80 byte blocks, but this program
      * only returnes four 10 byte file input characteristics.  So, retreive the
      * block represented by Idx and substring it's contents into the "array"
      * element represented by Idx.
     C                   CallP     QUsRtvUs(QUsQName : QryInOff + (Idx * 80) :
     C                                      %Size(QryInTmp) : QryInTmp)
     C                   Eval      %Subst(QryIn    :  1 + (Idx * 40) : 40) =
     C                             %Subst(QryInTmp :  1 : 10) +
     C                             %Subst(QryInTmp : 13 : 10) +
     C                             %Subst(QryInTmp : 25 : 10) +
     C                             %Subst(QryInTmp : 37 : 10)

     C                   EndFor

      * Delete any completion messages from called programs
     C                   CallP     QMhRmvPm( '*ALLINACT' : 0 : '    '
     C                                     : '*ALL' : QMhErrCode)

      * Cleanup and exit
     C                   ExSr      Cleanup

     C                   Eval      *InLr = *On
     C                   Return

      **************************************************************************
     C     *InzSr        BegSr
      *    Initialize program
      **************************************************************************

      * Assume normal end
     C                   Eval      ErrCode = '0'

      * Create a working user space (parms are defined and initialized above)
     C                   Call      'QUSCRTUS'
     C                   Parm                    QUsQName
     C                   Parm                    QUsExtAtr
     C                   Parm                    QUsInzSiz
     C                   Parm                    QUsInzVal
     C                   Parm                    QUsAut
     C                   Parm                    QUsTxt

      * Change the user space size to grow automatically (parms are defined and
      * initialized above)
     C                   Call      'QUSCUSAT'
     C                   Parm                    QUsLib
     C                   Parm                    QUsQName
     C                   Parm                    QUsAttr
     C                   Parm                    QUsErrCode

     C                   EndSr

      **************************************************************************
     C     Cleanup       BegSr
      *    Cleanup program
      **************************************************************************

      * Delete the user space
     C                   Call(e)   'QUSDLTUS'
     C                   Parm                    QUsQName
     C                   Parm                    QUsErrCode

     C                   EndSr

      **************************************************************************
     C     *PSSR         BegSr
      *    Error Handler
      **************************************************************************
      * Cleanup
     C                   Exsr      Cleanup

      * Abnormal end
     C                   Eval      QryIn   = *Blank
     C                   Eval      QryOut  = *Blank
     C                   Eval      ErrCode = '1'

     C                   Eval      *InLr = *On
     C                   Return

     C                   EndSr
