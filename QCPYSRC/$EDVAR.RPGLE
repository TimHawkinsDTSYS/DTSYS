      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  EDIT VARIABLE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $EDVAR        BEGSR
      *
     C     EDTCDE        IFEQ      *BLANKS
     C                   MOVE      'Z'           EDTCDE
     C                   ENDIF
      *
     C     LDGSYM        IFEQ      *BLANKS
     C                   MOVE      '*NO '        LDGSYM
     C                   ENDIF
      *
     C                   CALL      'UT1231R'                            95
     C                   PARM      *BLANKS       CHROUT           22            Mult by 10k for
     C                   PARM                    NUMINP           30 0           a 5.4 field.
     C                   PARM                    NBRDEC            1 0          0-9
     C                   PARM                    EDTCDE            1            J,K,L,M,W,Y,Z
     C                   PARM                    LDGSYM            4            *YES, *NO
      *
     C                   MOVE      *ZERO         NUMINP
     C                   MOVE      *ZERO         NBRDEC
     C                   MOVE      *BLANKS       EDTCDE
     C                   MOVE      *BLANKS       LDGSYM
      *
     CSR   #EDVAR        ENDSR
