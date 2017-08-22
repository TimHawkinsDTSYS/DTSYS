      /TITLE Copy Spooled File to Image
      *
      * P: PARMS OPTION(*NOXREF)
      *
      * S: Copies a spoolfile into the specified database file                */
      * S:  to appear as a image, taking into account the spacing             */
      * S:  of the report so that the resultant file would have               */
      * S:  blank lines.                                                      */
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * M: MODIFICATIONS --
      *
      * M: YY/MM/DD  PROGRAMMER  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
     FWRKFILE   IP   F  202        DISK
     FTOFILE    O    F  198        DISK
      *
     D DSinpData       DS
     D   InpData                      1    dim(198)
      *
     D DSoutData       DS
     D   OutData                      1    dim(198)
      *
     Iwrkfile   NS
     I                                  1    3 0RcdSkp
     I                                  4    4 0RcdSpc
     I                                  5  202  DSinpData
      *
      *
     C                   EXSR      $CpyRecord
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Copy record.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CpyRecord    BEGSR
      *
      *    Write the spool data.
      *
     C                   exsr      $WrtDta                                      Spc bfr 3
      *
      *    Skip/Space specified lines.
      *
     C     RcdSkp        ifne      *zero                                        Any skipping
     C                   exsr      $Skip                                        Any skipping
     C                   else                                                   Any skipping
     C                   exsr      $Space                                       Any skipping
     C                   endif                                                  Reset
      *
     CSR   #CpyRecord    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Write data.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $WrtDta       BEGSR
      *
     C                   if           RcdSkp <> *zero                           Spc bfr 3
     C                             or RcdSpc <> *zero                           Spc bfr 3
      *
     C                   if        DtaFmt = '*CRLF'                             Spc bfr 3
     C                   eval      DSoutData = %trim(DSoutData) + CRLF          Data rcd
     C                   endif                                                  Reset
      *
     C                   except    @Data                                        Data rcd
     C                   add       1             LinNbr                         Reset
     C                   eval      DSoutData = *blanks                          Data rcd
      *
     C                   endif                                                  Reset
      *
     CSR   #WrtDta       ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Skip.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Skip         BEGSR
      *
      *    If skip is less than the line, new page.
      *
     C     RcdSkp        IFLT      LinNbr                                       If new page
     C     InsPagBrk     andeq     '*YES'                                       If new page
     C                   sub       1             RcdSkp                         Spl page nb
      *
     C                   do        4                                            Spc bfr 3
     C                   add       1             LinNbr                         Reset
     C                   except    @blank                                       Blank rcd
     C                   enddo                                                  Blank rcd
      *
     C                   z-add     1             LinNbr                         Reset
     C                   except    @NewPag                                      Page format
     C                   endif                                                  If new page
      *
      *    Skip specified lines.
      *
     C                   do        RcdSkp                                       Spc bfr 3
     C                   add       1             LinNbr                         Reset
     C                   except    @blank                                       Blank rcd
     C                   enddo                                                  Blank rcd
      *
      *    Combine the previous line with the current line.
      *
     C                   exsr      $Combine                                     Reset
      *
     CSR   #Skip         ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Space.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Space        BEGSR
      *
      *    Wrote spool data.
      *
     C                   if        RcdSpc <> *zero                              Spc bfr 3
     C                   sub       1             RcdSpc                         Reset
     C                   endif                                                  Reset
      *
      *    Space specified lines.
      *
     C                   do        RcdSpc                                       Spc bfr 3
     C                   add       1             LinNbr                         Reset
     C                   except    @blank                                       Blank rcd
     C                   enddo                                                  Blank rcd
      *
      *    Combine the previous line with the current line.
      *
     C                   exsr      $Combine                                     Reset
      *
     CSR   #Space        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Combine the previous lines (not written) with current.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Combine      BEGSR
      *
      *    Combine.
      *
     C     DSinpData     ifne      *blanks                                      Reset
     C     DSoutData     andne     *blanks                                      Reset
      *
     C                   do        198           x                              Spc bfr 3
     C     InpData(x)    ifne      *blanks                                      Reset
     C                   eval      OutData(x) = InpData(x)                      Reset
     C                   endif                                                  Blank rcd
     C                   enddo                                                  Blank rcd
     C                   else                                                   Blank rcd
      *
      *    Replace (overlay).
      *
     C     DSinpData     ifne      *blanks                                      Reset
     C     DSoutData     andeq     *blanks                                      Reset
     C                   eval      DSoutData = DSinpData                        Reset
     C                   endif                                                  Blank rcd
     C                   endif                                                  Blank rcd
      *
     CSR   #Combine      ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Initialization
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   eval      PageBreak =                                  Reset
     C                             '------------------------------+
     C                              ---- page break --------------+
     C                              --------------------'
      *
     C                   MOVE      X'0D0A'       CRLF              2
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Definitions
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Define       BEGSR
      *
     C     *entry        plist
     C                   parm                    DtaFmt           10            Spl page nb
     C                   parm                    InsPagBrk         4            Spl page nb
      *
     C                   clear                   PageBreak        80            Spl page nb
     C                   clear                   SPLPAG            5 0          Spl page nb
     C                   clear                   LinNbr            5 0          Reset
     C                   clear                   X                 5 0
      *
     CSR   #Define       ENDSR
      *
     OTofile    E            @NewPag
     O                       PageBreak
      *
     OTofile    E            @Blank
      *
     OTofile    E            @Data
     O                       DSoutData          198
