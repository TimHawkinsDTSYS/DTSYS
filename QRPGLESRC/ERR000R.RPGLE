      //-------------------------------------------------------------------------------------------
      // @Program -
      // @Author - Aaron Bartell
      // @Creation Date -
      // @Description -
      // @Notes -
      //-------------------------------------------------------------------------------------------
     H*nomain bnddir('QC2LE')
     H NOMAIN DATFMT(*USA)
     H OPTION(*NOXREF)
     H CVTOPT(*DATETIME) ALWNULL(*USRCTL)
     H ENBPFRCOL(*FULL) BNDDIR('TSUTL':'QC2LE')

      /copy qcpysrc,err000s
      /copy qcpysrc,Dspec

      //
      // This DS is used for the message sent to the call stack. The *'s are used to differentiate
      // errors thrown by Error_throw from any other errors throw by other mechanisms.
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

      * program status data structure
     D*sds            sds                  qualified
     D* proc             *proc

      //--------------------------------------------------------------------------------------------
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
     P                 e


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
     D   MsgInfoLen                  10I 0 Const
     D   Format                       8A   Const
     D   StackEntry                  10A   Const
     D   StackCount                  10I 0 Const
     D   MsgType                     10A   Const
     D   MsgKey                       4A   Const
     D   WaitTime                    10I 0 Const
     D   MsgAction                   10A   Const
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
         error.text = stackErr.text;
       else;
         error.code = dsM1.msgId;
         //error.text = dsM1.dta;
       endif;

       return error;

      /End-Free
     P                 E



      //-------------------------------------------------------------------------------------------
      // @Author - Aaron Bartell
      // @Description -
      //-------------------------------------------------------------------------------------------
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
     P                 E


      //-------------------------------------------------------------------------------------------
      // @Author - Aaron Bartell
      // @Description -
      //-------------------------------------------------------------------------------------------
     P Error_globalErrNo...
     P                 b                    export
     D Error_globalErrNo...
     D                 pi            10i 0

     D based_int       s             10i 0  based(p)
     D p               s               *
     D sys_errno       pr              *    ExtProc( '__errno' )
      /free

       p = sys_errno;

       return    based_int;

      /end-free
     P                 e
