      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Print DB Record.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PrtDBrcd     BEGSR
      *
     C                   CALL      'UT1600R'
     C                   PARM                    FILE             10            I:FROM DATE
     C                   PARM                    FILELIB          10            I:FROM FORMAT
     C                   PARM                    RCDDTA         1024            I:DAYS +/-
      *
     CSR   #PrtDBrcd     ENDSR
