      *PARMS dftactgrp(*no)
     **
     **  Program . . : CIR000R (was CBX127)
     **  Description : Change IFS attributes - CPP
     **  Author  . . : Carsten Flensburg
     **  Published . : Club Tech iSeries Programming Tips Newsletter
     **  Date  . . . : November 18, 2004
     **
     **
     **
     **  Program summary
     **  ---------------
     **
     **  Unix type APIs:
     **    Qp0lSetAttr   Set IFS object        Changes the specified attribute
     **                  attribute             for the specified IFS object.
     **                                        Not all attributes are supported
     **                                        by all file systems.
     **
     **  MI builtins:
     **    _MEMMOVE      Copy memory           Copies a string from one pointer
     **                                        specified location to another.
     **
     **  Message handling API:
     **    QMHSNDPM      Send program message  Sends a message to a program stack
     **                                        entry (current, previous, etc.) or
     **                                        an external message queue.
     **
     **                                        Both messages defined in a message
     **                                        file and immediate messages can be
     **                                        used. For specific message types
     **                                        only one or the other is allowed.
     **
     **
     **  Programmer's notes:
     **    The following Qp0lSetAttr attribute-ID is supported as of V5R1 only:
     **
     **       27  QP0L_ATTR_CCSID          Coded characer set identifier
     **
     **    The following Qp0lSetAttr attribute-IDs are supported as of V5R2 only:
     **
     **       31  QP0L_ATTR_DISK_STG_OPT   How to allocate auxiliary storage
     **       32  QP0L_ATTR_MAIN_STG_OPT   How to allocate main storage
     **      301  QP0L_ATTR_SUID           Set effective user ID
     **      302  QP0L_ATTR_SGID           Set effective group ID
     **
     **
     **  Compile options:
     **    CrtRpgMod Module( CIR000R)
     **              DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CIR000R)
     **              Module( CIR000R)
     **              ActGrp( *NEW )
     **
     **
     **-- Control specifications:  -------------------------------------------**
     H Option( *SrcStmt )  BndDir( 'QC2LE' )
     **-- API error information:
     D ERRC0100        Ds                  Qualified
     D  BytPro                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      256a
     **-- Global variables:
     D MsgKey          s              4a
     **-- Object attributes:
     D QP0L_ATTR_CREATE_TIME...
     D                 c                   4
     D QP0L_ATTR_ACCESS_TIME...
     D                 c                   5
     D QP0L_ATTR_MODIFY_TIME...
     D                 c                   7
     D QP0L_ATTR_PC_READ_ONLY...
     D                 c                   17
     D QP0L_ATTR_PC_HIDDEN...
     D                 c                   18
     D QP0L_ATTR_PC_SYSTEM...
     D                 c                   19
     D QP0L_ATTR_PC_ARCHIVE...
     D                 c                   20
     D QP0L_ATTR_SYSTEM_ARCHIVE...
     D                 c                   21
     D QP0L_ATTR_CODEPAGE...
     D                 c                   22
     D QP0L_ATTR_ALWCKPWRT...
     D                 c                   26
     D QP0L_ATTR_CCSID...
     D                 c                   27
     D QP0L_ATTR_DISK_STG_OPT...
     D                 c                   31
     D QP0L_ATTR_MAIN_STG_OPT...
     D                 c                   32
     D QP0L_ATTR_RESET_DATE...
     D                 c                   200
     D QP0L_ATTR_SUID  c                   300
     D QP0L_ATTR_SGID  c                   301
     **-- File attribute constants:
     D QP0L_PC_NOT_READONLY...
     D                 c                   x'00'
     D QP0L_PC_READONLY...
     D                 c                   x'01'
     D QP0L_PC_NOT_HIDDEN...
     D                 c                   x'00'
     D QP0L_PC_HIDDEN...
     D                 c                   x'01'
     D QP0L_PC_NOT_SYSTEM...
     D                 c                   x'00'
     D QP0L_PC_SYSTEM...
     D                 c                   x'01'
     D QP0L_PC_NOT_CHANGED...
     D                 c                   x'00'
     D QP0L_PC_CHANGED...
     D                 c                   x'01'
     D QP0L_SYSTEM_NOT_CHANGED...
     D                 c                   x'00'
     D QP0L_SYSTEM_CHANGED...
     D                 c                   x'01'
     D QP0L_NOT_ALWCKPWRT...
     D                 c                   x'00'
     D QP0L_ALWCKPWRT...
     D                 c                   x'01'
     D QP0L_STG_NORMAL...
     D                 c                   x'00'
     D QP0L_STG_MINIMIZE...
     D                 c                   x'01'
     D QP0L_STG_DYNAMIC...
     D                 c                   x'02'
     D QP0L_SUID_OFF   c                   x'00'
     D QP0L_SUID_ON    c                   x'01'
     D QP0L_SGID_OFF   c                   x'00'
     D QP0L_SGID_ON    c                   x'01'

     **- Set attribute:
     D SetAtr          Pr            10i 0 ExtProc( 'Qp0lSetAttr' )
     D  SaPthNam                       *   Value
     D  SaAtrLst                       *   Value
     D  SaBufSizPrv                  10u 0 Value
     D  SaFlwSymLnk                  10u 0 Value
     D  SaDots                       10i 0 Options( *NoPass )
     **-- Error number:
     D sys_errno       Pr              *    ExtProc( '__errno' )
     **-- Error string:
     D sys_strerror    Pr              *    ExtProc( 'strerror' )
     D  errno                        10i 0  Value
     **-- Copy memory:
     D memcpy          Pr              *   ExtProc( '_MEMMOVE' )
     D pOutMem                         *   Value
     D pInpMem                         *   Value
     D iMemSiz                       10u 0 Value
     **-- Send program message:
     D SndPgmMsg       Pr                  ExtPgm( 'QMHSNDPM' )
     D  SpMsgId                       7a   Const
     D  SpMsgFq                      20a   Const
     D  SpMsgDta                    128a   Const
     D  SpMsgDtaLen                  10i 0 Const
     D  SpMsgTyp                     10a   Const
     D  SpCalStkE                    10a   Const  Options( *VarSize )
     D  SpCalStkCtr                  10i 0 Const
     D  SpMsgKey                      4a
     D  SpError                   32767a          Options( *VarSize )

     **-- Change IFS attribute:  ---------------------------------------------**
     D ChgIfsAtr       Pr            10i 0
     D  PxIfsObj                   5002a   Const  Varying
     D  PxAtrId                      10i 0 Const
     D  PxAtrVal_p                     *   Value
     D  PxAtrSiz                     10i 0 Const
     **-- Send diagnostic message:
     D SndDiagMsg      Pr            10i 0
     D  PxMsgDta                    512a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgDta                    512a   Const  Varying
     **-- Send completion message:
     D SndCmpMsg       Pr            10i 0
     D  PxMsgDta                    512a   Const  Varying
     **-- Error identification:
     D errno           Pr            10i 0
     D strerror        Pr           128a   Varying

     **-- Entry parameters:
     D CIR000R         Pr
     D  PxIfsObj                   5002a   Varying
     D  PxFlwSymLnk                  10i 0
     D  PxRdOnly                      1a
     D  PxHidden                      1a
     D  PxPcSys                       1a
     D  PxPcArc                       1a
     D  PxSysArc                      1a
     D  PxAlwCkpWrt                   1a
     D  PxCcsId                      10i 0
     D  PxDiskStgOpt                  1a
     D  PxMainStgOpt                  1a
     D  PxSetEuid                     1a
     D  PxSetEgid                     1a
     **
     D CIR000R         Pi
     D  PxIfsObj                   5002a   Varying
     D  PxFlwSymLnk                  10i 0
     D  PxRdOnly                      1a
     D  PxHidden                      1a
     D  PxPcSys                       1a
     D  PxPcArc                       1a
     D  PxSysArc                      1a
     D  PxAlwCkpWrt                   1a
     D  PxCcsId                      10i 0
     D  PxDiskStgOpt                  1a
     D  PxMainStgOpt                  1a
     D  PxSetEuid                     1a
     D  PxSetEgid                     1a

      /Free

        If  PxCcsId > *Zero;

          ChgIfsAtr( PxIfsObj
                   : QP0L_ATTR_CCSID
                   : %Addr( PxCcsId )
                   : %Size( PxCcsId )
                   );
        EndIf;

        If  PxRdOnly < x'FF';

          ChgIfsAtr( PxIfsObj
                   : QP0L_ATTR_PC_READ_ONLY
                   : %Addr( PxRdOnly )
                   : %Size( PxRdOnly )
                   );
        EndIf;

        If  PxHidden < x'FF';

          ChgIfsAtr( PxIfsObj
                   : QP0L_ATTR_PC_HIDDEN
                   : %Addr( PxHidden )
                   : %Size( PxHidden )
                   );
        EndIf;


        If  PxPcSys < x'FF';

          ChgIfsAtr( PxIfsObj
                   : QP0L_ATTR_PC_SYSTEM
                   : %Addr( PxPcSys )
                   : %Size( PxPcSys )
                   );
        EndIf;

        If  PxPcArc < x'FF';

          ChgIfsAtr( PxIfsObj
                   : QP0L_ATTR_PC_ARCHIVE
                   : %Addr( PxPcArc )
                   : %Size( PxPcArc )
                   );
        EndIf;

        If  PxSysArc < x'FF';

          ChgIfsAtr( PxIfsObj
                   : QP0L_ATTR_SYSTEM_ARCHIVE
                   : %Addr( PxSysArc )
                   : %Size( PxSysArc )
                   );
        EndIf;

        If  PxAlwCkpWrt < x'FF';

          ChgIfsAtr( PxIfsObj
                   : QP0L_ATTR_ALWCKPWRT
                   : %Addr( PxAlwCkpWrt )
                   : %Size( PxAlwCkpWrt )
                   );
        EndIf;

        If  PxDiskStgOpt < x'FF';

          ChgIfsAtr( PxIfsObj
                   : QP0L_ATTR_DISK_STG_OPT
                   : %Addr( PxDiskStgOpt )
                   : %Size( PxDiskStgOpt )
                   );
        EndIf;

        If  PxMainStgOpt < x'FF';

          ChgIfsAtr( PxIfsObj
                   : QP0L_ATTR_MAIN_STG_OPT
                   : %Addr( PxMainStgOpt )
                   : %Size( PxMainStgOpt )
                   );
        EndIf;

        If  PxSetEuid < x'FF';

          ChgIfsAtr( PxIfsObj
                   : QP0L_ATTR_SUID
                   : %Addr( PxSetEuid )
                   : %Size( PxSetEuid )
                   );
        EndIf;

        If  PxSetEgid < x'FF';

          ChgIfsAtr( PxIfsObj
                   : QP0L_ATTR_SGID
                   : %Addr( PxSetEgid )
                   : %Size( PxSetEgid )
                   );
        EndIf;

        *InLr = *On;
        Return;

      /End-Free

     **-- Change IFS attribute:  ---------------------------------------------**
     P ChgIfsAtr       B
     D                 Pi            10i 0
     D  PxIfsObj                   5002a   Const  Varying
     D  PxAtrId                      10i 0 Const
     D  PxAtrVal_p                     *   Value
     D  PxAtrSiz                     10i 0 Const
     **-- API Path constants:
     D CUR_CCSID       c                   0
     D CUR_CTRID       c                   x'0000'
     D CUR_LNGID       c                   x'000000'
     D CHR_DLM_1       c                   0
     **-- API path:
     D Path            Ds                  Qualified  Align
     D  CcsId                        10i 0 Inz( CUR_CCSID )
     D  CtrId                         2a   Inz( CUR_CTRID )
     D  LngId                         3a   Inz( CUR_LNGID )
     D                                3a   Inz( *Allx'00' )
     D  PthTypI                      10i 0 Inz( CHR_DLM_1 )
     D  PthNamLen                    10i 0
     D  PthNamDlm                     2a   Inz( '/ ' )
     D                               10a   Inz( *Allx'00' )
     D  PthNam                     5000a
     **- Set attribute buffer:
     D Buffer          Ds                  Qualified  Align
     D  OfsNxtAtr                    10u 0
     D  AtrId                        10u 0
     D  SizAtr                       10u 0
     D                                4a   Inz( *Allx'00' )
     D  AtrDta                      128a

      /Free

        Path.PthNam    = PxIfsObj;
        Path.PthNamLen = %Len( PxIfsObj );

        Buffer.OfsNxtAtr = 0;
        Buffer.AtrId     = PxAtrId;
        Buffer.SizAtr    = PxAtrSiz;

        memcpy( %Addr( Buffer.AtrDta ): PxAtrVal_p: PxAtrSiz );

        If  SetAtr( %Addr( Path )
                  : %Addr( Buffer )
                  : %Size( Buffer )
                  : PxFlwSymLnk
                  ) < *Zero;

          SndDiagMsg( %Char( errno ) + ': ' + strerror );
          SndEscMsg( 'CHGIFSATR command ended in error' );

        Else;

          SndCmpMsg( 'IFS object attribute changed.' );
        EndIf;

        Return *Zero;

      /End-Free

     **
     P ChgIfsAtr       E
     **-- Get runtime error number:  -----------------------------------------**
     P errno           B
     D                 Pi            10i 0
     **
     D Error           s             10i 0  Based( pError )  NoOpt

      /Free

        pError = sys_errno;

        Return  Error;

      /End-Free

     P Errno           E
     **-- Get runtime error text:  -------------------------------------------**
     P strerror        B
     D                 Pi           128a    Varying

      /Free

        Return  %Str( sys_strerror( Errno ));

      /End-Free

     P strerror        E
     **-- Send diagnostic message:  ------------------------------------------**
     P SndDiagMsg      B
     D                 Pi            10i 0
     D  PxMsgDta                    512a   Const  Varying
     **
     D MsgKey          s              4a

      /Free

        SndPgmMsg( 'CPF9897'
                 : 'QCPFMSG   *LIBL'
                 : PxMsgDta
                 : %Len( PxMsgDta )
                 : '*DIAG'
                 : '*PGMBDY'
                 : 1
                 : MsgKey
                 : ERRC0100
                 );

        If  ERRC0100.BytAvl > *Zero;
          Return  -1;

        Else;
          Return   0;
        EndIf;

      /End-Free

     P SndDiagMsg      E
     **-- Send escape message:  ----------------------------------------------**
     P SndEscMsg       B
     D                 Pi            10i 0
     D  PxMsgDta                    512a   Const  Varying

      /Free

        SndPgmMsg( 'CPF9898'
                 : 'QCPFMSG   *LIBL'
                 : PxMsgDta
                 : %Len( PxMsgDta )
                 : '*ESCAPE'
                 : '*PGMBDY'
                 : 1
                 : MsgKey
                 : ERRC0100
                 );

        If  ERRC0100.BytAvl > *Zero;
          Return  -1;

        Else;
          Return  0;

        EndIf;

      /End-Free

     P SndEscMsg       E
     **-- Send completion message:  ------------------------------------------**
     P SndCmpMsg       B
     D                 Pi            10i 0
     D  PxMsgDta                    512a   Const  Varying

      /Free

        SndPgmMsg( 'CPF9897'
                 : 'QCPFMSG   *LIBL'
                 : PxMsgDta
                 : %Len( PxMsgDta )
                 : '*COMP'
                 : '*PGMBDY'
                 : 1
                 : MsgKey
                 : ERRC0100
                 );

        If  ERRC0100.BytAvl > *Zero;
          Return  -1;

        Else;
          Return  0;

        EndIf;

      /End-Free

     **
     P SndCmpMsg       E

