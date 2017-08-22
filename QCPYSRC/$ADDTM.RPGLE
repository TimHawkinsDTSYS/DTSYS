      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  ADD TIME.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ADDTM        BEGSR
      *
     C                   CALL      'TAATIMAC'                                   ADDTIM
     C                   PARM                    NBRSEC            5 0
     C                   PARM                    ENDTIM            6
     C                   PARM                    ENDDAT            6
     C                   PARM                    ENDHR             2
     C                   PARM                    ENDMIN            2
     C                   PARM                    BGNTIM            6
     C                   PARM                    BGNDAT            6
      *
     CSR   #ADDTM        ENDSR
