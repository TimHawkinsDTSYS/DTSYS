      /TITLE Utility, Land City codes DB (SrvPgm)
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
      * RtvCtlLC() -- Retrieve land city codes record.
      ***********************************************************
     P RtvCtlLC        B                   Export
      *
     Fctllcp01  if   e           k disk    static
      *
     D RtvCtlLC        PI                  like(DFNctllc)
     D  RtvCtlLCcde                        like(dfnLCctycde) const
      *
     D ctllc           ds                  likerec(ctllc01r) inz
      * ---------------------------------------------------------
      *
      *    Return land city record.
      *
     C     RtvCtlLCcde   chain     ctllc01r      ctllc
     C                   if        not %found
     C                   reset                   ctllc
     C                   endif
      *
     C                   return    ctllc
      *
     P RtvCtlLC        E
      ***********************************************************
      * ExtLCcde() -- Extract land city code.
      ***********************************************************
     P ExtLCcde        B                   Export
      *
     D ExtLCcde        PI                  like(dfnLCctycde)
     D  PIctynam                           like(dfnLCctynam) const
      *
     D x               s                   like(StdInt)      inz
     D pos             s                   like(StdInt)      inz
     D count           s                   like(StdInt)      inz
     D LenCtyCde       s                   like(StdInt)      inz
     D WKctycde        s                   like(dfnLCctycde) inz
      * ---------------------------------------------------------
      * Determine length of city code definition.
      *
     C                   eval      LenCtyCde = %len(WKctycde)
      * ---------------------------------------------------------
      * Determine if only city code.
      *
     C                   if        %len(%trim(PIctynam)) = LenCtyCde
     C                   return    %trim(PIctynam)
     C                   endif
      *
     C                   return    *blanks
      *
     P ExtLCcde        E
      ***********************************************************
      * SchLCnam() -- Search for land city name.
      ***********************************************************
     P SchLCnam        B                   Export
      *
     D SchLCnam        PI                  like(dfnCtlLC)
     D  PIctynam                           like(dfnLCctynam) const
     D  PIdest                             like(dfnLCdest  ) const
      *
     D CtlLC         e ds                  extname(ctllcp01) inz
      *
     D WKctynam        s                   like(dfnLCctynam) inz
     D WKdest          s                   like(dfnLCdest  ) inz
      * ---------------------------------------------------------
      * Search for land city name.
      *
     C                   eval       WKctynam = PIctynam
     C                   eval       WKdest   = PIdest
      *
     C                   call      'UT0245R'
     C                   parm                    WKctynam
     C                   parm                    WKdest
     C                   parm                    CtlLC
      *
     C                   return    CtlLC
      *
     P SchLCnam        E
