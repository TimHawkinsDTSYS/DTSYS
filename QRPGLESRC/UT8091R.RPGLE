      /TITLE Utility, Application Control (SrvPgm)
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
      /copy qcpysrc,UT8072S
      * *********************************************************
      * SltCtlma() - Select application control
      * *********************************************************
     P SltCtlma        B                   Export

     D SltCtlma        PI                  likeDS(d_ctlma)
     D  appcat                             like(CMappcat)  const
     D  appsub                             like(CMappsub)  const
     D  appcd1                             like(CMappcd1)  const
     D                                     options(*omit:*nopass)
     D  appcd2                             like(CMappcd2)  const
     D                                     options(*omit:*nopass)

     D CT3108R         PR                  extpgm('CT3108R')
     D  appcat                             like(CMappcat)
     D  appsub                             like(CMappsub)
     D  appcd1                             like(CMappcd1)
     D  appcd2                             like(CMappcd2)
     D  RtnCtlma                           likeds(d_ctlma)

     D SSappcat        s                   like(CMappcat) inz
     D SSappsub        s                   like(CMappsub) inz
     D SSappcd1        s                   like(CMappcd1) inz
     D SSappcd2        s                   like(CMappcd2) inz
      /free
       // -------------------------------------------------------
       // Check for omitted parameters.

       SSappcat   = appcat;
       SSappsub   = appsub;

š1b€   if %parms        >= 3;
          CEETSTA(ParmPassed:3:*omit);
š2b€      if ParmPassed  = 1;
             SSappcd1    = appcd1;
š2e€      endif;
š1e€   endif;

š1b€   if %parms        >= 4;
          CEETSTA(ParmPassed:4:*omit);
š2b€      if ParmPassed  = 1;
             SSappcd2    = appcd2;
š2e€      endif;
š1e€   endif;

       // -------------------------------------------------------
       // Show select panel.

       CT3108R(SSappcat:SSappsub:SSappcd1:SSappcd2:d_ctlma);

š1b€   return d_ctlma;

      /end-free
     P SltCtlma        E
      * *********************************************************
      * ChkCtlma() - Check application control
      * *********************************************************
     P ChkCtlma        B                   Export

     Fctlmap01  if   e           k disk    static

     D ChkCtlma        PI                  like(StdInd)
     D  appcat                             like(CMappcat)  const
     D  appsub                             like(CMappsub)  const
     D  appcd1                             like(CMappcd1)  const
     D                                     options(*omit:*nopass)
     D  appcd2                             like(CMappcd2)  const
     D                                     options(*omit:*nopass)

     D I_ctlma         ds                  likerec(ctlma01r:*input) inz

     D KeysPassed      s                   like(StdInt) inz(2)
     D KYappcat        s                   like(I_ctlma.CMappcat) inz
     D KYappsub        s                   like(I_ctlma.CMappsub) inz
     D KYappcd1        s                   like(I_ctlma.CMappcd1) inz
     D KYappcd2        s                   like(I_ctlma.CMappcd2) inz
      /free
       // -------------------------------------------------------
       // Check for omitted parameters.

       KYappcat   = appcat;
       KYappsub   = appsub;

š1b€   if %parms       >= 3;
          CEETSTA(ParmPassed:3:*omit);
š2b€      if ParmPassed = 1;
             KYappcd1   = appcd1;
             KeysPassed += 1;
š2e€      endif;
š1e€   endif;

š1b€   if %parms       >= 4;
          CEETSTA(ParmPassed:4:*omit);
š2b€      if ParmPassed = 1;
             KYappcd2   = appcd2;
             KeysPassed += 1;
š2e€      endif;
š1e€   endif;

       // -------------------------------------------------------
       // Retrieve record based on keys passed.

š1b€   select;
š1b€   when KeysPassed = 2;
            setll (KYappcat:KYappsub) ctlma01r;
š1b€   when KeysPassed = 3;
            setll (KYappcat:KYappsub:KYappcd1) ctlma01r;
š1b€   when KeysPassed = 4;
            setll (KYappcat:KYappsub:KYappcd1:KYappcd2) ctlma01r;
       endsl;

       return %equal;

      /end-free
     P ChkCtlma        E
      * *********************************************************
      * RtvCtlmaDta() - Retrieve application control
      * *********************************************************
     P RtvCtlmaDta     B                   Export

     Fctlmap01  if   e           k disk    static

     D RtvCtlmaDta     PI                  like(StdStr)
     D  appcat                             like(CMappcat)  const
     D  appsub                             like(CMappsub)  const
     D  appcd1                             like(CMappcd1)  const
     D                                     options(*omit:*nopass)
     D  appcd2                             like(CMappcd2)  const
     D                                     options(*omit:*nopass)

     D I_ctlma         ds                  likerec(ctlma01r:*input) inz

     D KeysPassed      s                   like(StdInt) inz(2)
     D KYappcat        s                   like(I_ctlma.CMappcat) inz
     D KYappsub        s                   like(I_ctlma.CMappsub) inz
     D KYappcd1        s                   like(I_ctlma.CMappcd1) inz
     D KYappcd2        s                   like(I_ctlma.CMappcd2) inz
      /free
       // -------------------------------------------------------
       // Check for omitted parameters.

       KYappcat   = appcat;
       KYappsub   = appsub;

š1b€   if %parms       >= 3;
          CEETSTA(ParmPassed:3:*omit);
š2b€      if ParmPassed = 1;
             KYappcd1   = appcd1;
             KeysPassed += 1;
š2e€      endif;
š1e€   endif;

š1b€   if %parms       >= 4;
          CEETSTA(ParmPassed:4:*omit);
š2b€      if ParmPassed = 1;
             KYappcd2   = appcd2;
             KeysPassed += 1;
š2e€      endif;
š1e€   endif;

       // -------------------------------------------------------
       // Retrieve record based on keys passed.

š1b€   select;
š1b€   when KeysPassed = 2;
            chain (KYappcat:KYappsub) ctlma01r I_ctlma;
š1b€   when KeysPassed = 3;
            chain (KYappcat:KYappsub:KYappcd1) ctlma01r I_ctlma;
š1b€   when KeysPassed = 4;
            chain (KYappcat:KYappsub:KYappcd1:KYappcd2) ctlma01r I_ctlma;
       endsl;

       if not %found;
          return *blanks;
       endif;

       // -------------------------------------------------------
       // Decrypt it if required.

       I_ctlma = DcrCtlma(I_ctlma);

       // -----------------------------------------------------
       // Replace special values.

       if %scan('%':i_ctlma.CMappdta) <> *zero;
          i_ctlma.CMappdta =
            RplString(i_ctlma.CMappdta:'%envnam%':RtvCurEnv());
          i_ctlma.CMappdta =
            RplString(i_ctlma.CMappdta:'%dtalib%':RtvDtaLib());
       endif;

       return I_ctlma.CMappdta;

      /end-free
     P RtvCtlmaDta     E
      * *********************************************************
      * RtvCtlmaRcd() - Retrieve application control
      * *********************************************************
     P RtvCtlmaRcd     B                   Export

     Fctlmap01  if   e           k disk    static

     D RtvCtlmaRcd     PI                  like(d_ctlma)
     D  appcat                             like(CMappcat)  const
     D  appsub                             like(CMappsub)  const
     D  appcd1                             like(CMappcd1)  const
     D                                     options(*omit:*nopass)
     D  appcd2                             like(CMappcd2)  const
     D                                     options(*omit:*nopass)

     D I_ctlma         ds                  likerec(ctlma01r:*input) inz

     D KeysPassed      s                   like(StdInt) inz(2)
     D KYappcat        s                   like(I_ctlma.CMappcat) inz
     D KYappsub        s                   like(I_ctlma.CMappsub) inz
     D KYappcd1        s                   like(I_ctlma.CMappcd1) inz
     D KYappcd2        s                   like(I_ctlma.CMappcd2) inz
      /free
       // -------------------------------------------------------
       // Check for omitted parameters.

       KYappcat   = appcat;
       KYappsub   = appsub;

š1b€   if %parms       >= 3;
          CEETSTA(ParmPassed:3:*omit);
š2b€      if ParmPassed = 1;
             KYappcd1   = appcd1;
             KeysPassed += 1;
š2e€      endif;
š1e€   endif;

š1b€   if %parms       >= 4;
          CEETSTA(ParmPassed:4:*omit);
š2b€      if ParmPassed = 1;
             KYappcd2   = appcd2;
             KeysPassed += 1;
š2e€      endif;
š1e€   endif;

       // -------------------------------------------------------
       // Retrieve record based on keys passed.

š1b€   select;
š1b€   when KeysPassed = 2;
            chain (KYappcat:KYappsub) ctlma01r I_ctlma;
š1b€   when KeysPassed = 3;
            chain (KYappcat:KYappsub:KYappcd1) ctlma01r I_ctlma;
š1b€   when KeysPassed = 4;
            chain (KYappcat:KYappsub:KYappcd1:KYappcd2) ctlma01r I_ctlma;
       endsl;

       if not %found;
          return *blanks;
       endif;

       // -------------------------------------------------------
       // Decrypt it if required.

       I_ctlma = DcrCtlma(I_ctlma);

       // -----------------------------------------------------
       // Replace special values.

       if %scan('%':i_ctlma.CMappdta) <> *zero;
          i_ctlma.CMappdta =
            RplString(i_ctlma.CMappdta:'%envnam%':RtvCurEnv());
          i_ctlma.CMappdta =
            RplString(i_ctlma.CMappdta:'%dtalib%':RtvDtaLib());
       endif;

       return I_ctlma;

      /end-free
     P RtvCtlmaRcd     E
      * *********************************************************
      * DcrCtlma() -- Decrypt application control data
      * *********************************************************
     P DcrCtlma        B                   Export

     Fctlmdp01  if   e           k disk    static

     D DcrCtlma        PI                  likeDS(d_Ctlma)
     D  p_Ctlma                            likeDS(d_Ctlma)  const

     D DSctlmd         ds                  likerec(ctlmd01r:*input) inz
     D KYappcat        s                   like(CMappcat)           inz
     D KYappsub        s                   like(CMappsub)           inz
      /free

       d_ctlma = p_Ctlma;

       // -------------------------------------------------------
       // If unencrypted, return it.

       if CMencval <> 'Y';
          return d_ctlma;
       endif;

       // -------------------------------------------------------
       // Retrieve the encryption key.

       KYappcat = CMappcat;
       KYappsub = CMappsub;
       chain (KYappcat:KYappsub) ctlmd01r DSctlmd;
       if DSctlmd.MDenckey = *blanks;
          return d_ctlma;
       endif;

       // -------------------------------------------------------
       // Decrypt.

       CMappdta = Decrypt(DSctlmd.MDenckey:
                          CMappdta:
                          %len(CMappdta):
                          dsEC);

       return d_ctlma;

      /end-free
     P DcrCtlma        E
      * *********************************************************
      * UpdCtlma() - Update application control
      * *********************************************************
     P UpdCtlma        B                   Export

     Fctlmdp01  if   e           k disk    static
     Fctlmap01  uf a e           k disk    static

     D UpdCtlma        PI
     D  AppCat                             like(CMappcat)  const
     D  AppSub                             like(CMappsub)  const
     D  AppCd1                             like(CMappcd1)  const
     D                                     options(*omit)
     D  AppCd2                             like(CMappcd2)  const
     D                                     options(*omit)
     D  AppDta                             like(CMappdta)  const

     D DSctlmd         ds                  likerec(ctlmd01r:*input)  inz
     D I_ctlma         ds                  likerec(ctlma01r:*input)  inz
     D O_ctlma         ds                  likerec(ctlma01r:*output) inz

     D KeysPassed      s                   like(StdInt) inz
     D KYappcat        s                   like(I_ctlma.CMappcat) inz
     D KYappsub        s                   like(I_ctlma.CMappsub) inz
     D KYappcd1        s                   like(I_ctlma.CMappcd1) inz
     D KYappcd2        s                   like(I_ctlma.CMappcd2) inz
      /free
       // -------------------------------------------------------
       // Check for omitted parameters.

       KYappcat   = appcat;
       KYappsub   = appsub;
       KeysPassed = 2;

š1b€   if %parms       >= 3;
          CEETSTA(ParmPassed:3:*omit);
š2b€      if ParmPassed = 1;
             KYappcd1   = appcd1;
             KeysPassed += 1;
š2e€      endif;
š1e€   endif;

š1b€   if %parms       >= 4;
          CEETSTA(ParmPassed:4:*omit);
š2b€      if ParmPassed = 1;
             KYappcd2   = appcd2;
             KeysPassed += 1;
š2e€      endif;
š1e€   endif;

       // -------------------------------------------------------
       // Retrieve record based on keys passed.

š1b€   select;
š1b€   when KeysPassed = 2;
            chain (KYappcat:KYappsub) ctlma01r I_ctlma;
            i_ctlma.CMappcat = KYappcat;
            i_ctlma.CMappsub = KYappsub;
š1b€   when KeysPassed = 3;
            chain (KYappcat:KYappsub:KYappcd1) ctlma01r I_ctlma;
            i_ctlma.CMappcat = KYappcat;
            i_ctlma.CMappsub = KYappsub;
            i_ctlma.CMappcd1 = KYappcd1;
š1b€   when KeysPassed = 4;
            chain (KYappcat:KYappsub:KYappcd1:KYappcd2) ctlma01r I_ctlma;
            i_ctlma.CMappcat = KYappcat;
            i_ctlma.CMappsub = KYappsub;
            i_ctlma.CMappcd1 = KYappcd1;
            i_ctlma.CMappcd2 = KYappcd2;
       endsl;

       // -------------------------------------------------------
       // Set DB fields.

       o_ctlma          = i_ctlma;
       o_ctlma.CMappdta = AppDta;
       O_ctlma.CMencval = *blanks;

        // -------------------------------------------------------
        // Retrieve the definition for it's ID & encryption key.

        chain (KYappcat:KYappsub) ctlmd01r DSctlmd;
        if %found;
        // O_ctlma.CMctlmdid = DSctlmd.MDctlndid;
        else;
           clear DSctlmd;
        endif;

        // -------------------------------------------------------
        // Encrypt (if required).

        if DSctlmd.MDenckey <> *blanks;
            O_ctlma = EncCtlma(o_ctlma);
        endif;

       // -------------------------------------------------------
       // Write/Update.

       if not %found(ctlmap01);
          O_ctlma.CMctlmaid = RtvRecID('CTLMAP01');
š1b€      write(e)  ctlma01r O_ctlma;
š1b€   else;
š1b€      update(e) ctlma01r O_ctlma;
       endif;

       // -------------------------------------------------------
       // Errors.

       if %error;
š1b€      joblog('UT8091R UpdCtlma: Unable to write/update +
š1b€              record to Ctlma');
š1b€      dump(a);
       endif;

       return;

      /end-free
     P UpdCtlma        E
      * *********************************************************
      * EncCtlma () -- Encrypt application control data
      * *********************************************************
     P EncCtlma        B                   Export

     Fctlmdp01  if   e           k disk    static

     D EncCtlma        PI                  likeDS(d_Ctlma )
     D  p_Ctlma                            likeDS(d_Ctlma )  const

     D DSctlmd         ds                  likerec(ctlmd01r:*input) inz
     D KYappcat        s                   like(CMappcat)   inz
     D KYappsub        s                   like(CMappsub)   inz
      /free

       d_ctlma  = p_Ctlma;

       // -------------------------------------------------------
       // Retrieve the encryption key.

       KYappcat = CMappcat;
       KYappsub = CMappsub;
       chain (KYappcat:KYappsub) ctlmd01r DSctlmd;
       if DSctlmd.MDenckey = *blanks;
                  CMencval = *blanks;
          return d_ctlma;
       endif;

       // -------------------------------------------------------
       // Encrypt.

       CMappdta = Encrypt(DSctlmd.MDenckey:
                          CMappdta:
                          %len(CMappdta):
                          dsEC);
       CMencval = 'Y';

       return d_ctlma;

      /end-free
     P EncCtlma        E
