      /TITLE Utility, Add x Days to a Given Date
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
     C                   EXSR      $ADDDT
      *
     C                   RETURN
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  ADD X DAYS TO A GIVEN DATE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ADDDT        BEGSR
      *
     C                   MOVE      PFDTE         OSFDAT            6 0
     C                   MOVE      PTDTE         OSTDAT            6 0
      *
     C     OSFDAT        IFNE      *ZERO
     C                   MOVE      OSFFMT        @CFFMT                         CHANGE FORMAT
     C                   MOVEL     '*JUL'        @CTFMT                          TO *JUL.
     C                   MOVE      OSFDAT        @CFDAT
     C                   EXSR      $CVTDT
     C                   MOVEL     @CTDAT        JULYY
     C                   CLEAR                   JULDDD
     C                   MOVEL     @CTDAT        WK005A            5
     C                   MOVE      WK005A        JULDDD
     C                   ELSE
     C                   CLEAR                   JULYY             2 0
     C                   CLEAR                   JULDDD            3 0
     C                   ENDIF
     C                   Z-ADD     JULDDD        TTLDAY            5 0
     C                   ADD       OSDAYS        TTLDAY
      *
     C     @CKPLU        TAG
     C     TTLDAY        IFLE      *ZERO                                        DECREMENT
     C     JULYY         IFEQ      *ZERO                                         YEAR.
     C                   MOVE      99            JULYY
     C                   ELSE
     C                   SUB       1             JULYY
     C                   ENDIF
     C                   ENDIF
      *
     C     @CKLEP        TAG
     C     JULYY         DIV       4             LEAPYR            3 0          LEAP YEAR?
     C                   MVR                     LEAPYR
      *
     C     LEAPYR        IFGT      *ZERO                                        NOT LEAP YEAR
     C                   MOVE      365           DAYS              3 0
     C                   ELSE                                                   LEAP YEAR
     C                   MOVE      366           DAYS
     C                   ENDIF
      *
     C     TTLDAY        IFLE      *ZERO                                        DAYS ARE
     C                   ADD       DAYS          TTLDAY                          NEGATIVE.
     C                   GOTO      @CKPLU
     C                   ENDIF
      *
     C     TTLDAY        IFGT      DAYS                                         DAYS ARE
     C     JULYY         IFEQ      99                                            OVERFLOW.
     C                   SUB       1             JULYY
     C                   ENDIF
     C                   ADD       1             JULYY
     C                   SUB       DAYS          TTLDAY
     C                   GOTO      @CKLEP
     C                   ENDIF
      *
     C                   MOVE      TTLDAY        JULDDD
     C                   MOVEL     JULYY         @CFDAT
     C                   MOVE      *ZEROS        WK004A            4
     C                   MOVEL     JULDDD        WK004A
     C                   MOVE      WK004A        @CFDAT
      *
     C     JULDDD        IFNE      *ZERO
     C                   MOVEL     '*JUL'        @CFFMT                         CHANGE FORMAT
     C                   MOVE      OSTFMT        @CTFMT                          FROM *JUL.
     C                   EXSR      $CVTDT
     C                   MOVE      @CTDAT        OSTDAT
     C                   ELSE
     C                   CLEAR                   OSTDAT
     C                   ENDIF
      *
     C                   MOVE      OSFDAT        PFDTE
     C                   MOVE      OSTDAT        PTDTE
      *
     CSR   #ADDDT        ENDSR
      /SPACE 3
      /COPY QCPYSRC,$CVTDT
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PFDTE             6 0           I:FROM DATE
     C     OSFFMT        PARM      OSFFMT        PFFMT            10             I:FROM FORMAT
     C     OSDAYS        PARM      OSDAYS        PDAYS             5 0           O:NUMBER OF DAYS
     C                   PARM                    PTDTE             6 0           O:TO DATE
     C     OSTFMT        PARM      OSTFMT        PTFMT            10             O:TO FORMAT
      *
     C     *LIKE         DEFINE    PFFMT         OSFFMT
     C     *LIKE         DEFINE    PDAYS         OSDAYS
     C     *LIKE         DEFINE    PTFMT         OSTFMT
      *
     CSR   #DEFN         ENDSR
