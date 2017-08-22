      /TITLE Utility, Calendar (SrvPgm)
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
      * PrvBusDay -- Fetch previous business day.
      ***********************************************************
     P PrvBusDay       B                   Export
      *
     Fctlwhl01  if   e           k disk    rename(ctlwh01r:ctlwh01l)
     F                                     static
      *
     D PrvBusDay       PI                  like(NumISO)
     D  CurBusDay                          like(NumISO) const
      *
     Dctlwh            ds                  likerec(ctlwh01l) inz
      * ---------------------------------------------------------
      *
      *    Return previous business day.
      *
     C     CurBusDay     setgt     ctlwh01L
     C                   readp     ctlwh01L      ctlwh
     C                   if        %eof
     C                   eval      ctlwh.WHdate = *zero
     C                   endif
      *
     C                   return    ctlwh.WHdate
      *
     P PrvBusDay       E
      ***********************************************************
      * NxtBusDay -- Fetch next business day.
      ***********************************************************
     P NxtBusDay       B                   Export
      *
     Fctlwhl01  if   e           k disk    rename(ctlwh01r:ctlwh01l)
     F                                     static
      *
     D NxtBusDay       PI                  like(NumISO)
     D  CurBusDay                          like(NumISO) const
      *
     Dctlwh            ds                  likerec(ctlwh01l) inz
      * ---------------------------------------------------------
      *
      *    Return next business day.
      *
     C     CurBusDay     setll     ctlwh01L
     C                   read      ctlwh01L      ctlwh
     C                   if        %eof
     C                   eval      ctlwh.WHdate = *zero
     C                   endif
      *
     C                   return    ctlwh.WHdate
      *
     P NxtBusDay       E
      ***********************************************************
      * StdBusHrs() - Standard business hours.
      ***********************************************************
     P StdBusHrs       B                   Export
      *
     D StdBusHrs       PI                  like(StdInd)
     D  DepNam_p                           like(StdNam) const
     D                                     options(*omit:*nopass)
     D  DteToChk_p                         like(NumISO) const
     D                                     options(*nopass)
      *
     D DepNam          s                   like(DepNam_p)   inz
     D DteToChk        s                   like(DteToChk_p) inz
     D BusHrs          s                   like(StdInd)     inz
      * ---------------------------------------------------------
      *
      *    Set parameters.
      *
     C                   if        %parms    >= 1    and
     C                             DepNam_p  <> *blanks
     C                   eval      DepNam     = DepNam_p
     C                   else
     C                   eval      DepNam     = '*STD'
     C                   endif
      *
     C                   if        %parms    >= 2    and
     C                             DteToChk_p  <> *zero
     C                   eval      DteToChk     = DteToChk_p
     C                   else
     C                   eval      DteToChk   = *zero
     C                   endif
      * ---------------------------------------------------------
      *
      *    Standard business hours.
      *
     C                   call      'UT3060R'
     C                   parm                    DepNam
     C                   parm                    DteToChk
     C                   parm      *off          BusHrs
      *
š1b€ C                   return    BusHrs
      *
     P StdBusHrs       E
