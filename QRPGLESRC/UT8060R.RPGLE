      /TITLE Utility, Numeric (SrvPgm)
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
      *  01/23/06  TimH        Changed convert character to number to handle
      *                         SQL standard field types.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /copy qcpysrc,HspecSrv
      *
      /define DSpgm
      /copy qcpysrc,Dspec
      ***********************************************************
      * isNum() -- is numeric
      ***********************************************************
     P isNum           B                   Export
      *
     D isNum           PI                  like(StdInd)
     D  InpStr                             like(StdStr) const
      *
     D WrkStr          s                   like(InpStr)     inz
     D RtnInd          s                   like(StdInd)     inz
      * ---------------------------------------------------------
      *
      *    Test numeric after a trim.
      *
     C                   evalR     WrkStr = %trimr(InpStr)
     C                   testn                   WrkStr               999999
      *
     C                   eval      RtnInd = *in99
     C                   return    RtnInd
      *
     P isNum           E
      * **********************************************************
      *  InNum() -- Check values in a numeric list.
      * **********************************************************
     P InNum           B                   Export

     D InNum           PI                  like(StdInd)
     D  InNumCmp                           like(StdDec) const
     D  InNumLst01                         like(StdDec) const
     D  InNumLst02                         like(StdDec) const
     D                                     options(*nopass)
     D  InNumLst03                         like(StdDec) const
     D                                     options(*nopass)
     D  InNumLst04                         like(StdDec) const
     D                                     options(*nopass)
     D  InNumLst05                         like(StdDec) const
     D                                     options(*nopass)
     D  InNumLst06                         like(StdDec) const
     D                                     options(*nopass)
     D  InNumLst07                         like(StdDec) const
     D                                     options(*nopass)
     D  InNumLst08                         like(StdDec) const
     D                                     options(*nopass)
     D  InNumLst09                         like(StdDec) const
     D                                     options(*nopass)
     D  InNumLst10                         like(StdDec) const
     D                                     options(*nopass)

      /Free
       // --------------------------------------------------------
       //
       //   Extract the elements.
       //
        if InNumCmp = InNumLst01;
          return *on;
        endif;

        If %parms >= 3       and
           InNumCmp = InNumLst02;
          return *on;
        endif;

        If %parms >= 4       and
           InNumCmp = InNumLst03;
          return *on;
        endif;

        If %parms >= 5       and
           InNumCmp = InNumLst04;
          return *on;
        endif;

        If %parms >= 6       and
           InNumCmp = InNumLst05;
          return *on;
        endif;

        If %parms >= 7       and
           InNumCmp = InNumLst06;
          return *on;
        endif;

        If %parms >= 8       and
           InNumCmp = InNumLst07;
          return *on;
        endif;

        If %parms >= 9       and
           InNumCmp = InNumLst08;
          return *on;
        endif;

        If %parms >= 10      and
           InNumCmp = InNumLst09;
          return *on;
        endif;

        If %parms >= 11      and
           InNumCmp = InNumLst10;
          return *on;
        endif;

        return *off;

      /End-Free

     P InNum           E
      ***********************************************************
      * Digits() -- Convert numeric to string.
      ***********************************************************
     P Digits          B                   Export
      *
     D Digits          PI            30
     D  NumValue                     30 10               value
      *
     D RtnChar         S             30    inz
     D NumValue00      S             30  0
      * ---------------------------------------------------------
      *
      *    Test for no input.
      *
     C                   if        NumValue = *zero
     C                   return    *blanks
     C                   endif
      *
     C                   clear                   RtnChar
      *
      *    Remove decimals positions.
      *
     C                   move      NumValue      NumValue00
      *
      *    Convert to character (left justified).
      *
     C                   eval      RtnChar = %editc(NumValue00:'X')
      *
     C                   return    RtnChar
      *
     P Digits          E
      ***********************************************************
      * Num() -- Convert string to numeric data.
      ***********************************************************
     P Num             B                   Export
      *
     D Num             PI            30  0               opdesc
     D  CharValue                          like(StdSQL)  const
      *
     D RtnNum          S             30  0                inz
     D WrkString       S                    like(StdSQL)  inz
     D WrkString2      S                    like(StdSQL)  inz
     D Eidx            S                    like(StdLen)  inz
     D Iidx            S                    like(StdLen)  inz
     D Length          S                    like(StdLen)  inz
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
      *    Assure we can handle the length passed.
      *
     C                   if        InLen > %size(CharValue)
     C                   eval      InLen = %size(CharValue)
     C                   endif
      *
      *    Test for no input.
      *
     C                   if        %subst(CharValue:1:Inlen) = *blanks
     C                   return    *zero
     C                   endif
      *
      *    Extract the character value to the end of the string.
      *
     C                   eval      WrkString =
     C                             %trim(%subst(CharValue:1:InLen))
      *
      *    If there is no data then get out.
      *
     C                   if        WrkString  = *blanks
     C                   return    *zero
     C                   endif
      *
      *    Determine the number of actual characters.
      *
     C                   eval      NbrofChar  = %len(%trim(WrkString))
     C                   eval      WrkString2 = *blanks
      *
      *    Assure that only numeric values are passed back.
      *
     C                   do        NbrofChar     Eidx
     C                   if        %subst(WrkString:Eidx:1) >= '0' and
     C                             %subst(WrkString:Eidx:1) <= '9'
     C                   eval      Iidx += 1
     C                   eval      %subst(WrkString2:Iidx:1) =
     C                             %subst(WrkString:Eidx:1)
     C                   endif
     C                   enddo
      *
      *    Right justify the string.
      *
     C                   evalR     WrkString = %trimr(WrkString2)
      *
      *    Move into numeric return variable.
      *
     C                   move      WrkString     RtnNum
      *
     C                   return    RtnNum
      *
     P Num             E
      ***********************************************************
      * NumDec() -- Convert string to numeric data with decimals.
      ***********************************************************
     P NumDec          B                   Export
      *
     D NumDec          PI            30 10               opdesc
     D  CharValue                          like(StdSQL)  const
     D  NbrDec                             like(StdInt)  const
      *
     D RtnNum          S             30 10                inz
     D Negative        S                    like(StdInd)  inz
     D ChrRgtDec       S                    like(StdInt)  inz
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
     C                   return    *zero
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
     C                   if        Length    <= *zero  or
     C                             LeftByte  <= *zero  or
     C                             LeftByte  >= InLen
     C                   return    *zero
     C                   endif
      *
      *    Extract the character value to the end of the string.
      *
     C                   eval      WrkString =
     C                             %subst(CharValue:LeftByte:Length)
      *
      *    Determine the number of actual characters.
      *
     C                   eval      NbrofChar = %len(%trim(WrkString))
      *
      *    Determine if negative.
      *
     C                   if        %scan('-':WrkString) > *zero
     C                   eval      Negative = *on
     C                   endif
      *
      *    Set number of characters right of decimal.
      *
     C                   if        %scan('.':WrkString) > *zero
     C                   eval      ChrRgtDec =
     C                             %len(%trim(
     C                             %subst(WrkString:
     C                             %scan('.':WrkString)+1:%decpos(RtnNum))))
     C                   else
     C                   eval      ChrRgtDec = NbrDec
     C                   endif
      *
     C                   dow       ChrRgtDec < %decpos(RtnNum)
     C                   eval      NbrofChar += 1
     C                   eval      ChrRgtDec += 1
     C                   eval      WrkString = %trim(WrkString) + '0'
     C                   enddo
      *
     C                   dow       ChrRgtDec > %decpos(RtnNum)
     C                   eval      NbrofChar -= 1
     C                   eval      ChrRgtDec -= 1
     C                   eval      %subst(WrkString:ChrRgtDec:1) = ' '
     C                   enddo
      *
      *    Assure that only numeric values are passed back.
      *
     C                   do        NbrofChar     Eidx
      *
     C                   if        %subst(WrkString:Eidx:1) >= '0' and
     C                             %subst(WrkString:Eidx:1) <= '9'
     C                   eval      Iidx  += 1
     C                   eval      %subst(WrkString2:Iidx:1) =
     C                             %subst(WrkString:Eidx:1)
     C                   endif
     C                   enddo
      *
      *    Right justify the string.
      *
     C                   evalR     WrkString = %trimr(WrkString2)
      *
      *    Move into numeric return variable.
      *
     C                   move      WrkString     RtnNum
      *
      *    Make value negative.
      *
     C                   if        Negative
     C                   eval      RtnNum = -RtnNum
     C                   endif
      *
     C                   return    RtnNum
      *
     P NumDec          E
      ***********************************************************
      * CvtCharToNum() -- Convert character to numeric value.
      ***********************************************************
     P CvtCharToNum    B                   Export

     D CvtCharToNum    PI            30  9
     D  CharString                   40    Value

     D RcvAttr         DS
     D  Type                          1    Inz( X'03' )
     D  NbrLen                        5I 0
     D   DecPos                       3I 0 Overlay( NbrLen: 1 )
     D   TotDigits                    3I 0 Overlay( NbrLen: 2 )
     D                               10I 0 Inz

     D SymbolMask      DS
     D  CurSymbol                     1    Inz( '$' )
     D  ComSymbol                     1    Inz( ',' )
     D  DecPntSymbol                  1    Inz( '.' )

     D  Number         s             30  9 inz
      * ---------------------------------------------------------

     C                   eval      DecPos    = %DecPos( Number )
     C                   eval      TotDigits = %Len( Number )

     C                   CallP     CvtExtFrmToNum(
     C                                            %Addr( Number )         :
     C                                            RcvAttr                 :
     C                                            %Addr(CharString)       :
     C                                            %Len(%trimr(CharString)):
     C                                             SymbolMask)

     C                   Return    Number

     P CvtCharToNum    E
      * *********************************************************
      * CvtNumPakHex() -- Convert numeric to packed hex.
      * *********************************************************
     P CvtNumPakHex    B                   Export
      *
     D CvtNumPakHex    PI                  like(StdStr)
     D  CvtNumPak                          like(StdDec) const
     D  CvtNumLen                          like(StdInt) const
     D  CvtNumDec                          like(StdInt) const
      *
     D ExtPos          s                   like(StdInt) inz
     D ExtDec          s                   like(StdInt) inz
     D RtnStr          s                   like(StdStr) inz
      *
     D DSpack          ds                  inz
     D  Packed                 1     15p 0 packeven
      * ---------------------------------------------------------
      *
      *   Return value.
      *
     C                   eval      ExtDec = 10 ** CvtNumDec
     C                   eval      Packed = CvtNumPak * ExtDec
      *
     C                   eval      ExtPos = %dec(CvtNumLen/2) + 1
     C                   eval      ExtPos = 16 - Extpos
     C                   eval      RtnStr = %subst(DSpack:ExtPos)
      *
     C                   return    RtnStr
      *
     P CvtNumPakHex    E
      * *********************************************************
      * CvtNumZonHex() -- Convert numeric to zoned hex.
      * *********************************************************
     P CvtNumZonHex    B                   Export
      *
     D CvtNumZonHex    PI                  like(StdStr)
     D  CvtNumZon                          like(StdZon) const
     D  CvtNumLen                          like(StdInt) const
     D  CvtNumDec                          like(StdInt) const
      *
     D ExtPos          s                   like(StdInt) inz
     D ExtDec          s                   like(StdInt) inz
     D RtnStr          s                   like(StdStr) inz
      *
     D DSzone          ds                  inz
     D  Zoned                  1     15s 0
      * ---------------------------------------------------------
      *
      *   Return value.
      *
     C                   eval      ExtDec = 10 ** CvtNumDec
     C                   eval      Zoned  = CvtNumZon * ExtDec
      *
     C                   eval      ExtPos = %dec(CvtNumLen/2) + 1
     C                   eval      ExtPos = 16 - Extpos
     C                   eval      RtnStr = %subst(DSzone:ExtPos)
      *
     C                   return    RtnStr
      *
     P CvtNumZonHex    E
      * *********************************************************
      * RtvNamNbr() -- Retrieve name of a number.
      * *********************************************************
     P RtvNamNbr       B                   Export
      *
     D RtvNamNbr       PI                  like(StdStr)
     D  InpNbr                             like(StdInt) const
      * ---------------------------------------------------------
      *
      * Standalone fields
      *
     D AryNames        c                   'One      -
     D                                     Two      -
     D                                     Three    -
     D                                     Four     -
     D                                     Five     -
     D                                     Six      -
     D                                     Seven    -
     D                                     Eight    -
     D                                     Nine     -
     D                                     Ten      -
     D                                     Eleven   -
     D                                     Twelve   -
     D                                     Thirteen -
     D                                     Fourteen -
     D                                     Fifteen  -
     D                                     Sixteen  -
     D                                     Seventeen-
     D                                     Eighteen -
     D                                     Nineteen -
     D                                     Twenty   '
      *
     D RtnName         s                   like(StdStr) inz
      * ---------------------------------------------------------
      *
      *   Retrieve name of number.
      *
     C                   if        InpNbr  > *zero and
     C                             InpNbr <= 20
     C                   eval      RtnName =
     C                             %subst(AryNames:(InpNbr*9)-8:9)
     C                   else
     C                   eval      RtnName = %char(InpNbr)
     C                   endif
      *
     C                   return    RtnName
      *
     P RtvNamNbr       E
      ***********************************************************
      * CvtChrNum() -- Convert character to numeric.
      ***********************************************************
     P CvtChrNum       B                   Export
      *
     D CvtChrNum       PI                  like(StdMaxDec)
     D  ChrVar_p                           like(StdStr)      const
     D  FldTyp_p                           like(StdNam)      const
     D                                     options(*omit:*nopass)
     D  TotDig_p                           like(StdInt)      const
     D                                     options(*omit:*nopass)
     D  DecPos_p                           like(StdInt)      const
     D                                     options(*nopass)
      * -----------------------------------------------------
      *
      *   Conversion template:
      *
     D DPA_Template_T  DS                  Based(pDPA)
     D  SclTyp                             like(StdChr)
     D  RcvLen                             like(StdInt)
     D   DecPos                       3i 0 Overlay(RcvLen:1)
     D   TotDig                       3i 0 Overlay(RcvLen:2)
     D  Rsv                                like(StdInt)
      * -----------------------------------------------------
      *
      *   Late bound copy numeric variable:
      *
     D LBCPYNV         PR                  ExtProc('_LBCPYNV')
     D  Target                             like(StdPtr)           value
     D  Target_Tpl                         like(DPA_Template_T)   const
     D  Source                             like(StdPtr)           value
     D  Source_Tpl                         like(DPA_Template_T)   const
      *
      *    - with rounding:
      *
     D LBCPYNVR        PR                  extproc('_LBCPYNVR')
     D  Target                             like(StdPtr)           value
     D  Target_Tpl                         like(DPA_Template_T)   const
     D  Source                             like(StdPtr)           value
     D  Source_Tpl                         like(DPA_Template_T)   const
      * -----------------------------------------------------
      *
      *    Work variables.
      *
     D ChrVar          s                   like(StdStr)
     D FldTyp          s                   like(StdNam)
     D RtnVar          s                   like(StdMaxDec)
     D SrcTpl          s                   like(DPA_Template_T)
     D TgtTpl          s                   like(DPA_Template_T)
      * -----------------------------------------------------
      *
      *    Global constants: See QSYSINC/MIH.MICPTCOM:
      *
     D T_SIGNED        c                   x'00'
     D T_FLOAT         c                   x'01'
     D T_ZONED         c                   x'02'
     D T_PACKED        c                   x'03'
     D T_UNSIGNED      c                   x'0A'
      * ---------------------------------------------------------
      *
      *    Setup source variables.
      *
     C                   eval      pDPA   = %addr(SrcTpl)
     C                   eval      Rsv    = *zero
      * ---------------------------------------------------------
      *
      *    Set parameters.
      *
     C                   eval      ChrVar    = ChrVar_p
      *
     C                   if        %parms   >= 2
     C                   eval      FldTyp    = FldTyp_p
     C                   else
     C                   eval      FldTyp    = 'PACKED'
     C                   endif
      *
     C                   if        %parms   >= 3
     C                   eval      TotDig    = TotDig_p
     C                   else
     C                   eval      TotDig    = *zero
     C                   endif
      *
     C                   if        %parms   >= 4
     C                   eval      DecPos    = DecPos_p
     C                   else
     C                   eval      DecPos    = *zero
     C                   endif
      * ---------------------------------------------------------
      *
      *    Set field type.
      *
     C                   select
     C                   when      FldTyp = 'PACKED'    or
     C                             FldTyp = 'P'
     C                   eval      SclTyp = T_PACKED
      *
     C                   when      FldTyp = 'ZONED'     or
     C                             FldTyp = 'S'
     C                   eval      SclTyp = T_ZONED
      *
     C                   when      FldTyp = 'BINARY'    or
     C                             FldTyp = 'B'
     C                   eval      SclTyp = T_SIGNED
      *
     C                   when      FldTyp = 'FLOAT'     or
     C                             FldTyp = 'F'
     C                   eval      SclTyp = T_FLOAT
      *
     C                   when      FldTyp = 'UNSIGNED'  or
     C                             FldTyp = 'U'
     C                   eval      SclTyp = T_UNSIGNED
     C                   endsl
      * ---------------------------------------------------------
      *
      *    Setup target variable.
      *
     C                   eval      pDPA   = %addr(TgtTpl)
     C                   eval      SclTyp = T_PACKED
     C                   eval      TotDig = %len(RtnVar)
     C                   eval      DecPos = %decpos(RtnVar)
     C                   eval      Rsv    = *zero
      * ---------------------------------------------------------
      *
      *    Copy numeric variable.
      *
     C                   CallP     LBCPYNV(%addr(RtnVar):TgtTpl:
     C                                     %addr(ChrVar):SrcTpl)
      *
     C                   return    RtnVar
      *
     P CvtChrNum       E
      ***********************************************************
      * CntNumChr() -- Count numeric characters.
      ***********************************************************
     P CntNumChr       B                   Export
      *
     D CntNumChr       PI                  like(StdInt) opdesc
     D  String                             like(StdSQL) const
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
     C                   if        WrkArray(x) >= '0' and
     C                             WrkArray(x) <= '9'
     C                   eval      RtnCount    += 1
     C                   endif
     C                   enddo
      *
     C                   return    RtnCount
      *
     P CntNumChr       E
      ***********************************************************
      * EdtVar() -- Edit numeric value.
      ***********************************************************
     P EdtVar          B                   Export
      *
     D EdtVar          PI            22
     D  EditValue                    30 10                value
     D  EditCode_p                    1    const options(*omit:*nopass)
     D  NbrofDec_p                    2  0 const options(*omit:*nopass)
     D  Justify_p                    10    const options(*omit:*nopass)
     D  LeadSymbol_p                  1    const options(*omit:*nopass)
      *
      *  Standalone fields
      *
     D  EditCode       S                   like(EditCode_p)
     D  NbrofDec       S                   like(NbrofDec_p)
     D  Justify        S                   like(Justify_p)
     D  LeadSymbol     S                   like(LeadSymbol_p)
      *
     D RtnChr          S             22                   inz
     D EditValuePos    S             30  0                inz
     D EditValueChr    S             30                   inz
     D wk001a          S                    like(StdChr ) inz
     D InsertDigit     S                    like(StdInd ) inz
     D PosVal          S                    like(StdInd ) inz
     D CurChrPos       S                    like(StdLen ) inz
     D CurDecPos       S                    like(StdLen ) inz
      * ---------------------------------------------------------
      *
      *    Check for omitted parameters.
      *
     C                   eval      EditCode   = *blanks
     C                   eval      NbrofDec   = *zero
     C                   eval      Justify    = *blanks
     C                   eval      LeadSymbol = *blanks
      *
     C                   if        %parms    >= 2
     C                   callp     CEETSTA(ParmPassed:2:*omit)
     C                   if        ParmPassed = 1
     C                   eval      EditCode   = EditCode_p
     C                   endif
     C                   endif
      *
     C                   if        %parms    >= 3
     C                   callp     CEETSTA(ParmPassed:3:*omit)
     C                   if        ParmPassed = 1
     C                   eval      NbrofDec   = NbrofDec_p
     C                   endif
     C                   endif
      *
     C                   if        %parms    >= 4
     C                   callp     CEETSTA(ParmPassed:4:*omit)
     C                   if        ParmPassed = 1
     C                   eval      Justify    = Justify_p
     C                   endif
     C                   endif
      *
     C                   if        %parms    >= 5
     C                   callp     CEETSTA(ParmPassed:5:*omit)
     C                   if        ParmPassed = 1
     C                   eval      LeadSymbol = LeadSymbol_p
     C                   endif
     C                   endif
      * ---------------------------------------------------------
      *
      *    Edit variable 2.
      *
     C                   eval      RtnChr = EdtVar2(EditValue:
     C                                              EditCode:
     C                                              NbrofDec:
     C                                              Justify:
     C                                              LeadSymbol)
      *
     C                   return    RtnChr
      * =========================================================
      *
      *    Set defaults.
     C                   if        EditCode = *blanks
     C                   eval      EditCode = 'Z'
     C                   endif
      * ---------------------------------------------------------
      *
      *    W, Y, Z cannot have decimals.
      *
     C                   if         NbrofDec <> *zero   and
     C                             (EditCode  = 'W'     or
     C                              EditCode  = 'Y'     or
     C                              EditCode  = 'Z')
     C                   eval      msgid  = 'GNL0063'
     C                   eval      torel  = '*PRV'
     C                   exsr      $PMsnd
     C                   return    *blanks
     C                   endif
      *
      *    If there is no value, then edited value is blank.
      *
     C                   if         EditValue = *zero    and
     C                             (EditCode  = '4'      or
     C                              EditCode  = 'D'      or
     C                              EditCode  = 'M'      or
     C                              EditCode  = 'Q'      or
     C                              EditCode  = 'Z')
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *    Initialize variables.
      *
     C                   eval      RtnChr      = *blanks
     C                   eval      InsertDigit = *off
     C                   eval      CurChrPos   = 1
     C                   eval      CurDecPos   = NbrofDec + 1
      * ---------------------------------------------------------
      *
      *    Adjust out fixed decimal positions (30.10 to 30.0)
      *
     C                   eval      EditValuePos =
     C                             EditValue * (10 ** NbrofDec)
      *
      *                  Sometimes above code causes a round down:
      *                  "1964."   becomes   ".1963999999"
      *
     C                   if        NbrofDec > *zero              and
     C                             %subst(%char(EditValuePos):
     C                                     %len(EditValuePos):4) = '9999'
     C                   eval      EditValuePos += .000001
     C                   endif
      * ---------------------------------------------------------
      *
      *    Setup positive value and character equivelant.
      *
     C                   if        EditValue >= *zero
     C                   eval      PosVal     = *on
     C                   else
     C                   eval      EditValuePos = -EditValuePos
     C                   eval      PosVal       = *off
     C                   endif
      * ---------------------------------------------------------
      *
     C                   move      EditValuePos  EditValueChr
      *
      *    Set currency symbol.
      *
     C                   if        LeadSymbol <> *blanks
     C                   eval      RtnChr     =  LeadSymbol
     C                   endif
      * ---------------------------------------------------------
      *
      *    Set lead sign.
      *
     C                   if         EditValue < *zero  and
     C                             (EditCode  = 'N'    or
     C                              EditCode  = 'O'    or
     C                              EditCode  = 'P'    or
     C                              EditCode  = 'Q')
     C                   eval      RtnChr = %trim(RtnChr) + '-'
     C                   endif
      * ---------------------------------------------------------
      *
     C                   dou       CurChrPos = 31
      *
      *                  Insert decimal seperator.
      *
     C                   if        31 - CurChrPos = NbrofDec
     C                   eval      RtnChr = %trim(RtnChr) + '.'
     C                   eval      InsertDigit = *on
     C                   endif
      *
      *                  Insert digit.
      *
     C                   eval      wk001a = %subst(EditValueChr:CurChrPos)
      *
     C                   if        InsertDigit    or
     C                             WK001a      <> '0'
     C                   eval      RtnChr       = %trim(RtnChr) + wk001a
     C                   eval      InsertDigit  = *on
      *
      *                  Insert decimal seperator character.
      *
     C                   if        (EditCode  =  'J'    or
     C                              EditCode  =  'K'    or
     C                              EditCode  =  'N'    or
     C                              EditCode  =  'O')   and
     C                             (CurDecPos =  18     or
     C                              CurDecPos =  21     or
     C                              CurDecPos =  27     or
     C                              CurDecPos =  27 )
     C                   eval      RtnChr = %trim(RtnChr) + ','
     C                   endif
      *
      *                  Insert time/date seperator character.
      *
     C                   if        CurDecPos = 26  or
     C                             CurDecPos = 28
     C                   select
     C                   when      EditCode = 'W'
     C                   eval      RtnChr = %trim(RtnChr) + ':'
     C                   when      EditCode = 'Y'
     C                   eval      RtnChr = %trim(RtnChr) + '/'
     C                   endsl
     C                   endif
      *
     C                   endif
      *
     C                   eval      CurChrPos += 1
     C                   eval      CurDecPos += 1
      *
      *                  If its the last character insert the digit.
      *
     C                   if          CurChrPos = 30
     C                   eval      InsertDigit = *on
     C                   endif
      *
     C                   enddo
      * ---------------------------------------------------------
      *
      *    Set trailing sign.
      *
     C                   if         EditValue < *zero   and
     C                             (EditCode  = 'J'     or
     C                              EditCode  = 'K'     or
     C                              EditCode  = 'L'     or
     C                              EditCode  = 'M')
     C                   eval      RtnChr = %trim(RtnChr) + '-'
     C                   endif
      * ---------------------------------------------------------
      *
      *    Justify left/right/column.
      *
     C                   select
     C                   when      Justify = '*LEFT'     or
     C                             Justify = '*L'
     C                   eval      RtnChr  = %trim(RtnChr)
      *
     C                   when      Justify = '*RIGHT'    or
     C                             Justify = '*R'
     C                   evalR     RtnChr  = %trimr(RtnChr)
      *
     C                   when      Justify = '*COLUMN'   or
     C                             Justify = '*C'
     C                   if        PosVal
     C                   eval      RtnChr  = %trim(RtnChr) + x'FF'
     C                   evalR     RtnChr  = %trimr(RtnChr)
     C                   eval      %subst(RtnChr:22) = *blanks
     C                   else
     C                   evalR     RtnChr  = %trimr(RtnChr)
     C                   endif
     C                   endsl
      *
     C                   return    RtnChr
      *
      /undefine $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P EdtVar          E
      ***********************************************************
      * EdtVar2() -- Edit variable.
      ***********************************************************
     P EdtVar2         B                   Export
      *
     D EdtVar2         PI            22
     D  EditValue_p                  30 10                value
     D  EditCode_p                    1    const options(*omit:*nopass)
     D  NbrofDec_p                    2  0 const options(*omit:*nopass)
     D  Justify_p                    10    const options(*omit:*nopass)
     D  LeadSymbol_p                  1    const options(*omit:*nopass)
      * ---------------------------------------------------------
      *
      *   QECCVTEC() -- Convert edit code.
      *
     D QECCVTEC        PR                  ExtPgm('QECCVTEC')
     D  EditMask                    256a   options(*varsize)
     D  EdtMskLen                          like(StdInt)
     D  RcvVarLen                          like(StdInt)
     D  ZeroFill                           like(StdChr)
     D  EditCode                           like(StdChr) const
     D  FillChar                           like(StdChr) const
     D  Digits                             like(StdInt) const
     D  DecPos                             like(StdInt) const
     D  ApiError                           likeds(DSec)
      * ---------------------------------------------------------
      *
      *   QECEDT() -- Edit.
      *
     D QECEDT          PR                  ExtPgm('QECEDT')
     D  EditValue                   256a   options(*varsize)
     D  EditLen                            like(StdInt)      const
     D  Value                        30p10                   const
     D  DataType                           like(StdNam)      const
     D  FldLen                             like(StdInt)      const
     D  EditMask                    256a   options(*varsize)
     D  EditMastLen                        like(StdInt)      const
     D  FillChar                           like(StdChr)      const
     D  ApiError                           likeds(DSec)
      *
      *   QECEDT8() -- Edit date/time.
      *
     D QECEDT8         PR                  ExtPgm('QECEDT')
     D  EditValue                   256a   options(*varsize)
     D  EditLen                            like(StdInt)      const
     D  Value                         8p 0                   const
     D  DataType                           like(StdNam)      const
     D  FldLen                             like(StdInt)      const
     D  EditMask                    256a   options(*varsize)
     D  EditMastLen                        like(StdInt)      const
     D  FillChar                           like(StdChr)      const
     D  ApiError                           likeds(DSec)
      * ---------------------------------------------------------
      *
      *  Standalone fields
      *
     D EditValue       s             30p10              inz
     D EditValue8      s              8p 0              inz
     D EditValue30     s             30p 0              inz
     D EditValueLen    s                   like(StdInt) inz
     D EditValueDec    s                   like(StdInt) inz
     D EditCode        s                   like(StdChr) inz
     D NbrofDec        s                   like(StdInt) inz
     D Justify         s                   like(StdNam) inz
     D LeadSymbol      s                   like(StdChr) inz
      *
     D RtnChr22        s             22a                inz
     D RtnChr          s            256a                inz
     D EditMask        s            256a                inz
     D EditMaskLen     s                   like(StdInt) inz(%size(EditMask))
     D EditMaskOut     s                   like(StdInt) inz
     D RtnChrLen       s                   like(StdInt) inz(%len(RtnChr))
     D ZeroBalance     s                   like(StdChr) inz
     D ApiError        ds                  likeds(DSec) inz
     D dec             s                   like(StdInt) inz
     D neg             s                   like(StdInt) inz
      *
     D ZZmsgid         s                   like(msgid) inz
      * ---------------------------------------------------------
      *
      *    Check for omitted parameters.
      *
     C                   eval      EditCode   = *blanks
     C                   eval      NbrofDec   = *zero
     C                   eval      Justify    = '*L'
     C                   eval      LeadSymbol = *blanks
      *
     C                   if        %parms    >= 2
     C                   callp     CEETSTA(ParmPassed:2:*omit)
     C                   if        ParmPassed = 1
     C                   eval      EditCode   = EditCode_p
     C                   endif
     C                   endif
      *
     C                   if        %parms    >= 3
     C                   callp     CEETSTA(ParmPassed:3:*omit)
     C                   if        ParmPassed = 1
     C                   eval      NbrofDec   = NbrofDec_p
     C                   endif
     C                   endif
      *
     C                   if        %parms    >= 4
     C                   callp     CEETSTA(ParmPassed:4:*omit)
     C                   if        ParmPassed = 1
     C                   eval      Justify    = Justify_p
     C                   endif
     C                   endif
      *
     C                   if        %parms    >= 5
     C                   callp     CEETSTA(ParmPassed:5:*omit)
     C                   if        ParmPassed = 1
     C                   eval      LeadSymbol = LeadSymbol_p
     C                   endif
     C                   endif
      * ---------------------------------------------------------
      *
      *    Set defaults.
     C                   if        EditCode = *blanks
     C                   eval      EditCode = 'Z'
     C                   endif
      * ---------------------------------------------------------
      *
      *    W, Y, Z cannot have decimals.
      *
     C                   if         NbrofDec <> *zero   and
     C                             (EditCode  = 'Y'     or
     C                              EditCode  = 'Z')
     C                   eval      msgid  = 'GNL0063'
     C                   eval      torel  = '*PRV'
     C                   exsr      $PMsnd
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *    If there is no value, then edited value is blank.
      *
     C                   if         EditValue_p = *zero    and
     C                             (EditCode    = '4'      or
     C                              EditCode    = 'D'      or
     C                              EditCode    = 'M'      or
     C                              EditCode    = 'Q'      or
     C                              EditCode    = 'Z')
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *   Setup value to be edited.
      *
     C                   if        EditCode     = 'Y'
     C                   eval      EditValue8   = EditValue_p
     C                   eval      EditValueLen = %len(EditValue8)
     C                   eval      EditValueDec = %decpos(EditValue8)
     C                   else
     C                   eval      EditValue    = EditValue_p
     C                   eval      EditValueLen = %len(EditValue)
     C                   eval      EditValueDec = %decpos(EditValue)
     C                   endif
      * ---------------------------------------------------------
      *
      *   Convert edit code.
      *
     C                   reset                   ApiError
     C                   eval      EditMask = *blanks
      *
     C                   callp     QECCVTEC(EditMask:
     C                                      EditMaskLen:
     C                                      EditMaskOut:
     C                                      ZeroBalance:
     C                                      EditCode:
     C                                      LeadSymbol:
     C                                      EditValueLen:
     C                                      EditValueDec:
     C                                      ApiError)
      * ---------------------------------------------------------
      *
      *   Edit.
      *
     C                   select
     C                   when      EditCode   = 'Y'
     C                   eval      EditValue8 = EditValue_p
     C                   eval      RtnChr = %editc(EditValue8:'Y')
      *
     C                   when      EditCode    = 'Z'
     C                   eval      EditValue30 = EditValue_p
     C                   eval      RtnChr = %char(EditValue30)
      *
     C                   other
     C                   callp     QECEDT(RtnChr:
     C                                    EditMaskOut:
     C                                    EditValue:
     C                                    '*PACKED':
     C                                    EditValueLen:
     C                                    EditMask:
     C                                    EditMaskLen:
     C                                    ZeroBalance:
     C                                    ApiError)
     C                   endsl
      * ---------------------------------------------------------
      *
      *    Correct number of decimals.
      *
     C                   eval      dec = %scan('.':RtnChr)
      *
     C                   if        NbrofDec <> *zero
     C                   eval      dec += NbrofDec + 1
     C                   endif
      *
     C                   if        dec <> *zero
     C                   eval      neg = %scan('-':RtnChr:dec)
     C                   eval      %subst(RtnChr:dec) = *blanks
      *
     C                   if        neg <> *zero
     C                   eval      RtnChr = %trim(RtnChr) + '-'
     C                   endif
     C                   endif
      * ---------------------------------------------------------
      *
      *    Justify left/right/column.
      *
     C                   select
     C                   when      Justify  = '*LEFT'     or
     C                             Justify  = '*L'        or
     C                             Justify  = *blanks
     C                   eval      RtnChr22 = %trim(RtnChr)
      *
     C                   when      Justify  = '*RIGHT'    or
     C                             Justify  = '*R'
     C                   evalR     RtnChr22 = %trimr(RtnChr)
      *
     C                   when      Justify = '*COLUMN'   or
     C                             Justify = '*C'
      *
     C                   if        EditValue >= *zero
     C                   evalR     RtnChr22 = %trimr(RtnChr)
     C                   eval      RtnChr22 = %trim(RtnChr22) + x'FF'
     C                   evalR     RtnChr22 = %trimr(RtnChr22)
     C                   eval      %subst(RtnChr22:%len(RtnChr22)) = *blanks
     C                   else
     C                   evalR     RtnChr22 = %trimr(RtnChr)
     C                   endif
     C                   endsl
      *
     C                   return    RtnChr22
      *
      /undefine $PMSND_copied
      /copy qcpysrc,$PMsnd
      *
     P EdtVar2         E
      ***********************************************************
      * ExtractNum() -- Extract numerics from string.
      ***********************************************************
     P ExtractNum      B                   export

     D ExtractNum      PI            30  0
     D   Input                             like(StdTxt) const

     D WrkString       s                   like(StdTxt) inz
     D x               s                   like(StdInt)
      /free

       WrkString = input;

       x = %check('0123456789': WrkString);

       dow x <> *zero;
         WrkString = %replace('': WrkString: x: 1);
         x = %check('0123456789': wrkString);
       enddo;

       return %dec(WrkString: 30: 0);

      /end-free
     P ExtractNum      E
      ***********************************************************
      * NumDec2() -- Convert string to numeric data with decimals.
      * -- *NODECS = No decimals are sometimes passed.
      ***********************************************************
     P NumDec2         B                   Export
      *
     D NumDec2         PI            30 10               opdesc
     D  CharValue                          like(StdSQL)  const
     D  NbrDec                             like(StdInt)  const
     D  Options                            like(StdStr)  const
     D                                     options(*nopass)
      *
     D RtnNum          S             30 10                inz
     D Negative        S                    like(StdInd)  inz
     D ChrRgtDec       S                    like(StdInt)  inz
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
     D NoDecs          S                    like(StdInd)  inz
      * ---------------------------------------------------------
      *
      *    Determine if the no decimals option is set.
      *
     C                   if        %parms >= 3                and
     C                             %scan('*NODECS':options) > *zero
     C                   eval      NoDecs = *on
     C                   endif
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
     C                   return    *zero
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
     C                   if        Length    <= *zero  or
     C                             LeftByte  <= *zero  or
     C                             LeftByte  >= InLen
     C                   return    *zero
     C                   endif
      *
      *    Extract the character value to the end of the string.
      *
     C                   eval      WrkString =
     C                             %subst(CharValue:LeftByte:Length)
      *
      *    Determine the number of actual characters.
      *
     C                   eval      NbrofChar = %len(%trim(WrkString))
      *
      *    Determine if negative.
      *
     C                   if        %scan('-':WrkString) > *zero
     C                   eval      Negative = *on
     C                   endif
      *
      *    Set number of characters right of decimal.
      *
     C                   if        %scan('.':WrkString) > *zero
     C                   eval      ChrRgtDec =
     C                             %len(%trim(
     C                             %subst(WrkString:
     C                             %scan('.':WrkString)+1:%decpos(RtnNum))))
     C                   else
      *
      *    No decimals option.
      *
     C                   if        NoDecs
     C                   eval      ChrRgtDec = *zero
     C                   else
     C                   eval      ChrRgtDec = NbrDec
     C                   endif
     C                   endif
      *
     C                   dow       ChrRgtDec < %decpos(RtnNum)
     C                   eval      NbrofChar += 1
     C                   eval      ChrRgtDec += 1
     C                   eval      WrkString = %trim(WrkString) + '0'
     C                   enddo
      *
     C                   dow       ChrRgtDec > %decpos(RtnNum)
     C                   eval      NbrofChar -= 1
     C                   eval      ChrRgtDec -= 1
     C                   eval      %subst(WrkString:ChrRgtDec:1) = ' '
     C                   enddo
      *
      *    Assure that only numeric values are passed back.
      *
     C                   do        NbrofChar     Eidx
      *
     C                   if        %subst(WrkString:Eidx:1) >= '0' and
     C                             %subst(WrkString:Eidx:1) <= '9'
     C                   eval      Iidx  += 1
     C                   eval      %subst(WrkString2:Iidx:1) =
     C                             %subst(WrkString:Eidx:1)
     C                   endif
     C                   enddo
      *
      *    Right justify the string.
      *
     C                   evalR     WrkString = %trimr(WrkString2)
      *
      *    Move into numeric return variable.
      *
     C                   move      WrkString     RtnNum
      *
      *    Make value negative.
      *
     C                   if        Negative
     C                   eval      RtnNum = -RtnNum
     C                   endif
      *
     C                   return    RtnNum
      *
     P NumDec2         E
      ***********************************************************
      * CharToNum() -- Convert character to numeric value.
      ***********************************************************
     P CharToNum       B                   export

     D CharToNum       PI            30  9
     D  InString                    256    const
     D  InFormat                      3    const options(*nopass)

     D DPA_Template    ds
     D  DPA_type                      1    inz(t_packed)
     D  DPA_len                       5i 0
     D    DPA_decpos                  3i 0 overlay(DPA_len:1) inz(9)
     D    DPA_length                  3i 0 overlay(DPA_len:2) inz(30)
     D  DPA_res                      10i 0 inz

     D cvtefn          pr                  extproc('_CVTEFN')
     D  pRtnValue                      *   value
     D  DPA_Templ                          const like(DPA_template)
     D  CharValue                   256    const
     D  nCharValueLen                10u 0 const
     D  EditMask                      3    const

     D x               s                   like(StdInt)   inz
     D WkString        s                   like(InString) inz
     D RtnValue        s             30  9 inz
     D t_packed        c                   x'03'
     D dftEditMask     c                   '$,.'
     D szEditMask      s              3    inz(dftEditMask)
     D VldChar         s             15    inz('-0123456789')
      /free

       // Set editmask if passed.

       if %parms    >= 2;
          szEditMask = InFormat;
       endif;

       // Extract non-numerics.

       WkString = InString;
       VldChar  = %trim(VldChar) + szEditMask;

       x = %check(VldChar:WkString);

       dow x <> *zero;
           WkString = %replace('':WkString:x:1);
           x = %check(VldChar:WkString);
       enddo;

       // Convert character to numeric.

       monitor;
         cvtefn(%addr(RtnValue):
                DPA_Template:
                %trim(WkString):
                %len(%trim(WkString)):
                szEditMask);
       on-error;
         return *zero;
       endmon;

       return RtnValue;

      /end-free
     P CharToNum       E
      ***********************************************************
      * NumDte() - Convert string to numeric date.
      ***********************************************************
     P NumDte          B                   Export
      *
     D NumDte          PI                  like(NumISO)
     D  CharValue                          like(AlpMDY) const
      *
     D RtnDte          S                    like(NumISO)  inz
     D WrkString       S                    like(AlpMDY)  inz
     D Eidx            S                    like(StdInt)  inz
     D Iidx            S                    like(StdInt)  inz
      * ---------------------------------------------------------
      *
      *    Test for no input.
      *
     C                   if        CharValue = *blanks
     C                   return    *zero
     C                   endif
      *
      *    Assure that only numeric values are passed back.
      *
     C                   for       Eidx   = 1 to 8
      *
     C                   if        %subst(CharValue:Eidx:1) >= '0' and
     C                             %subst(CharValue:Eidx:1) <= '9'
      *
     C                   eval      Iidx += 1
     C                   eval      %subst(WrkString:Iidx:1) =
     C                             %subst(CharValue:Eidx:1)
     C                   endif
     C                   endfor
      *
      *    Right justify the string.
      *
     C                   evalR     WrkString = %trimr(WrkString)
      *
      *    Move into numeric return variable.
      *
     C                   move      WrkString     RtnDte
      *
     C                   return    RtnDte
      *
     P NumDte          E
