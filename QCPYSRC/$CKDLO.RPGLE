      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Check DLO existance
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CKDLO        BEGSR
      *
     C                   CALL      'UT1145C'                                    CHECK
     C                   PARM                    OBJDLO           12             EXISTANCE.
     C                   PARM                    OBJFLR           63
     C                   PARM                    OBJTYP           10
     C                   PARM                    MSGID
     C                   PARM                    MSGDTA
      *
     CSR   #CKDLO        ENDSR
