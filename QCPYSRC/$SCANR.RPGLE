      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Scan and Replace Strings.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $SCANR        BEGSR
      *
     C     @DLIM         IFEQ      *BLANKS                                      Delimiter
     C                   MOVE      ','           @DLIM
     C                   ENDIF
      *
     C                   CALL      'UT1380R'
     C                   PARM                    @DLIM             1            Delimiter char
     C                   PARM                    @ADJ              1            Adjust Y=Yes,N=No
     C                   PARM                    @PAD              1            Pad char
     C                   PARM                    @DBL              1            Double replace
     C                   PARM                    @STNG           512            String
     C                   PARM                    @SCAN           512            Scan values
     C                   PARM                    @REPL           512            Replace values
     C                   PARM                    MSGID             7            Error messageID
      *
     CSR   #SCANR        ENDSR
