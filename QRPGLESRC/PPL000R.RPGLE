      /TITLE PC Support Exit Program, Log Purge
      *
      * P: PARMS OPTION(*NOXREF) USRPRF(*OWNER)
      *
      * S: PROGRAM AUT100R THE PC SUPPORT EXIT PROGRAMS WRITES
      * S:  LOG RECORDS WHICH IS CLEANED UP BY THIS PROGRAM EACH
      * S:  NIGHT.
      *
      *
      * C: T.HAWKINS   07/08/93
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
     FAUT800P   UF   E             DISK
      *
      *
     D PGMDS         ESDS                  EXTNAME(DSPGM)
      *
      /SPACE 3
     C                   EXSR      $READ
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * READ THROUGH RECORDS AND PURGE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $READ         BEGSR
      *
     C     *INLR         DOUEQ     *ON
     C                   READ      AUT800R                                LR
     C     *INLR         IFEQ      *OFF
      *
     C     ALDTE         IFLT      PRGDTE
     C                   DELETE    AUT800R
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDDO
      *
     CSR   #READ         ENDSR
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
     C                   PARM                    PRGDTE            8 0
      *
     C                   MOVE      *ZERO         X                 5 0
      *
     CSR   #DEFN         ENDSR
