      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  JUSTIFY, CENTER
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $JUSTC        BEGSR
      *
     C     ' '           CHECK     JUSSTR        JLT               5 0          LEFT CHAR
     C     JLT           IFGT      *ZERO
     C     ' '           CHECKR    JUSSTR        JRT               5 0          RIGHT CHAR
     C     JRT           SUB       JLT           JLN               5 0
     C                   ADD       1             JLN                            STRING LEN
     C     JLN           IFGT      *ZERO
     C     JLN           ANDLT     50
     C     JLN           SUBST(P)  JUSSTR:JLT    JUSWRK          200
     C     JUSLEN        IFEQ      *ZERO
     C                   MOVE      50            JUSLEN            5 0
     C                   ENDIF
     C     JUSLEN        SUB       JLN           JCT               5 0
     C                   DIV(H)    2             JCT
     C                   SUB       1             JCT
     C     JCT           IFGT      *ZERO
     C                   MOVE      *BLANKS       JUSSTR          200
     C                   CAT       JUSWRK:JCT    JUSSTR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     CSR   #JUSTC        ENDSR
