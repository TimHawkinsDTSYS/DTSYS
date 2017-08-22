      /TITLE Display Job Analysis, Build Workfile
      *
      * P: PARMS USRPRF(*OWNER) AUT(*ALL)
      *
      * S: DISPLAY JOB ANALYSIS
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
     FCJB100P   IP   E             DISK
     FDJB100P   O  A E             DISK
     F                                     RENAME(CJB100R:DJB100R)
      *
     D SLTL            S              3  0 DIM(200)
     D OMTL            S              3  0 DIM(200)
      *
     D SLTJDS          DS          2000
      *
     D OMTJDS          DS          2000
      *
      /EJECT
     C                   EXSR      $PROCS
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * PROCESS THIS JOB?
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PROCS        BEGSR
      *
     C                   MOVE      *ZERO         Y
     C                   MOVE      *OFF          FOUND
      *
     C                   DO        SLTJPT        X
     C                   ADD       1             Y
     C     SLTL(Y)       SUBST(P)  SLTJDS:X      JOB
     C     JOB           IFEQ      '*ALL'
     C                   MOVE      *ON           FOUND
     C                   LEAVE
     C                   ELSE
     C     SLTL(Y)       SUBST(P)  JOBNAM        WK010A
     C     WK010A        IFEQ      JOB
     C                   MOVE      *ON           FOUND
     C                   LEAVE
     C                   END
     C                   END
     C                   END       10
      *
     C     FOUND         CABEQ     *OFF          #PROCS
      *
     C                   MOVE      *ZERO         Y
     C                   MOVE      *OFF          FOUND             1
      *
     C                   DO        OMTJPT        X
     C                   ADD       1             Y
     C     OMTL(Y)       SUBST(P)  OMTJDS:X      JOB
     C     JOB           IFEQ      '*NONE'
     C                   MOVE      *OFF          FOUND
     C                   LEAVE
     C                   ELSE
     C     OMTL(Y)       SUBST(P)  JOBNAM        WK010A
     C     WK010A        IFEQ      JOB
     C                   MOVE      *ON           FOUND
     C                   LEAVE
     C                   END
     C                   END
     C                   END       10
      *
     C     FOUND         IFEQ      *OFF
     C                   WRITE     DJB100R
     C                   END
      *
     CSR   #PROCS        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DETERMINE SELECT/OMIT JOB GENERIC* LENGTH.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $GENRC        BEGSR
      *
     C                   DO        2000          X                 5 0
     C     10            SUBST(P)  SLTJDS:X      JOB              10
     C     JOB           IFNE      *BLANKS
     C                   ADD       1             SLTJPT            5 0
     C                   ELSE
     C                   LEAVE
     C                   END
     C                   END       10
      *
     C                   MULT      10            SLTJPT
     C                   MOVE      *ZERO         Y                 5 0
      *
     C                   DO        SLTJPT        X
     C     10            SUBST(P)  SLTJDS:X      JOB
     C                   ADD       1             Y
     C     '*'           SCAN      JOB           SLTL(Y)
     C     SLTL(Y)       IFGT      *ZERO
     C     SLTL(Y)       ANDNE     1
     C                   SUB       1             SLTL(Y)
     C                   ELSE
     C                   Z-ADD     10            SLTL(Y)
     C                   END
     C                   END       10
      *
     C                   DO        2000          X
     C     10            SUBST(P)  OMTJDS:X      JOB
     C     JOB           IFNE      *BLANKS
     C                   ADD       1             OMTJPT            5 0
     C                   ELSE
     C                   LEAVE
     C                   END
     C                   END       10
      *
     C                   MULT      10            OMTJPT
     C                   MOVE      *ZERO         Y
      *
     C                   DO        OMTJPT        X
     C     10            SUBST(P)  OMTJDS:X      JOB
     C                   ADD       1             Y
     C     '*'           SCAN      JOB           OMTL(Y)
     C     OMTL(Y)       IFGT      *ZERO
     C     OMTL(Y)       ANDNE     1
     C                   SUB       1             OMTL(Y)
     C                   ELSE
     C                   Z-ADD     10            OMTL(Y)
     C                   END
     C                   END       10
      *
     CSR   #GENRC        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   EXSR      $GENRC
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    SLTJDS
     C                   PARM                    OMTJDS
      *
     C                   MOVE      *BLANKS       WK010A           10
      *
     CSR   #DEFN         ENDSR
