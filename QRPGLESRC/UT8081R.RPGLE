      /TITLE Utility, Imports (SrvPgm)
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Provides miscellaneous routines via function calls.
      *
      *  Notes   :  none
      *
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  mm/dd/yy  xxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /copy qcpysrc,HspecSrv
      *
      /define DSpgm
      /copy qcpysrc,Dspec
      /copy qcpysrc,UT8081S
      * *********************************************************
      * ImpMDYtoISP() -- Import m/d/yyyy to yyyymmdd.
      * *********************************************************
     P ImpMDYtoISO     b                   export
      *
     D ImpMDYtoISO     pi                  like(WKiso)
     D  I_mdy                              like(WKmdy)
     D**                                   options(*nullind)

     D MDYwords        ds                  likeds(t_ExtWords)
     D                                     based(pMDYwords)

      /free

       if I_mdy = *blanks;
         return *zero;
       endif;

       pMDYwords  = ExtWords(I_mdy:'/');
       WKalpMM    = MDYwords.words(1);
       WKalpDD    = MDYwords.words(2);
       WKalpYYYY  = MDYwords.words(3);

       if        %len(%trim(WKalpMM)) = 1;
         WKalpMM = '0' + WKalpMM;
       endif;

       if        %len(%trim(WKalpDD)) = 1;
         WKalpDD = '0' + WKalpDD;
       endif;

       WKalpISO = WKalpYYYY + WKalpMM + WKalpDD;
       WKiso    = num(WKalpISO);

       return    WKiso;

      /end-free

     P ImpMDYtoISO     e
      * *********************************************************
      * ImpAlptoNum() -- Import alpha string to numeric.
      * *********************************************************
     P ImpAlptoNum     b                   export
      *
     D ImpAlptoNum     pi                  like(WKnumamt)
     D  I_alpamt                           like(WKalpamt)
     D**                                   options(*nullind)
      *
     D Negative        s                   like(StdInd) inz

      /free

       if I_alpamt = *blanks;
         return *zero;
       endif;

       Negative = *off;

       if %scan('(':I_alpamt) > *zero;
         Negative = *on;
         I_alpamt = %replace('':I_alpamt:%scan('(':I_alpamt):1);

         if %scan(')':I_alpamt) > *zero;
           I_alpamt = %replace('':I_alpamt:%scan(')':I_alpamt):1);
         endif;
       endif;

       WKnumamt = CvtCharToNum(I_alpamt);

       if Negative;
         WKnumamt = -WKnumamt;
       endif;

       return WKnumamt;

      /end-free

     P ImpAlptoNum     e
