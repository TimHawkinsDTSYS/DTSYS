      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  CREATE MESSAGE QUEUE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PMCMQ        BEGSR
      *
     C                   CALL      'UT0100C'
     C                   PARM                    MSGQ             10
     C                   PARM                    MSGQLB           10
     C                   PARM                    MSGQTX           50
      *
     C                   eval      Msgq   = *blanks
     C                   eval      Msgqlb = *blanks
     C                   eval      Msgqtx = *blanks
      *
     CSR   #PMCMQ        ENDSR
