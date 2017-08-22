      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * OFFSET DATE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $OFSET        BEGSR
      *
     C                   MOVE      *ZERO         OSTDTE
      *
     C                   CALL      'UT0140R'
     C                   PARM                    OSFDTE            6 0          I    (YMD)
     C                   PARM                    OSDAYS            3 0          I
     C                   PARM                    OSTDTE            6 0          O    (YMD)
     C                   PARM                    MSGID                          I/O
     C                   PARM                    MSGDTA                         I/O
      *
     CSR   #OFSET        ENDSR
