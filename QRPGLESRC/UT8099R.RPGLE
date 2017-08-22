      /TITLE Utility, Translate (SrvPgm)
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Provides translate routines via function calls.
      *
      *  Notes   :  none.
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  09/10/02  TimH        New program.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /copy qcpysrc,HspecSrv
      *
      /define DSpgm
      /copy qcpysrc,Dspec
      * *********************************************************
      * TranslateCCSID() - Translate CCSID.
      * -- Note: input string is translated in place.
      * --
      * -- Common CCSID's are defined as named constants:
      *    CCSID_UTF8  = 1208
      *    CCSID_8859  = 819
      *    CCSID_ASCII = 37
      * *********************************************************
     P TranslateCCSID  B                   Export
      *
     D TranslateCCSID  pi
     D  p_Dta                              like(StdPtr)
     D  p_DtaLen                           like(StdInt) const
     D  p_fromCCSID                        like(StdInt) const
     D  p_toCCSID                          like(StdInt) const
     D  p_Options                          like(StdStr) const
     D                                     options(*omit:*nopass)

     D QtqIConvOpen    pr                  ExtProc('QtqIconvOpen')
     D                                     likeDS(t_iconv)
     D  d_toCCSID                          likeDS(t_QtqCode)
     D  d_fromCCSID                        likeDS(t_QtqCode)
     D iconv           PR                  ExtProc('iconv')
     D                                     like(StdUns)
     D  d_hconv                            likeDS(t_iconv) value
     D  pInBuff                            like(StdPtr)    value
     D  nInLen                             like(StdPtr)    value
     D  pOutBuff                           like(StdPtr)    value
     D  nOutLen                            like(StdPtr)    value

     D iconv_close     PR                  ExtProc('iconv_close')
     D                                     like(StdInt)
     D  d_hConv                            likeDS(t_iconv) value

     D t_QtqCode       ds                  qualified template
     D  CCSID                              like(StdInt) inz
     D  CvtAlt                             like(StdInt) inz
     D  SubAlt                             like(StdInt) inz
     D  ShiftState                         like(StdInt) inz(1)
     D  InLenOpt                           like(StdInt) inz
     D  MixDataErrorOpt...
     D                                     like(StdInt) inz
     D  Reserved                      8A   inz(*allX'00')

     D t_iconv         ds                  qualified template
     D  rtn_value                          like(StdInt) inz
     D  cd                                 like(StdInt) inz dim(12)

     D d_fromCCSID     ds                  likeDS(t_QtqCode) inz(*likeDS)
     D d_toCCSID       ds                  likeDS(t_QtqCode) inz(*likeDS)
     D d_hconv         ds                  likeDS(t_iconv)   inz(*likeDS)

     D ppDta           s                   like(StdPtr) inz
     D nInpLen         s                   like(StdInt) inz
     D nOutLen         s                   like(StdInt) inz
     D i_Options       s                   like(StdStr) inz
      /free
       // -------------------------------------------------------
       // Set input parameter values to DS.

       d_fromCCSID.CCSID = p_fromCCSID;
       d_toCCSID.CCSID   = p_toCCSID;

       // -------------------------------------------------------
       // Check for omitted parameters.

       if %parms       >= 5;
          CEETSTA(ParmPassed:5:*omit);
          if ParmPassed = 1;
             i_Options  = upper(p_Options);
          endif;
       endif;

       // -------------------------------------------------------
       // Open the conversion environment.

       d_hConv = *allX'00';
       d_hConv = QtqIconvOpen(d_toCCSID:d_fromCCSID);

       // -------------------------------------------------------
       // Convert the data.

       nInpLen = p_DtaLen;
       nOutLen = p_DtaLen;
       ppDta   = %addr(p_Dta);
       iconv(d_hConv : ppDta : %addr(nInpLen): ppDta : %addr(nOutLen));

       // -------------------------------------------------------
       // Close the conversion environment.

       iconv_close(d_hConv);
       d_hConv = *allX'00';

       return;

      /end-free
     P TranslateCCSID  E
