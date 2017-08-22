      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  SYSTEM CONTROL, LIST DISPLAY
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $SYSCT        BEGSR
      *
     C                   CALL      'SC0100R'
     C                   PARM                    SCCAT            25
     C                   PARM                    SCSUB            25
     C                   PARM                    SCCD1            10
     C                   PARM                    SCCD2            10
     C                   PARM                    SCDTA           100
     C                   PARM                    SCTYP             1
      *
     C                   MOVE      *BLANKS       SCTYP
      *
     CSR   #SYSCT        ENDSR
