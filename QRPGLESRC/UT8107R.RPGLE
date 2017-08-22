      /TITLE Utility, Application DB (SrvPgm)
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
      * SltCtlas() -- Select control association.
      ***********************************************************
     P SltCtlAS        B                   Export
      *
     D SltCtlAS        PI                  like(dfnCtlAS)
     D  WPposto_p                          like(dfnWPposto) const
     D                                     options(*nopass)
      *
     D  CtlAS        e ds                  extname(ctlasp01)
      *
     D  WPposto        s                   like(WPposto_p)
      * ---------------------------------------------------------
      *
      *    Select control association.
      *
     C                   if        %parms >= 1
     C                   eval      WPposto = WPposto_p
     C                   endif
      *
     C                   call      'CT0207R'
     C                   parm                    WPposto
     C                   parm                    CtlAS
      *
     C                   return    CtlAS
      *
     P SltCtlAS        E
