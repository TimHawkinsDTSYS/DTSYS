      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Adjust SFOPTN (shift left).
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $AdjSFOPTN    BEGSR
      *
     C                   MOVEL     SFOPTN        WK001A            1
     C     WK001A        IFEQ      *BLANKS
     C                   MOVE      SFOPTN        WK001A
     C                   MOVEL(P)  WK001A        SFOPTN
     C                   ENDIF
      *
     CSR   #AdjSFOPTN    ENDSR
