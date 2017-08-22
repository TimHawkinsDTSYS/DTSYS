      /TITLE Utility, Record ID (SrvPgm)
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
      **********************************************************
      * RtvRecID() -- Retrieve record ID.
      **********************************************************
     P RtvRecID        B                   Export
      *
     Fctlnrp01  uf a e           k disk    static
      *
     D RtvRecID        PI                  like(dfnNRrcid)
     D  P_type                             like(dfnNRtype) value
      *
š1b€ D ctlnr_i         ds                  likerec(ctlnr01r:*input)
š1b€ D ctlnr_o         ds                  likerec(ctlnr01r:*output)
      * ---------------------------------------------------------
      *
      *   Retrieve record ID.
      *
     C     P_type        chain     ctlnr01r      ctlnr_i
      *
      *    Update existing record.
      *
š1x€ C                   select
š1b€ C                   when      %found
     C                   eval-corr ctlnr_o = ctlnr_i
     C                   eval      ctlnr_o.NRrcid += 1
     C                   update(e) ctlnr01r      ctlnr_o
      *
      *    Write a new record.
      *
š1b€ C                   when      not %found
     C                   eval      ctlnr_o.NRtype = P_type
     C                   eval      ctlnr_o.NRrcid = 1
     C                   write(e)  ctlnr01r      ctlnr_o
š1e€ C                   endsl
      *
     C                   return    ctlnr_o.NRrcid
      *
     P RtvRecID        E
      **********************************************************
      * ClrRecID() -- Clear record ID.
      **********************************************************
     P ClrRecID        B                   Export
      *
     Fctlnrp01  uf a e           k disk    static
      *
     D ClrRecID        PI
     D  P_type                             like(dfnNRtype) value
      *
š1b€ D ctlnr_i         ds                  likerec(ctlnr01r:*input)
š1b€ D ctlnr_o         ds                  likerec(ctlnr01r:*output)
      * ---------------------------------------------------------
      *
      *   Clear record ID.
      *
     C     P_type        chain     ctlnr01r      ctlnr_i
      *
      *    Update existing record to *ZERO.
      *
š1b€ C                   select
š1b€ C                   when      %found
     C                   eval-corr ctlnr_o = ctlnr_i
     C                   eval      ctlnr_o.NRrcid = *zero
     C                   update(e) ctlnr01r      ctlnr_o
š1e€ C                   endsl
      *
     C                   return
      *
     P ClrRecID        E
