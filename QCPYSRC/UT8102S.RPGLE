      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      *  Land City codes DB prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      * ---------------------------------------------------------
      *  Retrieve land city code record
      *
     D RtvCtlLC        PR                  like(DFNctllc)
     D  RtvCtlLCcde                        like(dfnLCctycde)  const
      * ---------------------------------------------------------
      *  Extract land city code.
      *
     D ExtLCcde        PR                  like(dfnLCctycde)
     D  PIctynam                           like(dfnLCctynam)  const
      * ---------------------------------------------------------
      *  Search for land city.
      *
     D SchLCnam        PR                  like(dfnCtlLC)
     D  PIctynam                           like(dfnLCctynam)  const
     D  PIdest                             like(dfnLCdest)    const
