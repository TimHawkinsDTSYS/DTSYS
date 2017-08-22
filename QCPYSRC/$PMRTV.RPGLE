      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Retrieve message.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PMRTV        BEGSR
      *
     C                   CALL(e)   'UT0140C'
     C                   PARM                    MSGID             7
     C                   PARM                    MSGDTA          512
     C                   PARM                    MSG             132
     C                   PARM                    SECLVL          512
     C                   PARM                    SECLEN            5 0
     C                   PARM                    SEV               2 0
     C                   PARM                    MSGF             10
     C                   PARM                    MSGFLIB          10
      *
     C                   MOVE      *BLANKS       MSGID
     C                   MOVE      *BLANKS       MSGDTA
      *
     CSR   #PMRTV        ENDSR
