      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  CHECK OBJECT.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CKOBJ        BEGSR
      *
     C                   CALL      'UT1140C'                                    CHECK
     C                   PARM                    OBJNAM           10             EXISTANCE.
     C                   PARM                    OBJLIB           10
     C                   PARM                    OBJTYP           10
     C                   PARM                    MBR              10
     C                   PARM                    MSGID
     C                   PARM                    MSGDTA
      *
     CSR   #CKOBJ        ENDSR
