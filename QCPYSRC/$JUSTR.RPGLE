      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  JUSTIFY, RIGHT.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $JUSTR        BEGSR
      *
     C     ' '           CHECK     JUSSTR        JLT               5 0          LEFT CHAR
     C     JLT           IFNE      *ZERO
     C     ' '           CHECKR    JUSSTR        JRT               5 0          RIGHT CHAR
     C     JRT           SUB       JLT           JLN               5 0
     C                   ADD       1             JLN                            STRING LEN
     C     JLN           SUBST(P)  JUSSTR:JLT    JUSWRK          200
     C                   MOVE      *BLANKS       JUSSTR          200
     C     200           SUB       JLN           JCT               5 0
     C                   CAT       JUSWRK:JCT    JUSSTR
     C                   ENDIF
      *
     CSR   #JUSTR        ENDSR
