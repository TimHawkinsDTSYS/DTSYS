      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  DETERMINE DAYS IN MONTH.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     C     $DAYMO        BEGSR
      *
     C                   CALL      'UT0150R'
     C                   PARM                    MONYR             2 0
     C                   PARM                    MONMO             2 0
     C                   PARM      *ZERO         MONDAY            2 0
     C                   PARM      *BLANKS       MONTX9            9
     C                   PARM      *BLANKS       MONTX3            3
     C                   PARM                    MSGID
     C                   PARM                    MSGDTA
      *
     C     #DAYMO        ENDSR
