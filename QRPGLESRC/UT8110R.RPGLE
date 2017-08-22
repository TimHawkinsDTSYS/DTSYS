      /TITLE Utility, Destination Code DB (SrvPgm)
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
      * RtvCtlDS() - Retrieve destination codes record.
      ***********************************************************
     P RtvCtlDS        B                   Export
      *
     Fctldsp01  if   e           k disk    static
      *
     D RtvCtlDS        PI                  like(DFNctlds)
     D  RtvCtlDScde                        like(dfnDSdstcde) value
      *
     D ctlds           ds                  likerec(ctlds01r) inz
      * ---------------------------------------------------------
      *
      *    Return destination record.
      *
     C     RtvCtlDScde   chain     ctlds01r      ctlds
     C                   if        not %found
     C                   reset                   ctlds
     C                   endif
      *
     C                   return    CtlDS
      *
     P RtvCtlDS        E
