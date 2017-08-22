      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  DETERMINE DAYS SINCE 1900.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $D1900        BEGSR
      *
     C                   MOVE      *ZERO         NBRDYS
      *
     C                   CALL      'UT0110R'
     C                   PARM                    D1900             6 0          I    (YMD)
     C                   PARM                    NBRDYS            5 0          O
     C                   PARM                    MSGID                          I/O
     C                   PARM                    MSGDTA                         I/O
      *
     CSR   #D1900        ENDSR
