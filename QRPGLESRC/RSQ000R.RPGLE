      /TITLE Retrieve SQL Source
      *PARMS OPTION(*NOXREF) USRPRF(*OWNER)
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Retrieves the equivalent SQL source based
      *             on a physical or logical file.
      *
      *  Notes   :  none
      *
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  12/07/96  TimH        New program.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
     H BNDDIR('QC2LE') OPTION(*SRCSTMT:*NODEBUGIO)
     H DFTACTGRP(*NO)
      *
     Fsource    uf a f  112        disk    usropn
     Fqafdaccp  if   e             disk    usropn

     D RSQ000R         PR
     D  FileLib                      20A
     D  SrcFileLib                   20A
     D  Srcmbr                       10A
     D  bReplace                      1N   OPTIONS(*NOPASS)
     D  szNaming                      3A   OPTIONS(*NOPASS)
     D  nStandard                     5I 0 OPTIONS(*NOPASS)
     D  bDrop                         1N   OPTIONS(*NOPASS)
     D  bHeader                       1N   OPTIONS(*NOPASS)
     D  nMsgLvl                       5I 0 OPTIONS(*NOPASS)
     D  nSevLvl                       5I 0 OPTIONS(*NOPASS)

     D RSQ000R         PI
     D  FileLib                      20A
     D  SrcFileLib                   20A
     D  Srcmbr                       10A
     D  bReplace                      1N   OPTIONS(*NOPASS)
     D  szNaming                      3A   OPTIONS(*NOPASS)
     D  nStandard                     5I 0 OPTIONS(*NOPASS)
     D  bDrop                         1N   OPTIONS(*NOPASS)
     D  bHeader                       1N   OPTIONS(*NOPASS)
     D  nMsgLvl                       5I 0 OPTIONS(*NOPASS)
     D  nSevLvl                       5I 0 OPTIONS(*NOPASS)

     D SafeRmvMbr      PR
     D  SrcFileLib                   20A   Value
     D  SrcMbr                       10A   Value

     D SafeAddMbr      PR
     D  SrcFileLib                   20A   Value
     D  SrcMbr                       10A   Value

     D system          PR                  extproc('system')
     D  szCMDString                    *   OPTIONS(*STRING) VALUE

     D  apiError       DS                  Inz
     D   errDSLen                    10I 0 Inz(%size(apiError))
     D   errRtnLen                   10I 0 Inz
     D   errMsgID                     7A   Inz(*ALLX'00')
     D   errReserved                  1A   Inz(X'00')
     D   errMsgData                  64A   Inz(*ALLX'00')

      /COPY QSYSINC/QRPGLESRC,QSQGNDDL
      /COPY QSYSINC/QRPGLESRC,QUSROBJD

     D pFileLib        S               *
     D InFileLib       DS                  BASED(pFileLib)
     D  InFile                       10A
     D  InLib                        10A
     D pSrcFileLib     S               *
     D InSrcFileLib    DS                  BASED(pSrcFileLib)
     D  SrcFile                      10A
     D  SrcLib                       10A

     D QRtvOBJD        PR                  Extpgm('QUSROBJD')
     D  rtnData                            LIKE(QUSD0200)
     D  rtnLen                       10I 0 Const
     D  odFormat                      8A   Const
     D  ObjLib                       20A   Const
     D  ObjType                      10A   Const
     D  apiErrorDS                         Like(ApiError)

     D  InReplace      S              1N   Inz('1')
     D  InNaming       S              3A   Inz('SYS')
     D  inMsgLvl       S              5I 0 Inz(30)
     D  inSevLvl       S              5I 0 Inz(30)
     D  inStandard     S              5I 0 Inz(0)
     D  inDrop         S              1N   Inz('0')
     D  inHeader       S              1N   Inz('1')

     D FileType        S                   Like(QUSEoA05)
     D SQLTempl        S                   Like(QSQR0100)

     D QRtvSQLSrc      PR                  Extpgm('QSQGNDDL')
     D  sqTempl                            Like(QSQR0100)
     D  sqtLen                       10I 0 Const
     D  sqFormat                      9A   Const
     D  apiError                     16A

     D AYkeyidx        s             10i 0 inz
     D AYkeyf          s             10    inz dim(20)
     D AYkseq          s              4    inz dim(20)

     D AYsrcidx        s             10i 0 inz
     D AYsrc           s             80    inz dim(2000)

     D x               s             10i 0 inz
      * ---------------------------------------------------------
      *
      *  Source records.
      *
     Isource    ns  01
     I                                  1    6 2SRCSEQ
     I                                  7   12 0SRCDAT
     I                                 13  112  SRCDTA
      * ---------------------------------------------------------

      *  Copy the input parms to their variables, if specified.

     C                   eval      pFileLib = %addr(FileLib)
     C                   eval      pSrcFileLIb = %addr(SrcFileLib)

     C                   if        srcmbr = '*FILE'
     C                   eval      srcmbr = InFile
     C                   endif

     C                   if        %parms >= 4
     C                   eval      InReplace = bReplace
     C                   endif

     C                   if        %parms >= 5
     C                   eval      InNaming = szNaming
     C                   endif

     C                   if        %parms >= 6
     C                   eval      InStandard= nStandard
     C                   endif

     C                   if        %parms >= 7
     C                   eval      InDrop = bDrop
     C                   endif

     C                   if        %parms >= 8
     C                   eval      InHeader = bHeader
     C                   endif

     C                   if        %parms >= 9
     C                   eval      inMsgLvl = nMsgLvl
     C                   endif

     C                   if        %parms >= 10
     C                   eval      InSevLvl = nSevLvl
     C                   endif
      * ---------------------------------------------------------

      *  Retrieve the file attribute (LF or PF)

     C                   callp     qrtvobjd(QUSD0200 : %Len(QUSD0200) :
     C                                 'OBJD0200' : FileLIb :
     C                                  '*FILE':apiError)

      *  Failed - Source file not found. :(

     C                   if        %subst(errMSGID:1:5) = 'CPF98'
     C                   eval      *inLR = *on
     C                   return
     C                   endif
      * ---------------------------------------------------------

      *  Does the member exist? Remove the member.

     C                   callp     SafeRmvMbr(InSrcFileLib : SrcMbr)

      *  Does the member exist? Add the member.

     C                   callp     SafeAddMbr(InSrcFileLib : SrcMbr)
      * ---------------------------------------------------------

      *  Set parameters for the retrieve DDL.

     C                   eval      FileType = QUSEoA05
     C                   CLEAR                   QSQR0100
      *                                             Object Name
     C                   eval      qsqOBJN = InFile
      *                                             Object Library
     C                   eval      qsqOBJL = inLib

      *                                             Object Type
     C                   select
     C                   when      FileType = 'PF'
     C                   eval      qsqObjT = 'TABLE'

     C                   when      FileType = 'LF'
     C                   eval      qsqObjT = 'INDEX'
     C                   endsl

      *                                             Source File Name
     C                   eval      qsqSFilN = SrcFile
      *                                             Source File Library
     C                   eval      qsqSFilL = SrcLib
      *                                             Source File Member
     C                   eval      qsqSFilM = SrcMbr
     C
      *                                             Severity Level
     C                   eval      qsqSL02 = InSevLvl
      *                                             Replace Option
     C                   eval      qsqRo   = InReplace
      *                                             Statement Formatting Option
     C                   eval      qsqSFo  = '0'
      *                                             Time Format
     C                   eval      qsqTF02 = 'ISO'
      *                                             Date Separator
     C                   eval      qsqDS02 = ' '
      *                                             Naming Option
     C                   eval      qsqNo02 = InNaming
      *                                             Message Level
     C                   eval      qsqML02 = InMsgLvl
      *                                             Time Format
     C                   eval      qsqDF02 = 'ISO'
      *                                             Time Separator
     C                   eval      qsqTS02 = ' '
      *                                             Decimal Point
     C                   eval      qsqDP02 = '.'
      *                                             Standards Option
     C                   eval      qsqSo01 = %char(InStandard)
      *                                             Drop Option
     C                   eval      qsqDo   = InDrop
      *                                             Comment Option
     C                   eval      qsqCo   = '1'
      *                                             Label option
     C                   eval      qsqLo   = '1'
      *                                             Header option
     C                   eval      qsqHo   = InHeader
      *                                             Trigger option
     C                   eval      qsqTo   = '0'
      *                                             Constraint option
     C                   eval      qsqCo00 = '0'
      *                                             System Name Option
     C                   eval      qsqsno  = '0'
      *                                             -- not used.
      **                 eval      qsqerved02 = *blanks

      **  Copy the data structure to our local data structure
      **  Note: When everyone is on V5R1 and later, we can use
      **        a qualified data structure instead.

     C                   eval      sqltempl = Qsqr0100

     C                   CallP     qrtvsqlsrc(sqltempl : %Len(QSQR0100) :
     C                                 'SQLR0100' : apiError)
      * ---------------------------------------------------------
      *
      *    Get physical files keys.
      *
     C                   if        FileType = 'PF'
     C                   exsr      $GetPhyKey
      *
      *    Fix DDS to DDL source.
      *
     C                   exsr      $FixDDStoDDL
     C                   endif
     C
     C                   eval      *inLR = *on
     C                   return
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Get physical files keys.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $GetPhyKey    BEGSR

      *  Get the list of primary keys.

     C                   callp     system('DSPFD FILE(' + %TrimR(inLib) +
     C                               '/' + InFile + ')' +
     C                               ' TYPE(*accpth)' +
     C                               ' OUTPUT(*outfile)' +
     C                               ' OUTFILE(qtemp/rsq000r)')

     C                   callp     system('OVRDBF FILE(qafdaccp) +
     C                                     tofile(qtemp/rsq000r)')
      * ---------------------------------------------------------
      *
      *    Extract keys.
      *    -- APKEYF     Key field name
      *       APKSEQ     D=Descending, A=Ascending
      *
     C                   open      qafdaccp
      *
     C                   read      QWHfdacp
     C                   dow       not %eof
     C                   eval      AYkeyidx += 1
     C                   eval      AYkeyf(AYkeyidx) = APkeyf
     C                   if        APkseq           = 'D'
     C                   eval      AYkseq(AYkeyidx) = 'DESC'
     C                   endif
      *
     C                   read      QWHfdacp
     C                   enddo
      *
     C                   close     qafdaccp

     C                   callp     system('dltovr file(qafdaccp)')

     CSR   #GetPhyKey    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Fix DDS to DDL source.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $FixDDStoDDL  BEGSR
      * ---------------------------------------------------------
      *
      *    Setup override to source member.
      *
     C                   callp     system('ovrdbf source tofile(' +
     C                             %trim(SrcLib) + '/' + %trim(SrcFile) +
     C                             ') mbr(' + %trim(SrcMbr) + ')')
      * ---------------------------------------------------------
      *
      *    Load upto the NOT VOLATILE.
      *
     C                   open      source
      *
     C                   read      source
      *
     C                   dow       not %eof
     C                   except    delsrc
      *
     C                   if        %scan('RCDFMT':srcdta) > *zero
     C                   leave
     C                   endif
      *
     C                   eval      AYsrcidx += 1
     C                   eval      AYsrc(AYsrcIdx) = srcdta
     C                   read      source
     C                   enddo
      * ---------------------------------------------------------
      *
      *    Set keys.
      *
     C                   eval      x        = AYsrcidx - 2
      *
     C                   if        %scan(',    ':AYsrc(x)) <> *zero
     C                   eval      AYsrc(x) = %replace(' ':AYsrc(x):
     C                                        %scan(',    ':AYsrc(x)):5)
     C                   endif
      *
     C                   if        APkeyf  <> '*NONE'
     C                   eval      AYsrc(AYsrcIdx) = '  primary key('
      *
      * 123456789.123456789.123456789.
      * __primary key(xxxxxxxxxx desc,
      *
     C                   for       x = 1 to AYkeyidx
     C                   eval      AYsrcidx += 1
     C                   eval      %subst(AYsrc(AYsrcIdx):15) =
     C                                          AYkeyf(x) + ' ' +
     C                                          AYkseq(x)
     C                   if        x <> AYkeyidx
     C                   eval      %subst(AYsrc(AYsrcIdx):30) = ','
     C                   endif
     C                   endfor
      *
     C                   eval      %subst(AYsrc(AYsrcIdx):30) = '))'
     C                   endif
      * ---------------------------------------------------------
      *
      *    Load that last record.
      *
     C                   if        %scan('RCDFMT':srcdta) > *zero
     C                   eval      AYsrcidx += 1
     C                   eval      AYsrc(AYsrcIdx) = srcdta
     C                   endif
      * ---------------------------------------------------------
      *
      *    Load rest of the member.
      *
     C                   read      source
      *
     C                   dow       not %eof
     C                   except    delsrc
     C                   eval      AYsrcidx += 1
     C                   eval      AYsrc(AYsrcIdx) = srcdta
     C                   read      source
     C                   enddo
      * ---------------------------------------------------------
      *
      *    Write out new source.
      *
     C                   for       x = 1 to AYsrcidx
     C                   eval      srcseq = x
     C                   eval      srcdat = *zero
     C                   eval      srcdta = AYsrc(x)
     C                   except    AddSrc
     C                   endfor
      *
     C                   close     source
      *
     CSR   #FixDDStoDDL  ENDSR
      * ---------------------------------------------------------
      *
      *    Source records.
      *
     Osource    Eadd         AddSrc
     O                       srcseq               6
     O                       srcdat              12
     O                       srcdta             112
      *
     Osource    Edel         DelSrc
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Safe remove member.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P SafeRmvMbr      B                   Export

     D SafeRmvMbr      PI
     D  SrcFileLib                   20A   Value
     D  SrcMbr                       10A   Value

     D InSrcFileLib    DS
     D  SrcFile                      10A
     D  SrcLib                       10A

     ** The structure returned by the QusRMBRD API.
     D szMbrd0100      DS                  INZ
     D  nBytesRtn                    10I 0
     D  nBytesAval                   10I 0
     D  szFileName                   10A
     D  szLibName                    10A
     D  szMbrName                    10A
     D  szFileAttr                   10A
     D  szSrcType                    10A
     D  dtCrtDate                    13A
     D  dtLstChg                     13A
     D  szMbrText                    50A
     D  bIsSource                     1A
     **----------------------------------------------------------------
     ** Input Parameters to the QUSRMBRD API
     **----------------------------------------------------------------
     **  Tells the APIs how long the buffers are that are being used.
     D nBufLen         S             10I 0
     ** Format to be returned
     D Format          S              8A   Inz('MBRD0100')
     ** Whether or not to ignore overrides (0=Ignore, 1 = Apply)
     D bOvr            S              1A   Inz('0')

     C                   eval      InSrcFileLib = SrcFileLib

     **----------------------------------------------------------------
     C                   Reset                   apiError
     C                   Eval      nBufLen = %size(szMbrD0100)
     **----------------------------------------------------------------
     C                   Call      'QUSRMBRD'
     C                   Parm                    szMbrD0100
     C                   Parm                    nBufLen
     C                   Parm                    Format
     C                   Parm                    SrcFileLIb
     C                   Parm                    SrcMbr
     C                   Parm                    bOvr
     C                   Parm                    apiError
      *
      ** If the member exists, remove it.
      *
     C                   if        errRtnLen > *zero   and
     C                             errMsgID  = *blanks
     C                   callp     system('RMVM   FILE(' + %TrimR(srcLib) +
     C                               '/' +
     C                               srcfile + ') MBR(' + srcmbr + ')')
     C                   endif
      *
     C                   return

     P SafeRmvMbr      E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Safe add member.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P SafeAddMbr      B                   Export

     D SafeAddMbr      PI
     D  SrcFileLib                   20A   Value
     D  SrcMbr                       10A   Value

     D InSrcFileLib    DS
     D  SrcFile                      10A
     D  SrcLib                       10A

     ** The structure returned by the QusRMBRD API.
     D szMbrd0100      DS                  INZ
     D  nBytesRtn                    10I 0
     D  nBytesAval                   10I 0
     D  szFileName                   10A
     D  szLibName                    10A
     D  szMbrName                    10A
     D  szFileAttr                   10A
     D  szSrcType                    10A
     D  dtCrtDate                    13A
     D  dtLstChg                     13A
     D  szMbrText                    50A
     D  bIsSource                     1A
     **----------------------------------------------------------------
     ** Input Parameters to the QUSRMBRD API
     **----------------------------------------------------------------
     **  Tells the APIs how long the buffers are that are being used.
     D nBufLen         S             10I 0
     ** Format to be returned
     D Format          S              8A   Inz('MBRD0100')
     ** Whether or not to ignore overrides (0=Ignore, 1 = Apply)
     D bOvr            S              1A   Inz('0')

     C                   eval      InSrcFileLib = SrcFileLib

     **----------------------------------------------------------------
     C                   Reset                   apiError
     C                   Eval      nBufLen = %size(szMbrD0100)
     **----------------------------------------------------------------
     C                   Call      'QUSRMBRD'
     C                   Parm                    szMbrD0100
     C                   Parm                    nBufLen
     C                   Parm                    Format
     C                   Parm                    SrcFileLIb
     C                   Parm                    SrcMbr
     C                   Parm                    bOvr
     C                   Parm                    apiError
      *
      ** If the member doesn't exist, add it; otherwise, just return.
      *
     C                   if        errRtnLen > *zero
     C                   if        errMsgID = 'CPF9815' or
     C                             errMsgID = 'CPF3019' or
     C                             errMsgID = 'CPF32DE' or
     C                             errMsgID = 'CPF3C27' or
     C                             errMsgID = 'CPF3C26'
     C                   callp     system('ADDPFM FILE(' + %TrimR(srcLib) +
     C                               '/' +
     C                               srcfile + ') MBR(' + srcmbr +
     C                               ') srctype(SQL) +
     C                                  text(''' + %trim(QUStd12) + ''')')
     C                   endif
     C                   endif
      *
     C                   return

     P SafeAddMbr      E
