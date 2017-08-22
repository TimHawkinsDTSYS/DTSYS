      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  WILDCARD MATCH.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $WILDC        BEGSR
      *
     C                   CALL      'UT1340R'
     C                   PARM                    SSWILD            1            O:FOUND W/C
     C                   PARM                    SSSCAN          256            I:SCAN STRING
     C                   PARM                    SSDATA          256            I:DATA STRING
      *
     CSR   #WILDC        ENDSR
