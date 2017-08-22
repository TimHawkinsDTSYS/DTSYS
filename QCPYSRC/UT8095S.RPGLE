      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Copy: Environment prototypes
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *
     D CurDtaLib       s                   like(StdNam) inz
      *---------------------------------------------------------
      * RtvCurEnv() - Retrieve current environment.
      *
     D RtvCurEnv       PR                  like(StdNam)
      *---------------------------------------------------------
      * RtvEnvTyp() - Retrieve environment type.
      *
     D RtvEnvtyp       PR             3
      *---------------------------------------------------------
      * RtvDtaLib() - Retrieve data library.
      *
     D RtvDtaLib       PR                  like(StdNam)
     D  EnvNam                             like(StdNam) const
     D                                     options(*omit:*nopass)
