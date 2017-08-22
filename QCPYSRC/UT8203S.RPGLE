      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      *  Email Address prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      * ---------------------------------------------------------
      *
      *  ChkEml() -- Check email address
      *
     D ChkEml          PR                  like(d_ChkEml)
     D  EmailAddress                       like(StdEml) value
      *
     D d_ChkEml        ds
     D  ChkEml_msgid                       like(msgid)
     D  ChkEml_msgdta                      like(msgdta)
      * ---------------------------------------------------------
      *  ValEml() -- Validate email address.
      *
     D ValEml          PR                  like(StdInd)
     D  p_EmlAdr                           like(StdEml) const
     D  p_ErrInfo                          likeDS(dsErrInfo)
     D                                     options(*nopass)
      * ---------------------------------------------------------
      *  ParseEmailAddr() -- Parse email address.
      *
     D ParseEmailAddr  PR                  like(StdInd)
     D  p_input                            like(StdStg) const
     D  p_name                             like(StdStg)
     D                                     options(*omit:*nopass)
     D  p_local                            like(StdStg)
     D                                     options(*omit:*nopass)
     D  p_domain                           like(StdStg)
     D                                     options(*omit:*nopass)
      * ---------------------------------------------------------
      *  Gethost() -- lookup domain name.
      *
     D GetHost         PR                  like(StdInd)
     D   domain                     512A   const varying
     D   addr                              like(StdUns)
      *
      *  GetMX() -- Get mail exchange record.
      *
     D GetMX           PR                  like(StdInt)
     D   domain                     512A   const varying
     D   max_entries                       like(StdInt) value
     D   mxhost                     256A   dim(50) options(*varsize)
     D   mxpty                             dim(50) options(*varsize)
     D                                     like(StdUnsSml)
      *
      *  GetInt16() -- Get short int from DNS record.
      *
     D GetInt16        PR                  like(StdUnsSml)
     D    ptr                              like(StdPtr)
      *
      *  GetInt32() -- Get int from DNS record.
      *
     D GetInt32        PR                  like(StdUns)
     D    ptr                              like(StdPtr)
