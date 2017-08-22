      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Application Control prototypes
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     D t_ctlma       e ds                  extname(ctlmap01)
     D                                     template prefix(t_)
      *
      /if not defined(d_ctlma)
     D d_ctlma       e ds                  extname(ctlmap01) inz
      /endif
      * ---------------------------------------------------------
      * SltCtlma() - Select application control
      *
     D SltCtlma        PR                  likeds(t_ctlma)
     D  AppCat                             like(CMappcat)  const
     D  AppSub                             like(CMappsub)  const
     D  AppCd1                             like(CMappcd1)  const
     D                                     options(*omit:*nopass)
     D  AppCd2                             like(CMappcd2)  const
     D                                     options(*omit:*nopass)
      * ---------------------------------------------------------
      * ChkCtlma() - Check application control
      *
     D ChkCtlma        PR                  like(StdInd)
     D  AppCat                             like(CMappcat)  const
     D  AppSub                             like(CMappsub)  const
     D  AppCd1                             like(CMappcd1)  const
     D                                     options(*omit:*nopass)
     D  AppCd2                             like(CMappcd2)  const
     D                                     options(*omit:*nopass)
      * ---------------------------------------------------------
      * RtvCtlmaDta() - Retrieve application control
      *
     D RtvCtlmaDta     PR                  like(StdStr)
     D  AppCat                             like(CMappcat)  const
     D  AppSub                             like(CMappsub)  const
     D  AppCd1                             like(CMappcd1)  const
     D                                     options(*omit:*nopass)
     D  AppCd2                             like(CMappcd2)  const
     D                                     options(*omit:*nopass)
      * ---------------------------------------------------------
      * RtvCtlmaRcd() - Retrieve application control
      *
     D RtvCtlmaRcd     PR                  like(t_ctlma)
     D  AppCat                             like(CMappcat)  const
     D  AppSub                             like(CMappsub)  const
     D  AppCd1                             like(CMappcd1)  const
     D                                     options(*omit:*nopass)
     D  AppCd2                             like(CMappcd2)  const
     D                                     options(*omit:*nopass)
      * ---------------------------------------------------------
      * UpdCtlma() - Update application control
      *
     D Updctlma        PR
     D  AppCat                             like(CMappcat)  const
     D  AppSub                             like(CMappsub)  const
     D  AppCd1                             like(CMappcd1)  const
     D                                     options(*omit)
     D  AppCd2                             like(CMappcd2)  const
     D                                     options(*omit)
     D  AppDta                             like(CMappdta)  const
      * ---------------------------------------------------------
      * DcrCtlma() - Decrypt application control data
      *
     D Dcrctlma        PR                  likeDS(t_ctlma)
     D  DSctlma                            likeDS(t_ctlma)  const
      * ---------------------------------------------------------
      * EncCtlma() - Encrypt application control data
      *
     D Encctlma        PR                  likeDS(t_ctlma)
     D  DSctlma                            likeDS(t_ctlma)  const
