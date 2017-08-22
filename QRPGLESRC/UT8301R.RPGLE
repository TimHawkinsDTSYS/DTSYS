      /TITLE Utility, Remarks (SrvPgm)
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
      *  01/21/07  TimH        Corrected to not include end tags when
      *                         processing thru the list of color codes.
      *
      *  01/30/07  TimH        Corrected to not handle a print formatting
      *                         code when its the first item to 'show'.
      *
      *  11/10/07  TimH        Changed to run an external module rather
      *                         than attempt to 'read' records into
      *                         a few procedures, we found that the
      *                         procedures shut down, and have to
      *                         refresh their stored DB records everytime.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /copy qcpysrc,HspecSrv
      *
      /define DSpgm
      /copy qcpysrc,Dspec
      /copy qcpysrc,UT8301S
      * **********************************************************
      * ChrSetPrtLin() -- Character set print line.
      * **********************************************************
     P ChrSetPrtLin    B                   Export
      *
     D ChrSetPrtLin    PI                  like(d_ChrSetPrtLin)
     D  string_p                  32767    varying           const
     D  chrset_p                           like(RMchrset)    const
     D                                     options(*nopass)
     D  prtrmklen_p                        like(StdInt)      const
     D                                     options(*nopass)
     D  options_p                          like(StdStr)      const
     D                                     options(*nopass)
      *
      * *NOFMT  = No formatting should be performed (history).
      * *FMTONLY = Format only (leave all print codes in text).
      * ---------------------------------------------------------
      *
      *  Standalone fields
      *
     D StringWords     ds                  likeds(t_ExtWords)
     D                                     based(pStringWords)
      *
     D string          s          32767    varying        inz
     D word            s            256    varying        inz
     D SVword          s                   like(word)     inz
     D DebugWord       s                   like(StdStr)   inz
     D SavFmtWrd       s                   like(word)     inz
      *
     D WrdLen          s                   like(dfnSWchrwid) inz
     D LinLen          s                   like(WrdLen)      inz
     D chrset          s                   like(chrset_p)    inz
     D prtrmklen       s                   like(prtrmklen_p) inz
     D options         s                   like(options_p)   inz
      *
     D NoFmt           s                   like(StdInd)   inz
     D FmtOnly         s                   like(StdInd)   inz
     D InsCol          s                   like(StdInd)   inz
     D LinIdx          s                   like(StdInt)   inz
     D LinStr          s                   like(StdStr)   inz dim(100)
     D PVchrset        s                   like(RMchrset) inz
     D FmtChr          s                   like(StdNam)   inz
     D ColChr          s                   like(StdNam)   inz
     D ColorOn         s                   like(StdChr)   inz
     D ColorOff        s                   like(StdChr)   inz
     D LastLetter      s                   like(StdChr)   inz
     D ListItem        s                   like(StdInt)   inz
     D BulletLen       s                   like(WrdLen)   inz
     D BlanksLen       s                   like(WrdLen)   inz
     D BlanksEqu       s                   like(WrdLen)   inz
     D BlanksNbr       s                   like(StdInt)   inz
     D BulletEqu       s                   like(word)     inz
     D Bullet          s                   like(word)     inz
     D FirstBul        s                   like(StdInd)   inz
      * ---------------------------------------------------------
      *
     C                   reset                   d_ChrSetPrtLin
      *
      *    Return on blank string.
      *
     C                   if        %trim(string_p) = *blanks
     C                   return    d_ChrSetPrtLin
     C                   endif
      * ---------------------------------------------------------
      *
      *    Set parameters.
      *
     C                   eval      string = string_p
      *
     C                   if        %parms   >= 2       and
     C                             chrset_p <> *blanks
     C                   eval      chrset    = chrset_p
     C                   else
     C                   eval      chrset    = RMchrset
     C                   endif
      *
     C                   if        %parms      >= 3    and
     C                             prtrmklen_p <> *zero
     C                   eval      prtrmklen    = prtrmklen_p
     C                   else
     C                   eval      prtrmklen    = RMprtrmklen
     C                   endif
      *
     C                   if        %parms      >= 4    and
     C                             options_p   <> *zero
     C                   eval      options      = options_p
     C                   else
     C                   eval      options      = *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *    No formatting should be removed (history).
      *
     C                   if        %scan('*NOFMT':options) > *zero
     C                   eval      NoFmt = *on
     C                   endif
      * ---------------------------------------------------------
      *
      *    Size of bullet, and equivalent in blanks.
      *
     C                   if        chrset  <> PVchrset
     C                   eval      PVchrset = chrset
     C                   exsr      $SizBullet
     C                   endif
      * ---------------------------------------------------------
      *
      *    Clear return values.
      *
     C                   eval      LinIdx   = *zero
     C                   eval      LinStr   = *blanks
     C                   eval      ListItem = *zero
     C                   eval      FirstBul = *on
      * ---------------------------------------------------------
      *
      *    Format only, leave print location codes in the text.
      *
     C                   if        %scan('*FMTONLY':options) > *zero
     C                   eval      FmtOnly = *on
     C                   else
     C                   eval      string = RmvPrtLoc(string)
     C                   endif
      * ---------------------------------------------------------
      *
      *    Insert space bweeeen print codes.
      *
     C                   eval      string = %trim(InsSpcPrtCde(string))
      * ---------------------------------------------------------
      *
      *    Extract all of the words in the string.
      *
     C                   eval      pStringWords = ExtWords(string)
      * ---------------------------------------------------------
      *
      *    Process until no more words.
      *
     C                   for       WordsIdx = 1 to StringWords.WordsMax
     C                   eval      word = StringWords.words(WordsIdx)
      *
      *    For debugging.
      *
     C                   eval      DebugWord = word
      *
      *    Check for formatting, and do it.
      *
     C                   dou       word = *blanks
     C                   exsr      $ChkFmt
      *
      *    Add a word into the print line.
      *
     C                   if        word  <> *blanks
     C                   exsr      $AddWrdPrtLin
     C                   endif
     C                   enddo
     C                   endfor
      *
     C                   dealloc                 pStringWords
      *
     C                   eval      AYrmklin = LinIdx
     C                   eval      AYrmktxt = LinStr
     C                   return    d_ChrSetPrtLin
      /space 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Size of bullet, and equivalent in blanks.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     C     $SizBullet    begsr
      * ---------------------------------------------------------
      *
      *    Determine size of a blank.
      *    -- since null won't be found, it will use blanks.
      *    -- reduce by half because a space is always added
      *
     C                   eval      word       = ' '
     C                   eval      BlanksLen  = ChrSetWrdLen(word:chrset)
     C                   eval      BlanksLen /= 2
      * ---------------------------------------------------------
      *
      *    Determine size of bullet and one blanks.
      *    -- since null won't be found, it will use blanks.
      *
     C                   eval      Bullet = 'o' + null
      *
     C                   eval      word       = Bullet
     C                   eval      BulletLen  = ChrSetWrdLen(word:chrset)
     C                   eval      BulletLen -= BlanksLen
      * ---------------------------------------------------------
      *
      *    Determine equivalent in blanks.
      *
     C                   if        BlanksLen <> *zero
     C                   eval      BlanksEqu  = BulletLen / BlanksLen
     C                   endif
      * ---------------------------------------------------------
      *
      *    String together the number of equivalent blanks.
      *
     C                   eval(h)   BlanksNbr = BlanksEqu
     C                   eval      BulletEqu = *blanks
      *
     C                   do        BlanksNbr
     C                   eval      BulletEqu = %trim(BulletEqu) + null
     C                   enddo
      *
     C     #SizBullet    endsr
      /space 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Check formatting.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     C     $ChkFmt       begsr
      * ---------------------------------------------------------
      *
      *    No formatting should be removed (history).
      *
     C                   if        NoFmt
     C                   leavesr
     C                   endif
      * ---------------------------------------------------------
      *
      *    Insert bullet.
      *
     C                   if        FirstBul
     C                   eval      FirstBul = *off
     C                   exsr      $AddBulPrtLin
     C                   endif
      * ---------------------------------------------------------
      *
      *    Do while there is before formatting.
      *
     C                   dou       FmtChr   = *blanks and
     C                             ColChr   = *blanks
     C                   eval      FmtChr   = *blanks
     C                   eval      ColChr   = *blanks
      *
     C                   if        %len(word)      >= 1 and
     C                             %subst(word:1:1) = '<'
      *
      *    New paragraph.
      *
     C                   select
     C                   when      %len(word)      >= 3       and
     C                             %subst(word:1:3) = '<P>'   and
     C                             LinLen           = BulletLen
     C                   eval      FmtChr  = '<P>'
      *
     C                   when      %len(word)      >= 3       and
     C                             %subst(word:1:3) = '<P>'   and
     C                             LinLen          <> BulletLen
     C                   eval      FmtChr  = '<P>'
     C                   exsr      $NewLine
     C                   eval      LinIdx += 1
      *
      *    New line (break).
      *
     C                   when      %len(word)      >= 4       and
     C                             %subst(word:1:4) = '<BR>'  and
     C                             LinLen           = BulletLen
     C                   eval      FmtChr  = '<BR>'
      *
     C                   when      %len(word)      >= 4       and
     C                             %subst(word:1:4) = '<BR>'  and
     C                             LinLen          <> BulletLen
     C                   eval      FmtChr  = '<BR>'
     C                   exsr      $NewLine
     C                   exsr      $Indent
      *
      *    List item.
      *
     C                   when      %len(word)      >= 4 and
     C                             %subst(word:1:4) = '<LI>'
     C                   eval      FmtChr  = '<LI>'
      *
     C                   when      %len(word)      >= 5 and
     C                             %subst(word:1:5) = '</LI>'
     C                   eval      FmtChr    = '</LI>'
     C                   eval      ListItem -= 1
      *
      *    Blue.
      *
     C                   when      %len(word)      >= 5 and
     C                             not FmtOnly          and
     C                             %subst(word:1:5) = '<BLU>'
     C                   eval      ColChr  = '<BLU>'
     C                   eval      ColorOn = Color_BLU
      *
     C                   when      %len(word)      >= 6 and
     C                             not FmtOnly          and
     C                             %subst(word:1:6) = '</BLU>'
     C                   eval      ColChr   = '</BLU>'
     C                   eval      ColorOn  = *blanks
     C                   eval      ColorOff = Color_GRN
      *
      *    Yellow.
      *
     C                   when      %len(word)      >= 5 and
     C                             not FmtOnly          and
     C                             %subst(word:1:5) = '<YLW>'
     C                   eval      ColChr  = '<YLW>'
     C                   eval      ColorOn = Color_YLW
      *
     C                   when      %len(word)      >= 6 and
     C                             not FmtOnly          and
     C                             %subst(word:1:6) = '</YLW>'
     C                   eval      ColChr   = '</YLW>'
     C                   eval      ColorOn  = *blanks
     C                   eval      ColorOff = Color_GRN
      *
      *    Pink.
      *
     C                   when      %len(word)      >= 5 and
     C                             not FmtOnly          and
     C                             %subst(word:1:5) = '<PNK>'
     C                   eval      ColChr  = '<PNK>'
     C                   eval      ColorOn = Color_PNK
      *
     C                   when      %len(word)      >= 6 and
     C                             not FmtOnly          and
     C                             %subst(word:1:6) = '</PNK>'
     C                   eval      ColChr   = '</PNK>'
     C                   eval      ColorOn  = *blanks
     C                   eval      ColorOff = Color_GRN
      *
      *    Green.
      *
     C                   when      %len(word)      >= 5 and
     C                             not FmtOnly          and
     C                             %subst(word:1:5) = '<GRN>'
     C                   eval      ColChr  = '<GRN>'
     C                   eval      ColorOn = Color_GRN
      *
     C                   when      %len(word)      >= 6 and
     C                             not FmtOnly          and
     C                             %subst(word:1:6) = '</GRN>'
     C                   eval      ColChr   = '</GRN>'
     C                   eval      ColorOn  = *blanks
     C                   eval      ColorOff = Color_GRN
      *
      *    Turquise.
      *
     C                   when      %len(word)      >= 5 and
     C                             not FmtOnly          and
     C                             %subst(word:1:5) = '<TRQ>'
     C                   eval      ColChr  = '<TRQ>'
     C                   eval      ColorOn = Color_TRQ
      *
     C                   when      %len(word)      >= 6 and
     C                             not FmtOnly          and
     C                             %subst(word:1:6) = '</TRQ>'
     C                   eval      ColChr   = '</TRQ>'
     C                   eval      ColorOn  = *blanks
     C                   eval      ColorOff = Color_GRN
      *
      *    Red.
      *
     C                   when      %len(word)      >= 5 and
     C                             not FmtOnly          and
     C                             %subst(word:1:5) = '<RED>'
     C                   eval      ColChr  = '<RED>'
     C                   eval      ColorOn = Color_RED
      *
     C                   when      %len(word)      >= 6 and
     C                             not FmtOnly          and
     C                             %subst(word:1:6) = '</RED>'
     C                   eval      ColChr   = '</RED>'
     C                   eval      ColorOn  = *blanks
     C                   eval      ColorOff = Color_GRN
      *
      *    White.
      *
     C                   when      %len(word)      >= 5 and
     C                             not FmtOnly          and
     C                             %subst(word:1:5) = '<WHT>'
     C                   eval      ColChr  = '<WHT>'
     C                   eval      ColorOn = Color_WHT
      *
     C                   when      %len(word)      >= 6 and
     C                             not FmtOnly          and
     C                             %subst(word:1:6) = '</WHT>'
     C                   eval      ColChr   = '</WHT>'
     C                   eval      ColorOn  = *blanks
     C                   eval      ColorOff = Color_GRN
      *
      *    Reservations blue (UL).
      *
     C                   when      %len(word)      >= 8 and
     C                             not FmtOnly          and
     C                             %subst(word:1:8) = '<RESBLU>'
     C                   eval      ColChr  = '<RESBLU>'
     C                   eval      ColorOn = DspAtr_NP_BLU_UL
      *
     C                   when      %len(word)      >= 9 and
     C                             not FmtOnly          and
     C                             %subst(word:1:9) = '</RESBLU>'
     C                   eval      ColChr   = '</RESBLU>'
     C                   eval      ColorOn  = *blanks
     C                   eval      ColorOff = Color_GRN
      *
      *    Reservations yellow (UL).
      *
     C                   when      %len(word)      >= 8 and
     C                             not FmtOnly          and
     C                             %subst(word:1:8) = '<RESYLW>'
     C                   eval      ColChr  = '<RESYLW>'
     C                   eval      ColorOn = DspAtr_NP_YLW_UL
      *
     C                   when      %len(word)      >= 9 and
     C                             not FmtOnly          and
     C                             %subst(word:1:9) = '</RESYLW>'
     C                   eval      ColChr   = '</RESYLW>'
     C                   eval      ColorOn  = *blanks
     C                   eval      ColorOff = Color_GRN
      *
      *    Reservations pink (UL).
      *
     C                   when      %len(word)      >= 8 and
     C                             not FmtOnly          and
     C                             %subst(word:1:8) = '<RESPNK>'
     C                   eval      ColChr  = '<RESPNK>'
     C                   eval      ColorOn = DspAtr_NP_PNK_UL
      *
     C                   when      %len(word)      >= 9 and
     C                             not FmtOnly          and
     C                             %subst(word:1:9) = '</RESPNK>'
     C                   eval      ColChr   = '</RESPNK>'
     C                   eval      ColorOn  = *blanks
     C                   eval      ColorOff = Color_GRN
     C                   endsl
     C                   endif
      * ---------------------------------------------------------
      *
      *    Escape if nothing found.
      *
     C                   if        FmtChr = *blanks and
     C                             ColChr = *blanks
     C                   leavesr
     C                   endif
      * ---------------------------------------------------------
      *
      *    Remove formatting code from the word.
      *
     C                   if        not FmtOnly
     C                   exsr      $RmvFmtCod
     C                   endif
      * ---------------------------------------------------------
      *
      *    Add/remove color to print line.
      *
     C                   if        ColorOn  <> *blanks or
     C                             ColorOff <> *blanks
     C                   exsr      $AddColPrtLin
     C                   endif
      * ---------------------------------------------------------
      *
      *    Add bullet to print line.
      *
     C                   if        FmtChr = '<LI>'
     C                   exsr      $AddBulPrtLin
     C                   endif
     C                   enddo
      *
     C     #ChkFmt       endsr
      /space 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Remove formatting code
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     C     $RmvFmtCod    begsr
      *
     C                   select
     C                   when      FmtChr <> *blanks
     C                   eval      word = %replace('':word:
     C                                    %scan(%trim(FmtChr):word):
     C                                    %len(%trim(FmtChr)))
      *
     C                   when      ColChr <> *blanks
     C                   eval      word = %replace('':word:
     C                                    %scan(%trim(ColChr):word):
     C                                    %len(%trim(ColChr)))
     C                   endsl
      *
     C     #RmvFmtCod    endsr
      /space 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Add bullet to print line.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     C     $AddBulPrtLin begsr
      *
      *    Force to next line.
      *
     C                   exsr      $NewLine
      *
      *    If we've already done a bullet, insert them.
      *
     C                   do        ListItem
     C                   eval      LinLen        += BulletLen
     C                   eval      LinStr(LinIdx) = %trim(LinStr(LinIdx)) +
     C                                              BulletEqu + null
     C                   enddo
      *
      *    Now insert the bullet.
      *
     C                   eval      ListItem      += 1
     C                   eval      LinLen        += BulletLen
     C                   eval      LinStr(LinIdx) = %trim(LinStr(LinIdx)) +
     C                                              Bullet
      *
     C     #AddBulPrtLin endsr
      /space 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Add word to print line.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     C     $AddWrdPrtLin begsr
      * ---------------------------------------------------------
      *
      *    If nothing to insert, escape.
      *
     C                   if        word = *blanks
     C                   leavesr
     C                   endif
      * ---------------------------------------------------------
      *
      *    If nothing inserted yet, set Index.
      *
     C                   if        Linidx  = *zero
     C                   eval      LinIdx += 1
     C                   endif
      * ---------------------------------------------------------
      *
      *    Extract any formatting after the word.
      *
     C                   if        %scan('<':word) > *zero
     C                   eval      SavFmtWrd = %subst(word:%scan('<':word))
     C                   eval      %subst(word:%scan('<':word)) = *blanks
     C                   eval      word = %trim(word)
      *
     C                   if        word = *blanks
     C                   eval      word = SavFmtWrd
     C                   eval      SavFmtWrd = *blanks
     C                   endif
      *
     C                   else
     C                   eval      SavFmtWrd = *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *    Determine size of word.
      *
     C                   eval      WrdLen = ChrSetWrdLen(word:chrset)
      * ---------------------------------------------------------
      *
      *    Check if this word will fit on this line.
      *
     C                   if        LinLen  + WrdLen > prtrmklen
     C                   exsr      $NewLine
     C                   endif
      * ---------------------------------------------------------
      *
      *    Indent based on number of bullets.
      *
     C                   exsr      $Indent
      * ---------------------------------------------------------
      *
      *    Add/remove color to print line.
      *
     C                   if        InsCol
     C                   exsr      $AddColPrtLin
     C                   endif
      * ---------------------------------------------------------
      *
      *    Extract last letter.
      *
     C                   if        %len(%trim(LinStr(LinIdx))) > *zero
     C                   eval      LastLetter =
     C                             %subst(LinStr(LinIdx):
     C                             %len(%trim(LinStr(LinIdx))):1)
     C                   else
     C                   eval      LastLetter = *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *    Add this word to the print line.
      *
     C                   eval      LinLen += WrdLen
      *
     C                   if        LastLetter > *blanks
     C                   eval      LinStr(LinIdx) = %trim(LinStr(LinIdx))
     C                                              + ' ' + word
      *
     C                   else
     C                   eval      LinStr(LinIdx) = %trim(LinStr(LinIdx))
     C                                              + word
     C                   endif
      * ---------------------------------------------------------
      *
      *    Restore formatting after printing the word.
      *
     C                   eval      word = SavFmtWrd
      *
     C     #AddWrdPrtLin endsr
      /space 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * New line.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     C     $NewLine      begsr
      * ---------------------------------------------------------
      *
      *    Force color to end after last word.
      *
     C                   if        LinIdx <> *zero
     C                   eval      LinStr(LinIdx) = %trim(LinStr(LinIdx))
     C                                              + Color_GRN
     C                   endif
      * ---------------------------------------------------------
      *
      *    Increment to next line.
      *
     C                   eval      LinLen  = *zero
     C                   eval      LinIdx += 1
      * ---------------------------------------------------------
      *
      *    Insert color for new line.
      *
     C                   if        not NoFmt
     C                   eval      InsCol = *on
     C                   endif
      *
     C     #NewLine      endsr
      /space 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Indent based on number of bullets.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     C     $Indent       begsr
      * ---------------------------------------------------------
      *
      *    Indent based on number of bullets.
      *
     C                   if        LinLen  = *zero
     C                   do        ListItem
     C                   eval      LinLen        += BulletLen
     C                   eval      LinStr(LinIdx) = %trim(LinStr(LinIdx)) +
     C                                              BulletEqu
     C                   enddo
     C                   endif
      *
     C     #Indent       endsr
      /space 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Add color code to print line.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     C     $AddColPrtLin begsr
      * ---------------------------------------------------------
      *
      *    Set fill character if color not set.
      *
     C                   if        InsCol    and
     C                             ColorOn = *blanks
     C                   eval      ColorOn = null
     C                   endif
      * ---------------------------------------------------------
      *
      *    Extract last character if there is one.
      *
     C                   if        %len(%trim(LinStr(LinIdx))) > *zero
     C                   eval      LastLetter = %subst(LinStr(LinIdx):
     C                             %len(%trim(LinStr(LinIdx))):1)
     C                   else
     C                   eval      LastLetter = *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *    If adding color, remove color off character.
      *
     C                   if         ColorOn    <> *blanks              and
     C                             (LastLetter  = Color_GRN            or
     C                              LastLetter  = Color_BLU            or
     C                              LastLetter  = Color_PNK            or
     C                              LastLetter  = Color_RED            or
     C                              LastLetter  = Color_TRQ            or
     C                              LastLetter  = Color_WHT            or
     C                              LastLetter  = Color_YLW            or
     C                              LastLetter  = DspAtr_PR_BLU_UL     or
     C                              LastLetter  = DspAtr_NP_YLW_UL     or
     C                              LastLetter  = DspAtr_PR_PNK_UL)
     C                   eval      %subst(LinStr(LinIdx):
     C                             %len(%trim(LinStr(LinIdx))):1) = *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *    Set color.
      *
     C                   if        ColorOn       <> *blanks
     C                   eval      LinStr(LinIdx) = %trim(LinStr(LinIdx))
     C                                            + ColorOn
     C                   eval      InsCol = *off
     C                   endif
      * ---------------------------------------------------------
      *
      *    End current color.
      *
     C                   if        ColorOff      <> *blanks
     C                   eval      LinStr(LinIdx) = %trim(LinStr(LinIdx))
     C                                            + ColorOff
     C                   eval      ColorOn  = *blanks
     C                   eval      ColorOff = *blanks
     C                   endif
      *
     C     #AddColPrtLin endsr
      *
     P ChrSetPrtLin    E
      * **********************************************************
      * ChrSetWrdLen() -- Character set word length.
      * **********************************************************
     P ChrSetWrdLen    B                   Export
      *
     D ChrSetWrdLen    PI                  like(dfnSWchrwid)
     D  string_p                    256    varying           const
     D  chrset_p                           like(RMchrset)    const
     D                                     options(*nopass)
      *
      *  Standalone fields
      *
     D PLstring        s                   like(string_p)    inz
     D PLchrset        s                   like(RMchrset)    inz
     D PLlen           s                   like(dfnSWchrwid) inz
      * ---------------------------------------------------------
      *
      *    Set parameters.
      *
     C                   eval      PLlen     = %len(string_p)
     C                   eval      PLstring  = string_p
     C                   eval      PLlen     = %len(PLstring)
      *
     C                   if        %parms   >= 2         and
     C                             chrset_p <> *blanks
     C                   eval      PLchrset  = chrset_p
     C                   else
     C                   eval      PLchrset  = RMchrset
     C                   endif
      * ---------------------------------------------------------
      *
      *    Determine character set word length.
      *
     C                   call      'UT2110R'
     C                   parm                    PLstring
     C                   parm                    PLchrset
     C                   parm      *zero         PLlen
      *
     C                   return    PLlen
      *
     P ChrSetWrdLen    E
      * **********************************************************
      * SetParFmt() -- Set paragraph formatting.
      * **********************************************************
     P SetParFmt       B                   Export
      *
     D SetParFmt       PI         32767    varying
     D  InpString                 32767    varying const
      *
     D WrkString       ds                  likeds(t_ExtWords)
     D                                     based(pWrkString)
      *
     D x               s                   like(StdInt)
     D Len             s                   like(StdInt)
     D RtnString       s                   like(InpString)
      * ---------------------------------------------------------
      /free

         // -----------------------------------------------------
         //
         // Extract words from the Rtnut string.
         //
         eval pWrkString = ExtWords(InpString);

         // -----------------------------------------------------
         //
         // String the paragraph back together.
         //
         for x = 1 to WrkString.WordsMax;

           eval Len = %len(%trim(RtnString));

         //  Insert two spaces after a paragraph.
           if   Len >= 3                                and
              %subst(%trim(RtnString):Len-2:1) <> '.'   and
              %subst(%trim(RtnString):Len  :1)  = '.';

             eval RtnString = %trim(RtnString) + '  ' +
                              WrkString.words(x);

         //  Insert one spaces after a word.
           else;
             eval RtnString = %trim(RtnString) + ' ' +
                              WrkString.words(x);
           endif;

         endfor;

         dealloc pWrkString;
         // -----------------------------------------------------
         //
         // Return the adjusted string.
         //

         eval RtnString = %trim(RtnString);

         return RtnString;

      /End-Free
      *
     P SetParFmt       E
      * **********************************************************
      * RmvColFmt() -- Remove color formatting codes.
      * **********************************************************
     P RmvColFmt       B                   Export
      *
     D RmvColFmt       PI         32767    varying
     D  string_p                  32767    varying           const
     D  options_p                          like(StdStr)      const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      *
      *  Standalone fields
      *
     D string          s          32767    varying         inz
     D options         s                   like(options_p) inz
     D RtnStr          s          32767    varying         inz
      * ---------------------------------------------------------
      *
      *    Return on blank string.
      *
     C                   if        %trim(string_p) = *blanks
     C                   return    %trim(string_p)
     C                   endif
      *
     C                   eval      string = string_p
      * ---------------------------------------------------------
      *
      *    Set parameters.
      *
     C                   if        %parms      >= 2    and
     C                             options_p   <> *zero
     C                   eval      options      = options_p
     C                   else
     C                   eval      options      = *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *    Run external process.
      *
     C                   call      'RM0600R'
     C                   parm                    string
     C                   parm                    options
     C                   parm                    RtnStr
      *
     C                   return    RtnStr
      *
     P RmvColFmt       E
      * **********************************************************
      * RmvPrtLoc() -- Remove print location codes.
      * **********************************************************
     P RmvPrtLoc       B                   Export
      *
     D RmvPrtLoc       PI         32767    varying
     D  string_p                  32767    varying           const
     D  options_p                          like(StdStr)      const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      *
      *  Standalone fields
      *
     D string          s          32767    varying         inz
     D options         s                   like(options_p) inz
     D RtnStr          s          32767    varying         inz
      * ---------------------------------------------------------
      *
      *    Return on blank string.
      *
     C                   if        %trim(string_p) = *blanks
     C                   return    %trim(string_p)
     C                   endif
      *
     C                   eval      string = string_p
      * ---------------------------------------------------------
      *
      *    Set parameters.
      *
     C                   if        %parms      >= 2    and
     C                             options_p   <> *zero
     C                   eval      options      = options_p
     C                   else
     C                   eval      options      = *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *    Run external process.
      *
     C                   call      'RM0601R'
     C                   parm                    string
     C                   parm                    options
     C                   parm                    RtnStr
      *
     C                   return    RtnStr
      *
     P RmvPrtLoc       E
      * **********************************************************
      * InsSpcPrtCde() -- Insert space between print codes.
      * **********************************************************
     P InsSpcPrtCde    B                   Export
      *
     Fctlmap01  if   e           k disk    static
      *
     D InsSpcPrtCde    PI         32767    varying
     D  string                    32767    varying           const
     D  options_p                          like(StdStr)      const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      *
      *  Standalone fields
      *
     D options         s                   like(options_p) inz
      *
     D AYprtlocidx     s                   like(StdInt)   inz
     D AYprtlocmax     s                   like(StdInt)   inz
     D AYprtloc        s                   like(CMappcd2)    inz dim(30)
      *
     D RtnStr          s          32767    varying        inz
     D ScnStr          s             32    varying        inz
     D ScnTag          s             32    varying        inz
     D str             s                   like(StdInt)   inz
     D LenScnTag       s                   like(StdInt)   inz
     D LenRtnStr       s                   like(StdInt)   inz
      *
     D I_ctlma         ds                  likerec(ctlma01r)
      * ---------------------------------------------------------
      *
      *    Return on blank string.
      *
     C                   if        %trim(string) = *blanks
     C                   return    %trim(string)
     C                   endif
      * ---------------------------------------------------------
      *
      *    Set parameters.
      *
     C                   if        %parms      >= 2    and
     C                             options_p   <> *zero
     C                   eval      options      = options_p
     C                   else
     C                   eval      options      = *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *    Retrieve list of print locations.
      *
     C                   if        AYprtloc(1) = *blanks
     C                   exsr      $RtvPrtLoc
     C                   endif
      * ---------------------------------------------------------
      *
      *    Check for colors & locations, and insert spaces.
      *
     C                   eval      RtnStr = %trim(string)
      * ---------------------------------------------------------
      *
      *    Do while there is before formatting.
      *
     C                   for       AYprtlocidx = 1 to AYprtlocmax
     C                   eval      ScnStr = AYprtloc(AYprtlocidx)
     C                   exsr      $InsSpcPrtCde
     C                   endfor
      *
     C                   return    RtnStr
      /space 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Retrieve list of print locations.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     C     $RtvPrtLoc    begsr
      /free
       //---------------------------------------------------------
       //Load print locations.

       CMappcat = 'DOCUMENTATION';
       CMappsub = 'PRINT LOCATION CODES';
       setll (CMappcat:CMappsub) ctlma01r;
       reade (CMappcat:CMappsub) ctlma01r I_ctlma;

       dow CMappdta <> *blanks;
C          if %lookup(CMappcd2:AYprtloc:1:AYprtlocmax) = *zero;
              AYprtlocmax          += 1;
              AYprtloc(AYprtlocmax) = CMappcd2;
C          endif;

           reade (CMappcat:CMappsub) ctlma01r I_ctlma;
       enddo;

       //---------------------------------------------------------
       //Load print color codes.

       CMappcat = 'DOCUMENTATION';
       CMappsub = 'PRINT COLOR CODES';
       setll (CMappcat:CMappsub) ctlma01r;
       reade (CMappcat:CMappsub) ctlma01r I_ctlma;

       dow CMappdta <> *blanks;
           if %lookup(CMappcd1:AYprtloc:1:AYprtlocmax) = *zero;
              AYprtlocmax          += 1;
              AYprtloc(AYprtlocmax) = CMappcd1;
           endif;

           reade (CMappcat:CMappsub) ctlma01r I_ctlma;
       enddo;

      /end-free
     C     #RtvPrtLoc    endsr
      /space 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Insert spaces between print codes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     C     $InsSpcPrtCde begsr
      * ---------------------------------------------------------
      *
      *    Insert blank after tag.
      *
     C                   eval      ScnTag = '<' + %trim(ScnStr) + '>'
     C                   exsr      $InsSpc
      *
      *    Insert blank before tag.
      *
     C                   eval      ScnTag = '</' + %trim(ScnStr) + '>'
     C                   exsr      $InsSpc
      *
     C     #InSpcPrtCde  endsr
      /space 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Insert space.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     C     $InsSpc       begsr
      * ---------------------------------------------------------
      *
      *    Determine string lengths.
      *
     C                   eval      str = 1
      *
     C                   do        *hival
     C                   eval      LenScnTag = %len(ScnTag)
     C                   eval      LenRtnStr = %len(RtnStr)
      * ---------------------------------------------------------
      *
      *    Assure that we don't overrun.
      *
     C                   if        %len(%trim(ScnTag)) >
     C                             %len(%trim(RtnStr))
     C                   leavesr
     C                   endif
      * ---------------------------------------------------------
      *
      *    Scan for value.
      *
     C                   eval      str = %scan(%trim(ScnTag):RtnStr:str)
     C                   if        str = *zero
     C                   leavesr
     C                   endif
      * ---------------------------------------------------------
      *
      *    Insert space.
      *
     C                   eval      RtnStr = %replace(' '+%trim(ScnTag)+' ':
     C                                      RtnStr:
     C                                      %scan(%trim(ScnTag):RtnStr:str):
     C                                      LenScnTag)
     C                   eval      str   += LenScnTag
     C                   enddo
      *
     C     #InsSpc       endsr
      *
     P InsSpcPrtCde    E
      ***********************************************************
      * ClnPrtLoc() -- Clean print location.
      ***********************************************************
     P ClnPrtLoc       B                   Export
      *
     D ClnPrtLoc       PI                  like(dfnRWprtloc)
     D  PLprtloc                           like(dfnRWprtloc) value
      *
      *  Standalone fields
      *
     D WKprtloc        ds                  likeds(t_ExtWords)
     D                                     based(pWKprtloc)
      *
     D x               s                   like(Stdint) inz
      * ---------------------------------------------------------
      *
      *    Test for no input.
      *
š1b€ C                   if        PLprtloc = *blanks
     C                   return    *blanks
š1e€ C                   endif
      * ---------------------------------------------------------
      *
      *    Extract the words
      *
     C                   eval      pWKprtloc = ExtWords(PLprtloc:' ,')
     C                   eval      PLprtloc = *blanks
      * ---------------------------------------------------------
      *
      *    Return the cleaned up value.
      *
š1b€ C                   for       x = 1 to WKprtloc.WordsMax
      *
š2b€ C                   if        PLprtloc = *blanks
     C                   eval      PLprtloc = %trim(WKprtloc.words(x))
š2b€ C                   else
     C                   eval      PLprtloc = %trim(PLprtloc) + ' ' +
     C                                        %trim(WKprtloc.words(x))
š2b€ C                   endif
š1e€ C                   endfor
      *
     C                   dealloc                 pWKprtloc
      *
     C                   return    PLprtloc
      *
     P ClnPrtLoc       E
      ***********************************************************
      * ChkPrtLoc() -- Check print location.
      ***********************************************************
     P ChkPrtLoc       B                   Export
      *
     D ChkPrtLoc       PI                  like(StdInd)
     D  FileName                           like(StdNam)      value
     D  PLprtloc                           like(dfnRWprtloc) value
      *
      *  Standalone fields
      *
     D WKprtloc        ds                  likeds(t_ExtWords)
     D                                     based(pWKprtloc)
      *
     D x               s                   like(StdInt) inz
      * ---------------------------------------------------------
      *
      *    Test for no input.
      *
š1b€ C                   if        PLprtloc = *blanks
     C                   return    *on
š1e€ C                   endif
      * ---------------------------------------------------------
      *
      *    Extract the words
      *
     C                   eval      pWKprtloc = ExtWords(PLprtloc:' ,')
      * ---------------------------------------------------------
      *
      *    Check the print code.
      *
š1b€ C                   for       x = 1 to WKprtloc.WordsMax
      *
     C                   if        not ChkCtlma('DOCUMENTATION':
     C                                       'PRINT LOCATION CODES':
     C                                       FileName:
     C                                       %trim(WKprtloc.words(x)))
      *
     C                   dealloc                 pWKprtloc
     C                   return    *off
š1e€ C                   endif
š1e€ C                   endfor
      *
     C                   dealloc                 pWKprtloc
      *
     C                   return    *on
      *
      /SPACE 3
      /COPY QCPYSRC,$PMsnd
      *
     P ChkPrtLoc       E
      * **********************************************************
      * AddSpcAftEndTag() -- Add space after end tag.
      * **********************************************************
     P AddSpcAftEndTag...
     P                 B                   Export
      *
     D AddSpcAftEndTag...
     D                 PI         32767    varying
     D  InpString                 32767    varying const
      *
     D strpos          s                   like(StdInt)
     D RtnString       s          32767    varying
      * ---------------------------------------------------------
      /free

         // -----------------------------------------------------
         //
         // Scan thru for end tags.
         //
         RtnString = %trim(InpString);
         strpos    = 1;

         dou  strpos = *zero;
           strpos = %scan('</':RtnString:strpos);

           if  strpos > *zero;
             strpos = %scan('>':RtnString:strpos);

             if   strpos                        > *zero    and
                  strpos+1 <= %len(%trim(RtnString))       and
                  %subst(RtnString:strpos+1:1) <> *blanks;
               RtnString = %trim(%replace('> ':RtnString:strpos:1));
             endif;
           endif;
         enddo;

         return %trim(RtnString);

      /End-Free
      *
     P AddSpcAftEndTag...
     P                 E
      * **********************************************************
      * AddSpcBfrBgnTag() -- Add space before beginning tag.
      * **********************************************************
     P AddSpcBfrBgnTag...
     P                 B                   Export
      *
     D AddSpcBfrBgnTag...
     D                 PI         32767    varying
     D  InpString                 32767    varying const
      *
     D strpos          s                   like(StdInt)
     D RtnString       s          32767    varying
      * ---------------------------------------------------------
      /free

         // -----------------------------------------------------
         //
         // Scan thru for begin tags.
         //
         RtnString = %trim(InpString);
         strpos    = 1;

         dou  strpos = *zero;
           strpos = %scan('<':RtnString:strpos);

           if strpos                        > *zero    and
              strpos+1 <= %len(%trim(RtnString))       and
              %subst(RtnString:strpos+1:1) <> '/'      and
              %subst(RtnString:strpos+1:1) <> *blanks;

             RtnString = %trim(%replace(' <':RtnString:strpos:1));
             strpos += 1;
           endif;

           if strpos > *zero;
             strpos += 1;
           endif;
         enddo;

         return %trim(RtnString);

      /End-Free
      *
     P AddSpcBfrBgnTag...
     P                 E
      * **********************************************************
      * AddSpcBfrAftTag() -- Add space before and after tags.
      * **********************************************************
     P AddSpcBfrAftTag...
     P                 B                   Export
      *
     D AddSpcBfrAftTag...
     D                 PI         32767    varying
     D  InpString                 32767    varying const
      *
     D strpos          s                   like(StdInt)
     D RtnString       s          32767    varying
      * ---------------------------------------------------------
      /free

         // -----------------------------------------------------
         //
         // Scan thru for begin tags.
         //
         RtnString = %trim(InpString);
         strpos    = 1;

         dou  strpos = *zero;
           strpos = %scan('<':RtnString:strpos);

           if strpos                        > *zero    and
              strpos+1 <= %len(%trim(RtnString))       and
              %subst(RtnString:strpos+1:1) <> *blanks;
             RtnString = %trim(%replace(' <':RtnString:strpos:1));
             strpos += 1;
           endif;

           if strpos > *zero;
             strpos += 1;
           endif;
         enddo;

         // -----------------------------------------------------
         //
         // Scan thru for end tags.
         //
         strpos    = 1;

         dou  strpos = *zero;
           strpos = %scan('<':RtnString:strpos);

           if  strpos > *zero;
             strpos = %scan('>':RtnString:strpos);

             if   strpos                        > *zero    and
                  strpos+1 <= %len(%trim(RtnString))       and
                  %subst(RtnString:strpos+1:1) <> *blanks;
               RtnString = %trim(%replace('> ':RtnString:strpos:1));
             endif;
           endif;
         enddo;

         return %trim(RtnString);

      /End-Free
      *
     P AddSpcBfrAftTag...
     P                 E
