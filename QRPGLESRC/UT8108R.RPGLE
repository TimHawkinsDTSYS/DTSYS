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
      * RtvCtlac() -- Retrieve airport codes record.
      ***********************************************************
     P RtvCtlAC        B                   Export
      *
     Fctlacp01  if   e           k disk    static
      *
     D RtvCtlAC        PI                  like(DFNctlac)
     D  ACctycde                           like(dfnACctycde) const
      *
     D ctlac           ds                  likerec(ctlac01r) inz
      * ---------------------------------------------------------
      * Return airport codes record.
      *
     C     ACctycde      chain     ctlac01r      ctlac
     C                   if        not %found
     C                   clear                   ctlac
     C                   endif
      *
     C                   return    CtlAC
      *
     P RtvCtlAC        E
      ***********************************************************
      * SchAPnam() -- Search for airport name.
      ***********************************************************
     P SchAPnam        B                   Export
      *
     D SchAPnam        PI                  like(dfnCtlAC)
     D  PIctynam                           like(dfnACctynam) const
     D  PIdest                             like(dfnACdest  ) const
      *
     D  CtlAC        e ds                  extname(ctlacp01) inz
      *
     D  WKctynam                           like(dfnACctynam) inz
     D  WKdest                             like(dfnACdest  ) inz
      * ---------------------------------------------------------
      *  Search for airport name.
      *
     C                   eval      WKctynam = PIctynam
     C                   eval      WKdest   = PIdest
      *
     C                   call      'UT0243R'
     C                   parm                    WKctynam
     C                   parm                    WKdest
     C                   parm                    CtlAC
      *
     C                   return    CtlAC
      *
     P SchAPnam        E
      ***********************************************************
      * ExtAPcde() -- Extract airport code from airport name.
      ***********************************************************
     P ExtAPcde        B                   Export
      *
     D ExtAPcde        PI                  like(dfnACctycde)
     D  PIctynam                           like(dfnACctynam) const
      *
     D x               s                   like(StdInt)      inz
     D pos             s                   like(StdInt)      inz
     D count           s                   like(StdInt)      inz
     D LenCtyCde       s                   like(StdInt)      inz
     D WKctycde        s                   like(dfnACctycde) inz
     D WKctynam        s                   like(dfnACctynam) inz
      * ---------------------------------------------------------
      * Determine length of city code definition.
      *
     C                   eval      WKctynam  = PIctynam
      *
     C                   eval      LenCtyCde = %len(WKctycde)
      *
      *    Determine if only airport code.
      *
     C                   if        %len(%trim(PIctynam)) = LenCtyCde
     C                   return    %trim(PIctynam)
     C                   endif
      *
      *    Determine number of left parens.
      *
     C                   for       x = 1 to %len(%trim(PIctynam))
     C                   if        %subst(PIctynam:x:1) = '('
     C                   eval      count += 1
     C                   endif
     C                   endfor
      *
      *    Locate postion of last paren.
      *
     C                   do        count
     C                   eval      pos = %scan('(':PIctynam:pos+1)
     C                   enddo
      *
      *    If nothing found, return nothing.
      *
     C                   if        count = *zero                      or
     C                             pos  <= *zero                      or
     C                             pos  >= %len(PIctynam) + LenCtyCde or
     C                             %subst(PIctynam:pos+LenCtyCde+1:1) <> ')'
     C                   return    *blanks
     C                   endif
      *
      *    Found a city code, return it.
      *
     C                   return    %subst(PIctynam:pos+1:LenCtyCde)
      *
     P ExtAPcde        E
      ***********************************************************
      * CatAPnam() -- Concatenate airport name.
      ***********************************************************
     P CatAPnam        B                   Export
      *
     D CatAPnam        PI                  like(dfnACctynam)
     D  PIctycde                           like(dfnACctycde) const
      *
     D ctlac         e ds                  extname(ctlacp01) inz
      *
     D WKctycde        s                   like(dfnACctycde) inz
     D RTctynam        s                   like(dfnACctynam) inz
      * ---------------------------------------------------------
      *Retrieve airport codes record.
      *
     C                   eval      WKctycde = PIctycde
     C                   eval      ctlac = RtvCtlAC(PIctycde)
      *
      *Set city name.
      *
     C                   eval      RTctynam = ACctynam
      *
      *Add state code.
      *
     C                   if        ACstcd  <> *blanks
     C                   eval      RTctynam = %trim(RTctynam) + ', ' +
     C                                        %trim(ACstcd)
     C                   endif
      *
      *   Add airport code.
      *
     C                   if        ACctycde <> *blanks
     C                   eval      RTctynam  = %trim(RTctynam) +
     C                                         ' (' + %trim(ACctycde) + ')'
     C                   endif
      *
      *   Add country name.
      *
     C                   if        ACctry <> *blanks
     C                   eval      d_ctlma = RtvCtlmaRcd('ADDRESS':
     C                                                   'COUNTRY CODES':
     C                                                   ACctry)
     C                   if        CMappdta   <> *blanks
     C                   eval      RTctynam = %trim(RTctynam) + '  ' +
     C                                        %trim(CMappdta)
     C                   endif
     C                   endif
      *
     C                   return    RTctynam
      *
     P CatAPnam        E
