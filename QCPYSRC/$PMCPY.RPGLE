      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  COPY MESSAGES FROM ARRAYS AND SEND TO LOCAL PGM.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PMCPY        BEGSR
      *
     C                   DO        MX            MY                3 0
     C     MID(MY)       IFNE      *BLANKS
     C                   MOVEL     MID(MY)       MSGID
     C                   MOVEL     MDT(MY)       MSGDTA
     C                   EXSR      $PMSND
     C                   END
     C                   END
      *
     C                   MOVE      *BLANKS       MID                            RESET MSGID'S
     C                   MOVE      *BLANKS       MDT                            RESET MSGDTA'S
     C                   Z-ADD     1             MX                3 0          RESET POINTER
     C                   MOVE      *BLANKS       MSGID
     C                   MOVE      *BLANKS       MSGDTA
      *
     CSR   #PMCPY        ENDSR
