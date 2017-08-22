      /TITLE Utility, Airline Codes DB (SrvPgm)
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
      * *********************************************************
      * SltCtlal() -- Select airline.
      * *********************************************************
     P SltCtlAL        B                   Export
      *
     D SltCtlAL        PI                  like(dfnCMcarr)
     D  CMcarr_p                           like(dfnCMcarr) const
     D                                     options(*nopass)
      *
     D  WKcarr         s                   like(dfnCMcarr) inz
      * ---------------------------------------------------------
      * Set optional value.
      *
     C                   if        %parms = 1
     C                   eval      WKcarr = CMcarr_p
     C                   endif
      * ---------------------------------------------------------
      * Show airline window.
      *
     C                   call      'CT0209R'
     C                   parm                    WKcarr
      *
     C                   return    WKcarr
      *
     P SltCtlAL        E
      * *********************************************************
      * ChkCtlAL() -- Check airline code.
      * *********************************************************
     P ChkCtlAL        B                   Export
      *
     D ChkCtlAL        PI                  like(StdInd)
     D  CMcarr_p                           like(dfnCMcarr) const
      *
     D  WKcarr         s                   like(dfnCMcarr) inz
     D  RtnInd         s                   like(StdInd) inz
      * ---------------------------------------------------------
      * Show airport window.
      *
     C                   eval      WKcarr = CMcarr_p
      *
     C                   call      'CT0500R'
     C                   parm                    WKcarr
     C                   parm                    RtnInd
      *
     C                   return    RtnInd
      *
     P ChkCtlAL        E
      * *********************************************************
      * RtvCtlAL() -- Retrieve airline control record.
      * *********************************************************
     P RtvCtlAL        B                   Export
      *
     D RtvCtlAL        PI                  like(dfnctlal)
     D  CMcarr_p                           like(dfnCMcarr) const
      *
     D DSparm        e ds                  extname(DSparm) inz
     D SScarr          s                   like(dfnCMcarr) inz
     D SSvndn          s                   like(dfnCMvndn) inz
     D SSdest          s                   like(dfnCMdest) inz
     D SSused          s                   like(NumISO)    inz
     D SSctid          s                   like(dfnCMctid) inz
     D SSctex          s                   like(dfnCMctex) inz
     D RtnCtlAL        s                   like(dfnctlal)  inz
      * ---------------------------------------------------------
      * Retrieve airline control record.
      *
     C                   eval      SScarr = CMcarr_p
      *
     C                   call      'CT0501R'
     C                   parm                    DSparm
     C                   parm                    SScarr
     C                   parm                    SSvndn
     C                   parm                    SSdest
     C                   parm                    SSused
     C                   parm                    SSctid
     C                   parm                    SSctex
     C                   parm                    Rtnctlal
      *
     C                   return    RtnCtlAL
      *
     P RtvCtlAL        E
      * *********************************************************
      * RtvCarr() -- Retrieve carrier code.
      * *********************************************************
     P RtvCarr         B                   Export
      *
     D RtvCarr         PI                  like(dfnCMcarr)
     D  CMvndn_p                           like(dfnCMvndn) const
      *
     D DSparm        e ds                  extname(DSparm)   inz
     D DSctlal       e ds                  extname(ctlalp01) inz
      *
     D SSvndn          s                   like(dfnCMvndn) inz
     D SScarr          s                   like(dfnCMcarr) inz
     D SSdest          s                   like(dfnCMdest) inz
     D SSused          s                   like(NumISO)    inz
     D SSctid          s                   like(dfnCMctid) inz
     D SSctex          s                   like(dfnCMctex) inz
      * ---------------------------------------------------------
      * Reteive airline control record.
      *
     C                   eval      SSvndn = CMvndn_p
      *
     C                   call      'CT0501R'
     C                   parm                    DSparm
     C                   parm                    SScarr
     C                   parm                    SSvndn
     C                   parm                    SSdest
     C                   parm                    SSused
     C                   parm                    SSctid
     C                   parm                    SSctex
     C                   parm                    DSctlal
      *
     C                   return    CMcarr
      *
     P RtvCarr         E
