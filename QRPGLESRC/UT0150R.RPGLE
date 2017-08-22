      /TITLE Determine Days in Month
      *PARMS OPTION(*NOXREF) USRPRF(*OWNER)
      ************************************************************************
      *
      *   PROGRAMMER:    TIM HAWKINS
      *   CREATION DATE: 11/28/87
      *   REMARKS:       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *                   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      *   REVISED:       MM/DD/YY  BY XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *   REVISED DESC:                XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *                                 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *                                  XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      ************************************************************************
      /EJECT
      *
      *
     D RYR             S              2  0 DIM(12) CTDATA PERRCD(12)            # OF DAYS, REG
     D LYR             S              2  0 DIM(12) CTDATA PERRCD(12)            # OF DAYS, LEAP
     D MTX9            S              9    DIM(12) CTDATA PERRCD(1)             MONTH TEXT
      *
      /EJECT
     C                   EXSR      $DAYMO
      *
     C                   RETURN
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  DETERMINE DAYS IN MONTH.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DAYMO        BEGSR
      *
     C     MONMO         IFLE      *ZERO                                        MONTH MM
     C     MONMO         ORGT      12                                            IS NOT VALID.
     C                   MOVE      'GNL0049'     MSGID
     C                   MOVEL     MONMO         MSGDTA
     C                   GOTO      #DAYMO
     C                   ENDIF
      *
     C     MONYR         DIV       4             RSLT              5 0          LEAP
     C                   MVR                     RMDR              3 0           YEAR.
      *
     C     RMDR          IFNE      *ZERO                                        REGULAR
     C                   Z-ADD     RYR(MONMO)    MONDAY                          YEAR.
     C                   ELSE                                                   LEAP
     C                   Z-ADD     LYR(MONMO)    MONDAY                          YEAR.
     C                   ENDIF
      *
     C                   MOVE      MONMO         X                 3 0
     C                   MOVE      MTX9(X)       MONTX9
     C                   MOVE      MTX9(X)       MONTX9
     C                   MOVEL     MONTX9        MONTX3
      *
     CSR   #DAYMO        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *   INITIALIZE PROGRAM
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    MONYR             2 0
     C                   PARM                    MONMO             2 0
     C                   PARM                    MONDAY            2 0
     C                   PARM                    MONTX9            9
     C                   PARM                    MONTX3            3
     C                   PARM                    MSGID             7
     C                   PARM                    MSGDTA          256
      *
     CSR   #INZSR        ENDSR
      *
**    *  RYR - NUMBER OF DAYS IN MONTH, REGULAR YEAR
312831303130313130313031
**    *  LYR - NUMBER OF DAYS IN MONTH, LEAP YEAR
312931303130313130313031
**    * MNO/MTX9 - MONTH NUMBER/MONTH TEXT
January
Febuary
March
April
May
June
July
August
September
October
November
December
