      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  SYSTEM CONTROL, RETRIEVE RECORDS.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $RTVSC        BEGSR
      *
     C                   CALL      'SC0110R'
     C                   PARM                    OPCDE             6
     C                   PARM                    SCCAT            25
     C                   PARM                    SCSUB            25
     C                   PARM                    SCCD1            10
     C                   PARM                    SCCD2            10
     C                   PARM                    SCDTA           100
      *
     CSR   #RTVSC        ENDSR
