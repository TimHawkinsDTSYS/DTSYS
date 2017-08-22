      /TITLE Retrieve DDS Source
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Retrieves DDS source.
      *
      *  Notes   :  none
      *
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  10/26/06  TimH        New program.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
      /COPY QCPYSRC,Hspec
     H*COPYRIGHT('(C) Alex Nubla of PGMR, Inc.  1998')
      *
     FQAFDACCP  IF   E             DISK
     FQAFDJOIN  IF   E             DISK    UsrOpn
     FQAFDSELO  IF   E             DISK    UsrOpn
     FQDDSSRC   UF A F   92        DISK
      *--------------------------------------------------------------*
      *
      *  Program Status Data Structure
      /define  DSpgm
      *
     D PGMDS          SDS
     D  Pgmq##           *PROC
     D  ErrorSts         *STATUS
     D  PrvStatus             16     20S 0
     D  SrcLinNum             21     28
     D  Routine          *ROUTINE
     D  NumParms         *PARMS
     D  ExcpType              40     42
     D  ExcpNum               43     46
      *
     D  PgmLib                81     90
     D  ExcpData              91    170
     D  ExcpId               171    174
     D  LastFile             201    208
     D  FileErr              209    243
     D  JobName              244    253
     D  User                 254    263
     D  JobNumA              264    269
     D  JobNum               264    269S 0
     D  JobDate              270    275S 0
     D  RunDate              276    281S 0
     D  RunTime              282    287S 0
     D  PgmCrtDt             288    293
     D  PgmCrtTm             294    299
     D  CmplrLvl             300    303
     D  SrcFile              304    313
     D  SrcLib               314    323
     D  SrcMbr               324    333
     D  ProcPgm              334    343
     D  ProcMod              344    353
      *--------------------------------------------------------------*
      *
      *  User space parameters
      *
     D @SpcName        S             10    Based(#SpcName)
     D #SpcName        S               *
      *
     D @SpcLib         S             10    Based(#SpcLib)
     D #SpcLib         S               *
      *
     D @SpcSize        S              9B 0 Based(#SpcSize)
     D #SpcSize        S               *
      *
     D @SpcPtr         S               *   Based(#SpcPtr)
     D #SpcPtr         S               *
      *
     D @MsgId          S              7    Based(#MsgId)
     D #MsgId          S               *
      *
     D @MsgDta         S            184    Based(#MsgDta)
     D #MsgDta         S               *

      *--------------------------------------------------------------*
      *
      *  Initial User Space Name & Library
      *
     D @UsNameLib      DS            20
     D  @UsName                      10    Inz('DBSPACE')
     D  @UsLib                       10    Inz('QTEMP')

      *--------------------------------------------------------------*
      *
      *  Fields used in List Record Formats (QUSLRCD) API
      *    and List Field (QUSLFLD) API
      *
     D @FormatR        S              8    Inz('RCDL0200')
     D @FormatF        S              8    Inz('FLDL0100')
     D @RecFmt         S             10    Inz
     D @OvrdPrc        S              1    Inz('1')
     D @QFile          S             20    Inz
     D @RecText        S             50    Inz
      *
      *  Format RCDL0200 List Data Section
      *
     D @Receiver1      DS            82
     D  @200Name                     10
     D  @200Id                       13
     D  @200Res1                      1
     D  @200RecLen                    9B 0
     D  @200NoFld                     9B 0
     D  @200Text                     50
      *
      *  Format FLDL0100 List Data Section
      *
     D @Receiver2      DS           268
     D  @100Field                    10
     D  @100Type                      1
     D  @100Use                       1
     D  @100OutBuf                    9B 0
     D  @100InBuf                     9B 0
     D  @100FldLen                    9B 0
     D  @100Digits                    9B 0
     D  @100DecPos                    9B 0
     D  @100FldTxt                   50
     D  @100EdtCde                    2
     D  @100EdwLen                    9B 0
     D  @100EdtWrd                   64
     D  @100ColHdg1                  20
     D  @100ColHdg2                  20
     D  @100ColHdg3                  20
     D  @100IntFld                   10
     D  @100Alias                    30
     D  @100AliasLn                   9B 0
     D  @100NoDBCS                    9B 0
     D  @100AlwNull                   1
     D  @100Host                      1
     D  @100DTFmt                     4
     D  @100DTSep                     1
     D  @100MIMap                     1

      *--------------------------------------------------------------*
      *
      *  Additional User Space parameters
      *
     D @ExtAttr        S             10    Inz('RTVDBSRC')
     D @InitValue      S              1    Inz(X'00')
     D @PubAut         S             10    Inz('*ALL')
     D @Text           S             50    Inz('User space for RTVDDSSRC')
     D @Replace        S             10    Inz('*NO')
     D @FrcToAux       S              1    Inz('1')
     D @StartPos       S              9B 0 Inz(1)
     D @StartEnt       S              9B 0 Inz(1)
     D @DataLen        S              9B 0 Inz(192)
     D @Size           S              9B 0 Inz(4096)
     D @Loop           S              5P 0
     D @BasePtr        S               *

      *--------------------------------------------------------------*
      *
      *  Record structure for error code parameter
      *
     D@ErrData         DS
     D  @BytesProv                    9B 0 Inz(200)
     D  @BytesAval                    9B 0
     D  @ExcpId                       7
     D  @Reserved1                    1
     D  @ExcpData                   184

      *--------------------------------------------------------------*
      *
      *  Change attribute parameters
      *
     D@ChgAttr         DS
     D  @NbrAttr                      9B 0 Inz(2)
      *
     D  @Attr2                        9B 0 Inz(2)
     D  @Attr2Len                     9B 0 Inz(1)
     D  @Attr2Dta                     1    Inz(X'00')
      *
     D  @Attr3                        9B 0 Inz(3)
     D  @Attr3Len                     9B 0 Inz(1)
     D  @Attr3Dta                     1    Inz('1')

      *--------------------------------------------------------------*
      *
      *  Generic Header Format 0100
      *
     D@GenHeader       DS                  Based(@SpcPtr)
     D  @QUserArea             1     64
     D  @QSzGenHdr            65     68B 0
     D  @QStrRelLv            69     72
     D  @QFmtName             73     80
     D  @QApiUsed             81     90
     D  @QDtTmCrtd            91    103
     D  @QInfoSts            104    104
     D  @QUsSize             105    108B 0
     D  @QOfstInp            109    112B 0
     D  @QSizeInp            113    116B 0
     D  @QOfstHdr            117    120B 0
     D  @QSzHdrSec           121    124B 0
     D  @QOfstLst            125    128B 0
     D  @QSizeLst            129    132B 0
     D  @QNoLstEnt           133    136B 0
     D  @QLstEntSz           137    140B 0
     D  @QCCSIdLst           141    144B 0
     D  @QCntryId            145    146
     D  @QLangId             147    149
     D  @QSubLstIn           150    150
     D  @QUsResrvd           151    192

      *--------------------------------------------------------------*
      *
      *  New source date
      *
     D                 ds
     D DateRtn                       32A
     D  NewDat                        6S 0 overlay(DateRtn:  1)

      *--------------------------------------------------------------*
      *
      *  New source record
      *
     DNewSource        ds                  Inz
     D  NsSeqNo                1      5    Inz
     D  NsFormType             6      6    Inz
     D  NsComment              7      7    Inz
     D  NsConditn              8     16    Inz
     D  NsNameType            17     17    Inz
     D  NsReservd1            18     18    Inz
     D  NsName                19     28    Inz
     D  NsRef                 29     29    Inz
     D  NsLen                 30     34    Inz
     D  NsDataType            35     35    Inz
     D  NsDec                 36     37    Inz
     D  NsUsage               38     38    Inz
     D  NsLocation            39     44    Inz
     D  NsKeyword             45     80    Inz
     D  NsLen#         S              5S 0 Inz
     D  NsDec#         S              2S 0 Inz

      *--------------------------------------------------------------*
      *
      *  Record Format array and information
      *
     D RfArray         DS
     D  RfInfo                       60    dim(99)
     D   RfName                      10    overlay(RfInfo:  1)
     D   RfText                      50    overlay(RfInfo: 11)
     D Rf#             S              3  0 Inz EXPORT
     D Lf#             S              3  0 Inz

      *--------------------------------------------------------------*
      *
      *  Physical File array - for logical file only
      *
     D PfArray         DS                  EXPORT
     D  PfInfo                       10    dim(32)
     D Pf#             S              3  0 Inz EXPORT
     D PfAccess        S              3  0 Inz EXPORT

      *--------------------------------------------------------------*
      *
      *  Join File array - for logical file only
      *
     D JfArray         DS                  EXPORT
     D  JfInfo                       10    dim(32)
     D Jf#             S              3  0 Inz EXPORT

      *--------------------------------------------------------------*
      *
      *  Text Line array
      *
     D LnArray         DS                  Inz
     D  Line1                        36
     D  Line2                        36
     D  Line3                        36
     D  Line4                        36
     D  Line5                        36
     D  Line6                        36
     D  Line7                        36
     D  Line8                        36
     D  Line9                        36
     D  Line10                       36
     D Lin             S             36    Inz Dim(10)
     D Ln#             S              3  0 Inz

      *--------------------------------------------------------------*
      *
      *  From & To file for Join
      *
     D CurJFiles       DS
     D  JNJFNM                       10
     D  JNJTNM                       10
      *
     D SavJFiles       DS
     D  SVJFNM                       10
     D  SVJTNM                       10

      *--------------------------------------------------------------*
      *
      *  Constants
      *
     D @Yes            C                   const('Y')
     D @No             C                   const('N')
     D @PF             C                   const('Physical File  . . :')
     D @LF             C                   const('Logical file . . . :')
     D @Unique         C                   const('UNIQUE')
     D @Minus          C                   const('-')
     D @Plus           C                   const('+')
     D @Descend        C                   const('DESCEND')
     D @Ascend         C                   const(' ')
     D @Signed         C                   const('SIGNED')
     D @Unsigned       C                   const(' ')
     D @Zone           C                   const('ZONE')
     D @NotZone        C                   const(' ')

      *--------------------------------------------------------------*
      *
      *  Standalone fields
      *
     D Lilian          S              9B 0 Inz
     D Second          S              8A   Inz
     D GregDt          S             17A   Inz
     D Picture         S             32A   Inz('Mmmmmmmmmz ZD, YYYY')
     D Picture2        S             32A   Inz('MM/DD/YY')
     D DateTxt         S             32A   Inz
     D DateMDY         S             32A   Inz
     D Lbl             S             80    Dim(19) CtData PerRcd(1)
     D Lbl#            S              3  0
     D Fil#            S              3  0
     D Maint           S              8
     D KeyOrder        S              8
     D Unique          S              1
     D Keyed           S              1
     D SelOmt          S              1
     D Join            S              1
     D Key#            S                   Inz Like(APNKYF)
     D KeyFld          S                   Inz Like(APKEYF)
     D LFFormat        S                   Inz Like(APBOLF)
     D Pfile           S                   Inz Like(APBOF)
     D Jfile           S                   Inz Like(JNDNAM)
     D KeySeq          S              8    Inz
     D KeySign         S              8    Inz
     D KeyZone         S              4    Inz
     D TstTxt          S            360    Inz
     D Txt34           S             34    Inz
     D Cont            S              1    Inz
     D TxtLen          S              3  0 Inz
     D Remain          S              3  0 Inz
     D Scan            S              3  0 Inz
     D BrkPos          S              3  0 Inz
      *
      /COPY QCPYSRC,Dspec

      *--------------------------------------------------------------*
     IQDDSSRC   NS
     I                             S    1    6 2SRCSEQ
     I                             S    7   12 0SRCDAT
     I                                 13   92  SRCDTA
      *
     C                   exsr      $Main
      *
     C                   eval      *inLR = *on
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Main routine.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $Main         begsr
      *
     C                   Eval      %Subst(@QFile: 1: 10) = File
     C                   Eval      %Subst(@QFile:11: 10) = FileL

      *----------------------------------------------------*
      *  Get the local date                                *
      *----------------------------------------------------*
     C                   Callb(d)  'CEELOCT'
     C                   Parm                    Lilian
     C                   Parm                    Second
     C                   Parm                    GregDt
     C                   Parm                    *Omit
      *
     C                   Callb(d)  'CEEDATE'
     C                   Parm                    Lilian
     C                   Parm      'YYMMDD'      Picture
     C                   Parm                    DateRtn
     C                   Parm                    *Omit
      *
     C                   Reset                   Picture
     C                   Callb(d)  'CEEDATE'
     C                   Parm                    Lilian
     C                   Parm                    Picture
     C                   Parm                    DateTxt
     C                   Parm                    *Omit
      *
     C                   Reset                   Picture2
     C                   Callb(d)  'CEEDATE'
     C                   Parm                    Lilian
     C                   Parm                    Picture2
     C                   Parm                    DateMDY
     C                   Parm                    *Omit
      *
      *----------------------------------------------------*
      *  Initialize pointers                               *
      *----------------------------------------------------*
     C                   Eval      #SpcName    = %addr(@UsName)
     C                   Eval      #SpcLib     = %addr(@UsLib)
     C                   Eval      #SpcSize    = %addr(@Size)
     C                   Eval      #SpcPtr     = %addr(@BasePtr)
      *----------------------------------------------------*
      *  Create a new user space                           *
      *----------------------------------------------------*
     C                   Exsr      $CrtUs
      *
     C                   Eval      SRCSEQ      = 0
     C                   Eval      SRCDAT      = NewDat
      *----------------------------------------------------*
      *  Retrieve list of Record formats for the file      *
      *----------------------------------------------------*
     C                   Exsr      $RecFmt
      *
      *----------------------------------------------------*
      *  Write the standard label & file level keywords    *
      *----------------------------------------------------*
     C                   Exsr      $StdLbl
      *
      *----------------------------------------------------*
      *  Write record & field level source                 *
      *----------------------------------------------------*
     C     1             Do        Rf#           Lf#
     C                   Exsr      $CrtUs
     C                   Eval      @RecFmt     = RfName(Lf#)
     C                   Eval      @RecText    = RfText(Lf#)
     C                   Eval      LnArray     = *Blanks
      *
     C                   Eval      NsComment   = '*'
     C                   Eval      SRCSEQ      = SRCSEQ + 1
     C                   Eval      SRCDTA      = NewSource
     C                   Except    WrtSrc
     C                   Reset                   NewSource
      *         *------------------------------------------*
      *         *  Write the Record Level                  *
      *         *------------------------------------------*
     C                   Eval      TstTxt      = %Trimr('TEXT(''')   +
     C                                           %Trim(@RecText)     +
     C                                           ''')'
     C                   Eval      Cont        = @Plus
     C     @RecText      CasNe     *Blanks       $BrkLin
     C                   EndCs
      *
     C                   If        Line1      <> *Blanks
     C                   Eval      NsKeyword   = Line1
     C                   EndIf
     C                   Eval      NsFormType  = 'A'
     C                   Eval      NsNameType  = 'R'
     C                   Eval      NsName      = @RecFmt
     C                   Eval      SRCSEQ      = SRCSEQ + 1
     C                   Eval      SRCDTA      = NewSource
     C                   Except    WrtSrc
     C                   Reset                   NewSource
      *
     C     2             Do        9             Ln#
     C                   If        Lin(Ln#)   <> *Blanks
     C                   Eval      NsFormType  = 'A'
     C                   Eval      NsKeyword   = Lin(Ln#)
     C                   Eval      SRCSEQ      = SRCSEQ + 1
     C                   Eval      SRCDTA      = NewSource
     C                   Except    WrtSrc
     C                   Reset                   NewSource
     C                   Else
     C                   Leave
     C                   EndIf
     C                   EndDo
      *
      *         *------------------------------------------*
      *         *  Write PFILE keyword                     *
      *         *------------------------------------------*
     C                   If        Pfile      <> *Blanks
     C                   Eval      NsFormType  = 'A'
     C                   Eval      NsKeyword   = %Trimr('PFILE(')    +
     C                                           %Trimr(Pfile)       +
     C                                           ')'
     C                   Eval      SRCSEQ      = SRCSEQ + 1
     C                   Eval      SRCDTA      = NewSource
     C                   Except    WrtSrc
     C                   Reset                   NewSource
     C                   Else
      *         *------------------------------------------*
      *         *  Write Join logical keywords             *
      *         *------------------------------------------*
     C     Join          CasEq     @Yes          $LstJoin
     C                   EndCs
     C                   EndIf
      *         *------------------------------------------*
      *         *  Write the Field Level                   *
      *         *------------------------------------------*
     C                   Eval      NsComment   = '*'
     C                   Eval      SRCSEQ      = SRCSEQ + 1
     C                   Eval      SRCDTA      = NewSource
     C                   Except    WrtSrc
     C                   Reset                   NewSource
     C                   Exsr      $LstFld
      *         *------------------------------------------*
      *         *  Write the Key fields (if any)           *
      *         *------------------------------------------*
     C                   Exsr      $LstKFld
      *         *------------------------------------------*
      *         *  Write the Select/Omit fields (if any)   *
      *         *------------------------------------------*
     C     SelOmt        CasEq     @Yes          $LstSelO
     C                   EndCs
     C                   EndDo
      *
     Csr   #Main         endsr
      /SPACE
      *==============================================================*
      *  Create a new user space for this job                        *
      *==============================================================*
     C     $CrtUs        BEGSR
      *
      *----------------------------------------------------*
      *  Delete any existing user space                    *
      *----------------------------------------------------*
     C                   Call      'QUSDLTUS'
     C                   Parm                    @UsNameLib
     C                   Parm                    @ErrData
      *----------------------------------------------------*
      *  Create the user space                             *
      *----------------------------------------------------*
     C                   Eval      @ExcpId     = *Blanks
     C                   Eval      @BytesProv  = 200
      *
     C                   Call      'QUSCRTUS'
     C                   Parm                    @UsNameLib
     C                   Parm                    @ExtAttr
     C                   Parm                    @SpcSize
     C                   Parm                    @InitValue
     C                   Parm                    @PubAut
     C                   Parm                    @Text
     C                   Parm                    @Replace
     C                   Parm                    @ErrData
      *
     C                   If        @BytesAval  > 0
     C                   Eval      @MsgId      = @ExcpId
     C                   Eval      @MsgDta     = @ExcpData
     C                   Else
      *
      *----------------------------------------------------*
      *  Change the user space & expand the size           *
      *----------------------------------------------------*
     C                   Eval      @ExcpId     = *Blanks
     C                   Eval      @BytesProv  = 200
      *
     C                   Call      'QUSCUSAT'
     C                   Parm                    @UsLib
     C                   Parm                    @UsName
     C                   Parm                    @ChgAttr
     C                   Parm                    @ErrData
      *
     C                   If        @BytesAval  > 0
     C                   Eval      @MsgId      = @ExcpId
     C                   Eval      @MsgDta     = @ExcpData
     C                   Else
      *
      *----------------------------------------------------*
      *  Retrieve pointer to user space                    *
      *----------------------------------------------------*
     C                   Call      'QUSPTRUS'
     C                   Parm                    @UsNameLib
     C                   Parm                    @SpcPtr
     C                   Parm                    @ErrData
      *
     C                   EndIf
     C                   EndIf
      *
     C     #CrtUs        ENDSR
      /EJECT
      *==============================================================*
      *  Get all record format for the file                          *
      *==============================================================*
     C     $RecFmt       BEGSR
      *
     C                   Eval      @ExcpId     = *Blanks
     C                   Eval      @BytesProv  = 200
      *----------------------------------------------------*
      *  List Record Formats (QUSLRCD) API                 *
      *----------------------------------------------------*
     C                   Call      'QUSLRCD'
     C                   Parm                    @UsNameLib
     C                   Parm                    @FormatR
     C                   Parm                    @QFile
     C                   Parm                    @OvrdPrc
      *         *------------------------------------------*
      *         *  Look for the generic header format to   *
      *         *  determine how info will be retrieved    *
      *         *  in the user space.                      *
      *         *------------------------------------------*
     C                   Eval      @BytesProv  = 200
      *
     C                   Call      'QUSRTVUS'
     C                   Parm                    @UsNameLib
     C                   Parm                    @StartPos
     C                   Parm                    @DataLen
     C                   Parm                    @GenHeader
     C                   Parm                    @ErrData
      *
     C                   If        @BytesAval  > 0
     C                   Eval      @MsgId      = @ExcpId
     C                   Eval      @MsgDta     = @ExcpData
     C                   EndIf
      *
      *         *------------------------------------------*
      *         *  Determine the size of each entries      *
      *         *------------------------------------------*
     C                   If        @QLstEntSz  < 82
     C                   Eval      @DataLen    = @QLstEntSz
     C                   Else
     C                   Eval      @DataLen    = 82
     C                   EndIf
      *         *------------------------------------------*
      *         *  Retrieve the number of entries          *
      *         *------------------------------------------*
     C                   Eval      @Loop       = @QNoLstEnt
      *         *------------------------------------------*
      *         *  Get the starting position and increased *
      *         *  the offset by 1 (user space is based on *
      *         *  base 0, we compute under base 1)        *
      *         *------------------------------------------*
     C                   Eval      @StartEnt   = @QOfstLst + 1

      *----------------------------------------------------*
      *  Loop thru the list of record format entries       *
      *----------------------------------------------------*
     C                   Dow       @Loop       > 0
      *
     C                   Call      'QUSRTVUS'
     C                   Parm                    @UsNameLib
     C                   Parm                    @StartEnt
     C                   Parm                    @DataLen
     C                   Parm                    @Receiver1
     C                   Parm                    @ErrData
      *
     C                   If        @200Name    = *Blanks
     C                   Leave
     C                   EndIf
      *
     C                   If        @BytesAval  > 0
     C                   Eval      @MsgId      = @ExcpId
     C                   Eval      @MsgDta     = @ExcpData
     C                   EndIf
      *         *------------------------------------------*
      *         *  Store info into array - up to 99 elem   *
      *         *------------------------------------------*
     C                   Eval      Rf#         = Rf# + 1
     C                   Eval      RfName(Rf#) = @200Name
     C                   Eval      RfText(Rf#) = @200Text
      *
     C                   If        Rf#         = 99
     C                   Leave
     C                   EndIf
      *
      *         *------------------------------------------*
      *         *  Position to the record format entry     *
      *         *------------------------------------------*
     C                   Eval      @StartEnt   = @StartEnt + @QLstEntSz
     C                   Eval      @Loop       = @Loop - 1
     C                   EndDo
      *
     C     #RecFmt       ENDSR
      /EJECT
      *==============================================================*
      *                                                              *
      *  List all the fields per record format & write to source     *
      *                                                              *
     C     $LstFld       BEGSR
      *==============================================================*
     C                   Eval      @ExcpId     = *Blanks
     C                   Eval      @BytesProv  = 200
      *----------------------------------------------------*
      *  List Fields (QUSLFLD) API                         *
      *----------------------------------------------------*
     C                   Call      'QUSLFLD'
     C                   Parm                    @UsNameLib
     C                   Parm                    @FormatF
     C                   Parm                    @QFile
     C                   Parm                    @RecFmt
     C                   Parm                    @OvrdPrc
      *         *------------------------------------------*
      *         *  Look for the generic header format to   *
      *         *  determine how info will be retrieved    *
      *         *  in the user space.                      *
      *         *------------------------------------------*
     C                   Eval      @BytesProv  = 200
      *
     C                   Call      'QUSRTVUS'
     C                   Parm                    @UsNameLib
     C                   Parm                    @StartPos
     C                   Parm                    @DataLen
     C                   Parm                    @GenHeader
     C                   Parm                    @ErrData
      *
     C                   If        @BytesAval  > 0
     C                   Eval      @MsgId      = @ExcpId
     C                   Eval      @MsgDta     = @ExcpData
     C                   EndIf
      *
      *         *------------------------------------------*
      *         *  Determine the size of each entries      *
      *         *------------------------------------------*
     C                   If        @QLstEntSz  < 268
     C                   Eval      @DataLen    = @QLstEntSz
     C                   Else
     C                   Eval      @DataLen    = 268
     C                   EndIf
      *         *------------------------------------------*
      *         *  Retrieve the number of entries          *
      *         *------------------------------------------*
     C                   Eval      @Loop       = @QNoLstEnt
      *         *------------------------------------------*
      *         *  Get the starting position and increased *
      *         *  the offset by 1 (user space is based on *
      *         *  base 0, we compute under base 1)        *
      *         *------------------------------------------*
     C                   Eval      @StartEnt   = @QOfstLst + 1

      *----------------------------------------------------*
      *  Loop thru the list of record format entries       *
      *----------------------------------------------------*
     C                   Dow       @Loop       > 0
      *
     C                   Call      'QUSRTVUS'
     C                   Parm                    @UsNameLib
     C                   Parm                    @StartEnt
     C                   Parm                    @DataLen
     C                   Parm                    @Receiver2
     C                   Parm                    @ErrData
      *
     C                   If        @100Field   = *Blanks
     C                   Leave
     C                   EndIf
      *
     C                   If        @BytesAval  > 0
     C                   Eval      @MsgId      = @ExcpId
     C                   Eval      @MsgDta     = @ExcpData
     C                   EndIf

     C                   Eval      LnArray     = *Blanks

      *         *------------------------------------------*
      *         *  Field Name, Length, Type, Decimal & Text*
      *         *------------------------------------------*
     C                   Eval      TstTxt      = %Trimr('TEXT(''')   +
     C                                           %Trim(@100FldTxt)   +
     C                                           ''')'
     C                   Eval      Cont        = @Plus
     C     @100FldTxt    CasNe     *Blanks       $BrkLin
     C                   EndCs
      *
     C                   If        Line1      <> *Blanks
     C                   Eval      NsKeyword   = Line1
     C                   EndIf
     C                   Eval      NsFormType  = 'A'
     C                   Eval      NsName      = @100Field
     C                   Eval      NsDataType  = @100Type
      *         *--Time/Date/Timestamp---------------------*
     C                   If        @100Type    = 'L' or
     C                             @100Type    = 'T' or
     C                             @100Type    = 'Z'
     C                   Eval      NsLen       = *Blanks
     C                   Else
      *         *--Other data type-------------------------*
     C                   Eval      NsLen#      = @100FldLen
     C                   Eval      NsLen       = %Editc(NsLen#:'Z')
      *         *--Packed/Zoned/Binary---------------------*
     C                   If        @100Type    = 'P' or
     C                             @100Type    = 'Z' or
     C                             @100Type    = 'B'
     C                   Eval      NsLen#      = @100Digits
     C                   Eval      NsLen       = %Editc(NsLen#:'Z')
     C                   Eval      NsDec#      = @100DecPos
     C                   Eval      NsDec       = %Editc(NsDec#:'Z')
     C                   EndIf
     C                   EndIf
     C                   Eval      SRCSEQ      = SRCSEQ + 1
     C                   Eval      SRCDTA      = NewSource
     C                   Except    WrtSrc
     C                   Reset                   NewSource
      *
     C     2             Do        9             Ln#
     C                   If        Lin(Ln#)   <> *Blanks
     C                   Eval      NsFormType  = 'A'
     C                   Eval      NsKeyword   = Lin(Ln#)
     C                   Eval      SRCSEQ      = SRCSEQ + 1
     C                   Eval      SRCDTA      = NewSource
     C                   Except    WrtSrc
     C                   Reset                   NewSource
     C                   Else
     C                   Leave
     C                   EndIf
     C                   EndDo

      *         *------------------------------------------*
      *         *  Column Heading                          *
      *         *------------------------------------------*
     C                   If        @100ColHdg1<> *Blanks or
     C                             @100ColHdg2<> *Blanks or
     C                             @100ColHdg3<> *Blanks
      *
     C                   Eval      TstTxt      = %Trimr('COLHDG(''')
      *
     C                   If        @100ColHdg1<> *Blanks
     C                   Eval      TstTxt      = %Trimr(TstTxt)      +
     C                                           %Trim(@100ColHdg1)  +
     C                                           ''''
     C                   else
     C                   Eval      TstTxt      = %Trimr(TstTxt)      +
     C                                           ' '''
     C                   endif
      *
     C                   If        @100ColHdg2<> *Blanks
     C                   Eval      TstTxt      = %Trimr(TstTxt)      +
     C                                           ' '''               +
     C                                           %Trim(@100ColHdg2)  +
     C                                           ''''
     C                   EndIf
      *
     C                   If        @100ColHdg3<> *Blanks
     C                   Eval      TstTxt      = %Trimr(TstTxt)      +
     C                                           ' '''               +
     C                                           %Trim(@100ColHdg3)  +
     C                                           ''''
     C                   EndIf
     C                   Eval      TstTxt      = %Trimr(TstTxt)      +
     C                                           ')'
     C                   Eval      Cont        = @Plus
     C                   Exsr      $BrkLin
      *
     C                   Do        10            Ln#
     C                   If        Lin(Ln#)   <> *Blanks
     C                   Eval      NsFormType  = 'A'
     C                   Eval      NsKeyword   = Lin(Ln#)
     C                   Eval      SRCSEQ      = SRCSEQ + 1
     C                   Eval      SRCDTA      = NewSource
     C                   Except    WrtSrc
     C                   Reset                   NewSource
     C                   Else
     C                   Leave
     C                   EndIf
     C                   EndDo
      *
     C                   EndIf

      *         *------------------------------------------*
      *         *  Alternative field name                  *
      *         *------------------------------------------*
     C                   If        @100Alias  <> *Blanks
      *
     C                   Eval      TstTxt      = %Trimr('ALIAS(')    +
     C                                           %Trim(@100Alias)    +
     C                                           ')'
     C                   Eval      Cont        = @Minus
     C                   Exsr      $BrkLin
      *
     C                   Do        10            Ln#
     C                   If        Lin(Ln#)   <> *Blanks
     C                   Eval      NsFormType  = 'A'
     C                   Eval      NsKeyword   = Lin(Ln#)
     C                   Eval      SRCSEQ      = SRCSEQ + 1
     C                   Eval      SRCDTA      = NewSource
     C                   Except    WrtSrc
     C                   Reset                   NewSource
     C                   Else
     C                   Leave
     C                   EndIf
     C                   EndDo
      *
     C                   EndIf

      *         *------------------------------------------*
      *         *  Edit Code                               *
      *         *------------------------------------------*
     C                   If        @100EdtCde <> *Blanks and
     C                             @100EdtCde <> x'4000'
     C                   Eval      NsFormType  = 'A'
     C                   Eval      NsKeyword   = 'EDTCDE(' +
     C                                           %trim(@100EdtCde) + ')'
     C                   Eval      SRCSEQ      = SRCSEQ + 1
     C                   Eval      SRCDTA      = NewSource
     C                   Except    WrtSrc
     C                   Reset                   NewSource
     C                   EndIf

      *         *------------------------------------------*
      *         *  Edit word.                              *
      *         *------------------------------------------*
     C                   If        @100EdtWrd <> *Blanks
     C                   Eval      NsFormType  = 'A'
      *
     C                   Eval      NsKeyword   = 'EDTWRD(''' + @100EdtWrd
     C                   Eval      %subst(NsKeyword:@100edwlen+9) = ''')'
     C                   Eval      SRCSEQ      = SRCSEQ + 1
     C                   Eval      SRCDTA      = NewSource
     C                   Except    WrtSrc
     C                   Reset                   NewSource
     C                   EndIf

      *         *------------------------------------------*
      *         *  Date Format                             *
      *         *------------------------------------------*
      *
      *         *--Time/Date/Timestamp---------------------*
     C                   If        @100Type    = 'L' or
     C                             @100Type    = 'T' or
     C                             @100Type    = 'Z'
      *
     C                   If        @100DTFmt  <> *Blanks
     C                   Eval      NsFormType  = 'A'
     C                   Eval      NsKeyword   = 'DATFMT(' +
     C                                           %trim(@100DTFmt) + ')'
     C                   Eval      SRCSEQ      = SRCSEQ + 1
     C                   Eval      SRCDTA      = NewSource
     C                   Except    WrtSrc
     C                   Reset                   NewSource
     C                   EndIf

      *         *------------------------------------------*
      *         *  Date Seperator                          *
      *         *------------------------------------------*
      *
      *         *--Time/Date-------------------------------*
     C                   If        NsDataType  = 'L' or
     C                             NsDataType  = 'T'
     C                   If        @100DTSep  <> *Blanks
      *
     C                   Eval      NsFormType  = 'A'
     C                   Eval      NsKeyword   = %Trimr('DATSEP(')    +
     C                                           %Trimr(@100DTSep)   +
     C                                           ')'
     C                   Eval      SRCSEQ      = SRCSEQ + 1
     C                   Eval      SRCDTA      = NewSource
     C                   Except    WrtSrc
     C                   Reset                   NewSource
      *
      *
     C                   EndIf
     C                   EndIf
      *                             Type = L,T
      *
     C                   EndIf
      *                             Type = L,T,Z
      *         *------------------------------------------*
      *         *  Allow Null                              *
      *         *------------------------------------------*
     C                   If        @100AlwNull = '1'
     C                   Eval      NsFormType  = 'A'
     C                   Eval      NsKeyword   = 'ALWNULL'
     C                   Eval      SRCSEQ      = SRCSEQ + 1
     C                   Eval      SRCDTA      = NewSource
     C                   Except    WrtSrc
     C                   Reset                   NewSource
     C                   EndIf
      *
      *         *------------------------------------------*
      *         *  Position to the record format entry     *
      *         *------------------------------------------*
     C                   Eval      @StartEnt   = @StartEnt + @QLstEntSz
     C                   Eval      @Loop       = @Loop - 1
     C                   EndDo
      *
     C     #LstFld       ENDSR
      /EJECT
      *==============================================================*
      *
      *  List all the key fields per record format & write to source *
      *                                                              *
     C     $LstKFld      BEGSR
      *==============================================================*
     C                   If        Key#        > 0
     C                   Eval      NsComment   = '*'
     C                   Eval      SRCSEQ      = SRCSEQ + 1
     C                   Eval      SRCDTA      = NewSource
     C                   Except    WrtSrc
     C                   Reset                   NewSource
     C                   EndIf
      *
     C                   Do        Key#
      *----------------------------------------------------*
      *  Write key field & keywords to source              *
      *----------------------------------------------------*
     C                   Eval      NsFormType  = 'A'
     C                   Eval      NsNameType  = 'K'
     C                   Eval      NsName      = KeyFld
     C                   Eval      NsKeyword   = %Trimr(KeySeq)  + ' ' +
     C                                           %Trimr(KeySign) + ' ' +
     C                                           %Trimr(KeyZone)
     C                   Eval      SRCSEQ      = SRCSEQ + 1
     C                   Eval      SRCDTA      = NewSource
     C                   Except    WrtSrc
     C                   Reset                   NewSource
      *----------------------------------------------------*
      *  Read the next key from QAFDACCP                   *
      *----------------------------------------------------*
     C                   Read      QAFDACCP                               90
     C                   If        *In90
     C                   Leave
     C                   EndIf
      *         *------------------------------------------*
      *         *  Get Key information                     *
      *         *------------------------------------------*
     C                   Eval      KeyFld      = APKEYF
     C                   If        APKSEQ      = 'A'
     C                   Eval      KeySeq      = @Ascend
     C                   Else
     C                   Eval      KeySeq      = @Descend
     C                   EndIf
     C                   If        APKSIN      = @Yes
     C                   Eval      KeySign     = @Signed
     C                   Else
     C                   Eval      KeySign     = @Unsigned
     C                   EndIf
     C                   If        APKZD       = @Yes
     C                   Eval      KeyZone     = @Zone
     C                   Else
     C                   Eval      KeyZone     = @NotZone
     C                   EndIf
      *         *------------------------------------------*
      *         *  Get Pfile info if different             *
      *         *------------------------------------------*
     C                   If        APJOIN      = @No   and
     C                             APFATR      = 'LF'
     C                   If        Pfile      <> APBOF
     C                   Eval      Pfile       = APBOF
     C                   Eval      Pf#         = Pf# + 1
     C                   Eval      PfInfo(Pf#) = APBOF
     C                   EndIf
     C                   EndIf
      *         *------------------------------------------*
      *         *  Make sure the same record format        *
      *         *------------------------------------------*
     C                   If        APBOLF     <> *Blanks  and
     C                             LFFormat   <> @RecFmt
     C                   Eval      LFFormat    = APBOLF
     C                   Leave
     C                   EndIf
      *
     C                   Enddo
      *
     C     #LstKFld      ENDSR
      /EJECT
      *==============================================================*
      *                                                              *
      *  List Join keywords                                          *
      *                                                              *
     C     $LstJoin      BEGSR
      *==============================================================*
     C                   Eval      LnArray     = *Blanks
      *----------------------------------------------------*
      *  Write JFILE keyword                               *
      *----------------------------------------------------*
     C                   Eval      TstTxt      = %Trimr('JFILE(')
     C                   Do        Jf#           Fil#
     C                   If        Fil#        = 1
     C                   Eval      TstTxt      = %Trimr(TstTxt) +
     C                                           JfInfo(Fil#)
     C                   Else
     C                   Eval      TstTxt      = %Trimr(TstTxt) + ' ' +
     C                                           JfInfo(Fil#)
     C                   EndIf
     C                   Enddo
     C                   Eval      TstTxt      = %Trimr(TstTxt) + ')'
     C                   Eval      Cont        = @Plus
     C                   Exsr      $BrkLin
      *
     C                   Do        10            Ln#
     C                   If        Lin(Ln#)   <> *Blanks
     C                   Eval      NsFormType  = 'A'
     C                   Eval      NsKeyword   = Lin(Ln#)
     C                   Eval      SRCSEQ      = SRCSEQ + 1
     C                   Eval      SRCDTA      = NewSource
     C                   Except    WrtSrc
     C                   Reset                   NewSource
     C                   Else
     C                   Leave
     C                   EndIf
     C                   EndDo
      *----------------------------------------------------*
      *  Write JOIN & JFLD keywords                        *
      *----------------------------------------------------*
     C     1             Chain     QAFDJOIN                           92
     C                   Dow       Not *In92
     C                   If        JNJFRM      > *Zero    and
     C                             JNJTO       > *Zero
     C                   If        CurJFiles  <> SavJFiles
     C                   Eval      SVJFNM      = JNJFNM
     C                   Eval      SVJTNM      = JNJTNM
      *         *------------------------------------------*
      *         *  JOIN keyword                            *
      *         *------------------------------------------*
     C                   Eval      NsFormType  = 'A'
     C                   Eval      NsNameType  = 'J'
     C                   Eval      NsKeyword   = %Trimr('JOIN(') +
     C                                           %Trimr(JNJFNM)  + ' ' +
     C                                           %Trimr(JNJTNM)  + ')'
     C                   Eval      SRCSEQ      = SRCSEQ + 1
     C                   Eval      SRCDTA      = NewSource
     C                   Except    WrtSrc
     C                   Reset                   NewSource
      *         *------------------------------------------*
      *         *  JFLD keyword                            *
      *         *------------------------------------------*
     C                   Eval      NsFormType  = 'A'
     C                   Eval      NsKeyword   = %Trimr('JFLD(') +
     C                                           %Trimr(JNJFD1)  + ' ' +
     C                                           %Trimr(JNJFD2)  + ')'
     C                   Eval      SRCSEQ      = SRCSEQ + 1
     C                   Eval      SRCDTA      = NewSource
     C                   Except    WrtSrc
     C                   Reset                   NewSource
     C                   EndIf
     C                   EndIf
     C                   Read      QAFDJOIN                               92
     C                   EndDo
      *
     C     #LstJoin      ENDSR
      /EJECT
      *==============================================================*
      *                                                              *
      *  List all select / omit fields per record format & write     *
      *                                                              *
     C     $LstSelO      BEGSR
      *==============================================================*
      *
     C     1             Chain     QAFDSELO                           91
     C                   Dow       Not *In91
     C                   If        SORFMT      = @RecFmt
      *----------------------------------------------------*
      *  Write select / omit keywords to source            *
      *----------------------------------------------------*
     C                   Eval      NsFormType  = 'A'
     C                   Eval      NsNameType  = SORULE
     C                   Eval      NsName      = SOFLD
     C                   If        SOCOMP      = 'AL'
     C                   Eval      NsKeyword   = 'ALL'
     C                   Else
     C                   Eval      NsKeyword   = %Trimr('COMP(')     +
     C                                           %Trimr(SOCOMP)      +
     C                                           ' '                 +
     C                                           %Trimr(SOVALU)      +
     C                                           ')'
     C                   EndIf
     C                   Eval      SRCSEQ      = SRCSEQ + 1
     C                   Eval      SRCDTA      = NewSource
     C                   Except    WrtSrc
     C                   Reset                   NewSource
     C                   EndIf
     C                   Read      QAFDSELO                               91
     C                   EndDo
      *
     C     #LstSelO      ENDSR
      /EJECT
      *==============================================================*
      *                                                              *
      *  Print Standard DDS Labels                                   *
      *                                                              *
     C     $StdLbl       BEGSR
      *==============================================================*
     C                   for       Lbl# = 1 to %elem(lbl)
     C                   Eval      SRCSEQ      = SRCSEQ + 1
     C                   Eval      SRCDTA      = Lbl(Lbl#)
      *
     C                   Select
     C                   When      Lbl#        = 1
     C                   Eval      %Subst(SRCDTA:15) = Text
     C                   EndSl

     C                   Except    WrtSrc
     C                   endfor

      *----------------------------------------------------*
      *  Build fields used for file level keywords. Read   *
      *  the first record of QAFDACCP for this info.       *
      *----------------------------------------------------*
     C                   Read      QAFDACCP                               99
     C                   If        *In90
     C                   Eval      RtnCde = '99'
     C                   eval      *inLR  = *on
     C                   return
     C                   endif
      *
      *         *------------------------------------------*
      *         *  Get Access path order of key            *
      *         *------------------------------------------*
     C                   Select
     C                   When      APKEYO      = 'L'
     C                   Eval      KeyOrder    = 'LIFO'
     C                   When      APKEYO      = 'F'
     C                   Eval      KeyOrder    = 'FIFO'
     C                   When      APKEYO      = 'C'
     C                   Eval      KeyOrder    = 'FCFO'
     C                   EndSl
      *         *------------------------------------------*
      *         *  Is key UNIQUE                           *
      *         *------------------------------------------*
     C                   Eval      Unique      = APUNIQ
      *         *------------------------------------------*
      *         *  Access path: A-Arrival, K-Keyed         *
      *         *------------------------------------------*
     C                   Eval      Keyed       = APACCP
      *         *------------------------------------------*
      *         *  Select/Omit file: Y-Yes, N-No           *
      *         *------------------------------------------*
     C                   Eval      SelOmt      = APSELO
     C                   If        SelOmt      = @Yes
     C                   Open      QAFDSELO
     C                   EndIf
      *         *------------------------------------------*
      *         *  Join logical file: Y-Yes, N-No          *
      *         *------------------------------------------*
     C                   Eval      Join        = APJOIN
     C                   If        APJOIN      = @Yes
     C                   Open      QAFDJOIN
     C                   Eval      *In92       = *Off
     C                   Eval      JFile       = *Blanks
      *
     C                   Dow       Not *In92
     C                   Read      QAFDJOIN                               92
     C                   If        Not *In92   and
     C                             JFile      <> JNDNAM
     C                   Eval      JFile       = JNDNAM
     C                   Eval      Jf#         = Jf# + 1
     C                   Eval      JfInfo(Jf#) = JNDNAM
     C                   EndIf
     C                   EndDo
     C                   Else
      *         *------------------------------------------*
      *         *  Based on Physical File - for LF only    *
      *         *------------------------------------------*
     C                   If        APFATR      = 'LF'
     C                   Eval      PfAccess    = APNSCO
     C                   Eval      Pfile       = APBOF
     C                   Eval      Pf#         = Pf# + 1
     C                   Eval      PfInfo(Pf#) = APBOF
     C                   EndIf
     C                   EndIf
      *         *------------------------------------------*
      *         *  Get Key information (& First Key Field) *
      *         *------------------------------------------*
     C                   Eval      Key#        = APNKYF
     C                   Eval      KeyFld      = APKEYF
     C                   Eval      LFFormat    = APBOLF
     C                   If        APKSEQ      = 'A'
     C                   Eval      KeySeq      = @Ascend
     C                   Else
     C                   Eval      KeySeq      = @Descend
     C                   EndIf
     C                   If        APKSIN      = @Yes
     C                   Eval      KeySign     = @Signed
     C                   Else
     C                   Eval      KeySign     = @Unsigned
     C                   EndIf
     C                   If        APKZD       = @Yes
     C                   Eval      KeyZone     = @Zone
     C                   Else
     C                   Eval      KeyZone     = @NotZone
     C                   EndIf
      *         *------------------------------------------*
      *         *  Get Access path maintenance             *
      *         *------------------------------------------*
     C                   Select
     C                   When      APMANT      = 'R'
     C                   Eval      Maint       = '*REBLD'
     C                   When      APMANT      = 'D'
     C                   Eval      Maint       = '*DLY'
     C                   Other
     C                   Eval      Maint       = '*IMMED'
     C                   EndSl
      *
      *----------------------------------------------------*
      *  File Level Keywords                               *
      *----------------------------------------------------*
     C                   Reset                   NewSource
      *         *------------------------------------------*
      *         *  UNIQUE                                  *
      *         *------------------------------------------*
     C                   If        Unique      = @Yes
     C                   Eval      NsFormType  = 'A'
     C                   Eval      NsKeyword   = @Unique
     C                   Eval      SRCSEQ      = SRCSEQ + 1
     C                   Eval      SRCDTA      = NewSource
     C                   Except    WrtSrc
     C                   Reset                   NewSource
     C                   Else
      *         *------------------------------------------*
      *         *  FCFO, FIFO or LIFO                      *
      *         *------------------------------------------*
     C                   If        KeyOrder   <> *Blanks
     C                   Eval      NsFormType  = 'A'
     C                   Eval      NsKeyword   = KeyOrder
     C                   Eval      SRCSEQ      = SRCSEQ + 1
     C                   Eval      SRCDTA      = NewSource
     C                   Except    WrtSrc
     C                   Reset                   NewSource
     C                   EndIf
     C                   EndIf
      *
     C     #StdLbl       ENDSR
      /EJECT
      *==============================================================*
      *                                                              *
      *  Break Text Line to Line 1, 2 & 3                            *
      *                                                              *
     C     $BrkLin       BEGSR
      *==============================================================*
     C                   Eval      LnArray     = *Blanks
     C     ' '           Checkr    TstTxt        TxtLen
     C                   MoveA     '1000000000'  *In(21)
      *----------------------------------------------------*
      *  Continuation tag is minus                         *
      *----------------------------------------------------*
     C                   If        Cont        = @Minus
     C                   Dow       TxtLen      > 0
      *         *------------------------------------------*
      *         *  Check if TstTxt is less than / equal 36 *
      *         *------------------------------------------*
     C                   If        TxtLen     <= 36
     C   21              Eval      Line1       = TstTxt
     C   22              Eval      Line2       = TstTxt
     C   23              Eval      Line3       = TstTxt
     C   24              Eval      Line4       = TstTxt
     C   25              Eval      Line5       = TstTxt
     C   26              Eval      Line6       = TstTxt
     C   27              Eval      Line7       = TstTxt
     C   28              Eval      Line8       = TstTxt
     C   29              Eval      Line9       = TstTxt
     C   30              Eval      Line10      = TstTxt
     C                   Leave
     C                   Else
      *         *------------------------------------------*
      *         *  Greater than 36, break text             *
      *         *------------------------------------------*
     C                   Eval      TstTxt      = %Trim(TstTxt)
     C                   Eval      Remain      = 1
     C                   Eval      Scan        = 1
     C                   Dow       Remain      < 36
     C     ' '           Scan      TstTxt:Scan   Scan
     C                   If        Scan        = 0
     C                   Leave
     C                   Else
     C                   Eval      Remain      = Scan - 1
     C                   Eval      Scan        = Scan + 1
     C                   EndIf
     C                   EndDo

     C                   If        Remain     <= 36
     C   21              Eval      Line1       = TstTxt
     C   22              Eval      Line2       = TstTxt
     C   23              Eval      Line3       = TstTxt
     C   24              Eval      Line4       = TstTxt
     C   25              Eval      Line5       = TstTxt
     C   26              Eval      Line6       = TstTxt
     C   27              Eval      Line7       = TstTxt
     C   28              Eval      Line8       = TstTxt
     C   29              Eval      Line9       = TstTxt
     C   30              Eval      Line10      = TstTxt
     C                   Leave
     C                   Else
     C   21              Eval      Line1       = %Subst(TstTxt: 1: 35)
     C                                           + '-'
     C   22              Eval      Line2       = %Subst(TstTxt: 1: 35)
     C                                           + '-'
     C   23              Eval      Line3       = %Subst(TstTxt: 1: 35)
     C                                           + '-'
     C   24              Eval      Line4       = %Subst(TstTxt: 1: 35)
     C                                           + '-'
     C   25              Eval      Line5       = %Subst(TstTxt: 1: 35)
     C                                           + '-'
     C   26              Eval      Line6       = %Subst(TstTxt: 1: 35)
     C                                           + '-'
     C   27              Eval      Line7       = %Subst(TstTxt: 1: 35)
     C                                           + '-'
     C   28              Eval      Line8       = %Subst(TstTxt: 1: 35)
     C                                           + '-'
     C   29              Eval      Line9       = %Subst(TstTxt: 1: 35)
     C                                           + '-'
     C   30              Eval      Line10      = TstTxt
     C                   EndIf
     C                   EndIf
      *
     C                   Select
     C                   When      *In21
     C                   MoveA     '0100000000'  *In(21)
     C                   When      *In22
     C                   MoveA     '0010000000'  *In(21)
     C                   When      *In23
     C                   MoveA     '0001000000'  *In(21)
     C                   When      *In24
     C                   MoveA     '0000100000'  *In(21)
     C                   When      *In25
     C                   MoveA     '0000010000'  *In(21)
     C                   When      *In26
     C                   MoveA     '0000001000'  *In(21)
     C                   When      *In27
     C                   MoveA     '0000000100'  *In(21)
     C                   When      *In28
     C                   MoveA     '0000000010'  *In(21)
     C                   When      *In29
     C                   MoveA     '0000000001'  *In(21)
     C                   When      *In30
     C                   Leave
     C                   EndSl
     C                   Eval      TxtLen      = TxtLen - 35
     C                   Eval      TstTxt      = %Subst(TstTxt: 36:
     C                                           TxtLen)
     C                   Enddo
     C                   Else
      *
      *----------------------------------------------------*
      *  Continuation tag is plus                          *
      *----------------------------------------------------*
     C                   Eval      BrkPos      = 1
     C                   Dow       TxtLen      > 0
      *         *------------------------------------------*
      *         *  Check if TstTxt is less than / equal 34 *
      *         *------------------------------------------*
     C                   If        TxtLen     <= 34
     C   21              Eval      Line1       = TstTxt
     C   22              Eval      Line2       = TstTxt
     C   23              Eval      Line3       = TstTxt
     C   24              Eval      Line4       = TstTxt
     C   25              Eval      Line5       = TstTxt
     C   26              Eval      Line6       = TstTxt
     C   27              Eval      Line7       = TstTxt
     C   28              Eval      Line8       = TstTxt
     C   29              Eval      Line9       = TstTxt
     C   30              Eval      Line10      = TstTxt
     C                   Leave
     C                   Else
      *         *------------------------------------------*
      *         *  Greater than 34, break text             *
      *         *------------------------------------------*
     C                   Eval      Txt34       = %Subst(TstTxt:  1: 34)
     C                   Eval      Txt34       = %Trim(Txt34)
     C                   Eval      Remain      = 1
     C                   Eval      Scan        = 1

     C                   Dow       Remain      < 34  and
     C                             Scan       <= 34
     C     ' '           Scan      Txt34:Scan    Scan
     C                   If        Scan        = 0
     C                   Leave
     C                   Else
     C                   Eval      Remain      = Scan - 1
     C                   Eval      Scan        = Scan + 1
     C                   EndIf
     C                   EndDo

     C   21              Eval      Line1       = %Subst(Txt34: 1:
     C                                           Remain) + ' +'
     C   22              Eval      Line2       = %Subst(Txt34: 1:
     C                                           Remain) + ' +'
     C   23              Eval      Line3       = %Subst(Txt34: 1:
     C                                           Remain) + ' +'
     C   24              Eval      Line4       = %Subst(Txt34: 1:
     C                                           Remain) + ' +'
     C   25              Eval      Line5       = %Subst(Txt34: 1:
     C                                           Remain) + ' +'
     C   26              Eval      Line6       = %Subst(Txt34: 1:
     C                                           Remain) + ' +'
     C   27              Eval      Line7       = %Subst(Txt34: 1:
     C                                           Remain) + ' +'
     C   28              Eval      Line8     = %Subst(Txt34:1:Remain) +
     C                                            ' +'
     C   29              Eval      Line9       = %Subst(Txt34: 1:
     C                                           Remain) + ' +'
     C   30              Eval      Line10      = TstTxt
     C                   EndIf
      *
     C                   Select
     C                   When      *In21
     C                   MoveA     '0100000000'  *In(21)
     C                   When      *In22
     C                   MoveA     '0010000000'  *In(21)
     C                   When      *In23
     C                   MoveA     '0001000000'  *In(21)
     C                   When      *In24
     C                   MoveA     '0000100000'  *In(21)
     C                   When      *In25
     C                   MoveA     '0000010000'  *In(21)
     C                   When      *In26
     C                   MoveA     '0000001000'  *In(21)
     C                   When      *In27
     C                   MoveA     '0000000100'  *In(21)
     C                   When      *In28
     C                   MoveA     '0000000010'  *In(21)
     C                   When      *In29
     C                   MoveA     '0000000001'  *In(21)
     C                   When      *In30
     C                   Leave
     C                   EndSl
     C                   Eval      BrkPos      = Remain + 2
     C                   Eval      TxtLen      = TxtLen - Remain
     C                   Eval      TstTxt      = %Subst(TstTxt: BrkPos:
     C                                           TxtLen)
     C                   EndDo
      *
     C                   EndIf
      *
     C                   MoveA     LnArray       Lin
      *
     C     #BrkLin       ENDSR
      /SPACE 3
      /COPY QCPYSRC,$PMSND
      /SPACE 3
      /COPY QCPYSRC,$PSSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Initialize variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *inzsr        begsr
      *
     CSR   #inzsr        endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Define variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Define       begsr
      *
     C     *Entry        plist
     C                   parm                    File             10
     C                   parm                    FileL            10
     C                   parm                    ObjAtr           10
     C                   parm                    Mbr              10
     C                   parm                    Text             50
     C                   parm                    Rtncde            2
      *
     CSR   #Define       endsr
      /SPACE 3
      ****************************************************************
      *          O U T P U T     S P E C I F I C A T I O N           *
      ****************************************************************
     OQDDSSRC   EADD         WRTSRC
     O                       SRCSEQ
     O                       SRCDAT
     O                       SRCDTA
** LBL Source label
      */TITLE xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *PARMS SIZE(*NOMAX) MAXMBRS(*NOMAX)
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *              xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *              xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *
      *  Notes   :  none.
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  mm/dd/yy  xxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
