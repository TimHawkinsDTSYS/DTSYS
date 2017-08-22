      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      *  Airport Codes DB prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      * ---------------------------------------------------------
      * RtvCtlac() - Retrieve airport code record
      *
     D RtvCtlAC        PR                  like(DFNctlac)
     D  RtvCtlACcde                        like(dfnACctycde) const
      * ---------------------------------------------------------
      * ExtAPcde() - Extract airport code.
      *
     D ExtAPcde        PR                  like(dfnACctycde)
     D  PIctynam                           like(dfnACctynam) const
      * ---------------------------------------------------------
      * SchAPnam() - Search for airport name.
      *
     D SchAPnam        PR                  like(dfnCtlAC)
     D  PIctynam                           like(dfnACctynam) const
     D  PIdest                             like(dfnACdest)   const
      * ---------------------------------------------------------
      * CatAPnam() - Concatenate airport name.
      *
     D CatAPnam        PR                  like(dfnACctynam)
     D  PIctycde                           like(dfnACctycde) const
