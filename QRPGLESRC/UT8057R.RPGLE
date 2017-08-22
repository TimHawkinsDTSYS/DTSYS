      /TITLE Utility, Spool to PDF using Infoprint
      *PARMS DFTACTGRP(*no)
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Executes the InfoPrint() routine in the MMAIL
      *              utility library.
      *
      *  Notes   :  Needs to be an external program due to conflicts
      *             in the binding directories and procedure names.
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  mm/dd/yy  xxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /copy MMAIL/qrpglesrc,hspecs
      /copy MMAIL/qrpglesrc,hspecsbnd
      /copy MMAIL/qrpglesrc,mailproto
      /copy MMAIL/qrpglesrc,prototypeb
      /copy MMAIL/qrpglesrc,variables3
      /copy MMAIL/qrpglesrc,usec

     D JobNam          s                   like(StdNam)
     D JobUsr          s                   like(StdNam)
     D JobNbr          s                   like(StdJobNbr)
     D SplfName        s                   like(StdNam)
     D SplfNbr         s                   like(StdInt)
     D Stmf            s                   like(StdStr)
      *
      *  RnmObj() -- Rename object
      *
     D RnmObj          PR                  ExtProc('Qp0lRenameKeep')
     D                                     like(StdInt)
     D  oldobj                             like(StdPtr)   value
     D                                     options(*string)
     D  newobj                             like(StdPtr)   value
     D                                     options(*string)
      *
      *  System() -- System command.
      *
     D SystemProc      pr                  extproc('system')
     D                                     like(StdInt)
     D  SysCmd                             like(StdPtr) value
     D                                     options(*string)
      *
      *  ReportError() -- Report error.
      *
     D ReportError     PR
      *
      *  Joblog() -- Write to job log.
      *  -- Joblog('Record %s':%char(RecCnt));
      *  -- "%s" is a positional replacment value for RecCnt
      *
     D Joblog          PR
     D  szInputStg                     *   value options(*string)
     D  szInputParm01                  *   value options(*string:*nopass)
     D  szInputParm02                  *   value options(*string:*nopass)
     D  szInputParm03                  *   value options(*string:*nopass)
     D  szInputParm04                  *   value options(*string:*nopass)
     D  szInputParm05                  *   value options(*string:*nopass)
     D  szInputParm06                  *   value options(*string:*nopass)
     D  szInputParm07                  *   value options(*string:*nopass)
     D  szInputParm08                  *   value options(*string:*nopass)
     D  szInputParm09                  *   value options(*string:*nopass)
     D  szInputParm10                  *   value options(*string:*nopass)

     D IPstmf          s                   like(StdStr)    inz
     D SplNam          s                   like(StdNam)    inz
     D SplNbr          s              9b 0                 inz
     D Job             s                   like(StdQalJob) inz

      /copy qcpysrc,StdTypD

      /free
       // -------------------------------------------------------
       // Use InfoPrint for the conversion to PDF.

       job    = JobNam + JobUsr + JobNbr;
       SplNam = SplfName;
       SplNbr = SplfNbr;

       joblog('InfoPrint(' + %trim(Job)           + ':' +
                             %trim(SplNam)        + ':' +
                             %trim(%char(SplNbr)) + ')');
       IPstmf = InfoPrint(Job:SplNam:SplNbr);
       if IPstmf = *blanks;
          joblog('InfoPrint did not convert this spoolfile.');
          stmf = *blanks;
          return;
       endif;

       // -------------------------------------------------------
       // Rename & move the IP stream file.

       joblog('RnmObj fromobj(' + %trim(IPstmf) + ') +
                        toobj(' + %trim(stmf)   + ')');
       if RnmObj(%trim(IPstmf):%trim(stmf)) = -1;
          ReportError();
       endif;

       // -------------------------------------------------------
       // Change IFS attributes of PDF file to 0819.

       joblog('chgifsatr ifsobj(''' + %trim(stmf) + ''') ccsid(0819)');
       systemProc('chgifsatr ifsobj(''' + %trim(stmf) + ''') +
                         ccsid(0819)');

       return;

      /end-free
      *
     C     *entry        plist
     C                   parm                    JobNam
     C                   parm                    JobUsr
     C                   parm                    JobNbr
     C                   parm                    SplfName
     C                   parm                    SplfNbr
     C                   parm                    stmf
      * *********************************************************
      * ReportError():  Send an escape message explaining errors
      * *********************************************************
     P ReportError     B                   Export

     D ReportError     PI

     D get_errno       PR              *   ExtProc('__errno')

     D errno           s             10I 0 based(p_errno)

     D QMHSNDPM        PR                  ExtPgm('QMHSNDPM')
     D   MessageID                    7A   Const
     D   QualMsgF                    20A   Const
     D   MsgData                  32767A   Const options(*varsize)
     D   MsgDtaLen                   10I 0 Const
     D   MsgType                     10A   Const
     D   CallStkEnt                  10A   Const
     D   CallStkCnt                  10I 0 Const
     D   MessageKey                   4A
     D   ErrorCode                 8192A   options(*varsize)

     D ErrorCode       DS                  qualified
     D  BytesProv                    10I 0 inz(0)
     D  BytesAvail                   10I 0 inz(0)

     D MsgKey          S              4A
     D MsgID           s              7A

      /free

       p_errno = get_errno();

       MsgID = 'CPE' + %editc( %dec(errno:4:0) : 'X');

       QMHSNDPM(MsgID
               :'QCPFMSG   *LIBL'
               :' '
               :0
               :'*ESCAPE'
               :'*PGMBDY'
               :1
               :MsgKey
               :ErrorCode);

      /end-free

     P ReportError     E
      ***********************************************************
      * Joblog -- Write to the joblog.
      ***********************************************************
     P Joblog          B                   Export
      *
     D Joblog          PI
     D  szInputStg                     *   value options(*string)
     D  szInputParm01                  *   value options(*string:*nopass)
     D  szInputParm02                  *   value options(*string:*nopass)
     D  szInputParm03                  *   value options(*string:*nopass)
     D  szInputParm04                  *   value options(*string:*nopass)
     D  szInputParm05                  *   value options(*string:*nopass)
     D  szInputParm06                  *   value options(*string:*nopass)
     D  szInputParm07                  *   value options(*string:*nopass)
     D  szInputParm08                  *   value options(*string:*nopass)
     D  szInputParm09                  *   value options(*string:*nopass)
     D  szInputParm10                  *   value options(*string:*nopass)
      *
      *  Qp0zLprintf() -- Write to job log API
      *  -- Qp0zLprintf('Record %s' + x'25':%char(RecCnt));
      *  -- "%s" is a positional replacment value for RecCnt
      *  -- x'25' is a line feed.
      *
     D Qp0zLprintf     PR                  ExtProc('Qp0zLprintf')
     D                                     like(StdInt)
     D  szOutputStg                    *   value options(*string)
     D                                 *   value options(*string:*nopass)
     D                                 *   value options(*string:*nopass)
     D                                 *   value options(*string:*nopass)
     D                                 *   value options(*string:*nopass)
     D                                 *   value options(*string:*nopass)
     D                                 *   value options(*string:*nopass)
     D                                 *   value options(*string:*nopass)
     D                                 *   value options(*string:*nopass)
     D                                 *   value options(*string:*nopass)
     D                                 *   value options(*string:*nopass)

      /free

       Qp0zLprintf(szInputStg:szInputParm01:
                              szInputParm02:
                              szInputParm03:
                              szInputParm04:
                              szInputParm05:
                              szInputParm06:
                              szInputParm07:
                              szInputParm08:
                              szInputParm09:
                              szInputParm10);

       Qp0zLprintf(x'25');

       return;

      /end-free

     P Joblog          E
