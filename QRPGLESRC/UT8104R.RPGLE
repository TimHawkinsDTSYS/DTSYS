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
      * RtvctlRS() -- Retrieve sub-region record.
      ***********************************************************
     P Rtvctlrs        B                   Export
      *
     FctlRSp01  if   e           k disk    static
      *
     D Rtvctlrs        PI                  like(DFNctlrs)
     D  PIctycde                           like(dfnLCctycde) const
      *
     D ctlrs           ds                  likerec(ctlrs01r) inz
      * ---------------------------------------------------------
      * Return sub-region record.
      *
     C     PIctycde      chain     ctlrs01r      ctlrs
     C                   if        not %found
     C                   reset                   ctlrs
     C                   endif
      *
     C                   return    ctlrs
      *
     P Rtvctlrs        E
      ***********************************************************
      * SchRSnam() -- Search for sub-region name.
      ***********************************************************
     P SchRSnam        B                   Export
      *
     D SchRSnam        PI                  like(dfnctlrs)
     D  PIsubnam                           like(dfnRSsubnam) const
      *
     D DSwdw         e ds                  extname(DSwdw)    inz
     D DSparm        e ds                  extname(DSparm)   inz
     D ctlrs         e ds                  extname(ctlrsp01) inz
      * ---------------------------------------------------------
      * Search for sub-region name.
      *
     C                   eval      RSsubnam = PIsubnam
      *
     C                   call      'CT0208R'
     C                   parm                    DSwdw
     C                   parm                    DSparm
     C                   parm                    ctlrs
      *
     C                   return    ctlrs
      *
     P SchRSnam        E
