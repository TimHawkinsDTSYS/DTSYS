      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  CONVERT A DATE FROM MM/DD/YY TO YY/MM/DD.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $YMD          BEGSR
      *
     C                   MOVEL     CVTDTE        CVT04A            4
     C                   MOVE      CVTDTE        CVT02A            2
     C                   MOVE      CVT04A        CVTDTE            6
     C                   MOVEL     CVT02A        CVTDTE
      *
     CSR   #YMD          ENDSR
