      *PARMS dftactgrp(*no)
     **
     **  Program . . : cir010r
     **  Description : Change IFS attributes - prompt override program
     **  Author  . . : Carsten Flensburg
     **  Published . : Club Tech iSeries Programming Tips Newsletter
     **  Date  . . . : November 18, 2004
     **
     **
     **  Parameters:
     **    PxCmdNam_q  INPUT      Qualified command name
     **
     **    PxKeyPrm1   INPUT      Key parameter indentifying the
     **                           IFS object to retrieve attribute
     **                           information about.
     **
     **    PxKeyPrm2   INPUT      Key parameter specifying the
     **                           symbolic link parameter setting.
     **
     **    PxCmdStr    OUTPUT     The formatted command prompt
     **                           string returning the current
     **                           attribute setting of the IFS
     **                           object.
     **
     **
     **  Program summary
     **  ---------------
     **
     **  Unix type APIs:
     **    Qp0lGetAttr   Get IFS object        Gets one or more attributes for
     **                  attributes            the IFS object specified.  Not
     **                                        all attributes are supported by
     **                                        all file systems.
     **
     **  C library function:
     **    memset        Set bytes to value    The storage pointed to by the
     **                                        first parameter, is set to the
     **                                        value of the second parameter,
     **                                        for the number of bytes defined
     **                                        by the third parameter.
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
     **    The following Qp0lGetAttr attribute-IDs are supported as of V5R2 only:
     **
     **       29  QP0L_ATTR_SYS_SIGNED     Signed by a trusted source
     **       30  QP0L_ATTR_MULT_SIGS      More than one OS/400 digital signature
     **       31  QP0L_ATTR_DISK_STG_OPT   How to allocate auxiliary storage
     **       32  QP0L_ATTR_MAIN_STG_OPT   How to allocate main storage
     **       33  QP0L_ATTR_DIR_FORMAT     Directory format; *TYPE1, *TYPE2
     **       34  QP0L_ATTR_AUDIT          Object auditing value
     **      301  QP0L_ATTR_SUID           Set effective user ID
     **      302  QP0L_ATTR_SGID           Set effective group ID
     **
     **
     **  Compile options:
     **    CrtRpgMod Module( cir010r )
     **              DbgView( *LIST )
     **
     **    CrtPgm    Pgm( cir010r )
     **              Module( cir010r )
     **              ActGrp( *NEW )
     **
     **
     **-- Control specification:  --------------------------------------------**
     H Option( *SrcStmt )  BndDir( 'QC2LE' )
     **-- System information:
     D                SDs
     D  PsPgmNam         *Proc
     **-- API error information:
     D ERRC0100        Ds                  Qualified
     D  BytPro                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      256a
     **-- Global variables:
     D MsgKey          s              4a
     **
     D BufSizAvl       s             10u 0 Inz( 0 )
     D NbrBytRtn       s             10u 0 Inz( 0 )
     D ApiBytAlc       s             10u 0
     D rc              s             10i 0
     D Idx             s             10i 0
     D pBuffer         s               *
     D ErrTxt          s            256a
     **-- Global constants:
     D CUR_CCSID       c                   0
     D CUR_CTRID       c                   x'0000'
     D CUR_LNGID       c                   x'000000'
     D CHR_DLM_1       c                   0
     **-- File attributes:
     D QP0L_ATTR_OBJTYPE...
     D                 c                   0
     D QP0L_ATTR_DATA_SIZE...
     D                 c                   1
     D QP0L_ATTR_ALLOC_SIZE...
     D                 c                   2
     D QP0L_ATTR_EXTENDED_ATTR_SIZE...
     D                 c                   3
     D QP0L_ATTR_CREATE_TIME...
     D                 c                   4
     D QP0L_ATTR_ACCESS_TIME...
     D                 c                   5
     D QP0L_ATTR_CHANGE_TIME...
     D                 c                   6
     D QP0L_ATTR_MODIFY_TIME...
     D                 c                   7
     D QP0L_ATTR_STG_FREE...
     D                 c                   8
     D QP0L_ATTR_CHECKED_OUT...
     D                 c                   9
     D QP0L_ATTR_LOCAL_REMOTE...
     D                 c                   10
     D QP0L_ATTR_AUT   c                   11
     D QP0L_ATTR_FILE_ID...
     D                 c                   12
     D QP0L_ATTR_ASP   c                   13
     D QP0L_ATTR_DATA_SIZE_64...
     D                 c                   14
     D QP0L_ATTR_ALLOC_SIZE_64...
     D                 c                   15
     D QP0L_ATTR_USAGE_INFORMATION...
     D                 c                   16
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
     D QP0L_ATTR_FILE_FORMAT...
     D                 c                   23
     D QP0L_ATTR_UDFS_DEFAULT_FORMAT...
     D                 c                   24
     D QP0L_ATTR_JOURNAL_INFORMATION...
     D                 c                   25
     D QP0L_ATTR_ALWCKPWRT...
     D                 c                   26
     D QP0L_ATTR_CCSID...
     D                 c                   27
     D QP0L_ATTR_SIGNED...
     D                 c                   28
     D QP0L_ATTR_SYS_SIGNED...
     D                 c                   29
     D QP0L_ATTR_MULT_SIGS...
     D                 c                   30
     D QP0L_ATTR_DISK_STG_OPT...
     D                 c                   31
     D QP0L_ATTR_MAIN_STG_OPT...
     D                 c                   32
     D QP0L_ATTR_DIR_FORMAT...
     D                 c                   33
     D QP0L_ATTR_AUDIT...
     D                 c                   34
     D QP0L_ATTR_SUID  c                   300
     D QP0L_ATTR_SGID  c                   301
     **-- File attribute constants:
     D QP0L_SYS_NOT_STG_FREE...
     D                 c                   x'00'
     D QP0L_SYS_STG_FREE...
     D                 c                   x'01'
     D QP0L_NOT_CHECKED_OUT...
     D                 c                   x'00'
     D QP0L_CHECKED_OUT...
     D                 c                   x'01'
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
     D QP0L_FILE_FORMAT_TYPE1...
     D                 c                   x'00'
     D QP0L_FILE_FORMAT_TYPE2...
     D                 c                   x'01'
     D QP0L_UDFS_DEFAULT_TYPE1...
     D                 c                   x'00'
     D QP0L_UDFS_DEFAULT_TYPE2...
     D                 c                   x'01'
     D QP0L_NOT_JOURNALED...
     D                 c                   x'00'
     D QP0L_JOURNALED  c                   x'01'
     D QP0L_JOURNAL_SUBTREE...
     D                 c                   x'80'
     D QP0L_JOURNAL_OPTIONAL_ENTRIES...
     D                 c                   x'08'
     D QP0L_JOURNAL_AFTER_IMAGES...
     D                 c                   x'20'
     D QP0L_JOURNAL_BEFORE_IMAGES...
     D                 c                   x'40'
     D QP0L_NOT_ALWCKPWRT...
     D                 c                   x'00'
     D QP0L_ALWCKPWRT...
     D                 c                   x'01'
     D QP0L_NOT_SIGNED...
     D                 c                   x'00'
     D QP0L_SIGNED     c                   x'01'
     D QP0L_SYSTEM_SIGNED_NO...
     D                 c                   x'00'
     D QP0L_SYSTEM_SIGNED_YES...
     D                 c                   x'01'
     D QP0L_MULT_SIGS_NO...
     D                 c                   x'00'
     D QP0L_MULT_SIGS_YES...
     D                 c                   x'01'
     D QP0L_STG_NORMAL...
     D                 c                   x'00'
     D QP0L_STG_MINIMIZE...
     D                 c                   x'01'
     D QP0L_STG_DYNAMIC...
     D                 c                   x'02'
     D QP0L_DIR_FORMAT_TYPE1...
     D                 c                   x'00'
     D QP0L_DIR_FORMAT_TYPE2...
     D                 c                   x'01'
     D QP0L_SUID_OFF   c                   x'00'
     D QP0L_SUID_ON    c                   x'01'
     D QP0L_SGID_OFF   c                   x'00'
     D QP0L_SGID_ON    c                   x'01'
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
     **
     D AtrIds          Ds                  Qualified  Align
     D  NbrAtr                       10i 0
     D  AtrId                        10i 0 Dim( 32 )
     **
     D Buffer          Ds                  Qualified  Align  Based( pBufferE )
     D  OfsNxtAtr                    10u 0
     D  AtrId                        10u 0
     D  SizAtr                       10u 0
     D                                4a
     D  AtrDta                     1024a
     D   AtrInt                      10i 0 Overlay( AtrDta )

     **-- Get attributes:
     D GetAtr          Pr            10i 0 ExtProc( 'Qp0lGetAttr' )
     D  GaFilNam                       *   Value
     D  GaAtrLst                       *   Value
     D  GaBuffer                       *   Value
     D  GaBufSizPrv                  10u 0 Value
     D  GaBufSizAvl                  10u 0
     D  GaBufSizRtn                  10u 0
     D  GaFlwSymLnk                  10u 0 Value
     D  GaDots                       10i 0 Options( *NoPass )
     **-- Initialize memory:
     D memset          Pr            10i 0 ExtProc( 'memset' )
     D  pStg                           *   Value
     D  InzVal                       10u 0 Value
     D  InzByt                       10i 0 Value
     **-- Error number:
     D sys_errno       Pr              *    ExtProc( '__errno' )
     **-- Error string:
     D sys_strerror    Pr              *    ExtProc( 'strerror' )
     D  errno                        10i 0  Value
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

     **-- Send diagnostic message:
     D SndDiagMsg      Pr            10i 0
     D  PxMsgDta                    512a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
     **-- Error identification:
     D errno           Pr            10i 0
     **
     D strerror        Pr           128a   Varying
     **
     D cir010r         Pr
     D  PxCmdNam_q                   20a
     D  PxKeyPrm1                  5002a   Varying
     D  PxKeyPrm2                    10i 0
     D  PxCmdStr                  32674a   Varying
     **
     D cir010r         Pi
     D  PxCmdNam_q                   20a
     D  PxKeyPrm1                  5002a   Varying
     D  PxKeyPrm2                    10i 0
     D  PxCmdStr                  32674a   Varying

      /Free

        Path.PthNam    = PxKeyPrm1;
        Path.PthNamLen = %Len( PxKeyPrm1 );

        ApiBytAlc = 32767;
        pBuffer   = %Alloc( ApiBytAlc );

        memset( pBuffer: x'00': ApiBytAlc );

        AtrIds.NbrAtr    = 11;
        AtrIds.AtrId(1)  = QP0L_ATTR_PC_READ_ONLY;
        AtrIds.AtrId(2)  = QP0L_ATTR_PC_HIDDEN;
        AtrIds.AtrId(3)  = QP0L_ATTR_PC_SYSTEM;
        AtrIds.AtrId(4)  = QP0L_ATTR_PC_ARCHIVE;
        AtrIds.AtrId(5)  = QP0L_ATTR_SYSTEM_ARCHIVE;
        AtrIds.AtrId(6)  = QP0L_ATTR_ALWCKPWRT;
        AtrIds.AtrId(7)  = QP0L_ATTR_CCSID;
        AtrIds.AtrId(8)  = QP0L_ATTR_DISK_STG_OPT;
        AtrIds.AtrId(9)  = QP0L_ATTR_MAIN_STG_OPT;
        AtrIds.AtrId(10) = QP0L_ATTR_SUID;
        AtrIds.AtrId(11) = QP0L_ATTR_SGID;

        If  GetAtr( %Addr( Path )
                  : %Addr( AtrIds )
                  : pBuffer
                  : ApiBytAlc
                  : BufSizAvl
                  : NbrBytRtn
                  : PxKeyPrm2
                  ) = 0;

           pBufferE = pBuffer;

           For  Idx = 1  to AtrIds.NbrAtr;

             ExSr  RtvAtrVal;

             If  Buffer.OfsNxtAtr = *Zero;
               Leave;
             EndIf;

             pBufferE = pBuffer + Buffer.OfsNxtAtr;
           EndFor;
        Else;

          SndDiagMsg( %Char( Errno ) + ': ' + Strerror );
          SndEscMsg( 'CPF0011': '' );
        EndIf;

        DeAlloc  pBuffer;

        *InLr = *On;
        Return;


        BegSr  RtvAtrVal;

          Select;
          When  Buffer.AtrId = QP0L_ATTR_PC_READ_ONLY;

            If  %Subst( Buffer.AtrDta: 1: Buffer.SizAtr ) = QP0L_PC_READONLY;
              PxCmdStr += '?<READONLY(*YES) ';
            Else;
              PxCmdStr += '?<READONLY(*NO) ';
            EndIf;

          When  Buffer.AtrId = QP0L_ATTR_PC_HIDDEN;

            If  %Subst( Buffer.AtrDta: 1: Buffer.SizAtr ) = QP0L_PC_HIDDEN;
              PxCmdStr += '?<HIDDEN(*YES) ';
            Else;
              PxCmdStr += '?<HIDDEN(*NO) ';
            EndIf;

          When  Buffer.AtrId = QP0L_ATTR_PC_SYSTEM;

            If  %Subst( Buffer.AtrDta: 1: Buffer.SizAtr ) = QP0L_PC_SYSTEM;
              PxCmdStr += '?<PCSYSTEM(*YES) ';
            Else;
              PxCmdStr += '?<PCSYSTEM(*NO) ';
            EndIf;

          When  Buffer.AtrId = QP0L_ATTR_PC_ARCHIVE;

            If  %Subst( Buffer.AtrDta: 1: Buffer.SizAtr ) = QP0L_PC_CHANGED;
              PxCmdStr += '?<PCARCHIVE(*YES) ';
            Else;
              PxCmdStr += '?<PCARCHIVE(*NO) ';
            EndIf;

          When  Buffer.AtrId = QP0L_ATTR_SYSTEM_ARCHIVE;

            If  %Subst( Buffer.AtrDta: 1: Buffer.SizAtr ) = QP0L_SYSTEM_CHANGED;
              PxCmdStr += '?<SYSARCHIVE(*YES) ';
            Else;
              PxCmdStr += '?<SYSARCHIVE(*NO) ';
            EndIf;

          When  Buffer.AtrId = QP0L_ATTR_ALWCKPWRT;

            Select;
            When  Buffer.SizAtr = *Zero;
              PxCmdStr += '?*ALWCKPWRT() ';
            When  %Subst( Buffer.AtrDta: 1: Buffer.SizAtr ) = QP0L_ALWCKPWRT;
              PxCmdStr += '?<ALWCKPWRT(*YES) ';
            Other;
              PxCmdStr += '?<ALWCKPWRT(*NO) ';
            EndSl;

          When  Buffer.AtrId = QP0L_ATTR_CCSID;

              PxCmdStr += '?<CCSID(' + %Char( Buffer.AtrInt ) + ') ';

          When  Buffer.AtrId = QP0L_ATTR_DISK_STG_OPT;

            Select;
            When  Buffer.SizAtr = *Zero;
              PxCmdStr += '?*DISKSTGOPT() ';
            When  %Subst( Buffer.AtrDta: 1: Buffer.SizAtr ) = QP0L_STG_NORMAL;
              PxCmdStr += '?<DISKSTGOPT(*NORMAL) ';
            When  %Subst( Buffer.AtrDta: 1: Buffer.SizAtr ) = QP0L_STG_MINIMIZE;
              PxCmdStr += '?<DISKSTGOPT(*MINIMIZE) ';
            When  %Subst( Buffer.AtrDta: 1: Buffer.SizAtr ) = QP0L_STG_DYNAMIC;
              PxCmdStr += '?<DISKSTGOPT(*DYNAMIC) ';
            EndSl;

          When  Buffer.AtrId = QP0L_ATTR_MAIN_STG_OPT;

            Select;
            When  Buffer.SizAtr = *Zero;
              PxCmdStr += '?*MAINSTGOPT() ';
            When  %Subst( Buffer.AtrDta: 1: Buffer.SizAtr ) = QP0L_STG_NORMAL;
              PxCmdStr += '?<MAINSTGOPT(*NORMAL) ';
            When  %Subst( Buffer.AtrDta: 1: Buffer.SizAtr ) = QP0L_STG_MINIMIZE;
              PxCmdStr += '?<MAINSTGOPT(*MINIMIZE) ';
            When  %Subst( Buffer.AtrDta: 1: Buffer.SizAtr ) = QP0L_STG_DYNAMIC;
              PxCmdStr += '?<MAINSTGOPT(*DYNAMIC) ';
            EndSl;

          When  Buffer.AtrId = QP0L_ATTR_SUID;

            If  %Subst( Buffer.AtrDta: 1: Buffer.SizAtr ) = QP0L_SUID_ON;
              PxCmdStr += '?<SETEUID(*YES) ';
            Else;
              PxCmdStr += '?<SETEUID(*NO) ';
            EndIf;

          When  Buffer.AtrId = QP0L_ATTR_SGID;

            If  %Subst( Buffer.AtrDta: 1: Buffer.SizAtr ) = QP0L_SGID_ON;
              PxCmdStr += '?<SETEGID(*YES) ';
            Else;
              PxCmdStr += '?<SETEGID(*NO) ';
            EndIf;

          EndSl;

        EndSr;

      /End-Free

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

        Return  %Str( sys_strerror( errno ));

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
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
     **
     D MsgKey          s              4a

      /Free

        SndPgmMsg( PxMsgId
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
          Return   0;
        EndIf;

      /End-Free

     P SndEscMsg       E

