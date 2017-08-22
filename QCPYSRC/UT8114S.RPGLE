      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      *  Company DB prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      * ---------------------------------------------------------
      *  RtvCtlce() -- Retrieve Control Company Email
      *
     D RtvCtlce        PR                  likeds(t_ctlce)
     D  CEcode                             like(StdNam)  const
      *
     D t_ctlce       e ds                  prefix(dfn)
     D                                     extname(ctlcep01) inz
     D                                     template
