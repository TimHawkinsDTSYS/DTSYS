      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  SYSTEM CONTROL, SERVER.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $SRVSC        BEGSR
      *
     C                   CALL      'SC0120R'
     C                   PARM                    SCCAT            25
     C                   PARM                    SCSUB            25
     C                   PARM                    SCCD1            10
     C                   PARM                    SCCD2            10
     C                   PARM                    SCDTA           100
      *
     CSR   #SRVSC        ENDSR
