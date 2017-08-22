      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  String extract prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      * ExtWords() -- Extract words from a string.
      *
     D ExtWords        PR                  like(StdPtr)
     D  ChrString                          like(StdPtr) const
     D                                     options(*string:*trim)
     D  Delimiters                         like(StdPtr) const
     D                                     options(*string:*nopass:*omit)
      *
     D t_ExtWords      ds                  qualified template
     D  WordsMax                           like(StdInt)
     D  Words                       100    varying dim(1500)
      *
     D WordsIdx        s                   like(StdInt) inz
      * ---------------------------------------------------------
      * getToken() -- Get token (words in a string).
      *
     D getToken        PR                  like(StdPtr) extproc('strtok')
     D  pString                            like(StdPtr) value
     D                                     options(*string)
     D  pTokenList                         like(StdPtr) value
     D                                     options(*string)
      * ---------------------------------------------------------
      * ExtFirstLast() -- Extract first & last names from a string.
      *
     D ExtFirstLast    PR                  like(t_ExtFirstLast) opdesc
     D  CharValue                          like(StdSQL) const
      *
     D t_ExtFirstLast  ds                  qualified template
     D  First                              like(StdStr)
     D  Last                               like(StdStr)
      * ---------------------------------------------------------
      * ExtRsp() -- Extract response.
      *
     D ExtRsp          PR                  like(StdBuf)
     D  RspNam                             like(StdBuf) const
     D  RecBuf                             like(StdBuf) const
      * ---------------------------------------------------------
      * ExtTxtBuf() -- Extract text.
      *
     D ExtTxtBuf       PR                  like(StdBuf)
     D  BufInp                             like(StdBuf) const
     D  BufStr                             like(StdInt) const
     D  BufLen                             like(StdInt) const
      * ---------------------------------------------------------
      * ExtPakBuf() -- Extract packed.
      *
     D ExtPakBuf       PR                  like(StdDec)
     D  BufInp                             like(StdBuf) const
     D  BufStr                             like(StdInt) const
     D  BufLen                             like(StdInt) const
     D  BufDec                             like(StdInt) const
      * ---------------------------------------------------------
      * ExtZonBuf() -- Extract zoned.
      *
     D ExtZonBuf       PR                  like(StdZon)
     D  BufInp                             like(StdBuf) const
     D  BufStr                             like(StdInt) const
     D  BufLen                             like(StdInt) const
     D  BufDec                             like(StdInt) const
      * ---------------------------------------------------------
      * ExtDteBuf() -- Extract date.
      *
     D ExtDteBuf       PR                  like(StdDat)
     D  BufInp                             like(StdBuf) const
     D  BufStr                             like(StdInt) const
      * ---------------------------------------------------------
      * ExtNumDteBuf() -- Extract numeric date.
      *
     D ExtNumDteBuf    PR                  like(NumISO)
     D  BufInp                             like(StdBuf) const
     D  BufStr                             like(StdInt) const
      * ---------------------------------------------------------
      * ExtTimBuf() -- Extract time.
      *
     D ExtTimBuf       PR                  like(StdTim)
     D  BufInp                             like(StdBuf) const
     D  BufStr                             like(StdInt) const
      * ---------------------------------------------------------
      * ExtNumTimBuf() -- Extract numeric time.
      *
     D ExtNumTimBuf    PR                  like(NumHMS)
     D  BufInp                             like(StdBuf) const
     D  BufStr                             like(StdInt) const
      * ---------------------------------------------------------
      * ExtTspBuf() -- Extract timestamp.
      *
     D ExtTspBuf       PR                  like(StdTms)
     D  BufInp                             like(StdBuf) const
     D  BufStr                             like(StdInt) const
      * ---------------------------------------------------------
      *  ExtFromCDATA() -- Extract from CDATA.
      *
     D ExtFromCDATA    PR                  like(StdSQL)
     D  InpString                          like(StdSQL) const
      * ---------------------------------------------------------
      *  ExtAlpha() -- Extract alpha characters.
      *
     D ExtAlpha        PR          1024    varying
     D  InpString                  1024    varying const
      * ---------------------------------------------------------
      *  RmvNumeric() -- Remove numeric characters.
      *
     D RmvNumeric      PR          1024    varying
     D  InpString                  1024    varying const
