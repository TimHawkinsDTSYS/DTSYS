      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Retrieve user defaults.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $RTVUSRDFT    BEGSR
      *
     C     UD_OVRPGM     IFNE      *BLANKS
     C                   MOVE      UD_OVRPGM     UD_OVRPGM        10
     C                   MOVE      UD_OVRPGM     UD_CURPGM        10
     C                   ELSE
     C                   MOVE      ZZPGM         UD_CURPGM
     C                   ENDIF
      *
     C                   EVAL      OPCDE = '*CHAIN'
      *
     C                   EVAL      SCCAT = 'USER DEFAULTS'
     C                   EVAL      SCSUB = 'FULL SCREEN'
     C                   EVAL      SCCD1 = ZZUSR
     C                   EVAL      SCCD2 = UD_CURPGM
     C                   EXSR      $RTVSC                                       Retrieve
     C                   MOVEL     SCDTA         UD_FULSCN         1
     C     SCDTA         IFEQ      *BLANKS
     C                   MOVE      *OFF          UD$FULSCN         1
     C                   ELSE
     C                   MOVE      *ON           UD$FULSCN
     C                   ENDIF
      *
     C                   EVAL      SCCAT = 'USER DEFAULTS'
     C                   EVAL      SCSUB = 'DISPLAY FORMAT'
     C                   EVAL      SCCD1 = ZZUSR
     C                   EVAL      SCCD2 = UD_CURPGM
     C                   EXSR      $RTVSC                                       Retrieve
     C                   MOVEL     SCDTA         UD_DSPFMT         1
     C     SCDTA         IFEQ      *BLANKS
     C                   MOVE      *OFF          UD$DSPFMT         1
     C                   ELSE
     C                   MOVE      *ON           UD$DSPFMT
     C                   ENDIF
      *
     C                   EVAL      SCCAT = 'USER DEFAULTS'
     C                   EVAL      SCSUB = 'SHOW DL SEGMENTS'
     C                   EVAL      SCCD1 = ZZUSR
     C                   EVAL      SCCD2 = UD_CURPGM
     C                   EXSR      $RTVSC                                       Retrieve
     C                   MOVEL     SCDTA         UD_SHOWDL         1
     C     SCDTA         IFEQ      *BLANKS
     C                   MOVE      *OFF          UD$SHOWDL         1
     C                   ELSE
     C                   MOVE      *ON           UD$SHOWDL
     C                   ENDIF
      *
     C                   EVAL      SCCAT = 'USER DEFAULTS'
     C                   EVAL      SCSUB = 'SHOW INVENTORY BY WEEK'
     C                   EVAL      SCCD1 = ZZUSR
     C                   EVAL      SCCD2 = ' '
     C                   EXSR      $RTVSC                                       Retrieve
     C                   MOVEL     SCDTA         UD_INVWEEK        1
     C     SCDTA         IFEQ      *BLANKS
     C                   MOVE      *OFF          UD$INVWEEK        1
     C                   ELSE
     C                   MOVE      *ON           UD$INVWEEK
     C                   ENDIF
      *
     C                   EVAL      SCCAT = 'USER DEFAULTS'
     C                   EVAL      SCSUB = 'QUEUE STATUS'
     C                   EVAL      SCCD1 = ZZUSR
     C                   EVAL      SCCD2 = ' '
     C                   EXSR      $RTVSC                                       Retrieve
     C                   MOVEL     SCDTA         UD_QUESTS         1
     C     SCDTA         IFEQ      *BLANKS
     C                   MOVE      *OFF          UD$QUESTS         1
     C                   ELSE
     C                   MOVE      *ON           UD$QUESTS
     C                   ENDIF
      *
     C                   EVAL      SCCAT = 'USER DEFAULTS'
     C                   EVAL      SCSUB = 'QUEUE TEXT ADJUST'
     C                   EVAL      SCCD1 = ZZUSR
     C                   EVAL      SCCD2 = ' '
     C                   EXSR      $RTVSC                                       Retrieve
     C                   MOVEL     SCDTA         UD_QUETXAJ        1
     C     SCDTA         IFEQ      *BLANKS
     C                   MOVE      *OFF          UD$QUETXAJ        1
     C                   ELSE
     C                   MOVE      *ON           UD$QUETXAJ
     C                   ENDIF
      *
     C                   EVAL      SCCAT = 'USER DEFAULTS'
     C                   EVAL      SCSUB = 'SHOW LAST SCREEN'
     C                   EVAL      SCCD1 = ZZUSR
     C                   EVAL      SCCD2 = UD_CURPGM
     C                   EXSR      $RTVSC                                       Retrieve
     C                   MOVEL     SCDTA         UD_LSTSCN         1
     C     SCDTA         IFEQ      *BLANKS
     C                   MOVE      *OFF          UD$LSTSCN         1
     C                   ELSE
     C                   MOVE      *ON           UD$LSTSCN
     C                   ENDIF
      *
     C                   EVAL      SCCAT = 'USER DEFAULTS'
     C                   EVAL      SCSUB = 'START TRANSACTION DATE'
     C                   EVAL      SCCD1 = ZZUSR
     C                   EVAL      SCCD2 = UD_CURPGM
     C                   EXSR      $RTVSC                                       Retrieve
     C     SCDTA         IFEQ      *BLANKS
     C                   MOVE      *ZERO         UD_STRTRND        6 0
     C                   MOVE      *OFF          UD$STRTRND        1
     C                   ELSE
     C                   MOVEL     SCDTA         UD_STRTRND
     C                   MOVE      *ON           UD$STRTRND
     C                   ENDIF
      *
     CSR   #RTVUSRDFT    ENDSR
