      /TITLE Utility, Environment (SrvPgm)
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Provides date routines via function calls
      *              for converting dates from one format to another,
      *              adding dates, determining days between dates, etc.
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
      /define DSpgm
      /copy qcpysrc,Dspec
      ***********************************************************
      * RtvCurEnv() - Retrieve current environment.
      ***********************************************************
     P RtvCurEnv       B                   Export
      *
     Fctlell01  if   e           k disk    rename(ctlel01r:ctlel01l)
     F                                     infds(DSdbf) static
      *
     D RtvCurEnv       PI                  like(StdNam)
      *
     D DSdbf         e ds                  extname(DSdbf) static
     D DSctlel         ds                  likerec(ctlel01l:*input) inz
     D                                     static
      /free
       // -------------------------------------------------------
       // Return environment name.

       if DSctlel.ELenvnam = *blanks;
          chain (Z1flb) ctlel01l DSctlel;
       endif;

       if DSctlel.ELenvnam = *blanks;
          joblog('Data library %s not found +
                  in environment control record.':Z1flb);
       endif;

       return DSctlel.ELenvnam;

      /end-free
     P RtvCurEnv       E
      **********************************************************
      * RtvDtaLib() - Retrieve data library.
      **********************************************************
     P RtvDtaLib       B                   Export
      *
     Fctlelp01  if   e           k disk    static
      *
     D RtvDtaLib       PI                  like(StdNam)
     D  EnvNam_p                           like(StdNam) const
     D                                     options(*omit:*nopass)
      *
     D DSctlel         ds                  likerec(ctlel01r:*input) inz
     D                                     static
      *
     D EnvNam          s                   like(StdNam) inz
      /free
       // -------------------------------------------------------
       // Extract incomming parms.

       if %parms >= 1;
         CEETSTA(ParmPassed:1:*omit);
         if ParmPassed = 1;
            EnvNam = EnvNam_p;
         endif;
       endif;

       if EnvNam = *blanks;
          EnvNam = RtvCurEnv();
       endif;

       // -------------------------------------------------------
       // Return library name.

       if EnvNam <> DSctlel.ELenvnam or
          DSctlel.ELdtalib = *blanks;
          chain (EnvNam) ctlel01r DSctlel;
       endif;

       if DSctlel.ELdtalib = *blanks;
          joblog('Environment %s not found.':EnvNam);
       endif;

       return DSctlel.ELdtalib;

      /end-free
     P RtvDtaLib       E
      **********************************************************
      * RtvEnvTyp() - Retrieve environment type.
      **********************************************************
     P RtvEnvTyp       B                   Export
      *
     Fctlell01  if   e           k disk    rename(ctlel01r:ctlel01l)
     F                                     infds(DSdbf) static
      *
     D RtvEnvtyp       PI             3
      *
     D DSdbf         e ds                  extname(DSdbf) static
     D DSctlel         ds                  likerec(ctlel01l:*input) inz
     D                                     static
      /free
       // -------------------------------------------------------
       // Return environment name.

       if DSctlel.ELenvnam = *blanks;
          chain (Z1flb) ctlel01l DSctlel;
       endif;

       if DSctlel.ELenvnam = *blanks;
          joblog('Data library %s not found +
                  in environment control record.':Z1flb);
       endif;

       return DSctlel.ELenvtyp;

      /end-free
     P RtvEnvTyp       E
