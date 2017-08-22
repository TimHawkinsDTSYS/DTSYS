      /TITLE Write Column Headings
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Writes column headings for the specified file.
      *
      *  Notes   :  none
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  04/09/06  TimH        New program.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
      /COPY QCPYSRC,Hspec
      *
     Fqadspffd  if   e             disk    usropn
      *
     D FileName        s                   like(ifsFileName) inz
     D FileNameP       s                   like(StdPtr) inz(%addr(FileName))
     D DLdata          s                   like(StdBuf)  inz
     D DLdataP         s                   like(StdPtr) inz(%addr(DLdata))
     D rc              s                   like(ifsReturnInt) inz
     D fd              s                   like(ifsFileDesc)  inz
      *
     D PLfile          s                   like(ifsfileName)
     D WKdata          s                   like(DLdata) inz
     D Column          s                   like(StdInt) inz
      *
      /copy qcpysrc,Dspec
      *---------------------------------------------------------
      *
      *   Read thru the fields (once for each heading).
      *
     C                   exsr      $ReadFields
     C                   exsr      $ReadFields
     C                   exsr      $ReadFields
      *
      *   Close IFS file.
      *
     C                   eval      rc = IFSclose(fd)
      *
     C                   eval      *inLR = *on
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Read thru the fields.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ReadFields   BEGSR
      *
     C                   eval      DLdata  = *blanks
     C                   eval      Column += 1
     C                   open      qadspffd
      *---------------------------------------------------------
      *
      *   Concatenate all columns.
      *
     C                   read      qwhdrffd
      *
     C                   dow       not %eof
     C                   if        DLdata <> *blanks
     C                   eval      DLdata = %trim(DLdata) + ','
     C                   endif
      *
     C                   select
     C                   when      Column = 1
     C                   eval      DLdata = %trim(DLdata) +
     C                                '"' + %trim(WHchd1) + '"'
      *
     C                   when      Column = 2
     C                   eval      DLdata = %trim(DLdata) +
     C                                '"' + %trim(WHchd2) + '"'
      *
     C                   when      Column = 3
     C                   eval      DLdata = %trim(DLdata) +
     C                                '"' + %trim(WHchd3) + '"'
     C                   endsl
      *
     C                   read      qwhdrffd
     C                   enddo
      *
     C                   close     qadspffd
      *---------------------------------------------------------
      *
      *   Assure that we arn't just sending blanks.
      *
     C                   eval      WKdata = %xlate('"':' ':DLdata)
     C                   eval      WKdata = %xlate(',':' ':WKdata)
     C                   if        WKdata = *blanks
     C                   leavesr
     C                   endif
      *---------------------------------------------------------
      *
      *   Write IFS record.
      *
     C                   eval      DLdata = %trim(DLdata) + ifsCRLF
      *
     C                   eval      rc  = write(fd:DLdataP:
     C                                   %len(%trim(DLdata)))
      *
     CSR   #ReadFields   ENDSR
      /SPACE 3
      /COPY QCPYSRC,$PSSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Initialize variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
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
      *
     C                   eval      rc = IFSclose(fd)
      *
     C                   eval      fd = open(FileNameP:O_WRONLY+O_TEXTDATA)
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Define variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Define       BEGSR
      *
     C     *entry        plist
     C                   parm                    PLfile
      *
     CSR   #Define       ENDSR
