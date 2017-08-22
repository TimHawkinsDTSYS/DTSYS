      /TITLE Utility, PNR (SrvPgm)
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
      * **********************************************************
      * SetPnrDlm() -- Set PNR delimiters.
      * **********************************************************
     P SetPnrDlm       B                   Export

     D SetPnrDlm       PI                  like(dfnBAcurpnr)
     D  CurPnr                             like(dfnBAcurpnr)   const
      *
     D CurWords        ds                  likeds(t_ExtWords)
     D                                     based(pCurWords)
      *
     D CurIdx          s                   like(StdInt) inz
     D MaxIdx          s                   like(StdInt) inz
      *
     D wrkPnr          s                   like(dfnBAcurpnr)
     D DatePos         s                   like(StdInt) inz
     D RtnPnr          s                   like(dfnBAcurpnr)
      * ---------------------------------------------------------
      *
      *   Return if nothing passed.
      *
     C                   if        CurPnr = *blanks
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *   Assure that dates are delimted by hyphens.
      *
     C                   eval      wrkPnr  = CurPnr
     C                   eval      DatePos = like('%/__/%':wrkPnr)
      *
     C                   dow       DatePos > *zero
     C                   eval      %subst(wrkPnr:DatePos  :1) = '-'
     C                   eval      %subst(wrkPnr:DatePos+3:1) = '-'
     C                   eval      DatePos = like('%/__/%':wrkPnr)
     C                   enddo
      * ---------------------------------------------------------
      *
      *   Extract words.
      *
     C                   eval      pCurWords = ExtWords(wrkPnr  :' ,/*')
      *
      *   Set cleaned up PNR.
      *
     C                   eval      RtnPnr = CurWords.words(1)
      *
     C                   if        CurWords.WordsMax > 1
      *
     C                   for       CurIdx = 2 to CurWords.WordsMax
     C                   eval      RtnPnr = %trim(RtnPnr) + '*' +
     C                                      CurWords.Words(CurIdx)
     C                   endfor
     C                   endif
      *
     C                   dealloc                 pCurWords
      *
     C                   return    RtnPnr
      *
      /copy qcpysrc,$PSSR
      *
     P SetPnrDlm       E
      * **********************************************************
      * SetPrvPnr() -- Set previous PNR
      * **********************************************************
     P SetPrvPnr       B                   Export

     D SetPrvPnr       PI                  like(dfnBAprvpnr)
     D  CurPnr                             like(dfnBAcurpnr)   const
     D  PrvCurPnr                          like(dfnBAcurpnr)   const
     D  PrvPnr                             like(dfnBAprvpnr)   const
      *
     D CurWords        ds                  likeds(t_ExtWords)
     D                                     based(pCurWords)
      *
     D PrvCurWords     ds                  likeds(t_ExtWords)
     D                                     based(pPrvCurWords)
      *
     D PrvWords        ds                  likeds(t_ExtWords)
     D                                     based(pPrvWords)
      *
     D AYCurWords      s                   like(dfnBAcurpnr) dim(10) inz
     D AYPrvCurWords   s                   like(dfnBAcurpnr) dim(10) inz
     D AYPrvWords      s                   like(dfnBAcurpnr) dim(10) inz
      *
     D x               s                   like(StdInt)      inz
     D MaxIdx          s                   like(StdInt)      inz
     D RtnPnr          s                   like(dfnBAprvpnr) inz
      * ---------------------------------------------------------
      *
      *   Extract words.
      *
     C                   eval      pCurWords    = ExtWords(CurPnr:' ,/*')
     C                   eval      pPrvCurWords = ExtWords(PrvCurPnr:' ,/*')
     C                   eval      pPrvWords    = ExtWords(PrvPnr:' ,/*')
      *
      *   Shift values from word structures to internal arrays.
      *    -- this is done to avoid referencing external structures
      *    -- that may not have been initialized.
      *
     C                   for       x = 1 to CurWords.WordsMax
     C                   eval      AYCurWords(x) = CurWords.Words(x)
     C                   endfor
      *
     C                   for       x = 1 to PrvCurWords.WordsMax
     C                   eval      AYPrvCurWords(x) = PrvCurWords.Words(x)
     C                   endfor
      *
     C                   for       x = 1 to PrvWords.WordsMax
     C                   eval      AYPrvWords(x) = PrvWords.Words(x)
     C                   endfor
      *
      *   Determine largest index of the three.
      *
     C                   eval      MaxIdx = CurWords.WordsMax
      *
     C                   if        PrvCurWords.WordsMax > MaxIdx
     C                   eval      MaxIdx = PrvCurWords.WordsMax
     C                   endif
      *
     C                   if        PrvWords.WordsMax > MaxIdx
     C                   eval      MaxIdx = PrvWords.WordsMax
     C                   endif
      *
      *   Deallocate word structures as they are not needed.
      *
     C                   dealloc                 pCurWords
     C                   dealloc                 pPrvCurWords
     C                   dealloc                 pPrvWords
      * ---------------------------------------------------------
      *
      *   Remove prevous values.
      *
     C                   for       x = 1 to MaxIdx
      *
     C                   if        AYPrvCurWords(x) =
     C                             AYCurWords(x)       or
     C                             AYPrvCurWords(x) =
     C                             AYPrvWords(x)
     C                   eval      AYPrvCurWords(x) = *blanks
     C                   endif
     C                   endfor
      * ---------------------------------------------------------
      *
      *   Insert PNR's that were removed.
      *
     C                   eval      RtnPnr = PrvPnr
      *
     C                   for       x = 1 to MaxIdx
      *
     C                   if        AYPrvCurWords(x) <> *blanks
      *
     C                   if        RtnPnr = *blanks
     C                   eval      RtnPnr = AYPrvCurWords(x)
     C                   else
     C                   eval      RtnPnr = %trim(RtnPnr) + '*' +
     C                                      AYPrvCurWords(x)
     C                   endif
     C                   endif
     C                   endfor
      *
     C                   return    RtnPnr
      *
      /copy qcpysrc,$PSSR
      *
     P SetPrvPnr       E
