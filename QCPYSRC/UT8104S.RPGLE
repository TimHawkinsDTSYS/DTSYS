      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      *  Sub-Region codes DB prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      * ---------------------------------------------------------
      *  Retrieve sub-region code record.
      *
     D RtvCtlRS        PR                  like(DFNctlrs)
     D  RtvCtlRScde                        like(dfnRSctycde)  const
      * ---------------------------------------------------------
      *  Search for sub-region.
      *
     D SchRSnam        PR                  like(dfnCtlRS)
     D  PIsubnam                           like(dfnRSsubnam)  const
