      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Numeric prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *  isNum() -- Is numeric.
      *
     D isNum           PR                  like(StdInd)
     D  InpStr                             like(StdStr) const
      * ---------------------------------------------------------
      *  InNum() -- Check values in a numeric list.
      *
     D InNum           PR                  like(StdInd)
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
      * ---------------------------------------------------------
      *  Digits() -- Convert digits to string.
      *
     D Digits          PR            30
     D  NumValue                     30 10 value
      * ---------------------------------------------------------
      *  Num() -- Convert string to numeric.
      *
     D Num             PR            30  0              opdesc
     D  CharValue                          like(StdSQL) const
      * ---------------------------------------------------------
      * ExtractNum() -- Extract numerics from string.
      *
     D ExtractNum      PR            30  0
     D  Input                              like(StdTxt) const
      * ---------------------------------------------------------
      *  NumDec() -- Convert string to numeric with decimals.
      *
     D NumDec          PR            30 10              opdesc
     D  CharValue                          like(StdSQL) const
     D  NbrDec                             like(StdInt) const
      * ---------------------------------------------------------
      *  NumDec2() -- Convert string to numeric with decimals.
      *
     D NumDec2         PR            30 10              opdesc
     D  CharValue                          like(StdSQL) const
     D  NbrDec                             like(StdInt) const
     D  Options                            like(StdStr) const
0021 D                                     options(*nopass)
      * ---------------------------------------------------------
      *  CvtCharToNum() -- Convert character to numeric value.
      *
     D CvtCharToNum    PR            30  9
     D                               40    value
      * ---------------------------------------------------------
      *  CharToNum() -- Convert character to numeric value.
      *
0019 D CharToNum       PR            30  9
0020 D  InString                    256    const
0021 D  Format                        3    const options(*nopass)
      * ---------------------------------------------------------
      *  CvtFrmToNum() -- Convert external form to numeric value
      *
      *  - Receiver variable      Output
      *  - Receiver attributes    Input
      *  - Source string          Input
      *  - Source string length   Input
      *  - Symbol mask            Input
      *
     D CvtExtFrmToNum  PR                  ExtProc( '_CVTEFN' )
     D                                 *   value
     D                                7    Const
     D                                 *   Value
     D                               10u 0 Const
     D                                3    Const
      * ---------------------------------------------------------
      * CvtNumPakHex() -- Convert numeric to packed hex.
      *
     D CvtNumPakHex    PR                  like(StdStr)
     D  CvtNumPak                          like(StdDec) const
     D  CvtNumLen                          like(StdInt) const
     D  CvtNumDec                          like(StdInt) const
      * ---------------------------------------------------------
      * CvtNumZonHex() -- Convert numeric to zoned hex.
      *
     D CvtNumZonHex    PR                  like(StdStr)
     D  CvtNumZon                          like(StdZon) const
     D  CvtNumLen                          like(StdInt) const
     D  CvtNumDec                          like(StdInt) const
      * ---------------------------------------------------------
      * RtvNamNbr() -- Retrieve name of a number.
      *
     D RtvNamNbr       PR                  like(StdStr)
     D  InpNbr                             like(StdInt) const
      * ---------------------------------------------------------
      * CvtChrNum() -- Convert character to numeric.
      *  -- converts hex value to a numeric value, usually used
      *  -- when parsing down a buffer image.
      *
     D CvtChrNum       PR                  like(StdMaxDec)
     D  ChrVar                             like(StdStr) const
     D  FldTyp                             like(StdNam) const
     D                                     options(*omit:*nopass)
     D  TotDig                             like(StdInt) const
     D                                     options(*omit:*nopass)
     D  DecPos                             like(StdInt) const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      *  CntNumChr() -- Count numeric characters
      *
     D CntNumChr       PR                  like(StdInt) opdesc
     D  String                             like(StdSQL) const
      * ---------------------------------------------------------
      *  EdtVar() -- Edit variable
      *
     D EdtVar          PR            22
     D  EditValue                    30 10                value
     D  EditCode                      1    const options(*omit:*nopass)
     D  NbrofDec                      2  0 const options(*omit:*nopass)
     D  Justify                      10    const options(*omit:*nopass)
     D  LeadSymbol                    1    const options(*omit:*nopass)
      *
     D NbrDec          s              2  0 inz
     D EdtCde          s                   like(StdChr)  inz
      * ---------------------------------------------------------
      *   EdtVar2() -- Edit variable 2.
      *
     D EdtVar2         PR            22
     D  EditValue                    30 10                value
     D  EditCode                      1    const options(*omit:*nopass)
     D  NbrofDec                      2  0 const options(*omit:*nopass)
     D  Justify                      10    const options(*omit:*nopass)
     D  LeadSymbol                    1    const options(*omit:*nopass)
      * ---------------------------------------------------------
      * NumDte() -- Convert string to a ISO numeric date.
      *
     D NumDte          PR                  like(NumISO)
     D  CharValue                          like(AlpMDY) const
