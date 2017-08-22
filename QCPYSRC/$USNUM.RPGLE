      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  UNSTRING NUMERICS.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $USNUM        BEGSR
      *
     C                   MOVE      UNSSTR        UNS200          200
     C                   MOVE      *BLANKS       UNSSTR          200
      *
     C                   DO        200           UNS               5 0          UNPARSE
     C                   SUBST     UNS200:UNS    UNS001            1             NUMERICS.
     C     UNS001        IFGE      '0'
     C     UNS001        ANDLE     '9'
     C                   CAT       UNS001:0      UNSSTR
     C                   ENDIF
     C                   ENDDO
      *
     C                   MOVE      UNSSTR        JUSSTR                         RIGHT
     C                   EXSR      $JUSTR                                        JUSTIFY.
     C                   MOVE      JUSSTR        UNSSTR
      *
     CSR   #USNUM        ENDSR
