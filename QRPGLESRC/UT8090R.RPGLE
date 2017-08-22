      /TITLE Utility, Errors (SrvPgm)
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Provides error routines via function calls
      *              for handling C and UNIX error codes.
      *
      *  Notes   :  Copied from Scott Klement (c) 2001
      *              at klement.dstorm.net/rpg/socktut/tutorial.html
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  09/10/02  TimH        New program.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /copy qcpysrc,HspecSrv
      *
      /define DSpgm
      /copy qcpysrc,Dspec
      // --------------------------------------------------------
      // Used for the message sent to the call stack.
      //   The *'s are used to differentiate errors thrown by Error_throw
      //   from any other errors throw by other mechanisms.
      //
     D gStackErr       ds                  qualified inz
     D  msgQual                       7a   inz('*******')
     D  code                         10a
     D  severity                     10i 0
     D  pgm                          30a   varying
     D  text                      32000a   varying

     D CPF9897         c                   'CPF9897'

      * universal api error data structure
     D gError          ds                  qualified
     D  provided                     10i 0
     D  available                    10i 0
     D  msgid                         7a
     D  rsvd                          1a
     D  msgdta                       80

     D sds            sds                  qualified
     D  proc             *proc
      * **********************************************************
      *  Retrieve error code.
      * **********************************************************
     P errno           B                   export

     D errno           PI                  like(StdInt)

     D p_errno         S                   like(StdPtr)
     D wwreturn        S                   like(StdInt) based(p_errno)

     C                   eval      p_errno = @__errno
     c                   return    wwreturn

     P errno           E
      * *********************************************************
      *  EscErrno( -- Escape and return an error.
      * *********************************************************
     P EscErrno        B                   export
      *
     D EscErrno        PI                  like(StdInd)
     D   errnum                            like(StdInt) value
      *
     D QMHSNDPM        PR                  ExtPgm('QMHSNDPM')
     D  MessageID                     7    const
     D  QualMsgF                           like(StdNamLib) const
     D  MsgData                            like(StdChr) const
     D  MsgDtaLen                          like(StdInt) const
     D  MsgType                            like(StdNam) const
     D  CallStkEnt                         like(StdNam) const
     D  CallStkCnt                         like(StdInt) const
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
     P EscErrno        E
      ***********************************************************
      * Send escape message.
      ***********************************************************
     P Die             B                   export

     D Die             PI
     D   peMsg                      256A   const

     D SndPgmMsg       PR                  ExtPgm('QMHSNDPM')
     D   MessageID                    7A   const
     D   QualMsgF                    20A   const
     D   MsgData                    512A   const
     D   MsgDtaLen                   10I 0 const
     D   MsgType                     10A   const
     D   CallStkEnt                  10A   const
     D   CallStkCnt                  10I 0 const
     D   MessageKey                   4A
     D   ErrorCode                32766A   options(*varsize)

     D dsEC            DS
     D  dsECBytesP             1      4I 0 INZ(256)
     D  dsECBytesA             5      8I 0 INZ(0)
     D  dsECMsgID              9     15
     D  dsECReserv            16     16
     D  dsECMsgDta            17    256

     D wwMsgLen        S             10I 0
     D wwTheKey        S              4A
      *
      *  Assure that the message has text to send.
      *
     c                   eval      wwMsgLen = %len(%trim(peMsg))
š1b€ c                   if        wwMsgLen < 1
     c                   return
š1e€ c                   endif
      *
      *  Send the escape message.
      *
     c                   callp     SndPgmMsg('CPF9897': 'QCPFMSG   *LIBL':
     c                               peMsg: wwMsgLen: '*ESCAPE':
     c                               '*PGMBDY': 1: wwTheKey: dsEC)

     c                   return

     P Die             E
      * *********************************************************
      *  DiagErrno( -- Diagnostic and return an error.
      * *********************************************************
     P DiagErrno       B                   export
      *
     D DiagErrno       PI                  like(StdInd)
     D   errnum                            like(StdInt) value
      *
     D QMHSNDPM        PR                  ExtPgm('QMHSNDPM')
     D  MessageID                     7    const
     D  QualMsgF                           like(StdNamLib) const
     D  MsgData                            like(StdChr) const
     D  MsgDtaLen                          like(StdInt) const
     D  MsgType                            like(StdNam) const
     D  CallStkEnt                         like(StdNam) const
     D  CallStkCnt                         like(StdInt) const
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
     C                               ' ': 0: '*DIAG':
     C                               '*': 3: TheKey: dsEC)
      *
     C                   return    *off
      *
     P DiagErrno       E
      * *********************************************************
      *  Error_throw() -- Throw error messages (RPGmail).
      * *********************************************************

      //--------------------------------------------------------------------
      // @Author: Aaron Bartell
      // @Desc: Throw an error onto the call stack.
      // @Created:
      //--------------------------------------------------------------------------------------------
     P Error_throw     b                   export

     D Error_throw     pi
     D  pCode                              value Like(Error_Info.code)
     D  pSeverity                          value Like(Error_Info.severity)
     D  pPgm                               value Like(Error_Info.pgm)
     D  pText                              value Like(Error_Info.text)

     D error           ds                  likeds(Error_info) inz
     D stackErr        ds                  likeds(gStackErr) inz

     D  msgkey         s              4a
     D  msgf           c                   'QCPFMSG   *LIBL     '

     D sndpgmmsg       pr                  extpgm('QMHSNDPM')
     D  msgid                         7a   const
     D  msgf                         20a   const
     D  msgdta                    32767a   const options(*varsize)
     D  msgdtalen                    10i 0 const
     D  msgtype                      10a   const
     D  callstkent                   10a   const
     D  callstkcnt                   10i 0 const
     D  msgkey                        4a
     D  error                              likeds(gError)
      /free

       stackErr.msgQual = gStackErr.msgQual;
       stackErr.code = pCode;
       stackErr.severity = pSeverity;
       stackErr.pgm = pPgm;
       stackErr.text = pText;

       sndpgmmsg(
         CPF9897:
         msgf:
         %trim(stackErr):
         %len(%trim(stackErr)):
         '*ESCAPE': '*':
         0:
         msgkey:
         gError);

      /end-free

     P Error_throw     e


      //-------------------------------------------------------------------------------------------
      // @Author - Aaron Bartell
      // @Description -
      //-------------------------------------------------------------------------------------------
     P Error_catch     B                   export

     D Error_catch     PI                  likeds(Error_Info)

     D key             S              4A   Inz(*Allx'00')
     D error           DS                  LikeDS(Error_Info) inz
     D stackErr        ds                  likeds(gStackErr) inz

     D dsM1            DS                  Qualified
     D  bytRtn                       10I 0
     D  bytAvl                       10I 0
     D  msgSev                       10I 0
     D  msgID                         7A
     D  msgType                       2A
     D  msgKey                        4A
     D  reserv1                       7A
     D  ccsId_st                     10I 0
     D  ccdId                        10I 0
     D  dtaLen                       10I 0
     D  dtaAvl                       10I 0
     D  dta                       32712A

     D dsEC            DS                  Qualified
     D  bytesP                 1      4I 0 Inz(%size(dsEC))
     D  bytesA                 5      8I 0 Inz(0)
     D  msgID                  9     15
     D  reserv                16     16
     D  msgDta                17    256

     D QMHRCVPM        PR                  ExtPgm('QMHRCVPM')
     D   MsgInfo                  32766A   Options(*Varsize)
     D   MsgInfoLen                  10I 0 const
     D   Format                       8A   const
     D   StackEntry                  10A   const
     D   StackCount                  10I 0 const
     D   MsgType                     10A   const
     D   MsgKey                       4A   const
     D   WaitTime                    10I 0 const
     D   MsgAction                   10A   const
     D   ErrorCode                32766A   Options(*Varsize)
      /free

       QMHRCVPM(
         dsM1: %Size(dsM1): 'RCVM0100': '*': 1: '*PRV': key: 0: '*SAME': dsEC);

       if dsM1.msgId = CPF9897 and
          %subst(dsM1.dta:1:%size(gStackErr.msgQual)) = gStackErr.msgQual;
         stackErr = dsM1.dta;
         error.code = stackErr.code;
         error.severity = stackErr.severity;
         error.pgm = stackErr.pgm;
       else;
         error.code = dsM1.msgId;
         //error.text = dsM1.dta;
       endif;

       return error;

      /End-Free

     P Error_catch     E



      //-------------------------------------------------------------------------
      // @Author - Aaron Bartell
      // @Description -
      //-------------------------------------------------------------------------
     P Error_globalErrNoTxt...
     P                 b                   export
     D Error_globalErrNoTxt...
     D                 pi           128a   varying

     D pError          s               *
     D sys_errno       pr              *    ExtProc( '__errno' )
     D sys_strerror    pr              *    ExtProc( 'strerror' )
     D                               10i 0  Value

     D error           s             10i 0  Based( pError )  NoOpt
      /free

        pError = sys_errno;
        return %str( sys_strerror(error));

      /end-free

     P Error_globalErrNoTxt...
     P                 E


      //----------------------------------------------------------------------------------
      // @Author - Aaron Bartell
      // @Description -
      //----------------------------------------------------------------------------------
     P Error_globalErrNo...
     P                 b                    export

     D Error_globalErrNo...
     D                 pi            10i 0

     D based_int       s             10i 0  based(pBased_int)
     D pBased_int      s               *
     D sys_errno       pr              *    ExtProc( '__errno' )
      /free

       pBased_int = sys_errno;

       return    based_int;

      /end-free

     P Error_globalErrNo...
     P                 e



