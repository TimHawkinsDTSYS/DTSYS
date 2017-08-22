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
      * RtvCtlce() -- Retrieve control company email
      ***********************************************************
     P RtvCtlce        B                   Export

     Fctlcel01  if   e           k disk    rename(ctlce01r:ctlce01l)
     F                                     static

     D RtvCtlce        PI                  likeds(t_ctlce)
     D  CEcode                             like(StdNam)  const

     D ctlce           ds                  likerec(ctlce01l) inz
      /free
       // ---------------------------------------------------------
       // Return control company email.

       chain (CEcode) ctlce01l ctlce;
       if not %found;
          reset ctlce;
       endif;

       return ctlce;

      /end-free
     P RtvCtlce        E
