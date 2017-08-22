      /TITLE Work with Service Program References
     ** PARMS DFTACTGRP(*no)
     **
     **  Program . . : CBX196
     **  Description : Work with Service Program References - CPP
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Programming Tips Newsletter
     **  Date  . . . : September 25, 2008
     **
     **
     **  Program description:
     **    This program will produce a list of all programs and service
     **    programs referenced by the specified service program.
     **
     **
     **  Compile and setup instructions:
     **    CrtRpgMod   Module( CBX196 )
     **                DbgView( *NONE )
     **                Aut( *USE )
     **
     **    CrtPgm      Pgm( CBX196 )
     **                Module( CBX196 )
     **                ActGrp( *NEW )
     **                Aut( *USE )
     **
     **
     **-- Control specification:  --------------------------------------------**
     H Option( *SrcStmt: *NoDebugIo )  BndDir( 'QC2LE' )

     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      128a

     **-- Global constants:
     D OFS_MSGDTA      c                   16
     D TYP_ILE         c                   'B'
     **
     D NBR_KEY         c                   1
     D KEY_OFS         c                   80
     D SIZ_NLS_INF     c                   290
     D JOB_RUN         c                   0
     D CHAR_NLS        c                   4
     D ASCEND          c                   1
     D DESCEND         c                   2
     **
     D SRT_PUT         c                   1
     D SRT_END         c                   2
     D SRT_GET         c                   3
     D SRT_CNL         c                   4
     **
     D USRSPC_Q        c                   'WRKSPGREF QTEMP'
     D EXT_ATR         c                   ' '
     D USP_SIZ         c                   65535
     D INZ_VAL         c                   x'00'
     D PUB_AUT         c                   '*CHANGE'
     D TXT_DSC         c                   ' '
     D USP_RPL         c                   '*NO'
     **-- UIM constants:
     D PNLGRP_Q        c                   'CBX196P   *LIBL     '
     D PNLGRP          c                   'CBX196P   '
     D SCP_AUT_RCL     c                   -1
     D RDS_OPT_INZ     c                   'N'
     D PRM_IFC_0       c                   0
     D CLO_NORM        c                   'M'
     D FNC_EXIT        c                   -4
     D FNC_CNL         c                   -8
     D KEY_F05         c                   5
     D KEY_F17         c                   17
     D KEY_F18         c                   18
     D RTN_ENTER       c                   500
     D HLP_WDW         c                   'N'
     D POS_TOP         c                   'TOP'
     D POS_BOT         c                   'BOT'
     D LIST_COMP       c                   'ALL'
     D LIST_SAME       c                   'SAME'
     D EXIT_SAME       c                   '*SAME'
     D TRIM_SAME       c                   'S'
     **
     D APP_PRTF        c                   'QPRINT    *LIBL'
     D ODP_SHR         c                   'N'
     D SPLF_NAM        c                   'PSRVPGMREF'
     D SPLF_USRDTA     c                   'WRKSPGREF '
     D EJECT_NO        c                   'N'

     **-- Global variables:
     D Idx             s             10i 0
     D ObjItr          s             10i 0
     D SigIdx          s             10i 0
     D CrtSpc          s               n
     D SrtAct          s               n
     D PgmTyp          s              1a
     D SysDts          s               z
     **
     D SpgRefSig       s             16a
     D SpgRefLib       s             10a
     D CurSpgSig       s             16a
     D LstSpgSig       s             16a   Dim( 256 )

     **-- UIM variables:
     D UIM             Ds                  Qualified
     D  AppHdl                        8a
     D  LstHdl                        4a
     D  EntHdl                        4a
     D  FncRqs                       10i 0
     D  EntLocOpt                     4a
     D  LstPos                        4a
     **-- List attributes structure:
     D LstAtr          Ds                  Qualified
     D  LstCon                        4a
     D  ExtPgmVar                    10a
     D  DspPos                        4a
     D  AlwTrim                       1a

     **-- UIM Panel exit program record:
     D ExpRcd          Ds                  Qualified
     D  ExitPg                       20a   Inz( 'CBX196E   *LIBL' )
     **-- UIM Panel header record:
     D HdrRcd          Ds                  Qualified
     D  SysDat                        7a
     D  SysTim                        6a
     D  TimZon                       10a
     D  SrvPgmNam                    10a
     D  SrvPgmLib                    10a
     D  SrvPgmSig                    16a
     D  SrvPgmHex                    32a
     D  SrvPgmTxt                    50a
     **-- UIM Panel emphasis record:
     D EmpRcd          Ds                  Qualified
     D  SigEmp                        1a
     **-- UIM List entry:
     D LstEnt          Ds                  Qualified
     D  Option                        5i 0
     D  LstPos                       30a
     D  ObjNam                       10a
     D  LibNam                       10a
     D  PgmTyp                       10a
     D  PgmTyp2                      10a
     D  ObjAtr                       10a
     D  ObjTxt                       50a
     D  CrtPrf                       10a
     D  RefLib                       10a
     D  RefSig                       16a
     D  RefHex                       32a
     D  SigStt                        1a
     **
     D LstEntPos       Ds                  LikeDs( LstEnt )

     **-- User space generic header:
     D UsrSpcHdr       Ds                  Qualified  Based( pUsrSpc )
     D  OfsInpSec                    10i 0 Overlay( UsrSpcHdr: 109 )
     D  SizInpSec                    10i 0 Overlay( UsrSpcHdr: 113 )
     D  OfsHdrSec                    10i 0 Overlay( UsrSpcHdr: 117 )
     D  SizHdrSec                    10i 0 Overlay( UsrSpcHdr: 121 )
     D  OfsLstEnt                    10i 0 Overlay( UsrSpcHdr: 125 )
     D  NumLstEnt                    10i 0 Overlay( UsrSpcHdr: 133 )
     D  SizLstEnt                    10i 0 Overlay( UsrSpcHdr: 137 )
     **-- User space pointers:
     D pUsrSpc         s               *   Inz( *Null )
     D pHdrInf         s               *   Inz( *Null )
     D pLstEnt         s               *   Inz( *Null )
     **-- API input information:
     D ApiInpInf       Ds                  Qualified  Based( pInpInf )
     D  UsrSpcNamSpf                 10a
     D  UsrSpcLibSpf                 10a
     D  FmtNamSpf                     8a
     D  SbsNamSpf                    10a
     D  SbsLibSpf                    10a
     **-- API header information:
     D ApiHdrInf       Ds                  Qualified  Based( pHdrInf )
     D  SbsNamUsd                    10a
     D  SbsLibUsd                    10a

     **-- List API parameters:
     D LstApi          Ds                  Qualified  Inz
     D  RtnRcdNbr                    10i 0
     D  NbrKeyRtn                    10i 0 Inz( %Elem( LstApi.KeyFld ))
     D  KeyFld                       10i 0 Dim( 2 )
     D  ObjTyp                       10a
     **-- Object information:
     D ObjInf          Ds          4096    Qualified
     D  ObjNam_q                     20a
     D   ObjNam                      10a   Overlay( ObjNam_q: 1 )
     D   ObjLib                      10a   Overlay( ObjNam_q: 11 )
     D  ObjTyp                       10a
     D  InfSts                        1a
     D                                1a
     D  FldNbrRtn                    10i 0
     D  Data                               Like( KeyInf )
     **-- Key information:
     D KeyInf          Ds                  Qualified  Based( pKeyInf )
     D  FldInfLen                    10i 0
     D  KeyFld                       10i 0
     D  DtaTyp                        1a
     D                                3a
     D  DtaLen                       10i 0
     D  Data                        256a
     **-- List information:
     D LstInf          Ds                  Qualified
     D  RcdNbrTot                    10i 0
     D  RcdNbrRtn                    10i 0
     D  Handle                        4a
     D  RcdLen                       10i 0
     D  InfSts                        1a
     D  Dts                          13a
     D  LstSts                        1a
     D                                1a
     D  InfLen                       10i 0
     D  Rcd1                         10i 0
     D                               40a
     **-- Sort information:
     D SrtInf          Ds                  Qualified
     D  NbrKeys                      10i 0 Inz( 0 )
     D  SrtInf                       12a   Dim( 10 )
     D   KeyFldOfs                   10i 0 Overlay( SrtInf:  1 )
     D   KeyFldLen                   10i 0 Overlay( SrtInf: *Next )
     D   KeyFldTyp                    5i 0 Overlay( SrtInf: *Next )
     D   SrtOrd                       1a   Overlay( SrtInf: *Next )
     D   Rsv                          1a   Overlay( SrtInf: *Next )
     **-- Authority control:
     D AutCtl          Ds                  Qualified
     D  AutFmtLen                    10i 0 Inz( %Size( AutCtl ))
     D  CalLvl                       10i 0 Inz( 0 )
     D  DplObjAut                    10i 0 Inz( 0 )
     D  NbrObjAut                    10i 0 Inz( 0 )
     D  DplLibAut                    10i 0 Inz( 0 )
     D  NbrLibAut                    10i 0 Inz( 0 )
     D                               10i 0 Inz( 0 )
     D  ObjAut                       10a   Dim( 10 )
     D  LibAut                       10a   Dim( 10 )
     **-- Selection control:
     D SltCtl          Ds
     D  SltFmtLen                    10i 0 Inz( %Size( SltCtl ))
     D  SltOmt                       10i 0 Inz( 0 )
     D  DplSts                       10i 0 Inz( 20 )
     D  NbrSts                       10i 0 Inz( 1 )
     D                               10i 0 Inz( 0 )
     D  Status                        1a   Inz( '*' )
     **-- Object information key fields:
     D KEY0200         Ds                  Qualified
     D  InfSts                        1a
     D  ExtObjAtr                    10a
     D  TxtDsc                       50a
     D  UsrDfnAtr                    10a
     D  OrdLibL                      10i 0
     D                                5a
     **
     D CrtPrf          s             10a
     **-- Program service program references:
     D PGML0200        Ds                  Qualified  Based( pPGML0200 )
     D  PgmNam                       10a
     D  PgmLib                       10a
     D  BndSrvPgmNam                 10a
     D  BndSrvPgmLib                 10a
     D  BndSrvPgmSig                 16a
     **-- Service program service program references:
     D SPGL0200        Ds                  Qualified  Based( pSPGL0200 )
     D  SrvPgmNam                    10a
     D  SrvPgmLib                    10a
     D  BndSrvPgmNam                 10a
     D  BndSrvPgmLib                 10a
     D  BndSrvPgmSig                 16a
     **-- Service program signature list:
     D SPGL0800        Ds                  Qualified  Based( pSPGL0800 )
     D  SrvPgmNam                    10a
     D  SrvPgmLib                    10a
     D  SrvPgmSig                    16a

     **-- Sort API parameters:
     D SrtApi          Ds                  Qualified  Inz
     D  DtaBufLen                    10i 0
     D  DtaRtnLen                    10i 0
     D  Omit                         16a
     **
     D RqsCtlBlk       Ds                  Qualified  Inz
     D  BlkLen                       10i 0
     D  RqsTyp                       10i 0 Inz( 8 )
     D                               10i 0
     D  Options                      10i 0
     D  RcdLen                       10i 0 Inz( %Size( LstEnt ))
     D  RcdCnt                       10i 0
     D  KeyOfs                       10i 0 Inz( KEY_OFS )
     D  KeyNbr                       10i 0
     D  NlsOfs                       10i 0
     D  InpFlsOfs                    10i 0
     D  InpFlsNbr                    10i 0
     D  OutFlsOfs                    10i 0
     D  OutFlsNbr                    10i 0
     D  KeyEntLen                    10i 0 Inz( %Size( SrtKeyInfDs ))
     D  NlsSsqLen                    10i 0 Inz( SIZ_NLS_INF )
     D  InpFenLen                    10i 0
     D  OutFenLen                    10i 0
     D  NlbMapOfs                    10i 0
     D  VlrAciOfs                    10i 0
     D                               10i 0
     **
     D SrtKeyInf                     20a   Dim( NBR_KEY )
     **
     D SrtTblQ                       20a   Inz( '*LANGIDSHR' )
     D SrtSeqCcsId                   10i 0 Inz( JOB_RUN )
     D SrtSeqLngId                   10a   Inz( '*JOBRUN' )
     D SrtSeqTbl                    256a
     **
     D SrtKeyInfDs     Ds                  Qualified  Inz
     D  KeyStrPos                    10i 0
     D  KeySize                      10i 0
     D  KeyDtaTyp                    10i 0
     D  KeyOrder                     10i 0
     D  KeyOrdPos                    10i 0
     **
     D RqsCtlBlkIo     Ds                  Qualified
     D  RqsTyp                       10i 0 Inz
     D                               10i 0 Inz
     D  RcdLen                       10i 0 Inz
     D  RcdCnt                       10i 0 Inz
     **
     D DtaBufInf       Ds                  Qualified  Inz
     D  RcdPrc                       10i 0
     D  RcdAvl                       10i 0
     D                                8a

     **-- Open list of objects:
     D LstObjs         Pr                  ExtPgm( 'QGYOLOBJ' )
     D  RcvVar                    65535a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  LstInf                       80a
     D  NbrRcdRtn                    10i 0 Const
     D  SrtInf                     1024a   Const  Options( *VarSize )
     D  ObjNam_q                     20a   Const
     D  ObjTyp                       10a   Const
     D  AutCtl                     1024a   Const  Options( *VarSize )
     D  SltCtl                     1024a   Const  Options( *VarSize )
     D  NbrKeyRtn                    10i 0 Const
     D  KeyFld                       10i 0 Const  Options( *VarSize )  Dim( 32 )
     D  Error                      1024a          Options( *VarSize )
     **
     D  JobIdInf                    256a          Options( *NoPass: *VarSize )
     D  JobIdFmt                      8a   Const  Options( *NoPass )
     **
     D  AspCtl                      256a          Options( *NoPass: *VarSize )
     **-- Get open list entry:
     D GetOplEnt       Pr                  ExtPgm( 'QGYGTLE' )
     D  RcvVar                    65535a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  Handle                        4a   Const
     D  LstInf                       80a
     D  NbrRcdRtn                    10i 0 Const
     D  RtnRcdNbr                    10i 0 Const
     D  Error                      1024a          Options( *VarSize )
     **-- Close list:
     D CloseLst        Pr                  ExtPgm( 'QGYCLST' )
     D  Handle                        4a   Const
     D  Error                      1024a          Options( *VarSize )

     **-- Retrieve program information:
     D RtvPgmInf       Pr                  ExtPgm( 'QCLRPGMI' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  PgmNam_q                     20a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Retrieve service program information:
     D RtvSrvPgmI      Pr                  ExtPgm( 'QBNRSPGM' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  PgmNam_q                     20a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- List program information:
     D LstPgmInf       Pr                  ExtPgm( 'QBNLPGMI' )
     D  UsrSpc_Q                     20a   Const
     D  FmtNam                       10a   Const
     D  PgmNam_q                     20a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- List service program information:
     D LstSrvPgmI      Pr                  ExtPgm( 'QBNLSPGM' )
     D  UsrSpc_Q                     20a   Const
     D  FmtNam                       10a   Const
     D  SrvPgmNam_q                  20a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Retrieve job information:
     D RtvJobInf       Pr                  ExtPgm( 'QUSRJOBI' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  JobNamQ                      26a   Const
     D  JobIntId                     16a   Const
     D  Error                     32767a          Options( *NoPass: *VarSize )
     **-- Send program message:
     D SndPgmMsg       Pr                  ExtPgm( 'QMHSNDPM' )
     D  MsgId                         7a   Const
     D  MsgFq                        20a   Const
     D  MsgDta                      128a   Const
     D  MsgDtaLen                    10i 0 Const
     D  MsgTyp                       10a   Const
     D  CalStkE                      10a   Const  Options( *VarSize )
     D  CalStkCtr                    10i 0 Const
     D  MsgKey                        4a
     D  Error                     32767a          Options( *VarSize )

     **-- Create user space:
     D CrtUsrSpc       Pr                  ExtPgm( 'QUSCRTUS' )
     D  SpcNamQ                      20a   Const
     D  ExtAtr                       10a   Const
     D  InzSiz                       10i 0 Const
     D  InzVal                        1a   Const
     D  PubAut                       10a   Const
     D  Text                         50a   Const
     D  Replace                      10a   Const  Options( *NoPass )
     D  Error                     32767a          Options( *NoPass: *VarSize )
     D  Domain                       10a   Const  Options( *NoPass )
     **-- Delete user space:
     D DltUsrSpc       Pr                  ExtPgm( 'QUSDLTUS' )
     D  SpcNamQ                      20a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Retrieve pointer to user space:
     D RtvPtrSpc       Pr                  ExtPgm( 'QUSPTRUS' )
     D  SpcNamQ                      20a   Const
     D  Pointer                        *
     D  Error                     32767a          Options( *NoPass: *VarSize )

     **-- Initialize sort:
     D InzSort         Pr                  ExtPgm( 'QLGSORT' )
     D  RqsCtlBlk                    80a   Const  Options( *VarSize )
     D  InpDtaBuf                 65535a   Const  Options( *VarSize )
     D  OutDtaBuf                 65535a          Options( *VarSize )
     D  OutDtaLen                    10i 0 Const
     D  RtnDtaLen                    10i 0
     D  Error                     32767a          Options( *VarSize )
     D  RtnRcdFb                    144a          Options( *VarSize: *NoPass )
     D  RtnRcdFbLen                  10i 0 Const  Options( *NoPass )
     **-- Sort input/output:
     D SortIo          Pr                  ExtPgm( 'QLGSRTIO' )
     D  RqsCtlBlk                    16a   Const
     D  InpDtaBuf                 65535a   Const  Options( *VarSize )
     D  OutDtaBuf                 65535a          Options( *VarSize )
     D  OutDtaLen                    10i 0 Const
     D  OutDtaInf                    16a
     D  Error                     32767a          Options( *VarSize )
     D  RtnRcdFb                    144a          Options( *VarSize: *NoPass )
     D  RtnRcdFbLen                  10i 0 Const  Options( *NoPass )

     **-- Open display application:
     D OpnDspApp       Pr                  ExtPgm( 'QUIOPNDA' )
     D  AppHdl                        8a
     D  PnlGrp_q                     20a   Const
     D  AppScp                       10i 0 Const
     D  ExtPrmIfc                    10i 0 Const
     D  FulScrHlp                     1a   Const
     D  Error                     32767a          Options( *VarSize )
     D  OpnDtaRcv                   128a          Options( *NoPass: *VarSize )
     D  OpnDtaRcvLen                 10i 0 Const  Options( *NoPass )
     D  OpnDtaRcvAvl                 10i 0        Options( *NoPass )
     **-- Open print application:
     D OpnPrtApp       Pr                  ExtPgm( 'QUIOPNPA' )
     D  AppHdl                        8a
     D  PnlGrp_q                     20a   Const
     D  AppScp                       10i 0 Const
     D  ExtPrmIfc                    10i 0 Const
     D  PrtDevF_q                    20a   Const
     D  AltFilNam                    10a   Const
     D  ShrOpnDtaPth                  1a   Const
     D  UsrDta                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     D  OpnDtaRcv                   128a          Options( *NoPass: *VarSize )
     D  OpnDtaRcvLen                 10i 0 Const  Options( *NoPass )
     D  OpnDtaRcvAvl                 10i 0        Options( *NoPass )
     **-- Display panel:
     D DspPnl          Pr                  ExtPgm( 'QUIDSPP' )
     D  AppHdl                        8a   Const
     D  FncRqs                       10i 0
     D  PnlNam                       10a   Const
     D  ReDspOpt                      1a   Const
     D  Error                     32767a          Options( *VarSize )
     D  UsrTsk                        1a   Const  Options( *NoPass )
     D  CalStkCnt                    10i 0 Const  Options( *NoPass )
     D  CalMsgQue                   256a   Const  Options( *NoPass: *VarSize )
     D  MsgKey                        4a   Const  Options( *NoPass )
     D  CsrPosOpt                     1a   Const  Options( *NoPass )
     D  FinLstEnt                     4a   Const  Options( *NoPass )
     D  ErrLstEnt                     4a   Const  Options( *NoPass )
     D  WaitTim                      10i 0 Const  Options( *NoPass )
     D  CalMsgQueLen                 10i 0 Const  Options( *NoPass )
     D  CalQlf                       20a   Const  Options( *NoPass )
     **-- Print panel:
     D PrtPnl          Pr                  ExtPgm( 'QUIPRTP' )
     D  AppHdl                        8a   Const
     D  PrtPnlNam                    10a   Const
     D  EjtOpt                        1a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Put dialog variable:
     D PutDlgVar       Pr                  ExtPgm( 'QUIPUTV' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a   Const  Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Add list entry:
     D AddLstEnt       Pr                  ExtPgm( 'QUIADDLE' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a   Const  Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  LstNam                       10a   Const
     D  EntLocOpt                     4a   Const
     D  LstEntHdl                     4a
     D  Error                     32767a          Options( *VarSize )
     **-- Get list entry:
     D GetLstEnt       Pr                  ExtPgm( 'QUIGETLE' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a   Const  Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  LstNam                       10a   Const
     D  PosOpt                        4a   Const
     D  CpyOpt                        1a   Const
     D  SltCri                       20a   Const
     D  SltHdl                        4a   Const
     D  ExtOpt                        1a   Const
     D  LstEntHdl                     4a
     D  Error                     32767a          Options( *VarSize )
     **-- Retrieve list attributes:
     D RtvLstAtr       Pr                  ExtPgm( 'QUIRTVLA' )
     D  AppHdl                        8a   Const
     D  LstNam                       10a   Const
     D  AtrRcv                    32767a          Options( *VarSize )
     D  AtrRcvLen                    10i 0 Const
     D  Error                     32767a          Options( *VarSize )
     **-- Set list attributes:
     D SetLstAtr       Pr                  ExtPgm( 'QUISETLA' )
     D  AppHdl                        8a   Const
     D  LstNam                       10a   Const
     D  LstCon                        4a   Const
     D  ExtPgmVar                    10a   Const
     D  DspPos                        4a   Const
     D  AlwTrim                       1a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Delete list:
     D DltLst          Pr                  ExtPgm( 'QUIDLTL' )
     D  AppHdl                        8a   Const
     D  LstNam                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Close application:
     D CloApp          Pr                  ExtPgm( 'QUICLOA' )
     D  AppHdl                        8a   Const
     D  CloOpt                        1a   Const
     D  Error                     32767a          Options( *VarSize )

     **-- Convert hex to character:
     D cvthc           Pr                  ExtProc( 'cvthc' )
     D  RcvHex                         *   Value
     D  SrcChr                         *   Value
     D  RcvLen                       10i 0 Value

     **-- Get reference signature:
     D GetRefSig       Pr            16a
     D  PxPgmNam                     10a   Const
     D  PxPgmLib                     10a   Const
     D  PxPgmTyp                     10a   Const
     D  PxSpgRefLib                  10a
     **-- Get program reference signature:
     D GetPgmRefSig    Pr            16a
     D  PxPgmNam                     10a   Const
     D  PxPgmLib                     10a   Const
     D  PxSpgRefLib                  10a
     **-- Get service program signature:
     D GetSpgRefSig    Pr            16a
     D  PxSpgNam                     10a   Const
     D  PxSpgLib                     10a   Const
     D  PxSpgRefLib                  10a
     **-- Get service program signature:
     D GetSpgSig       Pr            16a
     D  PxPgmNam                     10a   Const
     D  PxPgmLib                     10a   Const
     **-- Get service program library:
     D GetSpgLib       Pr            10a
     D  PxPgmNam                     10a   Const
     D  PxPgmLib                     10a   Const
     **-- Get service program text:
     D GetSpgTxt       Pr            50a
     D  PxSrvPgmNam                  10a   Const
     D  PxSrvPgmLib                  10a   Const
     **-- Get program type:
     D GetPgmTyp       Pr             1a
     D  PxPgmNam                     10a   Const
     D  PxPgmLib                     10a   Const
     **-- Get signature state:
     D GetSigStt       Pr             1a
     D  PxPgmSig                     16a   Const
     **-- Convert character to hex nibbles:
     D CvtToHex        Pr           512a   Varying
     D  PxHexStr                    256a   Varying  Const
     **-- Get job type:
     D GetJobTyp       Pr             1a
     **-- Send status message:
     D SndStsMsg       Pr            10i 0
     D  PxMsgDta                   1024a   Const  Varying
     **-- Send completion message:
     D SndCmpMsg       Pr            10i 0
     D  PxMsgDta                    512a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying

     **-- Entry parameters:
     D ObjNam_q        Ds
     D  ObjNam                       10a
     D  ObjLib                       10a
     **
     D CBX196          Pr
     D  PxSrvPgm_q                         LikeDs( ObjNam_q )
     D  PxRefPgm_q                         LikeDs( ObjNam_q )
     D  PxRefTyp                     10a
     D  PxSrtOrd                     10a
     D  PxOutOpt                      3a
     **
     D CBX196          Pi
     D  PxSrvPgm_q                         LikeDs( ObjNam_q )
     D  PxRefPgm_q                         LikeDs( ObjNam_q )
     D  PxRefTyp                     10a
     D  PxSrtOrd                     10a
     D  PxOutOpt                      3a

      /Free

        SndStsMsg( 'Retrieving service program information' );

        ExSr  InzOplApi;

        If  PxOutOpt = 'DSP'  And  GetJobTyp() = 'I';

          OpnDspApp( UIM.AppHdl
                   : PNLGRP_Q
                   : SCP_AUT_RCL
                   : PRM_IFC_0
                   : HLP_WDW
                   : ERRC0100
                   );
        Else;
          OpnPrtApp( UIM.AppHdl
                   : PNLGRP_Q
                   : SCP_AUT_RCL
                   : PRM_IFC_0
                   : APP_PRTF
                   : SPLF_NAM
                   : ODP_SHR
                   : SPLF_USRDTA
                   : ERRC0100
                   );
        EndIf;

        If  ERRC0100.BytAvl > *Zero;
          ExSr  EscApiErr;
        EndIf;

        PutDlgVar( UIM.AppHdl: ExpRcd: %Size( ExpRcd ): 'EXPRCD': ERRC0100 );

        ExSr  BldHdrRcd;
        ExSr  BldSpgLst;

        If  PxOutOpt = 'DSP'  And  GetJobTyp() = 'I';
          ExSr  DspLst;
        Else;
          ExSr  WrtLst;
        EndIf;

        CloApp( UIM.AppHdl: CLO_NORM: ERRC0100 );

        If  CrtSpc = *On;
          DltUsrSpc( USRSPC_Q: ERRC0100 );
        EndIf;

        *InLr = *On;
        Return;


        BegSr  DspLst;

          DoU  UIM.FncRqs = FNC_EXIT  Or  UIM.FncRqs = FNC_CNL;

            DspPnl( UIM.AppHdl: UIM.FncRqs: PNLGRP: RDS_OPT_INZ: ERRC0100 );

            Select;
            When  UIM.FncRqs = RTN_ENTER;
              Leave;

            When  UIM.FncRqs = KEY_F17;
              ExSr  PosLstTop;

            When  UIM.FncRqs = KEY_F18;
              ExSr  PosLstBot;
            EndSl;

          If  UIM.FncRqs = KEY_F05  And  UIM.EntLocOpt = 'NEXT';
            ExSr  GetLstPos;
            ExSr  DltSpgLst;
          EndIf;

          If  UIM.FncRqs = KEY_F05;
            ExSr  BldSpgLst;
            ExSr  SetLstPos;
          EndIf;

            ExSr  BldHdrRcd;
          EndDo;

        EndSr;

        BegSr  WrtLst;

          PrtPnl( UIM.AppHdl
                : 'PRTHDR'
                : EJECT_NO
                : ERRC0100
                );

          PrtPnl( UIM.AppHdl
                : 'PRTLST'
                : EJECT_NO
                : ERRC0100
                );

          SndCmpMsg( 'List has been printed.' );

        EndSr;

        BegSr  BldSpgLst;

          UIM.EntLocOpt = 'FRST';

          For  ObjItr = 1  To 2;

            Select;
            When  ObjItr = 1;
              LstApi.ObjTyp = '*PGM';

            When  ObjItr = 2;
              LstApi.ObjTyp = '*SRVPGM';
            EndSl;

            If  PxRefTyp = '*ANY'  Or  PxRefTyp = LstApi.ObjTyp;

              LstApi.RtnRcdNbr = 1;

              LstObjs( ObjInf
                     : %Size( ObjInf )
                     : LstInf
                     : 1
                     : SrtInf
                     : PxRefPgm_q
                     : LstApi.ObjTyp
                     : AutCtl
                     : SltCtl
                     : LstApi.NbrKeyRtn
                     : LstApi.KeyFld
                     : ERRC0100
                     );

              If  ERRC0100.BytAvl = *Zero;

                DoW  LstInf.LstSts <> '2'  Or
                     LstInf.RcdNbrTot >= LstApi.RtnRcdNbr;

                  ExSr  GetKeyDta;
                  ExSr  ChkSpgRef;

                  LstApi.RtnRcdNbr = LstApi.RtnRcdNbr + 1;

                  GetOplEnt( ObjInf
                           : %Size( ObjInf )
                           : LstInf.Handle
                           : LstInf
                           : 1
                           : LstApi.RtnRcdNbr
                           : ERRC0100
                           );

                  If  ERRC0100.BytAvl > *Zero;
                    Leave;
                  EndIf;
                EndDo;

                CloseLst( LstInf.Handle: ERRC0100 );
              EndIf;
            EndIf;
          EndFor;

          ExSr  WrtSrtLst;

          SetLstAtr( UIM.AppHdl
                   : 'DTLLST'
                   : LIST_COMP
                   : EXIT_SAME
                   : POS_TOP
                   : TRIM_SAME
                   : ERRC0100
                   );

        EndSr;

        BegSr  GetKeyDta;

          pKeyInf = %Addr( ObjInf.Data );

          For  Idx = 1  To ObjInf.FldNbrRtn;

            Select;
            When  KeyInf.KeyFld = 200;
              KEY0200 = %Subst( KeyInf.Data: 1: KeyInf.DtaLen );

            When  KeyInf.KeyFld = 405;
              CrtPrf = %Subst( KeyInf.Data: 1: KeyInf.DtaLen );
            EndSl;

            If  Idx < ObjInf.FldNbrRtn;
              pKeyInf = pKeyInf + KeyInf.FldInfLen;
            EndIf;
          EndFor;

        EndSr;

        BegSr  ChkSpgRef;

          If  ObjInf.ObjTyp = '*SRVPGM';
            PgmTyp = TYP_ILE;
          Else;
            PgmTyp = GetPgmTyp( ObjInf.ObjNam: ObjInf.ObjLib );
          EndIf;

          If  PgmTyp = TYP_ILE;

            SpgRefSig = GetRefSig( ObjInf.ObjNam
                                 : ObjInf.ObjLib
                                 : ObjInf.ObjTyp
                                 : SpgRefLib
                                 );

            If  SpgRefSig > *LoVal;
              ExSr AddSrtLst;
            EndIf;
          EndIf;

        EndSr;

        BegSr  InzSrtLst;

          SrtKeyInfDs.KeySize   = %Size( LstEnt.LstPos );
          SrtKeyInfDs.KeyDtaTyp = CHAR_NLS;
          SrtKeyInfDs.KeyOrder  = ASCEND;
          SrtKeyInfDs.KeyStrPos = 3;

          RqsCtlBlk.SrtKeyInf(1) = SrtKeyInfDs;

          RqsCtlBlk.NlsOfs = KEY_OFS +
                             ( %Size( RqsCtlBlk.SrtKeyInf ) * NBR_KEY );

          RqsCtlBlk.BlkLen = KEY_OFS +
                             ( %Size( RqsCtlBlk.SrtKeyInf ) * NBR_KEY ) +
                             SIZ_NLS_INF;

          RqsCtlBlk.KeyNbr = NBR_KEY;

          InzSort( RqsCtlBlk
                 : SrtApi.Omit
                 : SrtApi.Omit
                 : SrtApi.DtaBufLen
                 : SrtApi.DtaRtnLen
                 : ERRC0100
                 );

          If  ERRC0100.BytAvl = *Zero;
            SrtAct = *On;
          EndIf;

        EndSr;

        BegSr  AddSrtLst;

          If  SrtAct = *Off;
            ExSr  InzSrtLst;
          EndIf;

          RqsCtlBlkIo.RcdLen = RqsCtlBlk.RcdLen;
          RqsCtlBlkIo.RcdCnt = 1;
          RqsCtlBlkIo.RqsTyp = SRT_PUT;

          LstEnt.Option  = *Zero;

          Select;
          When  PxSrtOrd = '*OBJLIB';
            LstEnt.LstPos = ObjInf.ObjNam + ObjInf.ObjLib + ObjInf.ObjTyp;

          When  PxSrtOrd = '*TYPOBJ';
            LstEnt.LstPos = ObjInf.ObjTyp + ObjInf.ObjNam + ObjInf.ObjLib;

          When  PxSrtOrd = '*LIBOBJ';
            LstEnt.LstPos = ObjInf.ObjLib + ObjInf.ObjNam + ObjInf.ObjTyp;

          When  PxSrtOrd = '*LIBTYP';
            LstEnt.LstPos = ObjInf.ObjLib + ObjInf.ObjTyp + ObjInf.ObjNam;
          EndSl;

          LstEnt.ObjNam  = ObjInf.ObjNam;
          LstEnt.LibNam  = ObjInf.ObjLib;
          LstEnt.PgmTyp  = ObjInf.ObjTyp;
          LstEnt.PgmTyp2 = %Subst( ObjInf.ObjTyp: 2 );
          LstEnt.ObjAtr  = KEY0200.ExtObjAtr;
          LstEnt.ObjTxt  = KEY0200.TxtDsc;
          LstEnt.CrtPrf  = CrtPrf;
          LstEnt.RefLib  = SpgRefLib;
          LstEnt.RefSig  = SpgRefSig;
          LstEnt.RefHex  = CvtToHex( SpgRefSig );
          LstEnt.SigStt  = GetSigStt( SpgRefSig );

          SortIo( RqsCtlBlkIo
                : LstEnt
                : SrtApi.Omit
                : SrtApi.DtaBufLen
                : DtaBufInf
                : ERRC0100
                );

        EndSr;

        BegSr  WrtSrtLst;

          ExSr  EndSrtLst;

          EmpRcd.SigEmp = *Off;

          PutDlgVar( UIM.AppHdl: EmpRcd: %Size( EmpRcd ): 'EMPRCD': ERRC0100 );

          If  DtaBufInf.RcdAvl > *Zero;

            RqsCtlBlkIo.RqsTyp = SRT_GET;

            SrtApi.DtaBufLen = RqsCtlBlkIo.RcdLen;

            SortIo( RqsCtlBlkIo
                  : SrtApi.Omit
                  : LstEnt
                  : SrtApi.DtaBufLen
                  : DtaBufInf
                  : ERRC0100
                  );

            DoW  DtaBufInf.RcdPrc > *Zero  And  ERRC0100.BytAvl = *Zero;

              ExSr  PutLstEnt;

              SortIo( RqsCtlBlkIo
                    : SrtApi.Omit
                    : LstEnt
                    : SrtApi.DtaBufLen
                    : DtaBufInf
                    : ERRC0100
                    );

            EndDo;
          EndIf;

        EndSr;

        BegSr  EndSrtLst;

          If  SrtAct = *On;

            RqsCtlBlkIo.RqsTyp = SRT_END;

            SortIo( RqsCtlBlkIo
                  : SrtApi.Omit
                  : SrtApi.Omit
                  : SrtApi.DtaBufLen
                  : DtaBufInf
                  : ERRC0100
                  );

            SrtAct = *Off;
          EndIf;

        EndSr;

        BegSr  PutLstEnt;

          If  LstEnt.SigStt = '0'  And  EmpRcd.SigEmp = '0'  Or
              LstEnt.SigStt > '0'  And  EmpRcd.SigEmp > '0';

            EmpRcd.SigEmp = EmpRcd.SigEmp = *Off;

            PutDlgVar( UIM.AppHdl: EmpRcd: %Size( EmpRcd ): 'EMPRCD': ERRC0100);
          EndIf;

          AddLstEnt( UIM.AppHdl
                   : LstEnt
                   : %Size( LstEnt )
                   : 'DTLRCD'
                   : 'DTLLST'
                   : UIM.EntLocOpt
                   : UIM.LstHdl
                   : ERRC0100
                   );

          UIM.EntLocOpt = 'NEXT';

        EndSr;

        BegSr  GetLstPos;

          RtvLstAtr( UIM.AppHdl: 'DTLLST': LstAtr: %Size( LstAtr ): ERRC0100 );

          If  LstAtr.DspPos <> 'TOP';

            GetLstEnt( UIM.AppHdl
                     : LstEnt
                     : %Size( LstEnt )
                     : 'DTLRCD'
                     : 'DTLLST'
                     : 'HNDL'
                     : 'Y'
                     : *Blanks
                     : LstAtr.DspPos
                     : 'N'
                     : UIM.EntHdl
                     : ERRC0100
                     );

            LstEntPos = LstEnt;
          EndIf;

        EndSr;

        BegSr  SetLstPos;

          If  LstAtr.DspPos <> 'TOP';

            LstEnt = LstEntPos;

            PutDlgVar( UIM.AppHdl
                     : LstEnt
                     : %Size( LstEnt )
                     : 'DTLRCD'
                     : ERRC0100
                     );

            GetLstEnt( UIM.AppHdl
                     : LstEnt
                     : %Size( LstEnt )
                     : '*NONE'
                     : 'DTLLST'
                     : 'FSLT'
                     : 'N'
                     : 'EQ        LSTPOS'
                     : LstAtr.DspPos
                     : 'N'
                     : UIM.EntHdl
                     : ERRC0100
                     );

            If  ERRC0100.BytAvl = *Zero;

              SetLstAtr( UIM.AppHdl
                       : 'DTLLST'
                       : LIST_SAME
                       : EXIT_SAME
                       : UIM.EntHdl
                       : TRIM_SAME
                       : ERRC0100
                       );

            EndIf;
          EndIf;

        EndSr;

        BegSr  PosLstTop;

          SetLstAtr( UIM.AppHdl
                   : 'DTLLST'
                   : LIST_SAME
                   : EXIT_SAME
                   : POS_TOP
                   : TRIM_SAME
                   : ERRC0100
                   );

        EndSr;

        BegSr  PosLstBot;

          SetLstAtr( UIM.AppHdl
                   : 'DTLLST'
                   : LIST_SAME
                   : EXIT_SAME
                   : POS_BOT
                   : TRIM_SAME
                   : ERRC0100
                   );

        EndSr;

        BegSr  DltSpgLst;

          DltLst( UIM.AppHdl: 'DTLLST': ERRC0100 );

        EndSr;

        BegSr  BldHdrRcd;

          SysDts = %Timestamp();

          HdrRcd.SysDat = %Char( %Date( SysDts ): *CYMD0 );
          HdrRcd.SysTim = %Char( %Time( SysDts ): *HMS0 );
          HdrRcd.TimZon = '*SYS';

          ExSr  GetSrvPgmInf;

          HdrRcd.SrvPgmNam = PxSrvPgm_q.ObjNam;
          HdrRcd.SrvPgmLib = PxSrvPgm_q.ObjLib;
          HdrRcd.SrvPgmSig = CurSpgSig;
          HdrRcd.SrvPgmHex = CvtToHex( CurSpgSig );
          HdrRcd.SrvPgmTxt = GetSpgTxt( HdrRcd.SrvPgmNam: HdrRcd.SrvPgmLib );

          PutDlgVar( UIM.AppHdl: HdrRcd: %Size( HdrRcd ): 'HDRRCD': ERRC0100 );

        EndSr;

        BegSr  GetSrvPgmInf;

          If  PxSrvPgm_q.ObjLib = '*LIBL';
            PxSrvPgm_q.ObjLib = GetSpgLib( PxSrvPgm_q.ObjNam
                                         : PxSrvPgm_q.ObjLib
                                         );
          EndIf;

          CurSpgSig = GetSpgSig( PxSrvPgm_q.ObjNam: PxSrvPgm_q.ObjLib );

          LstSrvPgmI( USRSPC_Q: 'SPGL0800': PxSrvPgm_q: ERRC0100 );

          If  ERRC0100.BytAvl = *Zero;
            ExSr  Prc800Spc;
          EndIf;

        EndSr;

        BegSr  Prc800Spc;

          RtvPtrSpc( USRSPC_Q: pUsrSpc );

          pInpInf = pUsrSpc + UsrSpcHdr.OfsInpSec;
          pHdrInf = pUsrSpc + UsrSpcHdr.OfsHdrSec;
          pSPGL0800 = pUsrSpc + UsrSpcHdr.OfsLstEnt;

          For  SigIdx = 1  to UsrSpcHdr.NumLstEnt;

            If  SigIdx <= %Elem( LstSpgSig );
              LstSpgSig(SigIdx) = SPGL0800.SrvPgmSig;
            EndIf;

            If  SigIdx = %Elem( LstSpgSig );
              Leave;
            EndIf;

            If  SigIdx < UsrSpcHdr.NumLstEnt;
              pSPGL0800 += UsrSpcHdr.SizLstEnt;
            Else;
              Leave;
            EndIf;
          EndFor;

        EndSr;

        BegSr  InzOplApi;

          LstApi.KeyFld(1) = 200;
          LstApi.KeyFld(2) = 405;

          SrtInf.NbrKeys      = 0;
          SrtInf.KeyFldOfs(1) = 0;
          SrtInf.KeyFldLen(1) = 0;
          SrtInf.KeyFldTyp(1) = 0;
          SrtInf.SrtOrd(1)    = '1';
          SrtInf.Rsv(1)       = x'00';

        EndSr;

        BegSr  EscApiErr;

          If  ERRC0100.BytAvl < OFS_MSGDTA;
            ERRC0100.BytAvl = OFS_MSGDTA;
          EndIf;

          SndEscMsg( ERRC0100.MsgId
                   : 'QCPFMSG'
                   : %Subst( ERRC0100.MsgDta: 1: ERRC0100.BytAvl - OFS_MSGDTA )
                   );

        EndSr;

        BegSr  *InzSr;

          CrtUsrSpc( USRSPC_Q
                   : EXT_ATR
                   : USP_SIZ
                   : INZ_VAL
                   : PUB_AUT
                   : TXT_DSC
                   : USP_RPL
                   : ERRC0100
                   );

          Select;
          When  ERRC0100.BytAvl > *Zero  And  ERRC0100.MsgId = 'CPF9870';
            CrtSpc = *Off;

          When  ERRC0100.BytAvl > *Zero;
            ExSr  EscApiErr;

          Other;
            CrtSpc = *On;
          EndSl;

        EndSr;

      /End-Free

     **-- Get reference signature:
     P GetRefSig       B
     D                 Pi            16a
     D  PxPgmNam                     10a   Const
     D  PxPgmLib                     10a   Const
     D  PxPgmTyp                     10a   Const
     D  PxSpgRefLib                  10a

      /Free

        Select;
        When  PxPgmTyp = '*PGM';
          Return  GetPgmRefSig( PxPgmNam: PxPgmLib: PxSpgRefLib );

        When  PxPgmTyp = '*SRVPGM';
          Return  GetSpgRefSig( PxPgmNam: PxPgmLib: PxSpgRefLib );

        Other;
          Return  *Blanks;
        EndSl;

      /End-Free

     P GetRefSig       E
     **-- Get program reference signature:
     P GetPgmRefSig    B
     D                 Pi            16a
     D  PxPgmNam                     10a   Const
     D  PxPgmLib                     10a   Const
     D  PxSpgRefLib                  10a

      /Free

        LstPgmInf( USRSPC_Q: 'PGML0200': PxPgmNam + PxPgmLib: ERRC0100 );

        If  ERRC0100.BytAvl = *Zero;

          RtvPtrSpc( USRSPC_Q: pUsrSpc );

          pHdrInf = pUsrSpc + UsrSpcHdr.OfsHdrSec;
          pPGML0200 = pUsrSpc + UsrSpcHdr.OfsLstEnt;

          For  Idx = 1  to UsrSpcHdr.NumLstEnt;

            If  PGML0200.BndSrvPgmNam = PxSrvPgm_q.ObjNam  And
              ( PGML0200.BndSrvPgmLib = PxSrvPgm_q.ObjLib  Or
                PGML0200.BndSrvPgmLib = *Allx'00' );

              If  PGML0200.BndSrvPgmLib = *Allx'00';
                PGML0200.BndSrvPgmLib = '*LIBL';
              EndIf;

              PxSpgRefLib = PGML0200.BndSrvPgmLib;

              Return  PGML0200.BndSrvPgmSig;
            EndIf;

            If  Idx < UsrSpcHdr.NumLstEnt;
              pPGML0200 += UsrSpcHdr.SizLstEnt;
            EndIf;
          EndFor;
        EndIf;

        PxSpgRefLib = *Blanks;

        Return  *LoVal;

      /End-Free

     P GetPgmRefSig    E
     **-- Get service program signature:
     P GetSpgRefSig    B
     D                 Pi            16a
     D  PxSpgNam                     10a   Const
     D  PxSpgLib                     10a   Const
     D  PxSpgRefLib                  10a

      /Free

        LstSrvPgmI( USRSPC_Q: 'SPGL0200': PxSpgNam + PxSpgLib: ERRC0100 );

        If  ERRC0100.BytAvl = *Zero;

          RtvPtrSpc( USRSPC_Q: pUsrSpc );

          pHdrInf = pUsrSpc + UsrSpcHdr.OfsHdrSec;
          pSPGL0200 = pUsrSpc + UsrSpcHdr.OfsLstEnt;

          For  Idx = 1  to UsrSpcHdr.NumLstEnt;

            If  SPGL0200.BndSrvPgmNam = PxSrvPgm_q.ObjNam  And
              ( SPGL0200.BndSrvPgmLib = PxSrvPgm_q.ObjLib  Or
                SPGL0200.BndSrvPgmLib = *Allx'00' );

              If  SPGL0200.BndSrvPgmLib = *Allx'00';
                SPGL0200.BndSrvPgmLib = '*LIBL';
              EndIf;

              PxSpgRefLib = SPGL0200.BndSrvPgmLib;

              Return  SPGL0200.BndSrvPgmSig;
            EndIf;

            If  Idx < UsrSpcHdr.NumLstEnt;
              pSPGL0200 += UsrSpcHdr.SizLstEnt;
            EndIf;
          EndFor;
        EndIf;

        PxSpgRefLib = *Blanks;

        Return  *LoVal;

      /End-Free

     P GetSpgRefSig    E
     **-- Get service program signature:
     P GetSpgSig       B
     D                 Pi            16a
     D  PxSrvPgmNam                  10a   Const
     D  PxSrvPgmLib                  10a   Const
     **
     D SPGI0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  PgmNam                       10a
     D  PgmLib                       10a
     D  PgmOwn                       10a
     D  PgmAtr                       10a
     D  CurSig                       16a   Overlay( SPGI0100: 122 )
     D  UsrPrf                        1a   Overlay( SPGI0100: 138 )
     D  TxtDsc                       50a   Overlay( SPGI0100: 157 )
     D  UseAdpAut                     1a   Overlay( SPGI0100: 213 )
     D  PgmStt                        1a   Overlay( SPGI0100: 307 )
     D  PgmDmn                        1a   Overlay( SPGI0100: 308 )

      /Free

        RtvSrvPgmI( SPGI0100
                  : %Size( SPGI0100 )
                  : 'SPGI0100'
                  : PxSrvPgmNam + PxSrvPgmLib
                  : ERRC0100
                  );

        If  ERRC0100.BytAvl > *Zero;
          Return  *Loval;

        Else;
          Return  SPGI0100.CurSig;
        EndIf;

      /End-Free

     P GetSpgSig       E
     **-- Get service program text:
     P GetSpgTxt       B
     D                 Pi            50a
     D  PxSrvPgmNam                  10a   Const
     D  PxSrvPgmLib                  10a   Const
     **
     D SPGI0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  PgmNam                       10a
     D  PgmLib                       10a
     D  PgmOwn                       10a
     D  PgmAtr                       10a
     D  CurSig                       16a   Overlay( SPGI0100: 122 )
     D  UsrPrf                        1a   Overlay( SPGI0100: 138 )
     D  TxtDsc                       50a   Overlay( SPGI0100: 157 )
     D  UseAdpAut                     1a   Overlay( SPGI0100: 213 )
     D  PgmStt                        1a   Overlay( SPGI0100: 307 )
     D  PgmDmn                        1a   Overlay( SPGI0100: 308 )

      /Free

        RtvSrvPgmI( SPGI0100
                  : %Size( SPGI0100 )
                  : 'SPGI0100'
                  : PxSrvPgmNam + PxSrvPgmLib
                  : ERRC0100
                  );

        If  ERRC0100.BytAvl > *Zero;
          Return  *Blanks;

        Else;
          Return  SPGI0100.TxtDsc;
        EndIf;

      /End-Free

     P GetSpgTxt       E
     **-- Get service program library:
     P GetSpgLib       B
     D                 Pi            10a
     D  PxSrvPgmNam                  10a   Const
     D  PxSrvPgmLib                  10a   Const
     **
     D SPGI0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  PgmNam                       10a
     D  PgmLib                       10a
     D  PgmOwn                       10a
     D  PgmAtr                       10a
     D  CurSig                       16a   Overlay( SPGI0100: 122 )
     D  UsrPrf                        1a   Overlay( SPGI0100: 138 )
     D  TxtDsc                       50a   Overlay( SPGI0100: 157 )
     D  UseAdpAut                     1a   Overlay( SPGI0100: 213 )
     D  PgmStt                        1a   Overlay( SPGI0100: 307 )
     D  PgmDmn                        1a   Overlay( SPGI0100: 308 )

      /Free

        RtvSrvPgmI( SPGI0100
                  : %Size( SPGI0100 )
                  : 'SPGI0100'
                  : PxSrvPgmNam + PxSrvPgmLib
                  : ERRC0100
                  );

        If  ERRC0100.BytAvl > *Zero;
          Return  PxSrvPgmLib;

        Else;
          Return  SPGI0100.PgmLib;
        EndIf;

      /End-Free

     P GetSpgLib       E
     **-- Get program type:
     P GetPgmTyp       B
     D                 Pi             1a
     D  PxPgmNam                     10a   Const
     D  PxPgmLib                     10a   Const
     **
     D PGMI0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  PgmNam                       10a
     D  PgmLib                       10a
     D  PgmOwn                       10a
     D  PgmAtr                       10a
     D  UsrPrf                        1a   Overlay( PGMI0100: 106 )
     D  UseAdpAut                     1a   Overlay( PGMI0100: 107 )
     D  LogCmd                        1a   Overlay( PGMI0100: 108 )
     D  AlwRtvSrc                     1a   Overlay( PGMI0100: 109 )
     D  PgmTyp                        1a   Overlay( PGMI0100: 161 )

      /Free

        RtvPgmInf( PGMI0100
                 : %Size( PGMI0100 )
                 : 'PGMI0100'
                 : PxPgmNam + PxPgmLib
                 : ERRC0100
                 );

        If  ERRC0100.BytAvl > *Zero;
          Return  *Blank;

        Else;
          Return  PGMI0100.PgmTyp;
        EndIf;

      /End-Free

     P GetPgmTyp       E
     **-- Get signature state:
     P GetSigStt       B
     D                 Pi             1a
     D  PxPgmSig                     16a   Const

      /Free

        Select;
        When  PxPgmSig = CurSpgSig;
          Return  '1';

        When  %LookUp( PxPgmSig: LstSpgSig: 1: SigIdx ) > *Zero;
          Return  '2';

        Other;
          Return  '0';
        EndSl;

      /End-Free

     P GetSigStt       E
     **-- Convert character to hex nibbles:
     P CvtToHex        B
     D                 Pi           512a   Varying
     D  PxChrStr                    256a   Varying  Const

     **-- Local declarations
     D ChrStr          s            256a
     D HexStr          s            512a

      /Free

        ChrStr = PxChrStr;

        cvthc( %Addr( HexStr ): %Addr( ChrStr ): %Len( PxChrStr ) * 2 );

        Return  %Subst( HexStr: 1: %Int( %Len( PxChrStr ) * 2 ));

      /End-Free

     P CvtToHex        E
     **-- Get job type:
     P GetJobTyp       B
     D                 Pi             1a

     D JOBI0400        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  JobNam                       10a
     D  UsrNam                       10a
     D  JobNbr                        6a
     D  JobIntId                     16a
     D  JobSts                       10a
     D  JobTyp                        1a
     D  JobSubTyp                     1a

      /Free

        RtvJobInf( JOBI0400
                 : %Size( JOBI0400 )
                 : 'JOBI0400'
                 : '*'
                 : *Blank
                 : ERRC0100
                 );

        If  ERRC0100.BytAvl > *Zero;
          Return  *Blank;

        Else;
          Return  JOBI0400.JobTyp;
        EndIf;

      /End-Free

     P GetJobTyp       E
     **-- Send status message:
     P SndStsMsg       B
     D                 Pi            10i 0
     D  PxMsgDta                   1024a   Const  Varying
     **
     D MsgKey          s              4a

      /Free

        SndPgmMsg( 'CPF9897'
                 : 'QCPFMSG   *LIBL'
                 : PxMsgDta
                 : %Len( PxMsgDta )
                 : '*STATUS'
                 : '*EXT'
                 : 0
                 : MsgKey
                 : ERRC0100
                 );

        If  ERRC0100.BytAvl > *Zero;
          Return  -1;

        Else;
          Return   0;
        EndIf;

      /End-Free

     P SndStsMsg       E
     **-- Send completion message:
     P SndCmpMsg       B
     D                 Pi            10i 0
     D  PxMsgDta                    512a   Const  Varying
     **
     D MsgKey          s              4a

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

     P SndCmpMsg       E
     **-- Send escape message:
     P SndEscMsg       B
     D                 Pi            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying
     **
     D MsgKey          s              4a

      /Free

        SndPgmMsg( PxMsgId
                 : PxMsgF + '*LIBL'
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
