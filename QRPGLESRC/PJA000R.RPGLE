      /TITLE Print Journal Analysis, Summarize Journals
      *
      * P: PARMS USRPRF(*OWNER) AUT(*ALL)
      *
      * S:
      *
      * C: 91/12/03  RCTHAWK
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
     FQADSPJRN  IP   E             DISK
     FPJA000P   O  A E             DISK
      *
     D KEY             S             33    DIM(9000) ASCEND
     D LKP             S              5  0 DIM(14)
      *
     D TRNDS         E DS                  OCCURS(9000) EXTNAME(PJA000P)
      *
      /EJECT
     C                   EXSR      $ACCUM
      *
     CLR                 EXSR      $WRITE
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ACCUMULATE ENTRIES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ACCUM        BEGSR
      *
     C                   MOVEL     JOLIB         WK020A           20
     C                   MOVE      JOOBJ         WK020A
     C                   MOVEL     WK020A        WK026A           26
     C                   MOVE      JODATE        WK026A
     C                   MOVEL     WK026A        WK028A           28
     C                   MOVEL     JOTIME        WK002A            2
     C                   MOVE      WK002A        WK028A
     C                   EXSR      $LOKUP
      *
     C     FOUND         IFEQ      ON
     C                   MOVEA     KEY(LX)       WK033A
     C                   MOVE      WK033A        OCUR              5 0
     C     OCUR          OCCUR     TRNDS
     C                   ELSE
      *
     C                   ADD       1             ARYIDX            5 0
     C                   MOVE      ARYIDX        X                 5 0
     C                   MOVEL     WK028A        WK033A           33
     C                   MOVE      ARYIDX        WK033A
     C                   MOVE      WK033A        KEY(X)
     C     ARYIDX        OCCUR     TRNDS
     C                   CLEAR                   TRNDS
     C                   MOVE      JOLIB         FSLIB
     C                   MOVE      JOOBJ         FSOBJ
     C                   MOVE      JODATE        FSDTE
     C                   MOVEL     JOTIME        FSTME
     C                   SORTA     KEY
     C                   ENDIF
      *
     C     'R'           IFEQ      JOCODE
     C     'PT'          IFEQ      JOENTT
     C     'UP'          OREQ      JOENTT
     C                   MOVE      JOENTL        FSLEN
     C                   ENDIF
     C                   ENDIF
      *
     C                   SELECT
     C     'OP'          WHENEQ    JOENTT
     C                   ADD       1             FSOPN
     C     'CL'          WHENEQ    JOENTT
     C                   ADD       1             FSCLO
     C     'PT'          WHENEQ    JOENTT
     C                   ADD       1             FSADD
     C     'UP'          WHENEQ    JOENTT
     C                   ADD       1             FSUPD
     C     'DL'          WHENEQ    JOENTT
     C                   ADD       1             FSDLT
     C                   ENDSL
      *
     CSR   #ACCUM        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * BINARY SEARCH FOR KEY.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $LOKUP        BEGSR
      *
     C                   Z-ADD     LKPMID        LX                5 0
     C                   MOVE      *ZERO         LY
     C                   Z-ADD     2             LKPINC
     C                   MOVEL     WK028A        LKPSRC
      *
     C     LKPSRC        DOUEQ     LKPWRK
     C                   MOVE      KEY(LX)       WK033A
     C                   MOVEL     WK033A        LKPWRK
      *
     C     LKPINC        IFEQ      1
     C     LKPSRC        ANDNE     LKPWRK
     C                   MOVE      OFF           FOUND             1
     C                   GOTO      #LOKUP
     C                   ENDIF
      *
     C                   ADD       1             LY
     C                   MOVE      LKP(LY)       LKPINC
      *
     C     LKPSRC        IFGT      LKPWRK
     C                   ADD       LKPINC        LX
     C     LX            IFGT      LKPMAX
     C                   Z-ADD     LKPMAX        LX
     C                   ENDIF
     C                   ELSE
      *
     C     LKPSRC        IFLT      LKPWRK
     C                   SUB       LKPINC        LX
     C     LX            IFLT      1
     C                   Z-ADD     1             LX
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   MOVE      ON            FOUND
      *
     CSR   #LOKUP        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * SET-UP LOOKUP.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $SETLU        BEGSR
      *
     C     *LIKE         DEFINE    WK028A        LKPSRC
     C     *LIKE         DEFINE    LKPSRC        LKPWRK
      *
     C                   Z-ADD     9000          LKPMAX            5 0
     C                   MOVE      005           DEC31             3 1
     C     LKPMAX        MULT      DEC31         LKPINC            5 0
     C                   Z-ADD     LKPINC        LKPMID            5 0
      *
     C     LKPINC        DOUEQ     1
     C     LKPINC        MULT(H)   DEC31         LKPINC
     C                   ADD       1             LY                5 0
     C                   MOVE      LKPINC        LKP(LY)
     C                   END
      *
     CSR   #SETLU        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * WRITE SUMMARY RECORDS.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $WRITE        BEGSR
      *
     C                   DO        ARYIDX        OCUR              5 0
     C     KEY(OCUR)     IFNE      *BLANKS
     C     OCUR          OCCUR     TRNDS
      *
     C     FSLEN         IFEQ      *ZERO
     C     FSDLT         ANDNE     *ZERO
     C                   MOVE      125           FSLEN
     C                   ENDIF
      *
     C                   WRITE     PJA000R
     C                   ENDIF
     C                   ENDDO
      *
     CSR   #WRITE        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   MOVE      '0'           OFF               1
     C                   MOVE      '1'           ON                1
      *
     C                   EXSR      $SETLU
     C                   MOVE      *HIVAL        KEY
      *
     CSR   #INZSR        ENDSR
