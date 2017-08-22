      /TITLE Utility, String case (SrvPgm)
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
      * Convert string to upper case.
      ***********************************************************
     P Upper           B                   Export
      *
     D Upper           PI                  like(StdSQL)  opdesc
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
     C                   CALLP     CEEDOD(1         : DescType : DataType :
     C                                    DescInfo1 : DescInfo2: InLen    :
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
      *    Convert to upper case.
      *
     C                   eval      RtnString = %xlate(lowr:uppr:WrkString)
      *
     C                   return    RtnString
      *
     P Upper           E
      ***********************************************************
      * Convert string to lower case.
      ***********************************************************
     P Lower           B                   Export
      *
     D Lower           PI                  like(StdSQL)  opdesc
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
     C                   CALLP     CEEDOD(1         : DescType : DataType :
     C                                    DescInfo1 : DescInfo2: InLen    :
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
     C                   if        Length   <= *zero or
     C                             LeftByte <= *zero or
     C                             LeftByte >  InLen
     C                   return    *blanks
     C                   endif
      *
      *    Extract the character value to the end of the string.
      *
     C                   eval      WrkString =
     C                               %subst(CharValue:LeftByte:Length)
      *
      *    Convert to lower case.
      *
     C                   eval      RtnString = %xlate(uppr:lowr:WrkString)
      *
     C                   return    RtnString
      *
     P Lower           E
      ***********************************************************
      * CvtCase - Convert case
      ***********************************************************
     P CvtCase         B
     D CvtCase         PI         32765    Varying
     D InputStr                   32765    Const
     D                                     Varying
     D CvtType                       10    Const
     D APIError                     272    Options( *NoPass )
     D CCSIDIn                       10I 0 Const
     D                                     Options( *NoPass )
      *
      * - Data definitions
      *
     D CtlBlock        DS
     D  RqsType                      10I 0 Inz( 1 )
     D  RqsCCSID                     10I 0
     D  RqsCase                      10I 0
     D                               10    Inz ( *AllX'00' )
      *
     D OutputStr       S          32765    Varying
      *
     D FixedInputStr   S          32765
     D FixedOutputStr  S          32765
      *
     D NoAPIError      C                   Const( *Zero )
     D APIErrorPassed  S               N
      *
     D APIErrorDS      DS
     D  BytesProvided                10I 0 Inz( %Size( APIErrorDS ) )
     D  BytesAvail                   10I 0 Inz( *Zero )
     D  MsgID                         7    Inz( *Blanks )
     D                                1    Inz( X'00' )
     D  MsgDta                      256    Inz( *Blanks )
      *
      * - Determine whether API error parameter was passed                -
      *
š1b€ C                   If        %Parms > 2
     C                   Eval      APIErrorPassed = *On
š1e€ C                   Endif
      *
      * - Set conversion type                                             -
      *
š1b€ C                   Select
š1x€ C                   When      CvtType = '*UPPER'
     C                   Eval      RqsCase = *Zero
      *
š1x€ C                   When      CvtType = '*LOWER'
     C                   Eval      RqsCase = 1
š1e€ C                   Endsl
      *
      * - Convert case                                                    -
      *
     C                   Reset                   APIErrorDS
      *
š1b€ C                   If        %Parms > 3
     C                   Eval      RqsCCSID = CCSIDIn
š1x€ C                   Else
     C                   Eval      RqsCCSID = *Zero
š1e€ C                   Endif
      *
     C                   Eval      FixedInputStr = InputStr
     C                   Eval      FixedOutputStr = OutputStr
      *
     C                   CallP     CvtCaseAPI (
     C                               CtlBlock         :
     C                               FixedInputStr    :
     C                               FixedOutputStr   :
     C                               %Len( InputStr ) :
     C                               APIErrorDS)
      *
š1b€ C                   If        BytesAvail <> NoAPIError
     C                   ExSr      ReturnError
š1e€ C                   Endif
      *
     C                   Eval      OutputStr = FixedOutputStr
     C                   Eval      %Len( OutputStr ) = %Len( InputStr )
     C                   Return    OutputStr
      *
      * - Subroutine.... ReturnError                                      -
      * - Description... Return error condition to caller                 -
      *
     C     ReturnError   BegSr
      *
š1b€ C                   If        APIErrorPassed
     C                   Eval      APIError = APIErrorDS
š1e€ C                   Endif
      *
     C                   Return    *Blank
      *
     C                   EndSr
      *
     P CvtCase         E
      ***********************************************************
      * CvtToUpper() - Convert to uppercase
      ***********************************************************
     P CvtToUpper      B                   Export
      *
     D CvtToUpper      PI         32765    varying
     D InputStr                   32765    const
     D                                     varying
     D APIError                     272    options(*nopass)
      *
     D CCSIDIn                       10I 0 Const
     D                                     options(*nopass)
      *
      * - Data definitions
      *
     D OutputStr       S          32765    Varying
     D CCSID           S             10I 0 Inz
      *
     D NoAPIError      C                   const(*zero)
     D APIErrorPassed  S               N
      *
     D APIErrorDS      DS
     D  BytesProvided                10I 0 Inz( %Size( APIErrorDS ) )
     D  BytesAvail                   10I 0 Inz( *Zero )
     D  MsgID                         7    Inz( *Blanks )
     D                                1    Inz( X'00' )
     D  MsgDta                      256    Inz( *Blanks )
      *
      * - Determine whether API error parameter was passed                -
      *
š1b€ C                   If        %Parms > 1
     C                   Eval      APIErrorPassed = *On
š1e€ C                   Endif
      *
      * - Convert case                                                    -
      *
     C                   Reset                   APIErrorDS
      *
š1b€ C                   If        %Parms > 2
     C                   Eval      CCSID = CCSIDIn
š1e€ C                   Endif
      *
     C                   Eval      OutputStr = CvtCase (
     C                                          InputStr   :
     C                                          '*UPPER'   :
     C                                          APIErrorDS :
     C                                          CCSID)
      *
š1b€ C                   If        BytesAvail <> NoAPIError
     C                   ExSr      ReturnError
š1e€ C                   Endif
      *
     C                   Return    OutputStr
      *
      * - Subroutine.... ReturnError                                      -
      * - Description... Return error condition to caller                 -
      *
     C     ReturnError   BegSr
      *
     C                   Eval      APIError = APIErrorDS
      *
     C                   Return    *Blank
      *
     C                   EndSr
      *
     P CvtToUpper      E
      ***********************************************************
      * CvtToLower - Convert to lowercase
      ***********************************************************
     P CvtToLower      B                   Export
     D CvtToLower      PI         32765    Varying
     D InputStr                   32765    Const
     D                                     Varying
     D APIError                     272    Options( *NoPass )
     D CCSIDIn                       10I 0 Const
     D                                     Options( *NoPass )
      *
      * - Data definitions                                                -
      *
     D OutputStr       S          32765    Varying
     D CCSID           S             10I 0 Inz( *Zero )
      *
     D NoAPIError      C                   Const( *Zero )
     D APIErrorPassed  S               N
      *
     D APIErrorDS      DS
     D  BytesProvided                10I 0 Inz( %Size( APIErrorDS ) )
     D  BytesAvail                   10I 0 Inz( *Zero )
     D  MsgID                         7    Inz( *Blanks )
     D                                1    Inz( X'00' )
     D  MsgDta                      256    Inz( *Blanks )
      *
      * - Determine whether API error parameter was passed                -
      *
š1b€ C                   If        %Parms > 1
     C                   Eval      APIErrorPassed = *On
š1e€ C                   Endif
      *
      * - Convert case                                                    -
      *
     C                   Reset                   APIErrorDS
      *
š1b€ C                   If        %Parms > 2
     C                   Eval      CCSID = CCSIDIn
š1e€ C                   Endif
      *
     C                   Eval      OutputStr = CvtCase (
     C                                          InputStr   :
     C                                          '*LOWER'   :
     C                                          APIErrorDS :
     C                                          CCSID)
      *
š1b€ C                   If        BytesAvail <> NoAPIError
     C                   ExSr      ReturnError
š1e€ C                   Endif
      *
     C                   Return    OutputStr
      *
      * - Subroutine.... ReturnError                                      -
      * - Description... Return error condition to caller                 -
      *
     C     ReturnError   BegSr
      *
     C                   Eval      APIError = APIErrorDS
      *
     C                   Return    *Blank
      *
     C                   EndSr
      *
     P CvtToLower      E
      ***********************************************************
      * Convert string to title case.
      ***********************************************************
     P SetTtlCse       B                   Export
      *
     D SetTtlCse       PI                  like(StdSQL) opdesc
     D  CharValue                          like(StdSQL) const
     D  options                            like(StdStr) const
     D                                     options(*nopass)
      *
     D Name            S                    like(StdInd)  inz
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
     D wk001a          S                    like(StdChr)  inz
     D idx             S                    like(StdInt)  inz
      * ---------------------------------------------------------
      *
      *    Determine length of input string.
      *
     C                   CALLP     CEEDOD(1         : DescType : DataType :
     C                                    DescInfo1 : DescInfo2: InLen    :
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
      *    Test for options.
      *
     C                   if        %parms >= 2 and
     C                             %scan('*NAME':options) > *zero
     C                   eval      name = *on
     C                   endif
      * ---------------------------------------------------------
      *
      *    Convert to lower case.
      *
     C                   eval      WrkString = %xlate(uppr:lowr:WrkString)
      *
      *    Convert first letter to upper case.
      *
     C                   eval      %subst(WrkString:1:1) =
     C                             %xlate(lowr:uppr:%subst(WrkString:1:1))
      *
      *    Convert each word to upper case.
      *
     C                   for       idx     = 1 to 1023
     C                   eval      wk001a  = %subst(WrkString:idx+1:1)
      *
     C                   if        %subst(WrkString:idx:1) = *blanks and
     C                             wk001a <> *blanks
     C                   eval      %subst(WrkString:idx+1:1) =
     C                             %xlate(lowr:uppr:wk001a)
     C                   endif
     C                   endfor
      *
      *    Convert a few words to fully upper case.
      *
     C                   eval      idx = 1
      *
     C                   dow       %scan('-':WrkString:idx) > *zero
     C                   eval      idx = %scan('-':WrkString:idx) + 1
     C                   eval      %subst(WrkString:idx:1) =
     C                             %xlate(lowr:uppr:%subst(WrkString:idx:1))
     C                   enddo
      *
     C                   if        name
     C                   dow       %scan(' Ii ':WrkString) > 2
     C                   eval      WrkString =  %replace(' II ':WrkString:
     C                                          %scan(' Ii ':WrkString):4)
     C                   enddo
      *
     C                   dow       %scan(' Iii ':WrkString) > 2
     C                   eval      WrkString =  %replace(' III ':WrkString:
     C                                          %scan(' Iii ':WrkString):5)
     C                   enddo
      *
     C                   dow       %scan(' Iv ':WrkString) > 2
     C                   eval      WrkString =  %replace(' IV ':WrkString:
     C                                          %scan(' Iv ':WrkString):4)
     C                   enddo
     C                   endif
      *
     C                   dow       %scan(' Po ':WrkString) > 2
     C                   eval      WrkString =  %replace(' PO ':WrkString:
     C                                          %scan(' Po ':WrkString):4)
     C                   enddo
      *
      *    Convert a few words back to lower case.
      *
     C                   if        not name
     C                   dow       %scan(' A ':WrkString) > 2
     C                   eval      WrkString =  %replace(' a ':WrkString:
     C                                          %scan(' A ':WrkString):3)
     C                   enddo
     C                   endif
      *
     C                   dow       %scan(' Of ':WrkString) > 2
     C                   eval      WrkString =  %replace(' of ':WrkString:
     C                                          %scan(' Of ':WrkString):4)
     C                   enddo
      *
     C                   dow       %scan(' To ':WrkString) > 2
     C                   eval      WrkString = %replace(' to ':WrkString:
     C                                         %scan(' To ':WrkString):4)
     C                   enddo
      *
     C                   dow       %scan(' In ':WrkString) > 2
     C                   eval      WrkString = %replace(' in ':WrkString:
     C                                         %scan(' In ':WrkString):4)
     C                   enddo
      *
     C                   dow       %scan(' And ':WrkString) > 2
     C                   eval      WrkString = %replace(' and ':WrkString:
     C                                         %scan(' And ':WrkString):5)
     C                   enddo
      *
     C                   dow       %scan(' The ':WrkString) > 2
     C                   eval      WrkString = %replace(' the ':WrkString:
     C                                         %scan(' The ':WrkString):5)
     C                   enddo
      *
     C                   return    WrkString
      *
     P SetTtlCse       E
