      /TITLE Utility, Environment variables (SrvPgm)
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
      * GetEnvVar() -- Get environment variable.
      ***********************************************************
     P GetEnvVar       B                   Export
      *
     D GetEnvVar       PI         32767    varying
     D  EnvVarNam                    64    varying const
     D                                     options(*trim:*varsize)
      *
     D  RtnVar         s          32767    varying inz
      * ---------------------------------------------------------
      *
      *    Test for no input.
      *
š1b€ C                   if        EnvVarNam = *blanks
     C                   return    *blanks
š1e€ C                   endif
      * ---------------------------------------------------------
      *
      *    Get environment variable.
      *
     C                   eval      pEnvVar = getenv(%trim(EnvVarNam))
      *
     C                   if        pEnvVar <> *null
     C                   eval      RtnVar   = %str(pEnvVar)
     C                   else
     C                   eval      RtnVar   = *blanks
     C                   endif
      *
     C                   return    RtnVar
      *
     P GetEnvVar       E
      ***********************************************************
      * GetEnvVarInd() -- Get environment variable as indcator.
      ***********************************************************
     P GetEnvVarInd    B                   Export
      *
     D GetEnvVarInd    PI                  like(StdInd)
     D  EnvVarNam                    64    varying const
     D                                     options(*trim:*varsize)
      *
     D  RtnInd         s                   like(StdInd) inz
      * ---------------------------------------------------------
      *
      *    Test for no input.
      *
š1b€ C                   if        EnvVarNam = *blanks
     C                   return    *off
š1e€ C                   endif
      * ---------------------------------------------------------
      *
      *    Get environment variable.
      *
     C                   eval      pEnvVar = getenv(%trim(EnvVarNam))
      *
     C                   if        pEnvVar <> *null
     C                   eval      RtnInd   = %str(pEnvVar)
     C                   else
     C                   eval      RtnInd   = *off
     C                   endif
      *
     C                   return    RtnInd
      *
     P GetEnvVarInd    E
      ***********************************************************
      * DltEnvVar() -- Delete environment variable.
      ***********************************************************
     P DltEnvVar       B                   Export
      *
     D DltEnvVar       PI
     D  EnvVarNam                    64    varying const
     D                                     options(*trim:*varsize)
      *
     D DltEnvVarAPI    PR                  extproc('Qp0zDltEnv')
     D                                     like(StdInt)
     D  i_envVar                           like(StdPtr) value
     D                                     options(*trim:*string)
      *
     D  RtnVar         s                   like(StdInt) inz
      * ---------------------------------------------------------
      *
      *    Test for no input.
      *
š1b€ C                   if        EnvVarNam = *blanks
     C                   return
š1e€ C                   endif
      * ---------------------------------------------------------
      *
      *    Delete environment variable.
      *    -- ignore the return variable.
      *
     C                   eval      RtnVar =
     C                             DltEnvVarAPI(%trim(EnvVarNam))
      *
     C                   return
      *
     P DltEnvVar       E
      * **********************************************************
      * IncEnvVar() -- Increment environment variable.
      * **********************************************************
     P IncEnvVar       B                   Export
      *
     D IncEnvVar       PI                  like(StdInt)
     D  EnvVarNam                    64    varying const
      *
     D  RtnCnt         s                   like(StdInt) inz
      /free
       // -------------------------------------------------------
       // Test for no input.

       if EnvVarNam = *blanks;
          joblog('Environment variable not specified to IncEnvVar');
          return *zero;
       endif;
       // -------------------------------------------------------
       // Get environment variable, add if not set.

       pEnvVar = getenv(%trim(EnvVarNam));

       if pEnvVar = *null;
          PutEnvVar(%trim(EnvVarNam) + '=1');
          return 1;
       endif;
       // -------------------------------------------------------
       // Increment environment variable & store.

       RtnCnt = num(%str(pEnvVar)) + 1;

       PutEnvVar(%trim(EnvVarNam) + '=' + %char(RtnCnt));

       return RtnCnt;

      /end-free
     P IncEnvVar       E
