      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Scan and Replace String.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $SCANREPL     BEGSR
      *
     C                   CALL      'UT1390R'
     C                   PARM                    PATT_STG        256            Delimiter char
     C                   PARM                    REPL_STG        256            Adjust Y=Yes,N=No
     C                   PARM                    SRCH_STG       1024            Pad char
      *
     CSR   #SCANREPL     ENDSR
