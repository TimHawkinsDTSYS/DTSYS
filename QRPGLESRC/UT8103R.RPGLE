      /TITLE Utility, Location Codes DB (SrvPgm)
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
      * RtvCtllo() -- Retrieve location codes record.
      ***********************************************************
     P RtvCtlLO        B                   Export
      *
     Fctllop01  if   e           k disk    static
      *
     D RtvCtlLO        PI                  like(DFNctllo)
     D  RtvCtlLOcde                        like(dfnLOloccde) const
      *
     D ctllo           ds                  likerec(ctllo01r) inz
      * ---------------------------------------------------------
      *
      *    Return location codes record.
      *
     C     RtvCtlLOcde   chain     ctllo01r      ctllo
     C                   if        not %found
     C                   reset                   ctllo
     C                   endif
      *
     C                   return    CtlLO
      *
     P RtvCtlLO        E
      ***********************************************************
      * ExtLOcde() -- Extract location code.
      ***********************************************************
     P ExtLOcde        B                   Export
      *
     D ExtLOcde        PI                  like(dfnLOloccde)
     D  PIlocnam                           like(dfnLOlocnam) const
      *
     D x               s                   like(StdInt)      inz
     D pos             s                   like(StdInt)      inz
     D count           s                   like(StdInt)      inz
     D LenLocCde       s                   like(StdInt)      inz
     D WKloccde        s                   like(dfnLOloccde)
      * ---------------------------------------------------------
      * Determine length of location code definition.
      *
     C                   eval      LenLocCde = %len(WKloccde)
      * ---------------------------------------------------------
      * Determine if only location code.
      *
     C                   if        %len(%trim(PIlocnam)) = LenLocCde
     C                   return    %trim(PIlocnam)
     C                   endif
      *
     C                   return    *blanks
      *
     P ExtLOcde        E
      ***********************************************************
      * SchLOnam() -- Search for location name.
      ***********************************************************
     P SchLOnam        B                   Export
      *
     D SchLOnam        PI                  like(dfnCtlLO)
     D  PIlocnam                           like(dfnLOlocnam) const
     D  PIdest                             like(dfnLOdest  ) const
      *
     D CtlLO         e ds                  extname(ctlLOp01) inz
      *
     D WKlocnam        s                   like(dfnLOlocnam) inz
     D WKdest          s                   like(dfnLOdest  ) inz
      * ---------------------------------------------------------
      * Search for location name.
      *
     C                   eval       WKlocnam = PIlocnam
     C                   eval       WKdest   = PIdest
      *
     C                   call      'UT0247R'
     C                   parm                    WKlocnam
     C                   parm                    WKdest
     C                   parm                    CtlLO
      *
     C                   return    CtlLO
      *
     P SchLOnam        E
