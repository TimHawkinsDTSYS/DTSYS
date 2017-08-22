      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Distance prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *
      *   CvtDMStoDD() -- Convert deg, min, sec to decimal degrees
      *
     D CvtDMStoDD      PR            10  7
     D  LatLonDeg                          like(StdInt) const
     D  LatLonMin                          like(StdInt) const
     D  LatLonSec                          like(StdInt) const
     D  LatLonDir                          like(StdChr) const
      *
      *   EdtDMStoDMS() -- Edit deg, min, sec to 145° 30' 35" W
      *
     D EdtDMStoDMS     PR            14
     D  LatLonDeg                          like(StdInt) const
     D  LatLonMin                          like(StdInt) const
     D  LatLonSec                          like(StdInt) const
     D  LatLonDir                          like(StdChr) const
      * ---------------------------------------------------------
      *
      *   RtnAPctydst() -- Return airport city to city distance
      *
     D RtnAPctydst     PR                  like(StdInt)
     D  FmCtyCde                           like(dfnBAdcty) const
     D  ToCtyCde                           like(dfnBAacty) const
