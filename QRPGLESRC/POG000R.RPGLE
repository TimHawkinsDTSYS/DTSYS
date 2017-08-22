      /TITLE Purge Object Growth
      *
      * P: PARMS OPTION(*NOXREF)
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
      *
     FCOG000P   UF   E             DISK    USROPN
     FCOG010P   UF   E             DISK    USROPN
     FCOG020P   UF   E             DISK    USROPN
     FCOG030P   UF   E             DISK    USROPN
      *
     D PGMDS         ESDS                  EXTNAME(DSPGM)
      *
     C     COG000PDAT    CASNE     *ZERO         $COG000P
     C                   ENDCS
      *
     C     COG010PDAT    CASNE     *ZERO         $COG010P
     C                   ENDCS
      *
     C     COG020PDAT    CASNE     *ZERO         $COG020P
     C                   ENDCS
      *
     C     COG030PDAT    CASNE     *ZERO         $COG030P
     C                   ENDCS
      *
     C                   MOVE      *ON           *INLR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Delete COG000P records.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $COG000P      BEGSR
      *
     C                   OPEN      COG000P
     C                   READ      COG000R                                99
      *
     C     *IN99         DOWEQ     *OFF
     C                   MOVE      OGYEAR        YEAR
     C                   MOVE      OGMONTH       MONTH
     C                   EVAL      RECDAT = YEAR + MONTH + '31'
     C     RECDAT        IFGT      COG000PDAT
     C                   DELETE    COG000R
     C                   ENDIF
     C                   READ      COG000R                                99
     C                   ENDDO
      *
     C                   CLOSE     COG000P
      *
     CSR   #COG000P      ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Delete COG010P records.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $COG010P      BEGSR
      *
     C                   OPEN      COG010P
     C                   READ      COG010R                                99
      *
     C     *IN99         DOWEQ     *OFF
     C                   MOVE      OGYEAR        YEAR
     C                   EVAL      WK030N  = OGWEEK * 7
     C                   MOVE      WK030N        JULDAYS
     C                   EVAL      @CFDAT  = YEAR + JULDAYS
     C                   MOVEL(P)  '*YYJUL'      @CFFMT
     C                   MOVEL(P)  '*YYMD'       @CTFMT
     C                   EXSR      $CVTDT
     C                   MOVE      @CTDAT        RECDAT
     C     RECDAT        IFGT      COG010PDAT
     C                   DELETE    COG010R
     C                   ENDIF
     C                   READ      COG010R                                99
     C                   ENDDO
      *
     C                   CLOSE     COG010P
      *
     CSR   #COG010P      ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Delete COG020P records.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $COG020P      BEGSR
      *
     C                   OPEN      COG020P
     C                   READ      COG020R                                99
      *
     C     *IN99         DOWEQ     *OFF
     C                   MOVE      OGYEAR        YEAR
     C                   EVAL      RECDAT = YEAR + '12' + '31'
     C     RECDAT        IFGT      COG020PDAT
     C                   DELETE    COG020R
     C                   ENDIF
     C                   READ      COG020R                                99
     C                   ENDDO
      *
     C                   CLOSE     COG020P
      *
     CSR   #COG020P      ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Delete COG030P records.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $COG030P      BEGSR
      *
     C                   OPEN      COG030P
     C                   READ      COG030R                                99
      *
     C     *IN99         DOWEQ     *OFF
     C                   MOVE      OGYEAR        YEAR
     C                   EVAL      RECDAT = YEAR + '12' + '31'
     C     RECDAT        IFGT      COG030PDAT
     C                   DELETE    COG030R
     C                   ENDIF
     C                   READ      COG030R                                99
     C                   ENDDO
      *
     C                   CLOSE     COG030P
      *
     CSR   #COG030P      ENDSR
      /SPACE 3
      /COPY QCPYSRC,$CVTDT
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   MOVE      *OFF          ERROR             1
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    COG000PDAT        8
     C                   PARM                    COG010PDAT        8
     C                   PARM                    COG020PDAT        8
     C                   PARM                    COG030PDAT        8
      *
     C     *LIKE         DEFINE    COG000PDAT    RECDAT
      *
     C                   CLEAR                   X                 5 0
     C                   CLEAR                   YEAR              4
     C                   CLEAR                   MONTH             2
     C                   CLEAR                   JULDAYS           3
     C                   CLEAR                   WK030N            3 0
      *
     CSR   #DEFN         ENDSR
