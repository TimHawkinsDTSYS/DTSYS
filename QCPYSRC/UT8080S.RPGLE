      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * System Directory prototypes
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      * RtvSmtpAddr() -- Retrieve SMTP Address.
      *
     D RtvSmtpAddr     pr           321a
     D  PxUser                             like(StdNam) const
     D  PxAddr                             like(StdFmt) const
     D                                     options(*nopass)
      *
      * RtvSysDirUsr() -- Retrieve System Directory user
      *
     D RtvSysDirUsr    pr                  like(RtvSysDirUsr_DS)
     D  PxUser                             like(StdNam) const
      *
     D RtvSysDirUsr_DS...
     D                 ds                  qualified
     D  RvUsrID                            like(StdFmt)
     D  RvSysAdr                           like(StdFmt)
