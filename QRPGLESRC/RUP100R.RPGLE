      /TITLE Request User Password
     H DATEDIT(*YMD)
      *
      * P: PARMS OPTION(*NOXREF) USRPRF(*OWNER) AUT(*EXCLUDE)
      * P: CHGPGM RMVOBS(*ALL)
      *
      * S:
      *
      * C: T.HAWKINS   08/09/93
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * M: MODIFICATIONS --
      *
      * M: YY/MM/DD  PROGRAMMER  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
     FRUP100P   UF   E             DISK
     F                                     INFDS(DBFDS)
     FRUP200P   O  A E             DISK
      *
     D DBFDS         E DS                  EXTNAME(DSDBF)
      *
     D PGMDS         ESDS                  EXTNAME(DSPGM)
      *
      /SPACE 3
     C                   EXSR      $NXTPW
     C                   EXSR      $WRTPW
      *
     C                   MOVE      *ON           *INLR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DETERMINE NEXT PASSWORD.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $NXTPW        BEGSR
      *
     C     WRDCNT        DOUEQ     2
     C                   EXSR      $RTVRN
     C     RANNBR        CHAIN     RUP100R                            99
     C     *IN99         IFEQ      *OFF
     C                   EXSR      $CATPW
     C                   ENDIF
     C                   ENDDO
      *
     CSR   #NXTPW        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * CONCATENATE PASSWORD AFTER DETERMINATION OF LENGTH.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CATPW        BEGSR
      *
     C                   CAT       WBWORD:0      RTNPWD
     C                   ADD       1             WRDCNT            5 0
      *
     C                   ADD       1             WBUCNT
     C                   UPDATE    RUP100R
      *
     CSR   #CATPW        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * WRITE LOG OF PASSWORD REQUEST.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $WRTPW        BEGSR
      *
     C                   MOVE      ZZJOB         HLRJOB
     C                   MOVE      ZZUSR         HLRUSR
     C                   MOVE      ZZJNO         HLRJNO
     C                   MOVE      *DATE         HLRDTE
     C                   TIME                    HLRTIM
     C                   MOVE      RTNPWD        HLRPWD
     C                   WRITE     RUP200R
      *
     CSR   #WRTPW        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DETERMINE RANDOM NUMBER.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $RTVRN        BEGSR
      *
     C                   MOVE      1             LOVAL             9 0
     C                   MOVE      Z1NROP        HIVAL             9 0
     C                   MOVE      *ZERO         RANNBR            9 0
      *
     C                   TIME                    TIME              6 0
     C                   Z-ADD     TIME          BGNVAL            9 0
     C     BGNVAL        MULT      3.1415        NBR1              9 0
      *
     C     HIVAL         SUB       LOVAL         MAX              13 4
     C                   ADD       1             MAX
     C                   SUB       DECVAL        MAX
      *
     C     NBR1          MULT      3.14159265    NBR2             15 7
     C     NBR2          DIV       17            NBR3             15 4
     C                   Z-ADD     NBR3          NBR4             15 3
     C                   MOVE      NBR4          DEC4              4 4
     C                   MOVE      DEC4          DECVAL            6 6
     C                   MOVE      NBR4          NBR5              9 0
     C     NBR5          DIV       MAX           NBR6             15 0
     C                   MVR                     RANNBR            9 0
     C                   ADD       LOVAL         RANNBR
      *
     CSR   #RTVRN        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   MOVE      *OFF          PWDGEN            1
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    HLPROF
     C                   PARM                    HLTEXT
     C                   PARM                    RTNPWD           10
      *
     C                   MOVE      *ZERO         X                 5 0
      *
     CSR   #DEFN         ENDSR
