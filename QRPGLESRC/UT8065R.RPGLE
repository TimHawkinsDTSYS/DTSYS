      /TITLE Utility, String extract (SrvPgm)
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
      * ExtWords() - Extract words from string.
      ***********************************************************
     P ExtWords        B                   Export
      *
     D ExtWords        PI                  like(StdPtr)
     D  ChrString                          like(StdPtr) const
     D                                     options(*string:*trim)
     D  Delimiters_p                       like(StdPtr) const
     D                                     options(*string:*nopass:*omit)
      *
     D pToken          s                   like(StdPtr)  inz
     D Delimiters      s                   like(StdStr)  inz
      *
     D DSwords         ds                  likeds(t_ExtWords)
     D                                     based(pExtWords)
      *
     D WordsMax        s                   like(StdInt)  inz
     D WordsInl        s                   like(StdInt)  inz(200)
     D WordsElm        s                   like(StdInt)  inz(200)
     D WordsIcr        s                   like(StdInt)  inz(100)
      * ---------------------------------------------------------
      * Check for omitted parameters.
      *
     C                   if        %parms    >= 2         and
     C                             %addr(Delimiters_p) <> *null
     C                   eval      Delimiters = %str(Delimiters_p)
     C                   endif
      * ---------------------------------------------------------
      * Set pointer to first word in the string.
      *
     C                   if        %parms  = 1
     C                   eval      pToken  = getToken(ChrString:delimiters)
     C                   else
     C                   eval      pToken  =
     C                             getToken(ChrString:%trimr(delimiters))
     C                   endif
      * ---------------------------------------------------------
      * Extract each of the words based on delimiters.
      *
     C                   eval      WordsMax  = *zero
     C                   eval      pExtWords =
     C                             %alloc(%size(WordsMax) +
     C                                    WordsInl * %size(StdStr))
      * ---------------------------------------------------------
      * Reallocate additional memory if needed.
      *
     C                   dow       pToken   <> *null
     C                   eval      WordsMax += 1
     C                   if        WordsMax  > WordsElm
     C                   eval      WordsElm += WordsIcr
     C                   eval      pExtWords = %realloc(pExtWords:
     C                                         %size(WordsMax) +
     C                                         WordsElm * %size(StdStr))
     C                   endif
      * ---------------------------------------------------------
      * Add the word to the array.
      *
     C                   eval      DSwords.Words(WordsMax) = %str(pToken)
      * ---------------------------------------------------------
      * Find the next delimiter and point to the word.
      *
     C                   if        %parms = 1
     C                   eval      pToken = getToken(*null:delimiters)
     C                   else
     C                   eval      pToken   =
     C                             getToken(*null:%trimr(delimiters))
     C                   endif
     C                   enddo
      * ---------------------------------------------------------
      * Extract each of the words based on delimiters.
      *
     C                   eval      DSwords.WordsMax = WordsMax
     C                   return    pExtWords
      *
     P ExtWords        E
      ***********************************************************
      * ExtFirstLast() - Extract first and last.
      ***********************************************************
     P ExtFirstLast    B                   Export
      *
     D ExtFirstLast    PI                  like(d_ExtFirstLast) opdesc
     D  CharValue                          like(StdSQL)  const
      *
     D d_ExtFirstLast  ds                  likeDS(t_ExtFirstLast) inz
      *
     D d_FstLstWrd     ds                  likeds(t_ExtWords)
     D                                     based(pFstLstWrd)
      *
     D WrkString       S                   like(StdSQL)  inz
     D WrkString2      S                   like(StdSQL)  inz
     D Eidx            S                   like(StdLen)  inz
     D Iidx            S                   like(StdLen)  inz
     D Length          S                   like(StdLen)  inz
     D LeftByte        S                   like(StdLen)  inz
     D NbrofChar       S                   like(StdLen)  inz
     D DescType        S                   like(StdInt)  inz
     D DataType        S                   like(StdInt)  inz
     D DescInfo1       S                   like(StdInt)  inz
     D DescInfo2       S                   like(StdInt)  inz
     D InLen           S                   like(StdInt)  inz
      * ---------------------------------------------------------
      *    Determine length of input string.
      *
     C                   CALLP     CEEDOD(1         : DescType : DataType :
     C                                    DescInfo1 : DescInfo2: InLen    :
     C                                    *OMIT)
      *
      *    Test for no input.
      *
     C                   if        %subst(CharValue:1:Inlen) = *blanks
     C                   return    d_ExtFirstLast
     C                   endif
      *
      *    Extract the character value to the end of the string.
      *
     C                   eval      WrkString = %subst(CharValue:1:InLen)
      *
      *    Locate leftmost byte of character data.
      *
     C     ' '           check     CharValue     LeftByte
      *
      *    Determine the length of the string.
      *
     C                   eval      Length = InLen - LeftByte + 1
      * ---------------------------------------------------------
      * If there is no data then get out.
      *
     C                   if        Length   <= *zero or
     C                             LeftByte <= *zero or
     C                             LeftByte >  InLen
     C                   return    d_ExtFirstLast
     C                   endif
      * ---------------------------------------------------------
      * Extract the character value to the end of the string.
      *
     C                   eval      WrkString =
     C                               %subst(CharValue:LeftByte:Length)
      * ---------------------------------------------------------
      * Extract words.
      *
     C                   eval      pFstLstWrd = ExtWords(WrkString)
      * ---------------------------------------------------------
      * Extract first and last.
      *
     C                   if        d_FstLstWrd.WordsMax > *zero
     C                   eval      d_ExtFirstLast.First =
     C                             %trim(d_FstLstWrd.Words(1))
      *
     C                   eval      d_ExtFirstLast.Last  =
     C                             %trim(d_FstLstWrd.Words
     C                             (d_FstLstWrd.WordsMax))
     C                   endif
      *
     C                   dealloc                 pFstLstWrd
      *
     C                   return    d_ExtFirstLast
      *
     P ExtFirstLast    E
      * * * * * * * * * * * * * * * * * * * * * * * * *
      *ExtRsp() - Extract response.
      * * * * * * * * * * * * * * * * * * * * * * * * *
     P ExtRsp          B                   Export
      *
     D ExtRsp          PI                  like(StdBuf)
     D  RspNam                             like(StdBuf) const
     D  RecBuf                             like(StdBuf) const
      *
     D StrPos          s                   like(StdInt) inz
     D StrOff          s                   like(StdInt) inz
     D EndPos          s                   like(StdInt) inz
     D Len             s                   like(StdInt) inz
     D RspVal          s                   like(RspNam) inz
      * ---------------------------------------------------------
      *
     c                   eval      RspVal = *blanks
     c                   eval      strpos = %scan(%trim(RspNam):recbuf)
      *
     c                   if        strpos > *zero
     c                   eval      stroff = strpos + %len(%trim(RspNam))
     c                   if        %subst(recbuf:stroff:1) = *blanks
     c                   eval      stroff += 1
     c                   endif
     c                   eval      endpos = %scan(' ':recbuf:stroff)
     c                   eval      len    = endpos - stroff + 1
     c                   if        len    > *zero
     c                   eval      RspVal =
     c                             %trim(%subst(recbuf:stroff:len))
     c                   endif
     c                   endif
      *
     c                   return    RspVal
      *
     P ExtRsp          E
      * *********************************************************
      * ExtTxtBuf() - Extract text from a buffer.
      * *********************************************************
     P ExtTxtBuf       B                   Export
      *
     D ExtTxtBuf       PI                  like(StdBuf)
     D  BufInp                             like(StdBuf) const
     D  BufStr                             like(StdInt) const
     D  BufLen                             like(StdInt) const
      * ---------------------------------------------------------
      * Return value.
      *
     C                   return    %subst(BufInp:BufStr:BufLen)
      *
     P ExtTxtBuf       E
      * *********************************************************
      * ExtPakBuf() - Extract packed from a buffer.
      * *********************************************************
     P ExtPakBuf       B                   Export
      *
     D ExtPakBuf       PI                  like(StdDec)
     D  BufInp                             like(StdBuf) const
     D  BufStr                             like(StdInt) const
     D  BufLen                             like(StdInt) const
     D  BufDec                             like(StdInt) const
      *
     D ExtDec          s                   like(StdInt) inz
     D InsPos          s                   like(StdInt) inz(16)
     D RtnPak          s                   like(StdDec) inz
      *
     D wk015a          s             15
      *
     D DSpack          ds                  inz
     D  Packed                 1     15p 0 packeven
      * ---------------------------------------------------------
      * Return value.
      *
     C                   eval      InsPos -= BufLen
     C                   eval      wk015a = %subst(BufInp:BufStr:BufLen)
      *
     C                   eval      %subst(DSpack:InsPos:BufLen) =
     C                             %subst(BufInp:BufStr:BufLen)
      *
     C                   if        Packed <> *zero
     C                   eval      ExtDec  = 10    ** BufDec
     C                   eval      RtnPak  = Packed / ExtDec
     C                   endif
      *
     C                   return    RtnPak
      *
     P ExtPakBuf       E
      * *********************************************************
      * ExtZonBuf() - Extract zoned from a buffer.
      * *********************************************************
     P ExtZonBuf       B                   Export
      *
     D ExtZonBuf       PI                  like(StdZon)
     D  BufInp                             like(StdBuf) const
     D  BufStr                             like(StdInt) const
     D  BufLen                             like(StdInt) const
     D  BufDec                             like(StdInt) const
      *
     D ExtDec          s                   like(StdInt) inz
     D InsPos          s                   like(StdInt) inz(16)
     D RtnZon          s                   like(StdZon) inz
      *
     D DSzone          ds                  inz
     D  Zoned                  1     15s 0
      * ---------------------------------------------------------
      * Return value.
      *
     C                   eval      InsPos -= BufLen
      *
     C                   eval      %subst(DSzone:InsPos:BufLen) =
     C                             %subst(BufInp:BufStr:BufLen)
      *
     C                   if        Zoned  <> *zero
     C                   eval      ExtDec  = 10    ** BufDec
     C                   eval      RtnZon  = Zoned  / ExtDec
     C                   endif
      *
     C                   return    RtnZon
      *
     P ExtZonBuf       E
      * *********************************************************
      * ExtDteBuf() - Extract date from a buffer.
      * *********************************************************
     P ExtDteBuf       B                   Export
      *
     D ExtDteBuf       PI                  like(StdDat)
     D  BufInp                             like(StdBuf) const
     D  BufStr                             like(StdInt) const
      *
     D wk010a          s             10    inz
      * ---------------------------------------------------------
      * Return value.
      *
     C                   eval      wk010a = %subst(BufInp:BufStr)
      *
     C                   return    %date(wk010a)
      *
     P ExtDteBuf       E
      * *********************************************************
      * ExtNumDteBuf() - Extract numeric date from a buffer.
      * *********************************************************
     P ExtNumDteBuf    B                   Export
      *
     D ExtNumDteBuf    PI                  like(NumISO)
     D  BufInp                             like(StdBuf) const
     D  BufStr                             like(StdInt) const
      *
     D wk008a          s              8                 inz
      * ---------------------------------------------------------
      * Return value.
      *
     C                   eval      wk008a = %subst(BufInp:BufStr)
      *
     C                   return    num(wk008a)
      *
     P ExtNumDteBuf    E
      * *********************************************************
      * ExtTimBuf() - Extract time from a buffer.
      * *********************************************************
     P ExtTimBuf       B                   Export
      *
     D ExtTimBuf       PI                  like(StdTim)
     D  BufInp                             like(StdBuf) const
     D  BufStr                             like(StdInt) const
      *
     D wk008a          s              8    inz
      * ---------------------------------------------------------
      * Return value.
      *
     C                   eval      wk008a = %subst(BufInp:BufStr)
      *
     C                   return    %time(wk008a)
      *
     P ExtTimBuf       E
      * *********************************************************
      * ExtNumTimBuf() - Extract numeric time from a buffer.
      * *********************************************************
     P ExtNumTimBuf    B                   Export
      *
     D ExtNumTimBuf    PI                  like(NumHMS)
     D  BufInp                             like(StdBuf) const
     D  BufStr                             like(StdInt) const
      *
     D wk006a          s              8                 inz
      * ---------------------------------------------------------
      * Return value.
      *
     C                   eval      wk006a = %subst(BufInp:BufStr)
      *
     C                   return    num(wk006a)
      *
     P ExtNumTimBuf    E
      * *********************************************************
      * ExtTspBuf() - Extract timestamp from a buffer.
      * *********************************************************
     P ExtTspBuf       B                   Export
      *
     D ExtTspBuf       PI                  like(StdTms)
     D  BufInp                             like(StdBuf) const
     D  BufStr                             like(StdInt) const
      *
     D wk026a          s             26    inz
      * ---------------------------------------------------------
      * Return value.
      *
     C                   eval      wk026a = %subst(BufInp:BufStr)
      *
     C                   return    %timestamp(wk026a)
      *
     P ExtTspBuf       E
      **********************************************************
      * ExtFromCDATA() -- Extract from CDATA.
      **********************************************************
     P ExtFromCDATA    B                   Export
      *
     D ExtFromCDATA    PI                  like(StdSQL)
     D  InpString                          like(StdSQL) const
      *
     D WrkString       S                   like(StdSQL)  inz
      * ---------------------------------------------------------
      *
      *    Test for no input.
      *
     C                   if        InpString = *blanks
     C                   return    *blanks
     C                   endif
      *
      *    Assure that <![CDATA[ is in the string.
      *
     C                   if        %subst(InpString:1:9) <> '<![CDATA['
     C                   return    InpString
     C                   endif
      * ---------------------------------------------------------
      *
      *    Extract the string, dropping the <![CDATA[
      *
     C                   eval      WrkString = %subst(InpString:1:10)
      *
      *    Remove the ]]> from the end.
      *
     C                   eval      WrkString = %replace('':WrkString:
     C                                         %scan(']]>':WrkString):3)
     C
      *
     C                   return    WrkString
      *
     P ExtFromCDATA    E
      **********************************************************
      * ExtAlpha() -- Extract alpha characters.
      **********************************************************
     P ExtAlpha        B                   Export
      *
     D ExtAlpha        PI          1024    varying
     D  InpString                  1024    varying const
      *
     D WrkString       s           1024    varying
     D x               s                   like(StdInt)  inz
      * ---------------------------------------------------------
      *
      *    Test for no input.
      *
     C                   if        InpString = *blanks
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *    Extract alpha characters.
      *
     C                   eval      WrkString = %trim(InpString)
      *
     C                   for       x = 1 to %len(%trim(WrkString))
      *
     C                   if        %subst(WrkString:x:1) >= 'A'    and
     C                             %subst(WrkString:x:1) <= 'Z'    or
     C                             %subst(WrkString:x:1) >= 'a'    and
     C                             %subst(WrkString:x:1) <= 'z'    or
     C                             %subst(WrkString:x:1)  = '-'    or
     C                             %subst(WrkString:x:1)  = ' '
     C                   else
     C                   eval      %subst(WrkString:x:1) = *blanks
     C                   endif
     C                   endfor
      *
     C                   return    WrkString
      *
     P ExtAlpha        E
      **********************************************************
      * RmvNumeric() -- Remove numeric characters.
      **********************************************************
     P RmvNumeric      B                   Export
      *
     D RmvNumeric      PI          1024    varying
     D  InpString                  1024    varying const
      *
     D WrkString       s           1024    varying
     D x               s                   like(StdInt)  inz
      * ---------------------------------------------------------
      *
      *    Test for no input.
      *
     C                   if        InpString = *blanks
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *    Remove numeric characters.
      *
     C                   eval      WrkString = %trim(InpString)
      *
     C                   for       x = 1 to %len(%trim(WrkString))
      *
     C                   if        %subst(WrkString:x:1) >= '0'    and
     C                             %subst(WrkString:x:1) <= '9'
     C                   eval      %subst(WrkString:x:1) = *blanks
     C                   endif
     C                   endfor
      *
     C                   return    WrkString
      *
     P RmvNumeric      E
