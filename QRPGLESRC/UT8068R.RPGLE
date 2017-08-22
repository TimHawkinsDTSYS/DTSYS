      /TITLE Utility, Distance (SrvPgm)
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
      /COPY QCPYSRC,UT8062S
      * *********************************************************
      * CvtDMStoDD() -- Convert deg, min, sec to decimal degrees
      * *********************************************************
     P CvtDMStoDD      B                   Export
      *
     D CvtDMStoDD      PI            10  7
     D  LatLonDeg                          like(StdInt) const
     D  LatLonMin                          like(StdInt) const
     D  LatLonSec                          like(StdInt) const
     D  LatLonDir                          like(StdChr) const
      *
     D WKmin           s                   like(StdMaxDec) inz
     D WKsec           s                   like(StdMaxDec) inz
     D WKdd            s                   like(StdMaxDec) inz
      * ---------------------------------------------------------
      *
      *   Return zero if no values.
      *
     C                   if        LatLonDeg = *zero   and
     C                             LatLonMin = *zero   and
     C                             LatLonSec = *zero   and
     C                             LatLonDir = *blanks
     C                   return    *zero
     C                   endif
      * ---------------------------------------------------------
      *
      *   Format the return value.
      *
     C                   eval      WKmin = LatLonMin / 60
     C                   eval      WKsec = LatLonSec / 3600
     C                   eval      WKdd  = LatLonDeg +
     C                                     WKmin     +
     C                                     WKsec
      *
     C                   if        LatLonDir = 'S' or
     C                             LatLonDir = 'W'
     C                   eval      WKdd      = -WKdd
     C                   endif
      *
     C                   return    WKdd
      *
     P CvtDMStoDD      e
      * *********************************************************
      * EdtDMStoDMS() -- Edit deg, min, sec to 145° 30' 35" W
      * *********************************************************
     P EdtDMStoDMS     B                   Export
      *
     D EdtDMStoDMS     PI            14
     D  LatLonDeg                          like(StdInt) const
     D  LatLonMin                          like(StdInt) const
     D  LatLonSec                          like(StdInt) const
     D  LatLonDir                          like(StdChr) const
      * ---------------------------------------------------------
      *
      *   Return blanks if no values.
      *
     C                   if        LatLonDeg = *zero   and
     C                             LatLonMin = *zero   and
     C                             LatLonSec = *zero   and
     C                             LatLonDir = *blanks
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *   Format the return value.
      *
     C                   return    %trim(%editc(LatLonDeg:'Z')) + x'9040' +
     C                             %trim(%editc(LatLonMin:'Z')) + x'7D40' +
     C                             %trim(%editc(LatLonSec:'Z')) + x'7F40' +
     C                                          LatLonDir
      *
     P EdtDMStoDMS     e
      * *********************************************************
      * RtnAPctydst() -- Return airport city to city distance
      * *********************************************************
     P RtnAPctydst     B                   Export
      *
     D RtnAPctydst     PI                  like(StdInt)
     D  FmCtyCde                           like(dfnBAdcty) const
     D  ToCtyCde                           like(dfnBAacty) const
      *
     D FmCtlac       e ds                  extname(ctlacp01) qualified inz
     D ToCtlac       e ds                  extname(ctlacp01) qualified inz
      *
     D WKcurtsp        s                   like(StdTok)    inz
     D RtnCtyDst       s                   like(StdInt)    inz
     D WKfloat         s                   like(StdDblFlt) inz
     D Pi              s                   like(StdDblFlt) inz(3.1415927)
     D Pi180           s                   like(StdDblFlt) inz(.0174532925)
      * pi/180
      /free
       // -------------------------------------------------------
       //Return zero if no values or city codes are the same.

       if FmCtyCde = *blanks or
          ToCtyCde = *blanks;
          return *zero;
       endif;

       if FmCtyCde = ToCtyCde;
          return *zero;
       endif;

       WKcurtsp = %char(TimeStamp());

       // -------------------------------------------------------
       //Retrieve from/to city.

       FmCtlac = RtvCtlAC(FmCtyCde);
       ToCtlac = RtvCtlAC(ToCtyCde);

       if FMctlac.AClatdd = *zero  or
          TOctlac.AClatdd = *zero;
          return *zero;
       endif;

       // -------------------------------------------------------
       //Calculate distance.

       monitor;
         WKfloat = Sine((FMctlac.AClatdd * pi180)) *
                   Sine((TOctlac.AClatdd * pi180)) +
                 Cosine((FMctlac.AClatdd * pi180)) *
                 Cosine((TOctlac.AClatdd * pi180)) *
                 Cosine(
                   %abs((TOctlac.AClondd * pi180) -
                        (FMctlac.AClondd * pi180)));
       on-error;
         return *zero;
       endmon;

       if WKfloat  = *zero;
          return *zero;
       endif;

       monitor;
         WKfloat = atan((sqrt(1-(WKfloat*WKfloat)))/WKfloat);
       on-error;
         return *zero;
       endmon;

       if WKfloat = *zero;
         return *zero;
       endif;

       monitor;
         WKfloat = 1.852 * 60.0 * ((WKfloat/pi)*180);
       on-error;
         return *zero;
       endmon;

       if WKfloat = *zero;
         return *zero;
       endif;

--     // Convert from kilometers to miles.

       monitor;
         RtnCtyDst = WKfloat * .621371192;
       on-error;
         return *zero;
       endmon;

       return    %abs(RtnCtyDst);

      /end-free
     P RtnAPctydst     e
