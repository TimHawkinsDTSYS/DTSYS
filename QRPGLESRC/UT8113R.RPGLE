      /TITLE Utility, User DB (SrvPgm)
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
      ***********************************************************
      * Select control user type.
      ***********************************************************
     P SltCtlUT        B                   Export
      *
     D SltCtlUT        PI                  like(dfnCtlUT)
     D  WPposto_p                          like(dfnWPposto) const
     D                                     options(*nopass)
      *
     D  CtlUT        e ds                  extname(ctlutp01)
      *
     D  WPposto        s                   like(WPposto_p)
      * ---------------------------------------------------------
      *
      *    Select control user type.
      *
     C                   if        %parms >= 1
     C                   eval      WPposto = WPposto_p
     C                   endif
      *
     C                   call      'CT0217R'
     C                   parm                    WPposto
     C                   parm                    CtlUT
      *
     C                   return    CtlUT
      *
     P SltCtlUT        E
