      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  CONVERT DATE TO DISPLAY FORMAT.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CVTDD        BEGSR
      *
     C                   MOVEL     CVFDTE        WK002A            2
     C                   MOVE      CVFDTE        WK004A            4
     C                   MOVE      *BLANKS       CVFDTE            6
     C                   MOVEL     WK004A        CVTDTE            6
     C                   MOVE      WK002A        CVTDTE
     C                   GOTO      #CVTDD
      *
     C                   CALL      'QWCCVTDT'
     C                   PARM      '*YMD'        CVFFMT           10
     C                   PARM                    CVFDTE            6
     C                   PARM      '*MDY'        CVTFMT           10
     C                   PARM                    CVTDTE            6
     C                   PARM                    APIERR            1
      *
     CSR   #CVTDD        ENDSR
