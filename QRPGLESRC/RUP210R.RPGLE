      /TITLE Request User Password, Write Use Log
     H DATEDIT(*YMD)
      *
      * P: PARMS  OPTION(*NOXREF) USRPRF(*OWNER) AUT(*EXCLUDE)
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
     FRUP210P   IF A E           K DISK
      *
     D CMDDS           DS           512
      *
     D PGMDS         ESDS                  EXTNAME(DSPGM)
      *
      /SPACE 3
     C                   EXSR      $WRTUL
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * WRITE USE LOG.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $WRTUL        BEGSR
      *
     C                   MOVE      ZZJOB         HLJNAM
     C                   MOVE      ZZUSR         HLJUSR
     C                   MOVE      ZZJNO         HLJNBR
     C                   MOVE      *DATE         HLDATE
     C                   TIME                    HLTIME
     C                   MOVEL     CMDDS         HLCMD
     C                   WRITE     RUP210R
      *
     CSR   #WRTUL        ENDSR
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
     C                   PARM                    CMDDS
      *
     C     *LOVAL        SETLL     RUP210R
      *
     C                   MOVE      *ZERO         X                 5 0
      *
     CSR   #DEFN         ENDSR
