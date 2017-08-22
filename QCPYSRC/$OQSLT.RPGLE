      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  OPEN QUERY FILE SELECT.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $OQSLT        BEGSR
      *
     C     OQOBNM        IFEQ      *BLANKS                                      REQUIRED.
     C     OQSLCT        OREQ      *BLANKS
     C                   GOTO      #OQSLT
     C                   END
      *
     C     OQLBNM        IFEQ      *BLANKS                                      DEFAULT.
     C                   MOVEL     '*LIBL'       OQLBNM
     C                   END
      *
     C     OQMBNM        IFEQ      *BLANKS                                      DEFAULT.
     C                   MOVEL     '*FIRST'      OQMBNM
     C                   END
      *
     C                   CALL      'UT1240R'
     C                   PARM                    OQOBNM           10            FILE NAME
     C                   PARM                    OQLBNM           10            LIBRARY NAME
     C                   PARM                    OQMBNM           10            MEMBER NAME
     C                   PARM                    OQSLCT          256            SELECT STRING
     C                   PARM                    OQREAD            1            1=READ, 0=EOF
      *
     CSR   #OQSLT        ENDSR
