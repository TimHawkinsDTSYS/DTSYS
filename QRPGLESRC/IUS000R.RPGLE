      /TITLE Increment User Space Pointer
     H DATEDIT(*YMD)
      *
      * P: PARMS OPTION(*NOXREF) USRPRF(*OWNER) AUT(*ALL)
      *
      * S:
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
     D DSBGN           DS
     D  BGNPOS                 1      4B 0
      *
     D DSLEN           DS
     D  DTALEN                 1      4B 0
      *
     D DSRCV           DS
     D  STRPS                  1      4B 0
     D  STRPOS                 1      4
     D  NBREN                  9     12B 0
     D  ENTLN                 13     16B 0
     D  ENTLEN                13     16
      *
     D PGMDS         ESDS                  EXTNAME(DSPGM)
      *
      /SPACE 3
     C                   EXSR      $RTVUS
     C                   SUB       1             NBREN
      *
     C     NBREN         IFGT      *ZERO
     C                   ADD       ENTLN         STRPS
     C                   ELSE
     C                   MOVE      '*END'        STRPOS
     C                   ENDIF
      *
     C                   EXSR      $CHGUS
      *
     C                   RETURN
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * RETRIEVE USER SPACE HEADER.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $RTVUS        BEGSR
      *
     C                   CALL      'QUSRTVUS'
     C                   PARM                    FULSPC
     C                   PARM                    DSBGN
     C                   PARM                    DSLEN
     C                   PARM                    DSRCV
     C                   PARM      *LOVAL        DSERR             8
      *
     CSR   #RTVUS        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * CHANGE USER SPACE HEADER.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CHGUS        BEGSR
      *
     C                   CALL      'QUSCHGUS'
     C                   PARM                    FULSPC
     C                   PARM                    DSBGN
     C                   PARM                    DSLEN
     C                   PARM                    DSRCV
     C                   PARM      *OFF          FRCAUX            1
     C                   PARM      *LOVAL        DSERR             8
      *
     CSR   #CHGUS        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   Z-ADD     125           BGNPOS
     C                   Z-ADD     16            DTALEN
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    FULSPC           20
      *
     C                   MOVE      *ZERO         X                 5 0
      *
     CSR   #DEFN         ENDSR
