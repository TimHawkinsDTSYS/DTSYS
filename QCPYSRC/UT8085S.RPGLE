      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Display file prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *
      *  Webfaced() -- Check webfacing environment.
      *
     D WebFaced        PR            10i 0 extproc('QqfEnvironment')
      * ---------------------------------------------------------
      *
      *  Retrieve panel dimensions.
      *
     D RtvPnlDim       PR             4
      * ---------------------------------------------------------
      *
      *  SetDspModDS4() -- Set display mode if *DS4
      *
     D SetDspModDS4    PR                  like(StdInd)
