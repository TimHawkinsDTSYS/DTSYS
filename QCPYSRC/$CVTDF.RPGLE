      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  CONVERT DATE TO FILE FORMAT.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CVTDF        BEGSR
      *
     C                   MOVEL     CVFDTE        WK004A            4
     C                   MOVE      CVFDTE        WK002A            2
     C                   MOVE      *BLANKS       CVFDTE            6
     C                   MOVEL     WK002A        CVTDTE            6
     C                   MOVE      WK004A        CVTDTE
     C                   GOTO      #CVTDF
      *
     C                   CALL      'QWCCVTDT'
     C                   PARM      '*MDY'        CVFFMT           10
     C                   PARM                    CVFDTE            6
     C                   PARM      '*YMD'        CVTFMT           10
     C                   PARM                    CVTDTE            6
     C                   PARM                    APIERR            1
      *
     CSR   #CVTDF        ENDSR
