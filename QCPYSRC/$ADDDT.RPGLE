      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  ADD X DAYS TO A GIVEN DATE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ADDDT        BEGSR
      *
     C                   CALL      'UT0180R'
     C                   PARM                    @DFDTE            6 0          I:FROM DATE
     C                   PARM                    @DFFMT           10            I:FROM FORMAT
     C                   PARM                    @DDAYS            5 0          I:DAYS +/-
     C                   PARM                    @DTDTE            6 0          O:TO DATE
     C                   PARM                    @DTFMT           10            I:TO FORMAT
      *
     CSR   #ADDDT        ENDSR
