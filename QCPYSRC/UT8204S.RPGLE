      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      *  Address Line prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      * ---------------------------------------------------------
      * ClnPObox() -- Cleanup PO Box.
      *
     D ClnPObox        PR                  like(StdStr)
     D  InpAddr                            like(StdStr)  const
      * ---------------------------------------------------------
      * ExtSuiteAddr() -- Extract suite and address.
      *
     D ExtSuiteAddr    PR                  likeds(t_ExtSuiteAddr)
     D  InpAddr                            like(StdStr)  const
      *
     D t_ExtSuiteAddr  ds                  qualified template
     D  Suite                              like(StdStr)
     D  Address                            like(StdStr)
