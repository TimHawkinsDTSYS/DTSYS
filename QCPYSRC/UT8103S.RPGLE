      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      *  Location codes DB prototypes
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      * ---------------------------------------------------------
      * RtvCtllo() - Retrieve location code record.
      *
     D RtvCtllo        PR                  like(DFNctllo)
     D  RtvCtlLOcde                        like(dfnLOloccde)  const
      * ---------------------------------------------------------
      * ExtLOcde() - Extract location code.
      *
     D ExtLOcde        PR                  like(dfnLOloccde)
     D  PIlocnam                           like(dfnLOlocnam)  const
      * ---------------------------------------------------------
      * SchLOnam() - Search for location name.
      *
     D SchLOnam        PR                  like(dfnCtlLO)
     D  PIlocnam                           like(dfnLOlocnam)  const
     D  PIdest                             like(dfnLOdest)    const
