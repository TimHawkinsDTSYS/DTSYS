      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DETERMINE TIME DIFFERENCE (IN SECONDS)
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $TDIFF        BEGSR
      *
     C                   CALL      'UT0103R'
     C                   PARM                    @SBTIM            6            I:BGN TIME
     C                   PARM                    @SETIM            6            I:END TIME
     C                   PARM                    @SSECS            5 0          O:DIFF IN SECS
      *
     CSR   #TDIFF        ENDSR
