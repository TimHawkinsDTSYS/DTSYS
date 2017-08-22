      /TITLE Utility, Application DB (SrvPgm)
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Provides miscellaneous routines via function calls.
      *
      *  Notes   :  none
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  mm/dd/yy  xxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /copy qcpysrc,HspecSrv
      *
      /define DSpgm
      /copy qcpysrc,Dspec
      ***********************************************************
      * RtvCtlra() -- Retrieve resort area codes record.
      ***********************************************************
     P RtvCtlRA        B                   Export
      *
     Fctlrap01  if   e           k disk    static
      *
     D RtvCtlRA        PI                  like(DFNctlra)
     D  RtvCtlRAcde                        like(dfnRArarcde) value
     D  RtvCtlRAdst                        like(dfnRAdest  ) value
      *
     D CtlRA           ds                  likerec(ctlra01r) inz
      * ---------------------------------------------------------
      *
      *    Return resort area record.
      *
     C     RAkey2        chain     ctlra01r      ctlra
     C                   if        not %found
     C                   reset                   ctlra
     C                   endif
      *
     C                   return    CtlRA
      *
     C     RAkey2        klist
     C                   kfld                    RtvCtlRAcde
     C                   kfld                    RtvCtlRAdst
      *
     P RtvCtlRA        E
