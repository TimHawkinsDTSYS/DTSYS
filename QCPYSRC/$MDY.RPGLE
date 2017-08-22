      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  CONVERT A DATE FROM YY/MM/DD TO MM/DD/YY.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $MDY          BEGSR
      *
     C                   MOVE      CVTDTE        CVT04A            4
     C                   MOVEL     CVTDTE        CVT02A            2
     C                   MOVEL     CVT04A        CVTDTE            6
     C                   MOVE      CVT02A        CVTDTE
      *
     CSR   #MDY          ENDSR
