      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Parse String to Chunks.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PARSE        BEGSR
      *
      *    Clear the return value.
      *
     C                   MOVE      *BLANKS       PARRTN          256
      *
      *    If no string; get out.
      *
     C     PARSTG        IFEQ      *BLANKS                                       START POS
     C                   GOTO      #PARSE                                        AND LEAVE?
     C                   ENDIF
      *
      *    Define fields.
      *
     C                   MOVE      PARSTG        PARSTG          512
     C                   MOVE      PARLEN        PARLEN            5 0           UP TO THE
     C                   MOVE      STGSIZ        STGSIZ            5 0           UP TO THE
      *
      *    Set start position to next chunk; assure not out of range.
      *
     C                   ADD       1             PARSTR            5 0          INCREMENT
     C     PARSTR        ADD       PARLEN        PARMAX            5 0
     C                   EVAL      STGSIZ = %SIZE(PARSTG)
     C     PARMAX        IFGT      STGSIZ                                        START POS
     C                   GOTO      #PARSE                                        AND LEAVE?
     C                   ENDIF
      *
      *    Parse out the chunk; if blank then we are at the end.
      *
     C     PARLEN        SUBST(P)  PARSTG:PARSTR PARRTN                          THE REQ LEN.
     C     PARRTN        IFEQ      *BLANKS                                      NOTHING TO
     C                   GOTO      #PARSE                                        AND LEAVE?
     C                   ENDIF
      *
      *    Cannot end chunk in the middle of a word; find last word.
      *
     C                   Z-ADD     PARLEN        PAREND            5 0
     C                   SUBST     PARRTN:PAREND PARBYTE           1             PARSE.
     C     PARBYTE       DOWNE     *BLANKS                                      NOTHING TO
     C                   SUB       1             PAREND
     C                   SUBST     PARRTN:PAREND PARBYTE                         PARSE.
     C                   ENDDO
      *
      *    Extract up to last word; setup start to be end of this chunk.
      *
     C     PAREND        IFGE      *ZERO
     C     PAREND        SUBST(P)  PARRTN        PARRTN                          BLANK CHAR.
     C                   ENDIF
      *
     C                   ADD       PAREND        PARSTR                         NEXT TIME.
      *
     CSR   #PARSE        ENDSR
