      /TITLE Determine Time Difference in Seconds
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
     C                   EXSR      $TDIFF
      *
     C                   RETURN
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DETERMINE TIME DIFFERENCE (IN SECONDS)
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $TDIFF        BEGSR
      *
     C                   CLEAR                   TDBHH             5 0
     C                   CLEAR                   TDBMM             5 0
     C                   CLEAR                   TDBSS             5 0
     C                   CLEAR                   TDEHH             5 0
     C                   CLEAR                   TDEMM             5 0
     C                   CLEAR                   TDESS             5 0
      *
     C     2             SUBST     TDBTIM:1      WK002A            2             BGN HOUR
     C                   MOVE      WK002A        TDBHH
     C     2             SUBST     TDBTIM:3      WK002A                          BGN MINUTES
     C                   MOVE      WK002A        TDBMM
     C     2             SUBST     TDBTIM:5      WK002A                          BGN SECONDS
     C                   MOVE      WK002A        TDBSS
     C                   MULT      3600          TDBHH
     C                   MULT      60            TDBMM
     C     TDBHH         ADD       TDBMM         TDBSEC            5 0
     C                   ADD       TDBSS         TDBSEC
      *
     C     2             SUBST     TDETIM:1      WK002A                          BGN HOUR
     C                   MOVE      WK002A        TDEHH
     C     2             SUBST     TDETIM:3      WK002A                          BGN MINUTES
     C                   MOVE      WK002A        TDEMM
     C     2             SUBST     TDETIM:5      WK002A                          BGN SECONDS
     C                   MOVE      WK002A        TDESS
     C                   MULT      3600          TDEHH
     C                   MULT      60            TDEMM
     C     TDEHH         ADD       TDEMM         TDESEC            5 0
     C                   ADD       TDESS         TDESEC
      *
     C     TDESEC        SUB       TDBSEC        TDSECS
      *
     CSR   #TDIFF        ENDSR
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
     C     TDBTIM        PARM      TDBTIM        PLBTIM            6            I:BGN TIME
     C     TDETIM        PARM      TDETIM        PLETIM            6            I:END TIME
     C     TDSECS        PARM      TDSECS        PLSECS            5 0          O:DIFF IN SECS
      *
     C     *LIKE         DEFINE    PLBTIM        TDBTIM
     C     *LIKE         DEFINE    PLETIM        TDETIM
     C     *LIKE         DEFINE    PLSECS        TDSECS
      *
     CSR   #DEFN         ENDSR
