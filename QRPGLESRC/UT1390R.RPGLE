      /TITLE Utility, Scan and Replace
      *PARMS OPTION(*NOXREF)
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:
      *
      *  Notes   :  none
      *
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  10/04/96  TimH        New program.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
     C     SRCH_STR      DOUEQ     *ZERO
     C                   EXSR      $SCAN
     C     PATT_STG      IFNE      *BLANKS
     C     SRCH_STR      CASNE     *ZERO         $REPLACE
     C                   ENDCS
     C                   ENDIF
     C                   ENDDO
      *
     C                   RETURN
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  SCAN FOR REPLACEABLE CHARACTERS.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $SCAN         BEGSR
      *
      *    Search for each variable.
      *
     C     ' '           CHECKR    PATT_STG      PL
      *
     C     PATT_STG:PL   SCAN      SRCH_STG      SRCH_STR
      *
     CSR   #SCAN         ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Replace variable.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $REPLACE      BEGSR
      *
      *    Determine pattern length.
      *
     C     ' '           CHECKR    PATT_STG      PATT_LEN
      *
      *    Determine pattern end position.
      *
     C                   EVAL      PATT_END = SRCH_STR + PATT_LEN
      *
      *    Determine search string remaining length.
      *
     C                   EVAL      SRCH_REM = %SIZE(SRCH_STG) - PATT_END
      *
      *    Insert replacement variable where pattern was found.
      *
     C                   EVAL      SRCH_WRK =
     C                              %SUBST(SRCH_STG:1:SRCH_STR-1) +
     C                              ' ' +
     C                              %TRIM(REPL_STG) +
     C                              ' ' +
     C                              %SUBST(SRCH_STG:PATT_END:SRCH_REM)
      *
     C                   EVAL      SRCH_STG = SRCH_WRK
      *
     CSR   #REPLACE      ENDSR
      /SPACE 3
      /COPY QCPYSRC,$CVTDD
      /SPACE 3
      /COPY QCPYSRC,$CVTDF
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   MOVE      UDATE         CVFDTE
     C                   EXSR      $CVTDF
     C                   MOVE      CVTDTE        TODAY             6 0
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PATT_STG        256
     C                   PARM                    REPL_STG        256
     C                   PARM                    SRCH_STG       1024
      *                                                                         Number of elements
     C     *LIKE         DEFINE    SRCH_STG      SRCH_WRK
      *                                                                         Number of elements
     C                   CLEAR                   X                 5 0
     C                   CLEAR                   WK001A            1
      *                                                                         Number of elements
     C                   MOVE      *ZERO         PL                5 0
     C                   MOVE      *ZERO         PATT_LEN          5 0
     C                   MOVE      *ZERO         PATT_END          5 0
     C                   MOVE      *ZERO         SRCH_REM          5 0
     C                   MOVE      *ZERO         SRCH_STR          5 0
      *
     CSR   #DEFN         ENDSR
