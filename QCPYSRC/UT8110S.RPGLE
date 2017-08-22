      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      *  Destination Code DB prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      * ---------------------------------------------------------
      * RtvCtlDS() - Retrieve destination codes
      *
     D RtvCtlDS        PR                  like(DFNctlds)
     D  RtvCtlDScde                        like(dfnDSdstcde) value
      * ---------------------------------------------------------
      *  Extract destination code.
      *
     D ExtDScde        PR                  like(dfnDSdstcde)
     D  PIdstnam                           like(dfnDSdstnam) value
      * ---------------------------------------------------------
      *  Search for destination name.
      *
     D SchDSnam        PR                  like(dfnCtlDS)
     D  PIdstnam                           like(dfnDSdstnam) value
     D  PIdest                             like(dfnDSdstcde) value
      * ---------------------------------------------------------
      *  Concatenate destination name.
      *
     D CatDSnam        PR                  like(dfnDSdstnam)
     D  PIdstcde                           like(dfnDSdstcde) value
