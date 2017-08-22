      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  CHECK FOR A PROGRAM IN THE INVOCATION STACK.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CKPGM        BEGSR
      *
     C                   CALL      'UT1130C'
     C                   PARM                    CHKPGM           10
     C                   PARM                    PGMFND            1
      *
     CSR   #CKPGM        ENDSR
