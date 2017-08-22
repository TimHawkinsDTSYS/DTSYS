      ****************************************************************
      * Copyright (c) 2000 by Multifoods Distribution Group, Inc.    *
      * All rights reserved.                                         *
      *                                                              *
      * Pgm:  UsDmpQry                                               *
      * Date: 04/21/00                                               *
      * Auth: Jeff Yanoviak                                          *
      * Desc: This program dumps the binary internal contents of the *
      *       specified query to the specified user space.           *
      *                                                              *
      * Input Parameters:                                            *
      *  QryName - 10 character query name                           *
      *  QryLib  - 10 character library name where query exists      *
      *  QUsName - 20 character qualified user space name            *
      * Output Parameters:                                           *
      *  None                                                        *
      ****************************************************************
     H DftActGrp(*No)

      * Working file
     FDmpFil    IF   F  528        DISK    UsrOpn

      *****************************************************************
      * Data Definitions
      *****************************************************************
      * Entry Parameters
     D QryName         S             10A
     D QryLib          S             10A
     D QUsName         S             20A

      * Working Variables
     D Cmd             S            100A

      * Message Handling Variables
     D QMhErrCode      S               *   Inz(*Null)

      * User Space Variables
     D QUsStrPos       S              9B 0 Inz(1)
     D QUsDataForce    S              1A   Inz('1')

      * Prototypes
      * Change User Space (update user space contents)
     D QUsChgUs        PR                  ExtPgm('QUSCHGUS')
     D  QualifiedName                20A   Const
     D  StartingPos                   9B 0 Const
     D  DataLength                    9B 0 Const
     D  Data                       9999    Options(*VarSize)
     D  ForceChanges                  1A

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

     D SysCmd          PR                  ExtPgm('QCMDEXC')
     D  CmdString                   300A   Options(*VarSize) Const
     D  CmdStringSize                15P 5 Const
     D  CmdOptions                    3A   Options(*NoPass) Const

      * Working file field definition
     IDmpFil    NS  01
     I                                  1  512  SavfDta
     I                                257  512  NoOMH
     I                                513  528  ChkSum

      *****************************************************************
      * Main Line Calculations
      *****************************************************************
      * Entry Parms
     C     *Entry        PList
     C                   Parm                    QryName
     C                   Parm                    QryLib
     C                   Parm                    QUsName

      * Create a working savf file and save the *QRYDFN to it.
     C                   Eval      Cmd = 'CRTSAVF FILE(QTEMP/DMPFIL)'
     C                   CallP     SysCmd(Cmd:%Size(Cmd))

     C                   Eval      Cmd = 'SAVOBJ OBJ(' + %Trim(QryName) + ') ' +
     C                                   'LIB( ' + %Trim(QryLib) + ') '        +
     C                                   'DEV(*SAVF) OBJTYPE(*QRYDFN) '        +
     C                                   'SAVF(QTEMP/DMPFIL)'
     C                   CallP     SysCmd(Cmd:%Size(Cmd))

      * Override to the save file and open it.  The override starts at record
      * 33, skipping the 32 record header in the save file.
     C                   Eval      Cmd = 'OVRSAVF FILE(DMPFIL) EXTEND(*NO) '   +
     C                                   'POSITION(*RRN 33) WAITFILE(*IMMED) ' +
     C                                   'SHARE(*NO) OPNSCOPE(*ACTGRPDFN)'
     C                   CallP     SysCmd(Cmd:%Size(Cmd))
     C                   Open      DmpFil

      * Prime the read loop.  The first 256 bytes of the first record contain
      * the Object Management Header (OMH), which is not part of the query
      * definition object.
     C                   Read      DmpFil
     C                   CallP     QUsChgUs(QUsName : QUsStrPos : %Size(NoOMH)
     C                                      : NoOMH : QUsDataForce)
     C                   Eval      QUsStrPos = QUsStrPos + %Size(NoOMH)

      * Read the rest of the file, and write it to the user space.
     C                   DoU       %Eof(DmpFil)
     C                   Read      DmpFil

     C                   CallP     QUsChgUs(QUsName : QUsStrPos : %Size(SavfDta)
     C                                      : SavfDta : QUsDataForce)
     C                   Eval      QUsStrPos = QUsStrPos + %Size(SavfDta)

     C                   EndDo

      * Cleanup and exit
     C                   ExSr      Cleanup
     C                   Eval      *InLr = *On

      **************************************************************************
     C     Cleanup       BegSr
      *    Cleanup working file
      **************************************************************************
     C                   Close     DmpFil

     C                   Eval      Cmd = 'DLTF FILE(QTEMP/DMPFIL)'
     C                   CallP(e)  SysCmd(Cmd:%Size(Cmd))

     C                   EndSr

      **************************************************************************
     C     *PSSR         BegSr
      *    Error Handler - Cleanup working objects and pass exception to the
      *                    caller.
      **************************************************************************
      * Cleanup
     C                   Exsr      Cleanup

      * Pass error message to caller
     C                   Eval      QMHCSE00 = *Null
     C                   Eval      QMHCC00  = 2
     C                   Eval      QMHPQ    = '*NONE'
     C                   CallP     ReSndMsg(*Blank: QMhErrCode: QMHM020001:
     C                                      %Size(QMHM020001): 'RSNM0200':
     C                                      *Null: 0)

      * Exit Program
     C                   Eval      *InLr = *On
     C                   Return

     C                   EndSr
