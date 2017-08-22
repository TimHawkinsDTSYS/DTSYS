      /TITLE Utility, String general (SrvPgm)
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
      * Center string.
      ***********************************************************
     P Center          B                   Export
      *
     D Center          PI                  like(StdSQL)  opdesc
     D  CenterString                       like(StdSQL)  const
      *
     D RtnString       S                    like(StdSQL)  inz
     D WrkString       S                    like(StdSQL)  inz
     D LeftByte        S                    like(StdLen)  inz
     D NbrofChar       S                    like(StdLen)  inz
     D Adjust          S                    like(StdLen)  inz
     D DescType        S                    like(StdInt)  inz
     D DataType        S                    like(StdInt)  inz
     D DescInfo1       S                    like(StdInt)  inz
     D DescInfo2       S                    like(StdInt)  inz
     D InLen           S                    like(StdInt)  inz
      * ---------------------------------------------------------
      *
      *    Determine length of input string.
      *
     C                   callp     CEEDOD(1        :DescType :DataType:
     C                                    DescInfo1:DescInfo2:InLen   :
     C                                    *OMIT)
      *
     C                   clear                   RtnString
      *
     C     ' '           check     CenterString  LeftByte
      *
      *    Test for no input.
      *
     C                   if        CenterString = *blanks
     C                   return    *blanks
     C                   endif
      *
     C                   eval      WrkString =
     C                               %subst(CenterString:LeftByte:
     C                                      InLen - LeftByte + 1)
      *
     C                   eval      NbrofChar = %LEN(%trim(WrkString))
      *
     C                   IF        NbrofChar < InLen
     C                   eval      Adjust =    InLen - NbrOfChar
     C                   div       2             Adjust
     C                   eval      Adjust = Adjust + 1
      *
     C                   eval      %subst(RtnString:Adjust) =
     C                             %subst(WrkString:1:NbrofChar)
     C                   else

     C                   eval      RtnString = WrkString
     C                   endif
      *
     C                   return    RtnString
      *
     P Center          E
      * **********************************************************
      * Like() -- Like scan for a string with wildcards.
      * -- The underscore sign (_) represents any single character.
      * -- The percent sign (%) represents a string of zero or more char.
      * -- Any other character represents itself.
      * **********************************************************
     P Like            B                   Export
      *
     D Like            PI                  like(StdInt)
     D  parmPattern                 256    varying           const
     D  parmSearch                32767    varying           const
     D  parmWildCard                  1    options(*nopass)  const
      *
     D wrkSearch       s                   like(parmSearch )  inz
     D wrkPattern      s                   like(parmPattern)  inz
     D wrkWildCard     s                   like(parmWildCard) inz('_')
     D lenSearch       s                   like(StdInt)       inz
     D lenPattern      s                   like(StdInt)       inz
     D strPattern      s                   like(StdInt)       inz(1)
     D strSearch       s                   like(StdInt)       inz(1)
     D MatchPatPos     s                   like(StdInt)       inz
     D MatchStrPos     s                   like(StdInt)       inz
     D MatchFirst      s                   like(StdInd)       inz
     D MatchPrv        s                   like(StdInd)       inz
     D MatchRest       s                   like(StdInd)       inz
     D PatChrFnd       s                   like(StdInd)       inz
     D x               s                   like(StdInt)       inz
     D y               s                   like(StdInt)       inz
      * ---------------------------------------------------------
      /free
         //
         // Assure values are varying length.
         //
         eval wrkSearch  = %trim(parmSearch);
         eval wrkPattern = %trim(parmPattern);

         //
         // Override default wildcard when supplied
         //
         If %parms >= 3;
             wrkWildCard = parmWildCard;
         EndIf;

         //
         // Ignore cases we know will fail
         //
         eval lenSearch  = %len(wrkSearch);
         eval lenPattern = %len(wrkPattern);

         if lenSearch  = *zero or
            lenPattern = *zero or
            lenPattern > lenSearch;
              return *zero;
         endif;

         //
         // Ignore when pattern doesn't have any non-wild characters.
         //
         for x = 1 to lenPattern;
           if %subst(wrkPattern:x:1) <> '%'      and
              %subst(wrkPattern:x:1) <> wrkWildCard;
                eval PatChrFnd = *on;
                leave;
           endif;
         endfor;

         if not PatChrFnd;
           return *zero;
         endif;

         // -----------------------------------------------------
         //
         //  Find matching pattern.
         //
         dou  MatchRest;

         //
         //  Set start pattern to first non-wild character.
         //
           for  strPattern = 1 to lenPattern;
             if %subst(wrkPattern:strPattern:1) <> '%'     and
                %subst(wrkPattern:strPattern:1) <> wrkWildCard;
               leave;
             endif;
           endfor;

         //
         //  Find first non-wildcard match.
         //  -- ignore percent and wildcards and search for
         //     the next matching character, when found get out.
         //
           eval MatchFirst  = *off;
           eval MatchPrv    = *off;
           eval MatchPatPos = *zero;
           eval MatchStrPos = *zero;

           for y = strSearch to lenSearch;
             if %subst(wrkPattern:strPattern:1) = %subst(wrkSearch:y:1);
               eval MatchFirst  = *on;
               eval MatchPatPos = strPattern;
               eval MatchStrPos = y;
               leave;
             endif;
           endfor;

           if not MatchFirst;
             return *zero;
           endif;

         //
         //  Find previous wildcard matches.
         //  -- if first char was percent, then matches all.
         //     assume otherwise all previous characters were
         //     wildcards, and if current positions match then
         //     we have the same number of wildcards and string
         //     caracters.
         //  -- otherwise, begin searching again at the next
         //     string position.
         //
           if %subst(wrkPattern:1:1) <> '%' and
              MatchPatPos <> MatchStrPos;
                eval strSearch = MatchStrPos + 1;
                iter;
           endif;

         //
         //  Match the rest of the pattern.
         //  -- when percent found, all is matched.
         //  -- otherwise, match every character that isn't a wildcard
         //
           eval MatchRest = *off;
           eval strPattern  = MatchPatPos + 1;
           eval strSearch  = MatchStrPos + 1;

           for  x = strPattern to lenPattern;

             if %subst(wrkPattern:x:1) = '%';
               eval MatchRest = *on;
               leave;
             endif;

             if %subst(wrkPattern:x:1) = wrkWildCard;
               eval strSearch += 1;
               iter;
             endif;

             if strSearch <= lenSearch    and
                %subst(wrkPattern:x:1) = %subst(wrkSearch:strSearch:1);
               eval MatchRest   = *on;
             else;
               eval MatchRest   = *off;
               leave;
             endif;

             eval strSearch += 1;
           endfor;

           if not MatchRest;
             iter;
           endif;

         //
         //  Finally, check for trailing characters.
         //  -- when percent is trailing character or
         //     pattern length matches search length,
         //     we have a match and can return with the position.
         //  -- otherwise, keep searching.
         //
           if %subst(wrkPattern:lenPattern:1) = '%' or
              lenPattern = lenSearch;
                return MatchStrPos;
           endif;

           eval MatchRest = *off;
         enddo;

         return *zero;

      /End-Free
      *
     P Like            E
      ***********************************************************
      * Compress string.
      ***********************************************************
     P CompressString  B                   Export
      *
     D CompressString  PI                  like(StdSQL)  opdesc
     D  CharValue                          like(StdSQL)  const
      *
     D RtnString       S                    like(StdSQL)  inz
     D WrkString       S                    like(StdSQL)  inz
     D WrkString2      S                    like(StdSQL)  inz
     D Eidx            S                    like(StdLen)  inz
     D Iidx            S                    like(StdLen)  inz
     D Length          S                    like(StdLen)  inz
     D LeftByte        S                    like(StdLen)  inz
     D NbrofChar       S                    like(StdLen)  inz
     D DescType        S                    like(StdInt)  inz
     D DataType        S                    like(StdInt)  inz
     D DescInfo1       S                    like(StdInt)  inz
     D DescInfo2       S                    like(StdInt)  inz
     D InLen           S                    like(StdInt)  inz
      * ---------------------------------------------------------
      *
      *    Determine length of input string.
      *
     C                   callp     CEEDOD(1        :DescType :DataType:
     C                                    DescInfo1:DescInfo2:InLen   :
     C                                    *OMIT)
      *
      *    Test for no input.
      *
     C                   if        %subst(CharValue:1:Inlen) = *blanks
     C                   return    *blanks
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
      *
      *    If there is no data then get out.
      *
     C                   if           Length    <= *zero
     C                             or LeftByte  <= *zero
     C                             or LeftByte  >= InLen
     C                   return    *blanks
     C                   endif
      *
      *    Extract the character value to the end of the string.
      *
     C                   eval      WrkString =
     C                               %subst(CharValue:LeftByte:Length)
      *
      *    Determine the number of actual characters.
      *
     C                   eval      NbrofChar = %LEN(%trim(WrkString))
      *
      *    Compress out the blanks.
      *
     C                   DO        NbrofChar     Eidx
      *
     C                   if        %subst(WrkString:Eidx:1) <> *blanks
     C                   eval      Iidx = Iidx + 1
     C                   eval      %subst(RtnString:Iidx:1) =
     C                             %subst(WrkString:Eidx:1)
     C                   endif
     C                   enddo
      *
     C                   return    RtnString
      *
     P CompressString  E
      ***********************************************************
      * RplString() -- Replace String.
      ***********************************************************
     P RplString       B                   Export
      *
     D RplString       PI         65535a   varying
     D  InString                  65535a   varying const
     D  InFmString                 1024    varying const
     D  InToString                 1024    varying const
      *
     D WrkString       s          65535a   varying      inz
     D strpos          s                   like(StdInt) inz
      * ---------------------------------------------------------
      * Test for no input.
      *
š1b€ C                   if        InString = *blanks
     C                   return    *blanks
š1e€ C                   endif
      * ---------------------------------------------------------
      * Replace string.
      *
     C                   eval      strpos = 1
š1b€ C                   eval      WrkString = InString
      *
     C                   dow       %scan(%trim(InFmString):
     C                             %trim(InString):strpos) > *zero
      *
     C                   eval      WrkString =
     C                             %replace(%trim(InToString):InString:
     C                             %scan(%trim(InFmString):InString:strpos):
     C                             %len(%trim(InFmString)))
      *
     C                   eval      strpos += 1
     C                   enddo
      *
š1b€ C                   return    WrkString
      *
     P RplString       E
      ***********************************************************
      * Compress() -- Compress field.
      ***********************************************************
     P Compress        B                   Export
      *
     D Compress        PI         65535
     D  p_value                   65535    const

     D Compress        pr                  Extproc('_CPRDATA')
     D  RcvrPtr                            like(StdPtr) value

     D CompressDS      ds
     D  SourceLen                          like(StdInt) inz
     D  ResultLen                          like(StdInt) inz
     D  CompressLen                        like(StdInt) inz
     D  Algorithm                          like(StdIntSml) inz(2)
     D                               18    inz(*loval)
     D  SourcePtr                          like(StdPtr) inz(%addr(i_value))
     D  ResultPtr                          like(StdPtr) inz(%addr(o_value))

     D i_value         s                   like(p_value)
     D o_value         s                   like(p_value)

      /free

        i_value = p_value;
        SourceLen = %len(%trim(p_value));
        ResultLen = %size(o_value);

        Compress(%addr(CompressDS));

        return %subst(o_value:1:CompressLen);

      /end-free

     P Compress        E
      ***********************************************************
      * Decompress() -- Decompress field.
      ***********************************************************
     P Decompress      B                   Export
      *
     D Decompress      PI         65535
     D  p_value                   65535    const

     D Decompress      pr                  Extproc('_DCPDATA')
     D  RcvrPtr                            like(StdPtr) value

     D DecompressDS    ds
     D                                4    inz(*loval)
     D  ResultLen                          like(StdInt) inz
     D  DecompressLen                      like(StdInt) inz
     D                               20    inz(*loval)
     D  SourcePtr                          like(StdPtr) inz(%addr(i_value))
     D  ResultPtr                          like(StdPtr) inz(%addr(o_value))

     D i_value         s                   like(p_value)
     D o_value         s                   like(p_value)

      /free

        i_value = p_value;
        ResultLen = %size(p_value);

        Decompress(%addr(DecompressDS));

        return %subst(o_value:1:DecompressLen);

      /end-free

     P Decompress      E
      ***********************************************************
      * SingularWord() -- Singluar word
      ***********************************************************
     P SingularWord    B                   Export
      *
     D SingularWord    PI                  like(StdNam)
     D  I_unit                             like(StdNam) const
     D  I_nits                             like(StdInt) const
      *
     D  O_unit         s                   like(StdNam) inz
      * ---------------------------------------------------------
      *
      * Remove last 's' from string if one night.
      *
      /free

       if  I_nits = *zero;
           return *blanks;
       endif;

       if  I_nits > 1;
           return lower(I_unit);
       endif;

       if  I_nits = 1     and
           %checkr(' ':I_unit) > 1;

           O_unit = lower(I_unit);
           %subst(O_unit:%checkr(' ':I_unit):1) = *blanks;
           return O_unit;
       endif;

       return *blanks;

      /end-free
     P SingularWord    E
      * **********************************************************
      * RmvNonAlpNum() - Remove non-alphanumeric characters.
      * **********************************************************
     P RmvNonAlpNum    B                   Export
      *
     D RmvNonAlpNum    PI           256    varying
     D  string                      256    varying           const

     D RtnString       s                   like(string) inz
     D WrkString       s                   like(StdStr) inz
     D RmvChar         s                   like(StdInd) inz
     D x               s                   like(StdInt) inz
      /free
       // -------------------------------------------------------
       // Ignore cases we know will fail

       If %len(string) = *zero or
          string       = *blanks;
            return *blanks;
       endif;

       eval WrkString = %trim(string);

       // -------------------------------------------------------
       // Ignore when pattern doesn't have any non-wild characters.

       for x = 1 to %len(string);
         if %subst(WrkString:x:1) >= 'A'      and
            %subst(WrkString:x:1) <= 'Z'      or
            %subst(WrkString:x:1) >= '0'      and
            %subst(WrkString:x:1) <= '9';
           else;
            eval RmvChar               = *on;
            eval %subst(WrkString:x:1) = *blanks;
         endif;
       endfor;

       // -------------------------------------------------------
       // Compress the string.

       if RmvChar;
         eval RtnString = %trim(CompressString(WrkString));
       else;
         eval RtnString = %trim(WrkString);
       endif;

       return RtnString;

      /End-Free
     P RmvNonAlpNum    E
      ***********************************************************
      * CatNam() - Concatenate name.
      ***********************************************************
     P CatNam          B                   Export
      *
     D CatNam          PI                  like(StdTxt)
     D   WKpxfn                            like(StdTxt) const
     D   WKpxln                            like(StdTxt) const
      /free
       // -------------------------------------------------------
       // Return concatenated name.

       return %trim(WKpxfn) + ' ' + %trim(WKpxln);

      /end-free
     P CatNam          E
      ***********************************************************
      * Add to comma delimited list.
      ***********************************************************
     P AddLst          B                   Export
      *
     D AddLst          PI                  like(StdStr)
     D  SrcString                          like(StdStr) const
     D  AddString                          like(StdStr) const

     D  WrkString      s                   like(StdStr) inz
      /free
       // -------------------------------------------------------
       // Return comma delimited list.

       if SrcString = *blanks;
          return AddString;
       else;
          return %trim(SrcString) + ', ' + %trim(AddString);
       endif;

      /end-free
     P AddLst          E
      ***********************************************************
      * CntAlpChr() - Count alpha characters.
      ***********************************************************
     P CntAlpChr       B                   Export
      *
     D CntAlpChr       PI                  like(StdInt ) opdesc
     D  String                             like(StdSQL)  const
      *
     D WrkString       DS                                 inz
     D  WrkArray                      1     overlay(WrkString)
     D                                      dim(1024)
      *
     D LeftByte        S                    like(StdLen)  inz
     D NbrofChar       S                    like(StdLen)  inz
     D Length          S                    like(StdLen)  inz
     D Adjust          S                    like(StdLen)  inz
     D DescType        S                    like(StdInt)  inz
     D DataType        S                    like(StdInt)  inz
     D DescInfo1       S                    like(StdInt)  inz
     D DescInfo2       S                    like(StdInt)  inz
     D InLen           S                    like(StdInt)  inz
     D x               S                    like(StdInt)  inz
     D RtnCount        S                    like(StdInt)  inz
      * ---------------------------------------------------------
      *
      *    Determine length of input string.
      *
     C                   callP     CEEDOD(1         : DescType : DataType :
     C                                    DescInfo1 : DescInfo2: InLen    :
     C                                    *OMIT)
      *
     C                   eval      RtnCount = *zero
      *
      *    Locate leftmost byte of character data.
      *
     C     ' '           check     String        LeftByte
      *
      *    If there is no data then get out.
      *
     C                   if        LeftByte  >= InLen
     C                   return    *zero
     C                   endif
      *
      *    Determine the length of the string.
      *
     C                   eval      Length = InLen - LeftByte + 1
      *
      *    Extract the character value to the end of the string.
      *
     C                   eval      WrkString =
     C                               %subst(String:LeftByte:Length)
      *
      *    Reset the length to the actual length.
      *
     C     ' '           checkR    WrkString     Length
      *
      *    Test for no input.
      *
     C                   if        String = *blanks
     C                   return    *zero
     C                   endif
      *
      *    Count numeric characters.
      *
     C                   do        Length        x
     C                   if        (WrkArray(x) >= 'a' and
     C                              WrkArray(x) <= 'z') or
     C                             (WrkArray(x) >= 'A' and
     C                              WrkArray(x) <= 'Z')
     C                   eval      RtnCount    = RtnCount + 1
     C                   endif
     C                   enddo
      *
     C                   return    RtnCount
      *
     P CntAlpChr       E
      ***********************************************************
      * Soundex() - Returns soundex string.
      ***********************************************************
     P Soundex         B                   Export
      *
     D Soundex         PI                  like(StdSQL)  opdesc
     D  NameString                         like(StdSQL)  const
     D  ReturnLen_p                        like(StdCnt)  const
     D                                     options(*nopass)
      *
     D WrkString       DS                                 inz
     D  WrkArray                      1     overlay(WrkString) dim(1024)
      *
     D RtnSoundex      DS                                 inz
     D  RtnArray                      1     overlay(RtnSoundex) dim(1024)
      *
     D ReturnLen       s                    like(ReturnLen_p) inz
     D Compress        s                    like(StdSQL)  inz
     D LeftByte        S                    like(StdLen)  inz
     D NbrofChar       S                    like(StdLen)  inz
     D Length          S                    like(StdLen)  inz
     D Adjust          S                    like(StdLen)  inz
     D DescType        S                    like(StdInt)  inz
     D DataType        S                    like(StdInt)  inz
     D DescInfo1       S                    like(StdInt)  inz
     D DescInfo2       S                    like(StdInt)  inz
     D InLen           S                    like(StdInt)  inz
     D x               S                    like(StdInt)  inz
      *
      *  Soundex values.
      *
     D One             c                    const('BPFV')
     D Two             c                    const('CSKGJQXZ')
     D Three           c                    const('DT')
     D Four            c                    const('L')
     D Five            c                    const('MN')
     D Six             c                    const('R')
     D Vowel           c                    const('AEIOU')
     D HorW            c                    const('HW')
      * ---------------------------------------------------------
      *
      *    Check for omitted parameters.
      *
     C                   eval      ReturnLen  = 4
      *
     C                   if        %parms    >= 2
     C                   callp     CEETSTA(ParmPassed:2:*omit)
     C                   if        ParmPassed = 1
     C                   eval      ReturnLen  = ReturnLen_p
     C                   endif
     C                   endif
      *
      *    Determine length of input string.
      *
     C                   callP     CEEDOD(1         : DescType : DataType :
     C                                    DescInfo1 : DescInfo2: InLen    :
     C                                    *OMIT)
      *
     C                   clear                   RtnArray
      *
      *    Locate leftmost byte of character data.
      *
     C     ' '           check     NameString    LeftByte
      *
      *    If there is no data then get out.
      *
     C                   if        NameString = *blanks or
     C                             LeftByte  >= InLen
     C                   return    *blanks
     C                   endif
      *
      *    Determine the length of the string.
      *
     C                   eval      Length = InLen - LeftByte + 1
      *
      *    Extract the character value to the end of the string.
      *
     C                   eval      WrkString =
     C                               %subst(NameString:LeftByte:Length)
      *
      *    Reset the length to the actual length.
      *
     C     ' '           checkR    WrkString     Length
      *
      *    Test for no input.
      *
     C                   if        NameString = *blanks
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *    Translate to uppercase.
      *
     C                   eval      WrkString = %xlate(lowr:uppr:WrkString)
      *
      *    Remove all non-alpha characters.
      *
     C                   for       x = 1 to Length
     C                   if        WrkArray(x) < 'A' or
     C                             WrkArray(x) > 'Z'
     C                   eval      WrkArray(x) = *blanks
     C                   endif
     C                   endfor
      *
      *    Compress the string.
      *
     C                   eval      Compress  = WrkString
     C                   eval      WrkString = CompressString(Compress)
      *
      *    Set first letter of soundex.
      *
     C                   eval      RtnArray(1) = WrkArray(1)
      *
      *    Remove the first letter of adjacent characters that
      *    have the same soundex character.
      *
     C                   for       x = 1 to Length
     C                   if        %scan(WrkArray(x  ):one  ) > *zero and
     C                             %scan(WrkArray(x+1):one  ) > *zero or
     C                             %scan(WrkArray(x  ):two  ) > *zero and
     C                             %scan(WrkArray(x+1):two  ) > *zero or
     C                             %scan(WrkArray(x  ):three) > *zero and
     C                             %scan(WrkArray(x+1):three) > *zero or
     C                             %scan(WrkArray(x  ):four ) > *zero and
     C                             %scan(WrkArray(x+1):four ) > *zero or
     C                             %scan(WrkArray(x  ):five ) > *zero and
     C                             %scan(WrkArray(x+1):five ) > *zero or
     C                             %scan(WrkArray(x  ):six  ) > *zero and
     C                             %scan(WrkArray(x+1):six  ) > *zero
     C                   eval      WrkArray(x) = *blanks
     C                   endif
     C                   endfor
      *
      *    Compress the string.
      *
     C                   eval      Compress  = WrkString
     C                   eval      WrkString = CompressString(Compress)
      *
      *    Remove the following characters A, E, I, O, U, H, W, Y.
      *
     C                   for       x = 2 to Length
     C                   if        %scan(WrkArray(x):'AEIOUHWY') > *zero
     C                   eval      WrkArray(x) = *blanks
     C                   endif
     C                   endfor
      *
      *    Compress the string.
      *
     C                   eval      Compress  = WrkString
     C                   eval      WrkString = CompressString(Compress)
      *
      *    Convert characters in positions 2 to ReturnLen to a number.
      *
     C                   for       x = 2 to ReturnLen
     C                   select
     C                   when      %scan(WrkArray(x):one  ) > *zero
     C                   eval      RtnArray(x) = '1'
     C                   when      %scan(WrkArray(x):two  ) > *zero
     C                   eval      RtnArray(x) = '2'
     C                   when      %scan(WrkArray(x):three) > *zero
     C                   eval      RtnArray(x) = '3'
     C                   when      %scan(WrkArray(x):four ) > *zero
     C                   eval      RtnArray(x) = '4'
     C                   when      %scan(WrkArray(x):five ) > *zero
     C                   eval      RtnArray(x) = '5'
     C                   when      %scan(WrkArray(x):six  ) > *zero
     C                   eval      RtnArray(x) = '6'
     C                   endsl
     C                   endfor
      *
      *    Fill any unused positions with zeros e.g. Lee is L00
      *
     C                   for       x = 1 to ReturnLen
     C                   if        RtnArray(x) = *blanks
     C                   eval      RtnArray(x) = *zero
     C                   endif
     C                   endfor
      *
     C                   return    RtnSoundex
      *
     P Soundex         E
      * **********************************************************
      * InChr() - Check values in a character list.
      * **********************************************************
     P InChr           B                   Export

     D InChr           PI                  like(StdInd)
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

      /Free
       // --------------------------------------------------------
       // Extract the elements.

        if InChrCmp = InChrLst01;
          return *on;
        endif;

        If %parms >= 3       and
           InChrCmp = InChrLst02;
          return *on;
        endif;

        If %parms >= 4       and
           InChrCmp = InChrLst03;
          return *on;
        endif;

        If %parms >= 5       and
           InChrCmp = InChrLst04;
          return *on;
        endif;

        If %parms >= 6       and
           InChrCmp = InChrLst05;
          return *on;
        endif;

        If %parms >= 7       and
           InChrCmp = InChrLst06;
          return *on;
        endif;

        If %parms >= 8       and
           InChrCmp = InChrLst07;
          return *on;
        endif;

        If %parms >= 9       and
           InChrCmp = InChrLst08;
          return *on;
        endif;

        If %parms >= 10      and
           InChrCmp = InChrLst09;
          return *on;
        endif;

        If %parms >= 11      and
           InChrCmp = InChrLst10;
          return *on;
        endif;

        return *off;

      /End-Free
     P InChr           E
      ***********************************************************
      * CvtToAlpha() -- Convert string to alpha only.
      ***********************************************************
     P CvtToAlpha      B                   Export
      *
     D CvtToAlpha      PI                  like(StdSQL)
     D  InpString                          like(StdSQL) const
      *
     D WrkString       s                   like(StdSQL) inz
     D x               s                   like(StdInt) inz
      * ---------------------------------------------------------
      * If there is no data then get out.
      *
     C                   if        InpString = *blanks
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      * Remove all non-alpha characters.
      *
     C                   eval      WrkString = InpString
      *
     C                   for       x = 1 to %len(%trim(WrkString))
     C                   if        %subst(WrkString:x:1) < 'A' or
     C                             %subst(WrkString:x:1) > 'Z'
     C                   eval      %subst(WrkString:x:1) = *blanks
     C                   endif
     C                   endfor
      *
     C                   return    WrkString
      *
     P CvtToAlpha      E
