      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Retrieve user security.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $RTVUSRSEC    BEGSR
      *
     C     US_OVRPGM     IFNE      *BLANKS
     C                   MOVE      US_OVRPGM     US_OVRPGM        10
     C                   MOVE      US_OVRPGM     US_CURPGM        10
     C                   ELSE
     C                   MOVE      ZZPGM         US_CURPGM
     C                   ENDIF
      *
     C                   EVAL      OPCDE = '*CHAIN'
      *
     C                   EVAL      SCCAT = 'USER SECURITY'
     C                   EVAL      SCSUB = 'FULL SCREEN'
     C                   EVAL      SCCD1 = ZZUSR
     C                   EVAL      SCCD2 = US_CURPGM
     C                   EXSR      $RTVSC                                       Retrieve
     C                   MOVEL     SCDTA         US_FULSCN         1
     C     SCDTA         IFEQ      *BLANKS
     C                   MOVE      *OFF          UD$FULSCN         1
     C                   ELSE
     C                   MOVE      *ON           UD$FULSCN
     C                   ENDIF
      *
     C                   EVAL      SCCAT = 'USER SECURITY'
     C                   EVAL      SCSUB = 'DISPLAY FORMAT'
     C                   EVAL      SCCD1 = ZZUSR
     C                   EVAL      SCCD2 = US_CURPGM
     C                   EXSR      $RTVSC                                       Retrieve
     C                   MOVEL     SCDTA         US_DSPFMT         1
     C     SCDTA         IFEQ      *BLANKS
     C                   MOVE      *OFF          UD$DSPFMT         1
     C                   ELSE
     C                   MOVE      *ON           UD$DSPFMT
     C                   ENDIF
      *
     C                   EVAL      SCCAT = 'USER SECURITY'
     C                   EVAL      SCSUB = 'SHOW DL SEGMENTS'
     C                   EVAL      SCCD1 = ZZUSR
     C                   EVAL      SCCD2 = US_CURPGM
     C                   EXSR      $RTVSC                                       Retrieve
     C                   MOVEL     SCDTA         US_SHOWDL         1
     C     SCDTA         IFEQ      *BLANKS
     C                   MOVE      *OFF          UD$SHOWDL         1
     C                   ELSE
     C                   MOVE      *ON           UD$SHOWDL
     C                   ENDIF
      *
     C                   EVAL      SCCAT = 'USER SECURITY'
     C                   EVAL      SCSUB = 'SHOW INVENTORY BY WEEK'
     C                   EVAL      SCCD1 = ZZUSR
     C                   EVAL      SCCD2 = ' '
     C                   EXSR      $RTVSC                                       Retrieve
     C                   MOVEL     SCDTA         US_INVWEEK        1
     C     SCDTA         IFEQ      *BLANKS
     C                   MOVE      *OFF          UD$INVWEEK        1
     C                   ELSE
     C                   MOVE      *ON           UD$INVWEEK
     C                   ENDIF
      *
     C                   EVAL      SCCAT = 'USER SECURITY'
     C                   EVAL      SCSUB = 'QUEUE STATUS'
     C                   EVAL      SCCD1 = ZZUSR
     C                   EVAL      SCCD2 = ' '
     C                   EXSR      $RTVSC                                       Retrieve
     C                   MOVEL     SCDTA         US_QUESTS         1
     C     SCDTA         IFEQ      *BLANKS
     C                   MOVE      *OFF          UD$QUESTS         1
     C                   ELSE
     C                   MOVE      *ON           UD$QUESTS
     C                   ENDIF
      *
     C                   EVAL      SCCAT = 'USER SECURITY'
     C                   EVAL      SCSUB = 'QUEUE TEXT ADJUST'
     C                   EVAL      SCCD1 = ZZUSR
     C                   EVAL      SCCD2 = ' '
     C                   EXSR      $RTVSC                                       Retrieve
     C                   MOVEL     SCDTA         US_QUETXAJ        1
     C     SCDTA         IFEQ      *BLANKS
     C                   MOVE      *OFF          UD$QUETXAJ        1
     C                   ELSE
     C                   MOVE      *ON           UD$QUETXAJ
     C                   ENDIF
      *
     C                   EVAL      SCCAT = 'USER SECURITY'
     C                   EVAL      SCSUB = 'SHOW LAST SCREEN'
     C                   EVAL      SCCD1 = ZZUSR
     C                   EVAL      SCCD2 = US_CURPGM
     C                   EXSR      $RTVSC                                       Retrieve
     C                   MOVEL     SCDTA         US_LSTSCN         1
     C     SCDTA         IFEQ      *BLANKS
     C                   MOVE      *OFF          UD$LSTSCN         1
     C                   ELSE
     C                   MOVE      *ON           UD$LSTSCN
     C                   ENDIF
      *
     C                   EVAL      SCCAT = 'USER SECURITY'
     C                   EVAL      SCSUB = 'START TRANSACTION DATE'
     C                   EVAL      SCCD1 = ZZUSR
     C                   EVAL      SCCD2 = US_CURPGM
     C                   EXSR      $RTVSC                                       Retrieve
     C     SCDTA         IFEQ      *BLANKS
     C                   MOVE      *ZERO         US_STRTRND        6 0
     C                   MOVE      *OFF          UD$STRTRND        1
     C                   ELSE
     C                   MOVEL     SCDTA         US_STRTRND
     C                   MOVE      *ON           UD$STRTRND
     C                   ENDIF
      *
     CSR   #RTVUSRSEC    ENDSR
