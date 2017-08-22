      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  COMPRESS A STRING.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $COMPR        BEGSR
      *
     C                   MOVE      *BLANKS       CPRWRK          256
      *
     C                   DO        256           CPR               5 0
     C                   SUBST     CPRSTR:CPR    CPR001            1
     C     CPR001        IFNE      *BLANKS
     C                   CAT       CPR001:0      CPRWRK
     C                   ENDIF
     C                   ENDDO
      *
     C                   MOVE      CPRWRK        CPRSTR          256
      *
     CSR   #COMPR        ENDSR
