      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * CONCATENATE WITH LENGTH LIMIT.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CATLL        BEGSR
      *
     C                   CALL      'UT1370R'                                    Cat with LenLmt
     C                   PARM                    CATVAL          256            Concatenated val
     C                   PARM                    DLIMIT            1            Delimiter
     C                   PARM                    LENLMT            5 0          Result len limit
      *
     CSR   #CATLL        ENDSR
