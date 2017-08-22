      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  User prototypes
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      * RtvUsrNam() - Retrieve users name.

     D RtvUsrNam       PR                  like(StdStg)
     D  UserID                             like(StdNam)  const
     D                                     options(*omit:*nopass)
      * ---------------------------------------------------------
      * RtvUsrEmlAdr() - Retrieve users email address.

     D RtvUsrEmlAdr    PR                  like(StdStg)
     D  UserID                             like(StdNam)  const
     D                                     options(*omit:*nopass)
      * ---------------------------------------------------------
      * RtvAdmNam() - Retrieve administrators name.

     D RtvAdmNam       PR                  like(StdStg)
      * ---------------------------------------------------------
      * RtvAdmUsrID() - Retrieve administrators UserID.

     D RtvAdmUsrID     PR                  like(StdNam)
      * ---------------------------------------------------------
      * RtvUsrCls() - Retrieve user class.

     D RtvUsrCls       PR                  like(StdNam)
     D  UserID                             like(StdNam)  const
     D                                     options(*omit:*nopass)
      * ---------------------------------------------------------
      * RtvAdmEmlAdr() - Retrieve administrators email address.

     D RtvAdmEmlAdr    PR                  like(StdStg)
      * ---------------------------------------------------------
      * RtvUsrEmlName() -- Retrieve users email name.

     D RtvUsrEmlName   PR                  like(StdStr)
     D  UserID                             like(StdNam)  const
      * ---------------------------------------------------------
      * RtvUsrEmlAddr() -- Retrieve users email address.

     D RtvUsrEmlAddr   PR                  like(StdStr)
     D  UserID                             like(StdNam)  const
