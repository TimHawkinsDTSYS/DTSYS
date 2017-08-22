      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  RETRIEVE MONTH NAME.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $MONAM        BEGSR
      *
     C                   MOVE      MONUMB        MONUMB            2
      *
     C                   SELECT
     C     MONUMB        WHENEQ    '01'
     C                   MOVE      'JAN'         MOUPR3            3
     C     MONUMB        WHENEQ    '02'
     C                   MOVE      'FEB'         MOUPR3
     C     MONUMB        WHENEQ    '03'
     C                   MOVE      'MAR'         MOUPR3
     C     MONUMB        WHENEQ    '04'
     C                   MOVE      'APR'         MOUPR3
     C     MONUMB        WHENEQ    '05'
     C                   MOVE      'MAY'         MOUPR3
     C     MONUMB        WHENEQ    '06'
     C                   MOVE      'JUN'         MOUPR3
     C     MONUMB        WHENEQ    '07'
     C                   MOVE      'JUL'         MOUPR3
     C     MONUMB        WHENEQ    '08'
     C                   MOVE      'AUG'         MOUPR3
     C     MONUMB        WHENEQ    '09'
     C                   MOVE      'SEP'         MOUPR3
     C     MONUMB        WHENEQ    '10'
     C                   MOVE      'OCT'         MOUPR3
     C     MONUMB        WHENEQ    '11'
     C                   MOVE      'NOV'         MOUPR3
     C     MONUMB        WHENEQ    '12'
     C                   MOVE      'DEC'         MOUPR3
     C                   OTHER
     C                   MOVE      *BLANKS       MOUPR3
     C                   MOVEL     MONUMB        MOUPR3
     C                   ENDSL
      *
     CSR   #MONAM        ENDSR
