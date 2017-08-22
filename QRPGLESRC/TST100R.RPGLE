      /TITLE Test CL vs RPG call
      *
      * P: PARMS OPTION(*NOXREF) USRPRF(*OWNER) AUT(*ALL)
      *
      * S:
      *
      * C: T.HAWKINS   07/08/93
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * M: MODIFICATIONS --
      *
      * M: YY/MM/DD  PROGRAMMER  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
     FQSYSPRT   O    F  132        PRINTER
      *
      /SPACE 3
     C                   MOVE      UDATE         CURDTE            6
     C                   EXSR      $CL
     C                   EXSR      $RPG
      *
     C                   MOVE      *ON           *INLR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DETERMINE CL PROGRAM OVERHEAD (TAATOOL)
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CL           BEGSR
      *
     C                   TIME                    UTIME             6 0
     C                   EXCEPT    #CLP01
      *
     C                   DO        1000
     C                   CALL      'RTVDATCL'
     C                   PARM      CURDTE        MDYDAT            6
     C                   PARM                    DAYYR             3
     C                   ENDDO
      *
     C                   TIME                    UTIME
     C                   EXCEPT    #CLP02
      *
     CSR   #CL           ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DETERMINE RPG PROGRAM OVERHEAD (TAATOOL)
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $RPG          BEGSR
      *
     C                   TIME                    UTIME
     C                   EXCEPT    #RPG01
      *
     C                   DO        1000
     C                   CALL      'X0028   '
     C                   PARM      CURDTE        #SIDAT            6
     C                   PARM      *BLANKS       #EDAT             8
     C                   PARM      '*MDY'        #FFMT             7
     C                   PARM      '*JUL'        #TFMT             7
     C                   PARM      '*NONE'       #SEP              7
     C                   PARM      *BLANKS       $ERTST            1
     C                   MOVEL     #EDAT         WK005A            5
     C                   MOVE      WK005A        DAYYR
     C                   ENDDO
      *
     C                   TIME                    UTIME
     C                   EXCEPT    #RPG02
      *
     CSR   #RPG          ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     CSR   #DEFN         ENDSR
      *
     OQSYSPRT   E            #CLP01         1
     O                                         +  0 'BEGIN CLP:'
     O                       UTIME             +  1 '  :  :  '
      *
     OQSYSPRT   E            #CLP02         2
     O                                         +  0 'END   CLP:'
     O                       UTIME             +  1 '  :  :  '
      *
     OQSYSPRT   E            #RPG01         1
     O                                         +  0 'BEGIN RPG:'
     O                       UTIME             +  1 '  :  :  '
      *
     OQSYSPRT   E            #RPG02         1
     O                                         +  0 'END   RPG:'
     O                       UTIME             +  1 '  :  :  '
