      /TITLE Utility, Currency (SrvPgm)
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
      /define Hspec_DATETIME
      /copy qcpysrc,HspecSrv
      *
      /define DSpgm
      /copy qcpysrc,Dspec
      * *********************************************************
      * RtvCurRte() -- Retrieve currency rate
      * *********************************************************
     P RtvCurRte       b                   export
      *
     Fctlcul01  if   e           k disk    rename(ctlcu01r:ctlcu01l)
     F                                     static
      *
     D RtvCurRte       pi                  like(StdCurRte)
     D  i_FromCurCde                       like(StdCurCde) const
     D  i_ToCurCde                         like(StdCurCde) const
     D  i_Timestamp                        like(StdTms)    const
     D                                     options(*nopass)
      *
     D ctlcu           ds                  likerec(ctlcu01l) inz

     D w_Timestamp     s                   like(StdTms) inz

      /free

       // --------------------------------------------------------
       // Escape if from/to currencies are the same.

š1b€   if i_FromCurCde = i_ToCurCde;
          return 1;
š1e€   endif;

       // --------------------------------------------------------
       // Default date if not provided.

š1b€   if %parms      = *zero     or
š1b€      i_Timestamp = NullTSP;
          w_Timestamp = TimeStamp();
š1e€   else;
          w_Timestamp = i_TimeStamp;
š1e€   endif;

       // --------------------------------------------------------
       // Retrieve from/to currency.

       setgt  (i_FromCurCde:i_ToCurCde:w_Timestamp) ctlcu01l;
       readpe (i_FromCurCde:i_ToCurCde)             ctlcu01l ctlcu;

       if not %eof                          and
          ctlcu.CUcurrte <> *zero           and
          ctlcu.CUvldfz  <= w_Timestamp     and
          ctlcu.CUvldtz  >= w_Timestamp;
       else;
          ctlcu.CUcurrte = *zero;
       endif;

       // --------------------------------------------------------
       // Retrieve to/from currency.

       if ctlcu.CUcurrte = *zero;
          setgt  (i_ToCurCde:i_FromCurCde:w_Timestamp) ctlcu01l;
          readpe (i_ToCurCde:i_FromCurCde)             ctlcu01l ctlcu;

          if not %eof                          and
             ctlcu.CUcurrte <> *zero           and
             ctlcu.CUvldfz  <= w_Timestamp     and
             ctlcu.CUvldtz  >= w_Timestamp;

             ctlcu.CUcurrte = 1 / ctlcu.CUcurrte;
          else;
            ctlcu.CUcurrte = *zero;
          endif;
       endif;

       // --------------------------------------------------------
       // Currency not found.

       if ctlcu.CUcurrte = *zero;
          msgid  = 'GNL0189';
          msgdta = i_FromCurCde + i_ToCurCde +
                   EdtMDYfromISO(CvtTSPtoISO(w_timestamp)) +
                   EdtHMSfromHMS(CvtTSPtoHMS(w_timestamp));
          torel  = '*PRV';
          exsr $PMsnd;
š1e€   endif;

       // --------------------------------------------------------
       // Currency still not found, default to 1.0

       if ctlcu.CUcurrte = *zero;
          ctlcu.CUcurrte = 1;
š1e€   endif;


       return ctlcu.CUcurrte;

      /end-free

      /COPY QCPYSRC,$PMSND
      /COPY QCPYSRC,$PSSR

     P RtvCurRte       e
