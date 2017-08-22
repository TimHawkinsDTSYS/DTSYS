      /TITLE Utility, Debug (SrvPgm)
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Provides error routines via function calls
      *              for handling C and UNIX error codes.
      *
      *  Notes   :  Copied from Scott Klement (c) 2001
      *              at klement.dstorm.net/rpg/socktut/tutorial.html
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
      * **********************************************************
      * GetDebug() -- Get debug environment setting.
      * **********************************************************
     P GetDebug        B                   Export
      *
     D GetDebug        PI                  like(StdInd)
      *
     C                   return    GetEnvVarInd('DEBUG_ENVIRONMENT')
      *
     P GetDebug        E
      * **********************************************************
      * SetDebug() -- Set debug environment.
      * **********************************************************
     P SetDebug        B                   Export
      *
     D SetDebug        PI
     D  Debug                              like(StdInd) const
      *
     C                   callp     PutEnvVar('DEBUG_ENVIRONMENT=' +
     C                                        Debug)
      *
     C                   return
      *
     P SetDebug        E
