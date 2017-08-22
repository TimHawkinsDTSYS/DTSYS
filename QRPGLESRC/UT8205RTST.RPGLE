      /TITLE Utility, Internet Weather test
      *PARMS
      *
      /copy qcpysrc,Hspec
      *
     Fagymap01  if   e             disk
     Fagywtl01  if a e           k disk    rename(agywt01r:agywt01l)
      *
      /copy qcpysrc,Dspec
      /copy qcpysrc,UT8205S
      *
     D d_RtvCurWth     ds                  likeds(t_RtvCurwth) inz

      * ---------------------------------------------------------
      /Free

       read agyma01r;
       dow not %eof;
         %subst(AMpscd:6) = *blanks;
         setll (AMpscd) agywt01l;

         if AMpscd     <> *blanks   and
            not           %equal;
            d_RtvCurWth = RtvCurWth(AMpscd);
            WTagyn      = AMagyn;
            WTpscd      = AMpscd;
            WTupddte    = d_RtvCurWth.LstUpdDte;
            WTupdtim    = d_RtvCurWth.LstUpdTim;
            WTupdzon    = d_RtvCurWth.LstUpdZon;
            WTobscty    = d_RtvCurWth.ObsCity;
            WTobsstcd   = d_RtvCurWth.ObsStcd;
            WTtemp      = d_RtvCurWth.Temperature;
            WTfeels     = d_RtvCurWth.FeelsLike;
            WTcond      = d_RtvCurWth.Conditions;
            WTprsbar    = d_RtvCurWth.PressureBar;
            WTprsdes    = d_RtvCurWth.PressureDesc;
            WTwndspd    = d_RtvCurWth.WindSpeed;
            WTwndgus    = d_RtvCurWth.WindGust;
            WTwnddir    = d_RtvCurWth.WindDir;
            WTwndcmp    = d_RtvCurWth.WindCompass;
            WThumid     = d_RtvCurWth.Humidity;
            WTvis       = d_RtvCurWth.Visability;
            WTuvnum     = d_RtvCurWth.UVnumber;
            WTuvdesc    = d_RtvCurWth.UVdesc;
            WTdewpnt    = d_RtvCurWth.Dewpoint;
            WTmoon      = d_RtvCurWth.MoonDesc;

            WTxmlerr    = d_RtvCurWth.XMLerr;
            WTxmlpth    = d_RtvCurWth.XMLpth;
            WTxmlnam    = d_RtvCurWth.XMLnam;
            WTxmlval    = d_RtvCurWth.XMLval;
            write agywt01l;
         endif;

         if d_RtvCurWth.XMLerr;
            leave;
         endif;

         read agyma01r;
       enddo;

       *inLR = *on;

      /end-Free
