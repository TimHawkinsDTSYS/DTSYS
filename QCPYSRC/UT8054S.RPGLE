      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Copy: DB file prototypes
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *
      * RtvRcdFmt() -- Retrieve record format ID.
      *
     D RtvRcdFmt       PR                  like(RcdFmtID)
     D  FilNam                             like(StdNam) const
     D  FilLib                             like(StdNam) const
     D                                     options(*nopass)
      *
     D RcdFmtID        s             13    inz
      * ---------------------------------------------------------
      *
      *  QRtvMbrd() -- Retrieve member description
      *
     D QRtvMbrD        PR                  ExtPgm('QUSRMBRD')
     D  szRecvBuffer              65535A   Options(*VARSIZE)
     D  nLenRecvBuf                  10I 0 Const
     D  FmtName                       8A   Const
     D  fileName                     20A   Const
     D  MbrName                      10A   Const
     D  bOvrProc                      1A   Const
     D  api_error                          Likeds(dsEC)
     D                                     OPTIONS(*VARSIZE)
     D  bFindMbr                      1A   Const OPTIONS(*NOPASS)
      * ---------------------------------------------------------
      *
      *  RtvNbrRec() -- Retrieve number of records.
      *
     D RtvNbrRec       PR                  like(StdInt)
     D  DbfNam                             like(StdNam) const
     D  LibNam                             like(StdNam) const
     D                                     options(*nopass:*omit)
     D  MbrNam                             like(StdNam) const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      *
      *  RtvMbrTxt() -- Retrieve member text.
      *
     D RtvMbrTxt       PR                  like(StdTxt)
     D  DbfNam                             like(StdNam) const
     D  LibNam                             like(StdNam) const
     D                                     options(*nopass:*omit)
     D  MbrNam                             like(StdNam) const
     D                                     options(*nopass)
