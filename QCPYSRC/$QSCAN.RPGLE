      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  SCAN FOR A PATTERN.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $QSCAN        BEGSR
      *
     C                   CALL      'QCLSCAN'
     C                   PARM                    STRING          256            String
     C                   PARM                    STRLEN            3 0          String len
     C                   PARM                    STRPOS            3 0          Start pos
     C                   PARM                    PATTRN           20            Pattern
     C                   PARM                    PATLEN            3 0          Pattern len
     C                   PARM                    XLATE             1            Translate
     C                   PARM                    TRIM              1            Trim blanks
     C                   PARM                    WLDCRD            1            Wild card
     C                   PARM                    RESULT            3 0          Result
      *
     C                   SELECT
     C     RESULT        WHENEQ    *ZERO
     C**                   MOVE 'SCN0000' MSGID            PAT NOT FOUND
     C     RESULT        WHENEQ    -1
     C                   MOVE      'SCN0001'     MSGID                          PAT > STR LEN
     C     RESULT        WHENEQ    -2
     C                   MOVE      'SCN0002'     MSGID                          PAT LEN LT 1
     C     RESULT        WHENEQ    -3
     C                   MOVE      'SCN0003'     MSGID                          1ST CHAR IS WLD
     C     RESULT        WHENEQ    -4
     C                   MOVE      'SCN0004'     MSGID                          PAT BLANK W/TRM
     C     RESULT        WHENEQ    -5
     C                   MOVE      'SCN0005'     MSGID                          STR POS INVALID
     C                   ENDSL
      *
     CSR   #QSCAN        ENDSR
