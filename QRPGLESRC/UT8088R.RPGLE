      /TITLE Utility, Locks (SrvPgm)
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Provides miscellaneous routines via function calls.
      *
      *  Notes   :  none
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
      /copy qcpysrc,HspecSrv
      *
      /copy qcpysrc,Dspec
      * *********************************************************
      * ChkRcdLck() -- Check for record locks.
      *   The program using this procedure must use %error logic
      *   and not monitor logic to trap the error, because the
      *   monitor passes back different information in the
      *   program status DS.  See this article on the subject:
      *   www.bmeyers.net/faqs/15-faqs/74-record-locking-
      *   problem-in-a-monitor-block
      * *********************************************************
     P ChkRcdLck       B                   Export

     D ChkRcdLck       PI                  like(StdInd)
     D  p_stscde                           like(StdInt)   const
     D  RecInfo                            like(StdStr)   const
     D  Wait_p                             like(StdInt)   const
     D                                     options(*omit:*nopass)
     D  TimeOut_p                          like(StdInt)   const
     D                                     options(*omit:*nopass)
     D  Options_p                          like(StdTxt)   const
     D                                     options(*nopass)

     D Wait            s                   like(StdInt)    inz
     D TimeOut         s                   like(StdInt)    inz
     D SecsToGo        s                   like(StdInt)    inz
     D Options         s                   like(StdTxt)    inz

     D StartTSP        s                   like(StdTms)    inz static
     D LckJobNam       s                   like(StdNam)    inz
     D LckJobNbr       s                   like(StdJobNbr) inz
     D LckJobUsr       s                   like(StdNam)    inz
     D CmdStr          s                   like(StdStr)    inz
     D FromName        s                   like(StdStr)    inz
     D FromAddr        s                   like(StdStr)    inz
     D LckUsrName      s                   like(StdStr)    inz
     D LckUsrAddr      s                   like(StdStr)    inz
     D StrPos          s                   like(StdInt)    inz

     D d_RcvPgmMsg     ds                  likeDS(t_RcvPgmMsg) inz

     D JobID           ds                  likeds(t_ExtWords)
     D                                     based(pJobID)

     D RecordExists    c                   const(01021)
     D RefConFilErr    c                   const(01022)
     D TriggerErrBfr   c                   const(01023)
     D TriggerErrAft   c                   const(01024)
     D FileNotOpen     c                   const(01211)
     D RecordLocked    c                   const(01218)
     D UpdateWORead    c                   const(01221)
     D RefConAlcErr    c                   const(01222)
     D WaitTiemWrkStn  c                   const(01331)

      /free

       // -------------------------------------------------------
       // Extract parameters.

       if %parms >= 4;
          CEETSTA(ParmPassed:4:*omit);
          if ParmPassed = 1;
             Wait = Wait_p;
          endif;
       endif;

       if %parms >= 5;
          CEETSTA(ParmPassed:5:*omit);
          if ParmPassed = 1;
             TimeOut = TimeOut_p;
          endif;
       endif;

       if %parms >= 6;
          Options = Options_p;
       endif;

       // -------------------------------------------------------
       // Check for error condition.

       select;
       when p_stscde = *zero;
            StartTSP = NullTSP;
            return *off;

       when p_stscde = RecordLocked;
            exsr $RecordLocked;
            return *on;

       when p_stscde <> *zero;
            StartTSP = NullTSP;
          //exsr *pssr;
            return *off;
       endsl;

       // *******************************************************
       // Record locked.

       begsr $RecordLocked;

       // -------------------------------------------------------
       // Set start time of first lock attempt.

       if StartTSP = NullTSP;
          StartTSP = TimeStamp();
       endif;

       // -------------------------------------------------------
       // Extract job information from message data.

       exsr $ExtJobInf;

       // -------------------------------------------------------
       // Determine if timeout has been exceeded.

       SecsToGo  = ElpSecFromTSP(StartTSP:TimeStamp());
       SecsToGo -= TimeOut;

       if TimeOut  <> *zero   and
          SecsToGo <= *zero;
          exsr $TimeOut;
       endif;

       // -------------------------------------------------------
       // NoWait: Notify the locker that they are locking a record.

       if Wait = *zero;
          msg = 'User ' + %trim(ZZusr) + ' requires access to ' +
                %trim(RecInfo) + ', please release it ASAP.';

          SndBrkMsg(LckJobUsr:msg);
       endif;

       // -------------------------------------------------------
       // TimeOut: Notify the locker that their LckJob will be ended.

       if TimeOut <> *zero;
          msg = 'The ' + %trim(ZZjob) + ' requires access to ' +
                %trim(RecInfo) + ', please release it immediately +
                or your job will be ended within ' +
                %char(SecsToGo/60) + ' minutes.';

          SndBrkMsg(LckJobUsr:msg);
       endif;

       // -------------------------------------------------------
       // Wait X seconds for next try.

       if Wait > *zero;
          sleep(Wait);
       endif;

       endsr;

       // *******************************************************
       // Timeout exceeded.

       begsr $TimeOut;

       // -------------------------------------------------------
       // End the locker.

       CmdStr = 'endjob job(' + %trim(LckJobNbr) + '/' +
                                %trim(LckJobUsr) + '/' +
                                %trim(LckJobNam) + ')' +
                              ' option(*immed)';
       ExecCmd(CmdStr);

       // -------------------------------------------------------
       // Retrieve FROM email name and addres.

       if RtvJobTyp() = 'BCH';
          FromName =
          %subst(RtvCtlmaDta('NOTIFICATION':'BATCH JOB IDENTITY':ZZjob):01);
          FromAddr =
          %subst(RtvCtlmaDta('NOTIFICATION':'BATCH JOB IDENTITY':ZZjob):51);

          if FromName = *blanks;
             RPGmail_simple('UT8088R':'ChkRcdLck':
                %subst(RtvCtlmaDta('NOTIFICATION':'ADMINISTRATOR'):01):
                %subst(RtvCtlmaDta('NOTIFICATION':'ADMINISTRATOR'):51):
                'Application control record NOTIFICATION/+
                 BATCH JOB IDENTITY for job ' + %trim(ZZjob) +
                 ' not found.');
          endif;
       endif;

       if FromName = *blanks;
          FromName = RtvUsrEmlName(ZZusr);
          FromAddr = RtvUsrEmlAddr(ZZusr);
       endif;

       // -------------------------------------------------------
       // Retrieve TO email name and addres.

       LckUsrName = RtvUsrEmlName(LckJobUsr);
       LckUsrAddr = RtvUsrEmlAddr(LckJobUsr);

       // -------------------------------------------------------
       // Notify the locker via email.

       RPGmail_simple(FromName:FromAddr:
                      LckUsrName:LckUsrAddr:
                      'Your job was ended because it was locking ' +
                       %trim(RecInfo) + '.');

       endsr;

       // *******************************************************
       // Extract job information from message data.

       begsr $ExtJobInf;

       // -------------------------------------------------------
       // Receive message.

       dou d_RcvPgmMsg.msgid = *blanks    or
           d_RcvPgmMsg.msgid = 'CPF5027';
           d_RcvPgmMsg = RcvPgmMsg('*PGMBDY':'2');
       enddo;

       // -------------------------------------------------------
       // Extract 'locker' job information.
       // -- Message text contains:
       // "Record X in use by job 299729/THAWKINS/QPADEV0019."

       if d_RcvPgmMsg.msgid = 'CPF5027';
          StrPos = %scan('job':d_RcvPgmMsg.msg);
          pJobID = ExtWords(%subst(d_RcvPgmMsg.msg:StrPos+4):'/.');

          if JobID.WordsMax = 3;
             LckJobNbr = JobID.words(1);
             LckJobUsr = JobID.words(2);
             LckJobNam = JobID.words(3);
          else;
             Joblog('UT8088R ChkRcdLck $ExtJobInf; bad JobID: ' +
                     %trim(d_RcvPgmMsg.msg));
          endif;
       endif;

       endsr;

      /end-free

      /COPY QCPYSRC,$PMsnd
      ****Y QCPYSRC,$PSSR

     P ChkRcdLck       E
