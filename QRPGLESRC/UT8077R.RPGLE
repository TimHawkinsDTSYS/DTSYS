      /TITLE Utility, Pager (SrvPgm)
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
      /define DSpgm
      /copy qcpysrc,Dspec
      /copy qcpysrc,UT8077S
      * *********************************************************
      * SndPgrMsg() -- Send pager message.
      * *********************************************************
     P SndPgrMsg       B                   Export
      *
     D SndPgrMsg       PI
     D  pager                              like(StdNam) const
     D  msg                                like(StdStr) const
      * --------------------------------------------------------
      *   Send pager message.
      *
     C                   eval      CmdStg = 'sndpgrmsg +
     C                             topgr(' + %trim(pager) + ') +
     C                             msg('''   + %trim(msg)  + ''')'
      *
     C                   callp     ExecCmd(CmdStg)
     C
     C                   return
      *
     P SndPgrMsg       E
