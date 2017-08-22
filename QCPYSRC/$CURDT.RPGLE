      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  DETERMINE CURRENT DATE AND TIME.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CURDT        BEGSR
      *
     C                   TIME                    TIME12           12 0
     C                   MOVE      UDATE         WK006A            6
     C                   MOVEL     WK006A        WK004A            4
     C                   MOVE      WK006A        WK002A            2
     C                   MOVEL     WK002A        CURDTE            6 0
     C                   MOVE      WK004A        CURDTE
     C                   MOVEL     TIME12        CURTIM            6 0
      *
     CSR   #CURDT        ENDSR
