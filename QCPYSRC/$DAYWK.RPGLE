      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  DETERMINE DAY OF WEEK.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     C     $DAYWK        BEGSR
      *
     C                   MOVE      *ZERO         DAYNBR
     C                   MOVE      *BLANKS       DAYTX9
     C                   MOVE      *BLANKS       DAYTX3
     C                   MOVE      *BLANKS       DAYTX2
      *
     C                   CALL      'UT0120R'
     C                   PARM                    DAYWEK            6 0          YMD
     C                   PARM                    DAYNBR            1 0
     C                   PARM                    DAYTX9            9
     C                   PARM                    DAYTX3            3
     C                   PARM                    DAYTX2            2
     C                   PARM                    MSGID
     C                   PARM                    MSGDTA
      *
     C     #DAYWK        ENDSR
