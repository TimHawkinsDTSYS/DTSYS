      /TITLE Utility, Addresses (SrvPgm)
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
      * ClnPObox() -- Cleanup PO Box.
      * **********************************************************
     P ClnPObox        B                   Export
      *
     D ClnPObox        PI                  like(StdStr)
     D  InpAddr                            like(StdStr)  const
      *
     D  RtnAddr        s                   like(StdStr)  inz
      /free
       // -------------------------------------------------------
       // Return if nothing passed.
       //
       if InpAddr = *blanks;
         return *blanks;
       endif;

       // -------------------------------------------------------
       // Change to upper case.

       RtnAddr  = upper(InpAddr);

       // -------------------------------------------------------
       // Change P.O. BOX to PO BOX.

       if %scan('BOX':RtnAddr) <> *zero;
          select;
          when      %scan('P.O. BOX':RtnAddr) <> *zero;
                    RtnAddr = %replace('PO BOX':RtnAddr:
                              %scan('P.O. BOX':RtnAddr):8);

          when      %scan('P.O  BOX':RtnAddr) <> *zero;
                    RtnAddr = %replace('PO BOX':RtnAddr:
                              %scan('P.O  BOX':RtnAddr):8);

          when      %scan('P.O BOX':RtnAddr) <> *zero;
                    RtnAddr = %replace('PO BOX':RtnAddr:
                              %scan('P.O BOX':RtnAddr):8);

          when      %scan('P O  BOX':RtnAddr) <> *zero;
                    RtnAddr = %replace('PO BOX':RtnAddr:
                              %scan('P O  BOX':RtnAddr):8);

          when      %scan('P O BOX':RtnAddr) <> *zero;
                    RtnAddr = %replace('PO BOX':RtnAddr:
                              %scan('P O BOX':RtnAddr):8);
          endsl;

          // Insert blank after the PO BOX.

          if        %scan('PO BOX' :RtnAddr) <> *zero and
                    %scan('PO BOX ':RtnAddr)  = *zero;
                    RtnAddr = %replace('PO BOX ':RtnAddr:
                              %scan('PO BOX' :RtnAddr):6);
          endif;
       endif;

       return RtnAddr;

      /End-Free
      *
     P ClnPObox        E
      * **********************************************************
      * ExtSuiteAddr() -- Extract suite and address.
      * **********************************************************
     P ExtSuiteAddr    B                   Export
      *
     D ExtSuiteAddr    PI                  likeds(t_ExtSuiteAddr)
     D  InpAddr                            like(StdStr)  const
      *
     D d_ExtSuiteAddr  ds                  likeds(t_ExtSuiteAddr)
     D                                     inz(*likeds)
      *
     D Address         ds                  likeds(t_ExtWords)
     D                                     based(pAddress)
      *
     D RtnAddr         s                   like(StdStr)  inz
     D Suite           s                   like(StdInd)  inz
     D x               s                   like(StdInt)  inz
      /free
       // -------------------------------------------------------
       // Return if nothing passed.
       //
       if InpAddr = *blanks;
          return d_ExtSuiteAddr;
       endif;

       // -------------------------------------------------------
       // Change to upper case.

       RtnAddr  = upper(InpAddr);

       // -------------------------------------------------------
       // If no suite in the address, pass back as address.

       if %scan('SUITE':RtnAddr) = *zero   and
          %scan(' STE' :RtnAddr) = *zero   and
          %scan('#'    :RtnAddr) = *zero   and
          %scan(' RT ' :RtnAddr) = *zero;

          d_ExtSuiteAddr.Suite   = *blanks;
          d_ExtSuiteAddr.Address = RtnAddr;
          return d_ExtSuiteAddr;
       endif;

       // -------------------------------------------------------
       // Extract suite from the address.

       pAddress = ExtWords(RtnAddr);

       for x = 1 to Address.WordsMax;
           if  not Suite                                  and
              (%scan('SUITE':Address.words(x)) <> *zero   or
               %scan(' STE' :Address.words(x)) <> *zero   or
               %scan('#'    :Address.words(x)) <> *zero   or
               %scan(' RT'  :Address.words(x)) <> *zero);
               Suite = *on;
           endif;

           if Suite;
              d_ExtSuiteAddr.Suite   = %trim(d_ExtSuiteAddr.Suite) +
                                       ' ' + Address.words(x);
           else;
              d_ExtSuiteAddr.Address = %trim(d_ExtSuiteAddr.Address) +
                                       ' ' + Address.words(x);
           endif;
       endfor;

       dealloc pAddress;

       // -------------------------------------------------------
       // Remove trailing comma.

       d_ExtSuiteAddr.Address =
       RplString(d_ExtSuiteAddr.Address:',':'');

       // -------------------------------------------------------
       // Trim leading blanks.

       d_ExtSuiteAddr.Suite   = %triml(d_ExtSuiteAddr.Suite);
       d_ExtSuiteAddr.Address = %triml(d_ExtSuiteAddr.Address);

       return d_ExtSuiteAddr;

      /End-Free
      *
     P ExtSuiteAddr    E
