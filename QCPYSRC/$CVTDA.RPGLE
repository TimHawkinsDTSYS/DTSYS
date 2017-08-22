      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  CONVERT DATE TO AIRLINE FORMAT.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CVTDA        BEGSR
      *
     C                   MOVE      *BLANKS       CVTDAT            7
     C     CVFDTE        IFEQ      *ZERO
     C                   GOTO      #CVTDA
     C                   ENDIF
      *
     C                   MOVE      CVFDTE        WK004A            4
     C                   MOVE      WK004A        WK002A            2            DAY
     C                   MOVEL     WK002A        CVTDAT                         "DD     "
     C                   MOVEL     WK004A        WK002A                         MONTH
      *
     C                   SELECT
     C     WK002A        WHENEQ    '01'
     C                   CAT       'JAN':0       CVTDAT                         "DDMMM  "
     C     WK002A        WHENEQ    '02'
     C                   CAT       'FEB':0       CVTDAT                         "DDMMM  "
     C     WK002A        WHENEQ    '03'
     C                   CAT       'MAR':0       CVTDAT                         "DDMMM  "
     C     WK002A        WHENEQ    '04'
     C                   CAT       'APR':0       CVTDAT                         "DDMMM  "
     C     WK002A        WHENEQ    '05'
     C                   CAT       'MAY':0       CVTDAT                         "DDMMM  "
     C     WK002A        WHENEQ    '06'
     C                   CAT       'JUN':0       CVTDAT                         "DDMMM  "
     C     WK002A        WHENEQ    '07'
     C                   CAT       'JUL':0       CVTDAT                         "DDMMM  "
     C     WK002A        WHENEQ    '08'
     C                   CAT       'AUG':0       CVTDAT                         "DDMMM  "
     C     WK002A        WHENEQ    '09'
     C                   CAT       'SEP':0       CVTDAT                         "DDMMM  "
     C     WK002A        WHENEQ    '10'
     C                   CAT       'OCT':0       CVTDAT                         "DDMMM  "
     C     WK002A        WHENEQ    '11'
     C                   CAT       'NOV':0       CVTDAT                         "DDMMM  "
     C     WK002A        WHENEQ    '12'
     C                   CAT       'DEC':0       CVTDAT                         "DDMMM  "
     C                   ENDSL
      *
     C                   MOVEL     CVFDTE        WK002A                         YEAR
     C                   MOVE      WK002A        CVTDAT                         "DDMMMYY"
     C                   MOVE      *BLANKS       CVFDTE            6
      *
     CSR   #CVTDA        ENDSR
