      /TITLE Determine Day of Week
      *PARMS OPTION(*NOXREF) USRPRF(*OWNER)
      ************************************************************************
      *
      *   PROGRAM ID:    UT0120R
      *   PROGRAM TITLE: DETERMINE DAY OF WEEK
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
      *
      *   * * * * * * * * * * * * * * * * * * * * * * * * *
      *   *  Property of Travel Management Systems, Inc.  *
      *   *  873 Sutter Street                            *
      *   *  San Francisco, California  94109             *
      *   *                                               *
      *   *  Technical Support Center                     *
      *   *  1250 Oakmead Parkway, Suite 308              *
      *   *  Sunnyvale, California  94086                 *
      *   * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      ************************************************************************
      /EJECT
      *
      *
     D NUM             S              1  0 DIM(7) CTDATA PERRCD(7)              DAY #/DAY TEXT 9
     D DTX9            S              9    DIM(7) ALT(NUM)
     D DTX3            S              3    DIM(7) CTDATA PERRCD(7)              DAY TEXT 3
     D DTX2            S              2    DIM(7) CTDATA PERRCD(7)              DAY TEXT 2
      *
     D                 DS
     D  WEKDTE                 1      6  0
     D  WEKYR                  1      2  0
     D  WEKMO                  3      4  0
     D  WEKDA                  5      6  0
      *
      /EJECT
     C                   EXSR      $DAYWK
      *
     C                   RETURN
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  DAY OF WEEK.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DAYWK        BEGSR
      *
     C     WEKMO         IFLE      *ZERO                                        DATE MM/DD/YY
     C     WEKMO         ORGT      12                                            IS NOT VALID.
     C                   MOVE      'GNL0010'     MSGID
     C                   MOVE      WEKDTE        CVFDTE
     C                   EXSR      $CVTDD
     C                   MOVE      CVTDTE        WK060N
     C                   MOVE      WK060N        WK006A
     C                   MOVEL     WK006A        MSGDTA
     C                   GOTO      #DAYWK
     C                   ENDIF
      *
     C     WEKYR         ADD       1900          YEAR              4 0
     C     1             DIV       WEKMO         AA                2 1
     C                   ADD       .6            AA
     C                   MOVEL     AA            BB                1 0
     C     YEAR          SUB       BB            CC                4 0
     C     BB            MULT      12            DD                3 0
     C                   ADD       WEKMO         DD
     C     CC            DIV       100           EE                2 0
     C     EE            DIV       4             Z1                2 0
     C     EE            MULT      1             Z2                2 0
     C     CC            MULT      5             Z3                4 0
     C                   DIV       4             Z3                4 0
     C                   ADD       1             DD
     C     DD            MULT      13            Z4                3 0
     C     Z4            DIV       5             Z4
     C     Z4            ADD       Z3            ZZ                4 0
     C                   SUB       Z2            ZZ
     C                   ADD       Z1            ZZ
     C                   ADD       WEKDA         ZZ
     C                   SUB       1             ZZ
     C     ZZ            DIV       7             ZD                3 0
     C     ZD            MULT      7             ZX                4 0
     C     ZZ            SUB       ZX            ZY                1 0
     C     ZY            ADD       1             ZZZ               1 0
      *
     C                   Z-ADD     1             DAYNBR
     C     ZZZ           LOOKUP    NUM(DAYNBR)                            30
     C                   Z-ADD     DAYNBR        DAY               1 0
     C                   MOVE      DTX9(DAY)     DAYTX9
     C                   MOVE      DTX3(DAY)     DAYTX3
     C                   MOVE      DTX2(DAY)     DAYTX2
      *
     CSR   #DAYWK        ENDSR
      /SPACE 3
      /COPY QCPYSRC,$CVTDD
      /SPACE 3
      /COPY QCPYSRC,$CVTDF
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *   INITIALIZE PROGRAM
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   CLEAR                   WK060N            6 0
     C                   CLEAR                   WK006A            6
      *
     C     *ENTRY        PLIST                                                  DAYWEEK
     C     WEKDTE        PARM                    WEKDAT            6 0          I    (YMD)
     C                   PARM                    DAYNBR            1 0          O
     C                   PARM                    DAYTX9            9            O
     C                   PARM                    DAYTX3            3            O
     C                   PARM                    DAYTX2            2            O
     C                   PARM                    MSGID             7            I/O
     C                   PARM                    MSGDTA          256            I/O
      *
     CSR   #INZSR        ENDSR
      *
**    * DNUM/DTX9 - DAY NUMBER/DAY TEXT
1Sunday   2Monday   3Tuesday  4Wednesday5Thursday 6Friday   7Saturday
**    * DTX3 - DAYS TEXT
SunMonTueWedThuFriSat
**    * DTX2 - DAYS TEXT
SuMoTuWeThFrSa
