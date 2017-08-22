      /TITLE Determine Days Since 1900
      *PARMS OPTION(*NOXREF) USRPRF(*OWNER)
      ************************************************************************
      *
      *   PROGRAM ID:    UT0110R
      *   PROGRAM TITLE: DETERMINE DAYS SINCE 1900
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
     D RYC             S              3  0 DIM(13) CTDATA PERRCD(13) ASCEND     REG. YR CUM DY
     D LYC             S              3  0 DIM(13) CTDATA PERRCD(13) ASCEND     LEAP YR CUM DY
      *
     D                 DS
     D  DTE                    1      6  0
     D  DTEYR                  1      2  0
     D  DTEMO                  3      4  0
     D  DTEDA                  5      6  0
      *
      /EJECT
     C                   MOVE      D1900         DTE
     C                   EXSR      $D1900
      *
     C                   RETURN
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  DAYS SINCE 1900.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $D1900        BEGSR
      *
     C     DTEMO         IFLE      *ZERO                                        DATE MM/DD/YY
     C     DTEMO         ORGT      12                                            IS NOT VALID.
     C                   MOVE      'GNL0010'     MSGID
     C                   MOVE      DTE           CVFDTE
     C                   EXSR      $CVTDD
     C                   MOVE      CVTDTE        WK060N
     C                   MOVE      WK060N        WK006A
     C                   MOVEL     WK006A        MSGDTA
     C                   GOTO      #D1900
     C                   ENDIF
      *
     C     DTEYR         SUB       1             PYEAR
     C     PYEAR         MULT      365           NBRDYS
      *
     C     PYEAR         DIV       4             RSLT              3 0          CHECK FOR
     C                   MVR                     RMDR              3 0           LEAP YEAR.
     C                   ADD       RSLT          NBRDYS
     C                   ADD       31            NBRDYS
     C     RMDR          IFEQ      *ZERO
     C                   ADD       LYC(12)       NBRDYS
     C                   ELSE
     C                   ADD       RYC(12)       NBRDYS
     C                   ENDIF
      *
     C     DTEYR         DIV       4             RSLT                           CHECK FOR
     C                   MVR                     RMDR                            LEAP YEAR.
      *
     C     RMDR          IFEQ      *ZERO
     C                   ADD       LYC(DTEMO)    NBRDYS
     C                   ELSE
     C                   ADD       RYC(DTEMO)    NBRDYS
     C                   ENDIF
      *
     C                   ADD       DTEDA         NBRDYS
      *
     CSR   #D1900        ENDSR
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
     C     *LIKE         DEFINE    DTEYR         PYEAR
      *
     C                   CLEAR                   WK030N            3 0
     C                   CLEAR                   WK060N            6 0
     C                   CLEAR                   WK006A            6
      *
     C     *ENTRY        PLIST                                                  UT0110R
     C                   PARM                    D1900             6 0          I    (YMD)
     C                   PARM                    NBRDYS            5 0          O
     C                   PARM                    MSGID             7            I/O
     C                   PARM                    MSGDTA          256            I/O
      *
     CSR   #INZSR        ENDSR
      *
**    *  RYC - NUMBER OF DAYS TO BE ADDED FOR MONTH OF YEAR
000031059090120151181212243273304334365
**    *  LYC - NUMBER OF DAYS TO BE ADDED FOR LEAP YEAR
000031060091121152182213244274305335366
