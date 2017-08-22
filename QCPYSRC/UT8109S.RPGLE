      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      *  Airline Codes DB prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      * ---------------------------------------------------------
      *  SltCtlAL() -- Select airline.
      *
     D SltCtlAL        PR                  like(dfnCMcarr)
     D  SScarr                             like(dfnCMcarr) const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      *  ChkCtlAL() -- Check airline code.
      *
     D ChkCtlAL        PR                  like(StdInd)
     D  SScarr                             like(dfnCMcarr) const
      * ---------------------------------------------------------
      *  RtvCtlAL() -- Retrieve airline control record.
      *
     D RtvCtlAL        PR                  like(dfnctlal)
     D  SScarr                             like(dfnCMcarr) const
      * ---------------------------------------------------------
      *  RtvCarr() -- Retrieve carrier.
      *
     D RtvCarr         PR                  like(dfnCMcarr)
     D  SSvndn                             like(dfnCMvndn) const
