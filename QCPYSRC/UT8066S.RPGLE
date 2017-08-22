      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  String general prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      * Center() -- Center string.
      *
     D Center          PR                  like(StdSQL) opdesc
     D  CenterString                       like(StdSQL) const
      * ---------------------------------------------------------
      * Like() -- Like scan for a string with wildcards.
      *
     D Like            PR                  like(StdInt)
     D  Pattern                     256    varying           const
     D  Search                    32767    varying           const
     D  WildCard                      1    options(*nopass)  const
      * ---------------------------------------------------------
      * CompressString() -- Compress a string.
      *
     D CompressString  PR                  like(StdSQL) opdesc
     D  CharValue                          like(StdSQL) const
      * ---------------------------------------------------------
      *  RplString() -- Replace string.
      *
     D RplString       PR         65535a   varying
     D  InString                  65535a   varying const
     D  InFmString                 1024    varying const
     D  InToString                 1024    varying const
      * ---------------------------------------------------------
      * RplStg() - Replace string
      *
     D RplStg          PR         65535a   varying
     D  p_String                  65535a   varying      const
     D  p_FmString                 8000    varying      const
     D  p_ToString                 8000    varying      const
     D                                     options(*omit:*nopass)
     D  p_Options                          like(StdStg) const
     D                                     options(*omit:*nopass)
      * ---------------------------------------------------------
      *  Compress() -- Compress a string.
      *
     D Compress        PR         65535
     D  i_value                   65535    const
      * ---------------------------------------------------------
      *  Decompress() -- Decompress a string.
      *
     D Decompress      PR         65535
     D  i_value                   65535    const
      * ---------------------------------------------------------
      *  SingularWord() -- Singluar word
      *
     D SingularWord    PR                  like(StdNam)
     D  i_unit                             like(StdNam) const
     D  i_nits                             like(StdInt) const
      * ---------------------------------------------------------
      * RmvNonAlpNum() -- Remove non-alphanumeric characters.
      *
     D RmvNonAlpNum    PR           256    varying
     D  string                      256    varying           const
      * ---------------------------------------------------------
      * CatNam() -- Concatenate name.
      *
     D CatNam          PR                  like(StdTxt)
     D   WKpxfn                            like(StdTxt) const
     D   WKpxln                            like(StdTxt) const
      * ---------------------------------------------------------
      * AddLst() -- Add to comma delimited list.
      *
     D AddLst          PR                  like(StdStr)
     D   SrcString                         like(StdStr) const
     D   AddString                         like(StdStr) const
      * ---------------------------------------------------------
      * CntAlpChr() -- Count number of alpha characters.
      *
     D CntAlpChr       PR                  like(StdInt) opdesc
     D  String                             like(StdSQL) const
      * ---------------------------------------------------------
      * Soundex() -- Soundex pattern matching
      *
     D Soundex         PR                  like(StdSQL) opdesc
     D  NameString                         like(StdSQL) const
     D  ReturnLen                          like(StdCnt) const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      * InChr() -- Check values in a character list.
      *
     D InChr           PR                  like(StdInd)
     D  InChrCmp                           like(StdStr) const
     D  InChrLst01                         like(StdStr) const
     D  InChrLst02                         like(StdStr) const
     D                                     options(*nopass)
     D  InChrLst03                         like(StdStr) const
     D                                     options(*nopass)
     D  InChrLst04                         like(StdStr) const
     D                                     options(*nopass)
     D  InChrLst05                         like(StdStr) const
     D                                     options(*nopass)
     D  InChrLst06                         like(StdStr) const
     D                                     options(*nopass)
     D  InChrLst07                         like(StdStr) const
     D                                     options(*nopass)
     D  InChrLst08                         like(StdStr) const
     D                                     options(*nopass)
     D  InChrLst09                         like(StdStr) const
     D                                     options(*nopass)
     D  InChrLst10                         like(StdStr) const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      * CvtToAlpha() -- Convert string to alpha only.
      *
     D CvtToAlpha      PR                  like(StdSQL)
     D  String                             like(StdSQL) const
