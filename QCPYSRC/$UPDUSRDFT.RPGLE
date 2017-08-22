      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Update user defaults.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $UPDUSRDFT    BEGSR
      *
     C     UD_OVRPGM     IFNE      *BLANKS
     C                   MOVE      UD_OVRPGM     UD_OVRPGM        10
     C                   MOVE      UD_OVRPGM     UD_CURPGM        10
     C                   ELSE
     C                   MOVE      ZZPGM         UD_CURPGM
     C                   ENDIF
      *
     C     UD_CURPGM     IFEQ      'PR0201R'
     C     UD_CURPGM     OREQ      'PR0209R'
     C     UD_CURPGM     OREQ      'PR0211R'
     C     UD_CURPGM     OREQ      'QM0290R'
     C     UD_CURPGM     OREQ      'QM0295R'
     C     UD_CURPGM     OREQ      'AM0201R'
     C     UD$FULSCN     IFEQ      *OFF
     C                   EVAL      UD$FULSCN = *ON
     C                   EVAL      OPCDE = '*WRITE'
     C                   ELSE
     C                   EVAL      OPCDE = '*UPDAT'
     C                   ENDIF
     C                   EVAL      SCCAT = 'USER DEFAULTS'
     C                   EVAL      SCSUB = 'FULL SCREEN'
     C                   EVAL      SCCD1 = ZZUSR
     C                   EVAL      SCCD2 = UD_CURPGM
     C     UD_FULSCN     IFEQ      'Y'
     C                   EVAL      SCDTA = UD_FULSCN + ' Full screen'
     C                   ELSE
     C                   EVAL      SCDTA = UD_FULSCN + ' Partial screen'
     C                   ENDIF
     C                   EXSR      $RTVSC                                       Retrieve
     C                   ENDIF
      *
     C     UD_CURPGM     IFEQ      'PR0211R'
     C     UD$DSPFMT     IFEQ      *OFF
     C                   EVAL      UD$DSPFMT = *ON
     C                   EVAL      OPCDE = '*WRITE'
     C                   ELSE
     C                   EVAL      OPCDE = '*UPDAT'
     C                   ENDIF
     C                   EVAL      SCCAT = 'USER DEFAULTS'
     C                   EVAL      SCSUB = 'DISPLAY FORMAT'
     C                   EVAL      SCCD1 = ZZUSR
     C                   EVAL      SCCD2 = UD_CURPGM
     C                   EVAL      SCDTA = UD_DSPFMT + ' Display format'
     C                   EXSR      $RTVSC                                       Retrieve
     C                   ENDIF
      *
     C     UD_CURPGM     IFEQ      'PR0209R'
     C     UD$SHOWDL     IFEQ      *OFF
     C                   EVAL      UD$SHOWDL = *ON
     C                   EVAL      OPCDE = '*WRITE'
     C                   ELSE
     C                   EVAL      OPCDE = '*UPDAT'
     C                   ENDIF
     C                   EVAL      SCCAT = 'USER DEFAULTS'
     C                   EVAL      SCSUB = 'SHOW DL SEGMENTS'
     C                   EVAL      SCCD1 = ZZUSR
     C                   EVAL      SCCD2 = UD_CURPGM
     C     UD_SHOWDL     IFEQ      'Y'
     C                   EVAL      SCDTA = UD_SHOWDL + ' Show DL segments'
     C                   ELSE
     C                   EVAL      SCDTA = UD_SHOWDL + ' Dont show DL segments'
     C                   ENDIF
     C                   EXSR      $RTVSC                                       Retrieve
     C                   ENDIF
      *
     C     UD_CURPGM     IFEQ      'PR0241R'
     C     UD_CURPGM     OREQ      'PR0242R'
     C     UD$INVWEEK    IFEQ      *OFF
     C                   EVAL      UD$INVWEEK = *ON
     C                   EVAL      OPCDE = '*WRITE'
     C                   ELSE
     C                   EVAL      OPCDE = '*UPDAT'
     C                   ENDIF
     C                   EVAL      SCCAT = 'USER DEFAULTS'
     C                   EVAL      SCSUB = 'SHOW INVENTORY BY WEEK'
     C                   EVAL      SCCD1 = ZZUSR
     C                   EVAL      SCCD2 = UD_CURPGM
     C     UD_INVWEEK    IFEQ      'Y'
     C                   EVAL      SCDTA = UD_INVWEEK +
     C                                     ' Show inventory by week'
     C                   ELSE
     C                   EVAL      SCDTA = UD_INVWEEK +
     C                                     ' Show inventory by month'
     C                   ENDIF
     C                   EXSR      $RTVSC                                       Retrieve
     C                   ENDIF
      *
     C     UD_CURPGM     IFEQ      'QM0210R'
     C     UD_CURPGM     OREQ      'QM0217R'
     C     UD_CURPGM     OREQ      'QM0300R'
     C     UD$QUESTS     IFEQ      *OFF
     C                   EVAL      UD$QUESTS = *ON
     C                   EVAL      OPCDE = '*WRITE'
     C                   ELSE
     C                   EVAL      OPCDE = '*UPDAT'
     C                   ENDIF
     C                   EVAL      SCCAT = 'USER DEFAULTS'
     C                   EVAL      SCSUB = 'QUEUE STATUS'
     C                   EVAL      SCCD1 = ZZUSR
     C                   EVAL      SCCD2 = ' '
     C                   EVAL      SCDTA = UD_QUESTS +
     C                             ' Show queues at a specific status'
     C                   EXSR      $RTVSC                                       Retrieve
     C                   ENDIF
      *
     C     UD_CURPGM     IFEQ      'QM0290R'
     C     UD_CURPGM     OREQ      'QM0920R'
     C     UD$QUETXAJ    IFEQ      *OFF
     C                   EVAL      UD$QUETXAJ = *ON
     C                   EVAL      OPCDE = '*WRITE'
     C                   ELSE
     C                   EVAL      OPCDE = '*UPDAT'
     C                   ENDIF
     C                   EVAL      SCCAT = 'USER DEFAULTS'
     C                   EVAL      SCSUB = 'QUEUE TEXT ADJUST'
     C                   EVAL      SCCD1 = ZZUSR
     C                   EVAL      SCCD2 = UD_CURPGM
     C     UD_QUETXAJ    IFEQ      'Y'
     C                   EVAL      SCDTA = UD_QUETXAJ +
     C                             ' Perform text adjust on queue text'
     C                   ELSE
     C                   EVAL      SCDTA = UD_QUETXAJ +
     C                             ' Dont perform text adjust on queue text'
     C                   ENDIF
     C                   EXSR      $RTVSC                                       Retrieve
     C                   ENDIF
      *
     C     UD_CURPGM     IFEQ      'PR0211R'
     C     UD$LSTSCN     IFEQ      *OFF
     C                   EVAL      UD$LSTSCN  = *ON
     C                   EVAL      OPCDE = '*WRITE'
     C                   ELSE
     C                   EVAL      OPCDE = '*UPDAT'
     C                   ENDIF
     C                   EVAL      SCCAT = 'USER DEFAULTS'
     C                   EVAL      SCSUB = 'SHOW LAST SCREEN'
     C                   EVAL      SCCD1 = ZZUSR
     C                   EVAL      SCCD2 = UD_CURPGM
     C     UD_LSTSCN     IFEQ      'Y'
     C                   EVAL      SCDTA = UD_LSTSCN  +
     C                             ' Show last screen'
     C                   ELSE
     C                   EVAL      SCDTA = UD_LSTSCN  +
     C                             ' Show first screen'
     C                   ENDIF
     C                   EXSR      $RTVSC                                       Retrieve
     C                   ENDIF
      *
     C     UD_CURPGM     IFEQ      'PR0211R'
     C     UD$STRTRND    IFEQ      *OFF
     C                   EVAL      UD$STRTRND = *ON
     C                   EVAL      OPCDE = '*WRITE'
     C                   ELSE
     C                   EVAL      OPCDE = '*UPDAT'
     C                   ENDIF
     C                   EVAL      SCCAT = 'USER DEFAULTS'
     C                   EVAL      SCSUB = 'START TRANSACTION DATE'
     C                   EVAL      SCCD1 = ZZUSR
     C                   EVAL      SCCD2 = UD_CURPGM
     C                   MOVE      UD_STRTRND    WK006A            6
     C                   EVAL      SCDTA = WK006A +
     C                             ' Show starting at transaction date'
     C                   EXSR      $RTVSC                                       Retrieve
     C                   ENDIF
      *
     CSR   #UPDUSRDFT    ENDSR
