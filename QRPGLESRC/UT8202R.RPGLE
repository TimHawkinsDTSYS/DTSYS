      /TITLE Utility, Postal code (SrvPgm)
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
      * **********************************************************
      * Check postal code.
      * **********************************************************
     P ChkPstCde       B                   Export
      *
     D ChkPstCde       PI                  like(msgid)
     D  InpPstCde                          like(dfnPApscd)  value
     D  InpCtry                            like(dfnPActry)  value
      *
     D  Len            s                   like(StdInt)     inz
      * ---------------------------------------------------------
      /free
       //
       // Return if nothing passed.
       //
       if InpPstCde = *blanks;
         return *blanks;
       endif;

       //
       // Return if foreign address.
       //
       if InpCtry <> *blanks and
          InpCtry <> 'US';
         return *blanks;
       endif;

       //
       // Check length.
       //
       eval Len = CntNumChr(InpPstCde);

       if   Len <> 5  and
            Len <> 9;
         return 'RES0277';
       endif;

       return *blanks;

      /End-Free
      *
     P ChkPstCde       E
      * **********************************************************
      * Mask postal code.
      * **********************************************************
     P MskPstCde       B                   Export
      *
     D MskPstCde       PI                  like(dfnPApscd)
     D  InpPstCde                          like(dfnPApscd)  value
     D  InpCtry                            like(dfnPActry)  value
      *
     D  WKpstcde       s                   like(dfnPApscd)  inz
     D  RtnPstCde      s                   like(dfnPApscd)  inz
      * ---------------------------------------------------------
      /free
       //
       // Return if nothing passed.
       //
       if InpPstCde = *blanks;
         return InpPstCde;
       endif;

       //
       // Return if foreign address.
       //
       if InpCtry <> *blanks and
          InpCtry <> 'US';
         return InpPstCde;
       endif;

       //
       // mask Zip + 4.
       //
       eval WKpstcde = %char(num(InpPstCde));

       if   %len(%trim(WKpstcde)) = 9;
         return %subst(WKpstcde:1:5) + '-' + %subst(WKpstcde:6:4);
       endif;

       return InpPstCde;

      /End-Free
      *
     P MskPstCde       E
