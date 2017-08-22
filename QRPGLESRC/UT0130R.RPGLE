      /TITLE Date Edit
      *PARMS OPTION(*NOXREF) USRPRF(*OWNER)
      *****************************************************************
      *
      *   PROGRAM ID:    UT0130R
      *   PROGRAM TITLE: DATE EDIT
      *   PROGRAMMER:    TIM HAWKINS
      *   CREATION DATE: MM/DD/YY
      *   REMARKS:       EDITS A DATE IN THE FORMAT OF 'YYMMDD' &
      *                   & CALCULATES THE NUMBER OF DAYS FROM 1900.
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
     D RYR             S              2  0 DIM(12) CTDATA PERRCD(12)            # OF DAYS, REG
     D LYR             S              2  0 DIM(12) CTDATA PERRCD(12)            # OF DAYS, LEAP
     D RYD             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND     REG. YEAR DAYS
     D LYD             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND     LEAP YEAR DAYS
      *
     D                 DS
     D  DTEEDT                 1      6  0
     D  YEAR                   1      2  0
     D  MONTH                  3      4  0
     D  DAY                    5      6  0
      *
      /EJECT
     C                   MOVE      DTE           DTEEDT
     C                   CLEAR                   MSGID
      *
     C                   EXSR      $DTEED
      *
     C                   RETURN
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  DATE EDIT.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DTEED        BEGSR
      *
     C     YEAR          DIV       4             RSLT              5 0          LEAP
     C                   MVR                     RMDR              3 0           YEAR.
      *
     C     YEAR          IFLT      80                                           YEAR
     C                   MOVE      'GNL0010'     MSGID
     C                   GOTO      #DTEED
     C                   ENDIF
      *
     C     MONTH         IFLE      *ZERO                                        MONTH
     C     MONTH         ORGT      12
     C                   MOVE      'GNL0010'     MSGID
     C                   GOTO      #DTEED
     C                   ENDIF
      *
     C     RMDR          IFNE      *ZERO                                           (REG YEAR
     C     DAY           IFLE      *ZERO                                        DAY
     C     DAY           ORGT      RYR(MONTH)
     C                   MOVE      'GNL0010'     MSGID
     C                   GOTO      #DTEED
     C                   ENDIF
     C                   ELSE                                                      (LEAP YEAR
     C     DAY           IFLE      *ZERO                                        DAY
     C     DAY           ORGT      LYR(MONTH)
     C                   MOVE      'GNL0010'     MSGID
     C                   GOTO      #DTEED
     C                   ENDIF
     C                   ENDIF
      *
     C     RMDR          IFNE      *ZERO                                        REGULAR
     C                   Z-ADD     RYD(MONTH)    DAYS              3 0           YEAR.
     C                   ELSE                                                   LEAP
     C                   Z-ADD     LYD(MONTH)    DAYS                            YEAR.
     C                   ENDIF
      *
     C     YEAR          MULT      365.25        DTEDYS
     C                   ADD       DAYS          DTEDYS
     C                   ADD       DAY           DTEDYS
      *
     C     #DTEED        TAG
     C     MSGID         IFEQ      'GNL0010'
     C                   MOVE      DTEEDT        CVFDTE
     C                   EXSR      $CVTDD
     C                   MOVE      CVTDTE        WK060N
     C                   MOVE      WK060N        WK006A
     C                   MOVEL     WK006A        MSGDTA
     C                   ENDIF
      *
     CSR                 ENDSR
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
     C                   CLEAR                   WK006A            6
     C                   CLEAR                   WK060N            6 0
      *
     C     *ENTRY        PLIST
     C                   PARM                    DTE               6 0          I    (YMD)
     C                   PARM                    DTEDYS            9 2          O
     C                   PARM                    MSGID             7            I/O
     C                   PARM                    MSGDTA          256            I/O
      *
     CSR   #INZSR        ENDSR
      *
**    *  RYR - NUMBER OF DAYS IN MONTH, REGULAR YEAR
312831303130313130313031
**    *  LYR - NUMBER OF DAYS IN MONTH, LEAP YEAR
312931303130313130313031
**    *  RYD - NUMBER OF DAYS IN A REGULAR YEAR
000031059090120151181212243273304334
**    *  LYD - NUMBER OF DAYS IN A LEAP YEAR
000031060091121152182213244274305335
