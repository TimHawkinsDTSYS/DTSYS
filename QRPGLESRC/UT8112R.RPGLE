      /TITLE Utility, Agency DB (SrvPgm)
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
      * AgyChkDig() -- Determine agency check digit.
      ***********************************************************
     P AgyChkDig       B                   Export
      *
     D AgyChkDig       PI                  like(StdInt)
     D   P_agyn                            like(dfnAMagyn) const

     D WKchkdig        s                   like(StdInt) inz
      /free
       // ---------------------------------------------------------
       // Determine check digit.

š1b€   select;
š1x€   when  P_agyn / 7 = .14;
             WKchkdig = 1;

š1x€   when  P_agyn / 7 = .28;
             WKchkdig = 2;

š1x€   when  P_agyn / 7 = .42;
             WKchkdig = 3;

š1x€   when  P_agyn / 7 = .57;
             WKchkdig = 4;

š1x€   when  P_agyn / 7 = .71;
             WKchkdig = 5;

š1x€   when  P_agyn / 7 = .85;
             WKchkdig = 6;

š1x€   other;
             WKchkdig = *zero;
š1e€   endsl;

       return WKchkdig;

      /end-free
     P AgyChkDig       E
