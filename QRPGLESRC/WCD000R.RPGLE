      /TITLE Write CSV DB file
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Copies the specified database file into the
      *              streamfile in a comma seperated values format.
      *
      *  Notes   :  none
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  04/09/06  TimH        New program.
      *
      *  10/26/06  EmilS       Changed to correctly return back numeric
      *                         fields.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
      /COPY QCPYSRC,Hspec
      *
     Fqadspffd  if   e             disk
     FDBfile    if   f 8000        disk    block(*yes)
      * ---------------------------------------------------------
      *
      *  Display file field descriptions.
      *
     D dspffd        e ds                  extname(qadspffd) inz
      *
     D FDfldn          s                   like(WHfldn) inz
     D FDoccur         s                   like(StdInt) inz
     D Column          s                   like(StdInt) inz
      *
     D FDentry         DS                  occurs(400)
     D  FDfldnam                           like(WHfldi)
     D  FDfldtyp                           like(WHfldt)
     D  FDbufpos                           like(WHibo)
     D  FDfldlen                           like(WHfldb)
     D  FDdeclen                           like(WHfldd)
     D  FDdecpos                           like(WHfldp)
     D  FDedtcde                           like(WHecde)
     D  FDedtwrd                           like(WHewrd)
     D  FDvarlen                           like(WHvarl)
     D  FDcolhdg1                          like(WHchd1)
     D  FDcolhdg2                          like(WHchd2)
     D  FDcolhdg3                          like(WHchd3)
      * ---------------------------------------------------------
      *
      *  IFS fields.
      *
     D FileName        s                   like(ifsFileName) inz
     D FileNameP       s                   like(StdPtr) inz(%addr(FileName))
     D DLdata          s           2000    inz
     D DLdataP         s                   like(StdPtr) inz(%addr(DLdata))
     D rc              s                   like(ifsReturnInt) inz
     D fd              s                   like(ifsFileDesc)  inz
      *
     D PLfile          s                   like(ifsfileName)
     D PLcolhdg        s                   like(StdNam)
     D Owner           s                   like(StdNam)
     D WKdata          s           2000    varying inz
      * ---------------------------------------------------------
      *
      *  Workfields.
      *
     D WrkNum          s                   like(StdMaxDec) inz
      * ---------------------------------------------------------
      *
      *  Extracted field.
      *
     D ExtData         s                   like(StdBuf) inz
      * ---------------------------------------------------------
      *
      *  Variable length extract.
      *
     D VarLenDS        ds
     D  VarLen                             like(StdIntSml) inz
      * ---------------------------------------------------------
      *
      *  Constants.
      *
     D ConstDate6s     c                   '''    / 0'''
     D ConstDate6d     c                   '''    - 0'''
     D ConstDate8s     c                   '''  /  / 0'''
     D ConstDate8d     c                   '''  -  - 0'''
     D ConstDate10s    c                   '''    /  / 0'''
     D ConstDate10d    c                   '''    -  - 0'''
     D ConstDateW1940  c                   '1940-01-01'
     D ConstDateW1950  c                   '1950-01-01'
      *
     D ConstTime6c     c                   '''  :  : 0'''
     D ConstTime6d     c                   '''  .  . 0'''
     D ConstTime4c     c                   '''  : 0'''
     D ConstTime4d     c                   '''  . 0'''
      *
     D ConstTSP        c                   '0001-01-01-00.00.00.000000'
      *
      *COPY QCPYSRC,DBtrig
      /COPY QCPYSRC,Dspec
      * ---------------------------------------------------------
      *
      *  DB file.
      *
     IDBfile    ns
     I                                  1 8000  DBdata
      * ---------------------------------------------------------
      *
      *   Extract information from the DSPFFD.
      *
     C                   exsr      $ExtDspffd
      * ---------------------------------------------------------
      *
      *   Column headings.
      *
     C     PLcolhdg      caseq     '*COMBINED'   $ColHdgCmb
     C     PLcolhdg      caseq     '*SEPERATED'  $ColHdgSep
     C                   endcs
      * ---------------------------------------------------------
      *
      *   Process DB file.
      *
     C                   exsr      $ProcDBfile
      *
     C                   eval      *inLR = *on
      *
     C                   eval      rc = IFSclose(fd)
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *Extract information from the DSPFFD.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $ExtDspffd    begsr
      *---------------------------------------------------------
      *
      *   Extract each field into the storage area.
      *
     C                   read      qwhdrffd
      *
     C                   dow       not %eof
     C                   eval      FDoccur += 1
     C     FDoccur       occur     FDentry
     C                   eval      FDfldnam = WHfldi
     C                   eval      FDfldn   = WHfldn
     C                   eval      FDfldtyp = WHfldt
     C                   eval      FDbufpos = WHibo
     C                   eval      FDfldlen = WHfldb
     C                   eval      FDdeclen = WHfldd
     C                   eval      FDdecpos = WHfldp
     C                   eval      FDedtcde = WHecde
     C                   eval      FDedtwrd = WHewrd
     C                   if        WHvarl   = 'Y'
     C                   eval      FDvarlen = WHvarl
     C                   else
     C                   eval      FDvarlen = *blanks
     C                   endif
     C                   eval      FDcolhdg1 = WHchd1
     C                   eval      FDcolhdg2 = WHchd2
     C                   eval      FDcolhdg3 = WHchd3
      *
      *    CSV cannot handle comma's used in edit codes.
      *
     C                   select
     C                   when      FDedtcde = 'J'  or
     C                             FDedtcde = 'L'
     C                   eval      FDedtcde = 'P'
      *
     C                   when      FDedtcde = 'K'  or
     C                             FDedtcde = 'M'
     C                   eval      FDedtcde = 'Q'
     C                   endsl
      *
     C     ',':' '       xlate     FDedtwrd      FDedtwrd
      *
     C                   read      qwhdrffd
     C                   enddo
      *
     Csr   #ExtDspffd    endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Column headings combined.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ColHdgCmb    BEGSR
      *
     C                   eval      DLdata  = *blanks
      *---------------------------------------------------------
      *
      *   Extract field from the buffer.
      *
š1b€ C                   for       FDoccur = 1 to FDfldn
     C     FDoccur       occur     FDentry
      *
     C                   if        DLdata <> *blanks
     C                   eval      DLdata = %trim(DLdata) + ','
     C                   endif
      *
     C                   eval      DLdata = %trim(DLdata) +
     C                                '"' + %trim(FDcolhdg1) + ' ' +
     C                                      %trim(FDcolhdg2) + ' ' +
     C                                      %trim(FDcolhdg3) + '"'
     C                   endfor
      *
      *   Write IFS record.
      *
     C                   eval      DLdata = %trim(DLdata) + ifsCRLF
      *
     C                   eval      rc = write(fd:DLdataP:
     C                                  %len(%trim(DLdata)))
     C                   if        rc < *zero
     C                   callp     ExecCmd('ovrdbf stdout qtemp/stdout')
     C                   callp     perror('heading write')
     C                   callp     perror(FileNameP)
     C                   exsr      *pssr
     C                   endif
      *
     CSR   #ColHdgCmb    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Column headings seperated.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ColHdgSep    BEGSR
      *---------------------------------------------------------
      *
      *   Extract field from the buffer.
      *
š1b€ C                   for       Column  = 1 to 3
     C                   eval      DLdata  = *blanks
      *
š1b€ C                   for       FDoccur = 1 to FDfldn
     C     FDoccur       occur     FDentry
      *
     C                   if        DLdata <> *blanks
     C                   eval      DLdata = %trim(DLdata) + ','
     C                   endif
      *
     C                   select
     C                   when      Column = 1
     C                   eval      DLdata = %trim(DLdata) +
     C                                '"' + %trim(FDcolhdg1) + '"'
      *
     C                   when      Column = 2
     C                   eval      DLdata = %trim(DLdata) +
     C                                '"' + %trim(FDcolhdg2) + '"'
      *
     C                   when      Column = 3
     C                   eval      DLdata = %trim(DLdata) +
     C                                '"' + %trim(FDcolhdg3) + '"'
     C                   endsl
     C                   endfor
      *---------------------------------------------------------
      *
      *   Assure that we arn't just sending blanks.
      *
     C                   eval      WKdata = %xlate('"':' ':DLdata)
     C                   eval      WKdata = %xlate(',':' ':WKdata)
      *
      *   Write IFS record.
      *
     C                   if        WKdata <> *blanks
     C                   eval      DLdata = %trim(DLdata) + ifsCRLF
      *
     C                   eval      rc = write(fd:DLdataP:
     C                                  %len(%trim(DLdata)))
     C                   if        rc < *zero
     C                   callp     ExecCmd('ovrdbf stdout qtemp/stdout')
     C                   callp     perror('column write')
     C                   callp     perror(FileNameP)
     C                   exsr      *pssr
     C                   endif
     C                   endif
     C                   endfor
      *
     CSR   #ColHdgSep    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *Process DB file.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $ProcDBfile   begsr
      *---------------------------------------------------------
      *
      *   Extract each field into the storage area.
      *
     C                   read      DBfile
      *
     C                   dow       not %eof
     C                   eval      WKdata  = *blanks
      *---------------------------------------------------------
      *
      *   Extract field from the buffer.
      *
š1b€ C                   for       FDoccur = 1 to FDfldn
     C     FDoccur       occur     FDentry
š1b€ C                   exsr      $ExtFldDta
      *
      *   Convert according to field type
      *
     C     FDfldtyp      caseq     'S'           $cvtZonPak
     C     FDfldtyp      caseq     'P'           $cvtZonPak
     C     FDfldtyp      caseq     'L'           $cvtdtetim
     C     FDfldtyp      caseq     'T'           $cvtdtetim
     C     FDfldtyp      caseq     'Z'           $cvtdtetim
š3e€ C                   endcs
      * ---------------------------------------------------------
      *
      *   Add value to the output record.
      *
     C                   exsr      $AddValOutRec
š1e€ C                   endfor
      *---------------------------------------------------------
      *
      *   Write IFS record.
      *
     C                   eval      DLdata = %trim(WKdata) + ifsCRLF
      *
     C                   eval      rc = write(fd:DLdataP:
     C                                  %len(%trim(DLdata)))
     C                   if        rc < *zero
     C                   callp     ExecCmd('ovrdbf stdout qtemp/stdout')
     C                   callp     perror('data write')
     C                   callp     perror(FileNameP)
     C                   exsr      *pssr
     C                   endif
      *
     C                   read      DBfile
š1e€ C                   enddo
      * ---------------------------------------------------------
      *
      *   Close IFS file.
      *
     C                   eval      rc = IFSclose(fd)
     C                   if        rc < *zero
     C                   callp     ExecCmd('ovrdbf stdout qtemp/stdout')
     C                   callp     perror('final close')
     C                   callp     perror(FileNameP)
     C                   exsr      *pssr
     C                   endif
      *
     Csr   #ProcDBfile   endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *Extract field data.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $ExtFldDta    begsr
      * ---------------------------------------------------------
      *
      *   Extract field from the buffer (variable length).
      *
š1b€ C                   if        FDvarlen  = 'Y'
š1b€ C                   eval      VarLenDS  = %subst(DBdata:FDbufpos)
     C                   eval      ExtData   = %subst(DBdata:
     C                                         FDbufpos + %len(VarLenDS):
     C                                         VarLen)
š1b€ C                   endif
      * ---------------------------------------------------------
      *
      *   Extract field from the buffer (fixed length).
      *
š1b€ C                   if        FDvarlen <> 'Y'
     C                   eval      ExtData   =
     C                             %subst(DBdata:FDbufpos:FDfldlen)
š1b€ C                   endif
      *
     Csr   #ExtFldDta    endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *Convert date/time/timestamp field.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $cvtdtetim    begsr
      * ---------------------------------------------------------
      *   Edited time/date is all zeros.
      *
š2b€ C                   if         FDfldtyp  = 'L'             and
     C                             (ExtData   = ConstDateW1940  or
     C                              ExtData   = ConstDateW1950)
     C                   eval       ExtData   = *blanks
š2x€ C                   else
      *
š3b€ C                   select
š3x€ C                   when      FDfldtyp = 'T'
     C     '0:. '        check     ExtData
      *
š3x€ C                   when      FDfldtyp = 'L'
     C     '01/- '       check     ExtData
      *
š3x€ C                   when      FDfldtyp = 'Z'
     C     '01-. '       check     ExtData
š3e€ C                   endsl
      *
š3b€ C                   if        not %found
     C                   eval      ExtData = *blanks
š3e€ C                   endif
š2e€ C                   endif
      *
     Csr   #cvtdtetim    endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *Convert zoned/packed numeric field.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $CvtZonPak    begsr
      *
     C                   reset                   WrkNum
      * ---------------------------------------------------------
      *   Extract value.
      *
     C                   eval      WrkNum = CvtChrNum(ExtData:FDfldtyp:
     C                                                FDdeclen:FDdecpos)
      * ---------------------------------------------------------
      *   Edit numeric variable.
      *
     C                   exsr      $EdtNumVar
      *
     Csr   #CvtZonPak    endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *Edit numeric variable.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $EdtNumVar    begsr
      *
     C                   eval      ExtData   = *blanks
      * ---------------------------------------------------------
      *  Edit time (6).
      *
     C                   select
     C                   when      FDedtwrd  = ConstTime6c    or
     C                             FDedtwrd  = ConstTime6d
     C                   if        WrkNum   <> *zero
     C                   eval      ExtData   = EdtHMSfromHMS(WrkNum)
     C                   endif
      * ---------------------------------------------------------
      *  Edit time (4).
      *
     C                   when      FDedtwrd  = ConstTime4c    or
     C                             FDedtwrd  = ConstTime4d
     C                   if        WrkNum   <> *zero
     C                   eval      ExtData   = EdtHMfromHM(WrkNum)
     C                   endif
      * ---------------------------------------------------------
      *  Edit dates (mm/yyyy).
      *
     C                   when      FDedtwrd  = ConstDate6s      or
     C                             FDedtwrd  = ConstDate6d
     C                   if        WrkNum   <> *zero
     C                   eval      ExtData   = %trim(%editc(WrkNum:'Z'))
     C                   eval      ExtData   = %subst(ExtData:5:2) + '/' +
     C                                         %subst(ExtData:1:4)
     C                   endif
      * ---------------------------------------------------------
      *  Edit dates (mm/dd/yy).
      *
     C                   when      FDedtwrd  = ConstDate8s      or
     C                             FDedtwrd  = ConstDate8d
     C                   if        WrkNum   <> *zero
     C                   eval      ExtData   = %trim(%editc(WrkNum:'Z'))
     C                   eval      ExtData   = %subst(ExtData:5:2) + '/' +
     C                                         %subst(ExtData:7:2) + '/' +
     C                                         %subst(ExtData:3:2)
     C                   endif
      * ---------------------------------------------------------
      *  Edit dates (mm/dd/yyyy).
      *
š1b€ C                   when      FDedtcde  = 'Y'              or
     C                             FDedtwrd  = ConstDate10s     or
     C                             FDedtwrd  = ConstDate10d
     C                   if        WrkNum   <> *zero
     C                   eval      ExtData   = %trim(%editc(WrkNum:'Z'))
     C                   eval      ExtData   = %subst(ExtData:5:2) + '/' +
     C                                         %subst(ExtData:7:2) + '/' +
     C                                         %subst(ExtData:1:4)
     C                   endif
      * ---------------------------------------------------------
      *  Edit using edit code.
      *
š1x€ C                   other
     C                   eval      edtcde    = FDedtcde
      *
š1b€ C                   if        edtcde = ' '
     C                   eval      edtcde = 'P'
š2e€ C                   endif
      *
š2b€ C**                 if        WrkNum   <> *zero
     C                   eval      ExtData =
     C                             EdtVar(WrkNum:edtcde:FDdecpos)
š2e€ C**                 endif
š2e€ C                   endsl
      *
     Csr   #EdtNumVar    endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *Add value to output record.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $AddValOutRec begsr
      *---------------------------------------------------------
      *
      *   Insert data, numeric values.
      *
     C                   select
     C                   when      FDfldtyp = 'S' or
     C                             FDfldtyp = 'P'
     C                   if        WKdata = *blanks
     C                   eval      WKdata = %trimr(WKdata) + Extdata
     C                   else
     C                   eval      WKdata = %trimr(WKdata) + ',' +
     C                                                       Extdata
     C                   endif
      *
      *   Insert data, character values.
      *
     C                   other
     C                   if        WKdata = *blanks
     C                   eval      WKdata = %trimr(WKdata) + '"' +
     C                             %trim(%subst(ExtData:1:FDfldlen)) + '"'
     C                   else
     C                   eval      WKdata = %trimr(WKdata) + ',"' +
     C                             %trim(%subst(ExtData:1:FDfldlen)) + '"'
     C                   endif
     C                   endsl
      *
     Csr   #AddValOutRec endsr
      /SPACE 3
      /COPY QCPYSRC,$pssr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *Initialization
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   *inzsr        begsr
      * -------------------------------------------------------------
      *
      *   Remove the buffer exceeded message.
      *
     C                   callp     ClrPgmq()
      * -------------------------------------------------------------
      *
      *   Open IFS file.
      *
     C                   eval      FileName = PLfile
      *
     C                   if        %scan(ifsNull:FileName) = *zero
     C                   eval      FileName = %trim(FileName) + ifsNull
     C                   endif
      *
     C                   eval      fd = open(FileNameP:
     C                                  O_WRONLY+O_TRUNC+O_CREAT+O_CODEPAGE:
     C                                  511: ifsAsciiCdePag)
     C                   if        fd < *zero
     C                   callp     ExecCmd('ovrdbf stdout qtemp/stdout')
     C                   callp     perror('initial error')
     C                   callp     perror(FileNameP)
     C                   exsr      *pssr
     C                   endif
      *
     C                   eval      rc = IFSclose(fd)
     C                   if        rc < *zero
     C                   callp     ExecCmd('ovrdbf stdout qtemp/stdout')
     C                   callp     perror('initial close')
     C                   callp     perror(FileNameP)
     C                   exsr      *pssr
     C                   endif
      /free
       // -------------------------------------------------------
       // Retrive object owner & environment.

       Owner  = RtvObjOwn(ZZpgm:'*PGM');

       // Set authorities.

       ChgIFSown(FileName:owner);

      /end-free
     C                   eval      fd = open(FileNameP:O_WRONLY+O_TEXTDATA)
     C                   if        fd < *zero
     C                   callp     ExecCmd('ovrdbf stdout qtemp/stdout')
     C                   callp     perror('second open')
     C                   callp     perror(FileNameP)
     C                   exsr      *pssr
     C                   endif
      *
     Csr   #inzsr        endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *Definitions
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $define       begsr
      *
     C     *entry        plist
     C                   parm                    PLfile
     C                   parm                    PLcolhdg
      *
     Csr   #define       endsr
