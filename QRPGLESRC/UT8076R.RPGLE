      /TITLE Utility, Group job (SrvPgm)
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
      /copy qcpysrc,Dspec
      * *********************************************************
      * ShwBrwWdw() -- Show browser window.
      * *********************************************************
     P ShwBrwWdw       B                   Export
      *
     D ShwBrwWdw       PI
     D  InpString                          like(StdStr) const
      *
     D WrkString       s                   like(StdStr) inz
      * --------------------------------------------------------
      * Show browser window.
      *
     C                   eval      Wrkstring = InpString
      *
     C                   call      'UT0013C'
     C                   parm                    WrkString
     C
     C                   return
      *
     P ShwBrwWdw       E
      * *********************************************************
      * PCcmd() -- Run a PC command.
      * *********************************************************
     P PCcmd           B                   Export
      *
     D PCcmd           PI
     D  InpString                          like(StdStr) const
      *
     D WrkString       s                   like(StdStr) inz
      * --------------------------------------------------------
      * Run a PC command.
      *
     C                   eval      Wrkstring = InpString
      *
     C                   call      'UT0014C'
     C                   parm                    WrkString
     C
     C                   return
      *
     P PCcmd           E
