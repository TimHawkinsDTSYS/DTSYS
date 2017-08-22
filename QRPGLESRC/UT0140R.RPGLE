      /TITLE Offset Dates
      *PARMS OPTION(*NOXREF) USRPRF(*OWNER)
      ************************************************************************
      *
      *   PROGRAM ID:    UT0140R
      *   PROGRAM TITLE: OFFSET DATES
      *   PROGRAMMER:    NOBI GAVIN
      *   CREATION DATE: 09/07/86
      *   REMARKS:       GIVEN A STARTING DATE 'OSFDT' AND A NUMBER OF
      *                   DAYS 'OFFSET', THIS PROGRAM WILL PASS BACK
      *                    AN ENDING DATE 'OSTDT'.
      *
      *   NOTE: OFFSET CAN BE POSITIVE OR NEGATIVE.
      *
      *
      *   REVISED:       02/03/88  BY N GAVIN
      *   REVISED DESC:                IF NEG OFSETD USE 365 INSTEAD
      *                                 OF DAZE
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
     D RYD             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND     REG. YEAR DAYS
     D LYD             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND     LEAP YEAR DAYS
      *
     D                 DS
     D  OSFDT                  1      6  0
     D  OSFYR                  1      2  0
     D  OSFMO                  3      4  0
     D  OSFDA                  5      6  0
     D  OSTDT                 10     15  0
     D  OSTYR                 10     11  0
     D  OSTMO                 12     13  0
     D  OSTDA                 14     15  0
      *
     C     *ENTRY        PLIST
     C                   PARM                    OSFDTE            6 0          I    (YMD)
     C                   PARM                    OSDAYS            3 0          I
     C                   PARM                    OSTDTE            6 0          O    (YMD)
     C                   PARM                    MSGID             7            I/O
     C                   PARM                    MSGDTA          256            I/O
      *
     C                   MOVE      OSFDTE        OSFDT
     C                   MOVE      OSFDTE        OSTDT
      *
     C     OSDAYS        IFNE      *ZERO                                        OFFSET DAYS
     C                   EXSR      $OFSET                                        *GT ZERO.
     C                   MOVE      OSTDT         OSTDTE
     C                   ELSE
     C                   MOVE      OSFDTE        OSTDTE                         OFFSET DAYS
     C                   ENDIF                                                   *EQ ZERO.
      *
     C                   RETURN
      /SPACE 3
      /COPY QCPYSRC,$CVTDD
      /SPACE 3
      /COPY QCPYSRC,$CVTDF
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * $OFSET - OFFSET DATE ROUTINE
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $OFSET        BEGSR
      *
     C     OSDAYS        IFGT      365
     C                   MOVE      365           OSDAYS
     C                   ENDIF
      *
     C     OSFMO         IFLE      *ZERO                                        DATE MM/DD/YY
     C     OSFMO         ORGT      12                                            IS NOT VALID.
     C                   MOVE      'GNL0010'     MSGID
     C                   MOVE      OSFDT         CVFDTE
     C                   EXSR      $CVTDD
     C                   MOVE      CVTDTE        WK060N            6 0
     C                   MOVE      WK060N        WK006A            6
     C                   MOVEL     WK006A        MSGDTA
     C                   GOTO      #OFSET
     C                   ENDIF
      *
     C                   Z-ADD     365           DAZE              3 0          SET UP
     C                   Z-ADD     OSFYR         OSTYR                           FOR
     C     RYD(OSFMO)    ADD       OSFDA         OFSETD            3 0           PROCESSING
     C                   ADD       OSDAYS        OFSETD
      *
     C     OSFYR         DIV       4             RSLT              3 0          CHECK FOR
     C                   MVR                     RMDR              3 0           LEAP YEAR
      *
     C     RMDR          IFEQ      *ZERO                                        HANDLE
     C                   ADD       1             DAZE                            LEAP YEAR
     C     OSFMO         IFGE      3
     C                   ADD       1             OFSETD
     C                   ENDIF
     C                   ENDIF
      *
     C     OFSETD        IFLT      1                                            NEGATIVE
     C                   SUB       1             OSTYR                           OFFSET
     C                   ADD       365           OFSETD                          DAYS
      *
     C     OSTYR         DIV       4             RSLT                           CHECK FOR
     C                   MVR                     RMDR                            LEAP YEAR
      *
     C     RMDR          IFEQ      *ZERO                                        IF LEAP
     C                   ADD       1             OFSETD                          YEAR
     C                   ENDIF                                                   ADD 1 TO
     C                   ELSE                                                    OFFSET DAYS
      *
     C     OFSETD        IFGT      DAZE                                         IF OFFSET
     C                   SUB       DAZE          OFSETD                          DAYS > 1 YR
     C                   ADD       1             OSTYR                           REDUCE DAYS
     C                   ENDIF                                                   INCREASE
     C                   ENDIF                                                    1 YEAR
      *
     C     OSTYR         DIV       4             RSLT                           CHECK FOR
     C                   MVR                     RMDR                            LEAP YEAR
      *
     C                   Z-ADD     1             OSTMO
     C     RMDR          IFEQ      *ZERO                                        YEAR IS A
     C     OFSETD        LOOKUP    LYD(OSTMO)                           30       LEAP YEAR
     C   30OFSETD        SUB       LYD(OSTMO)    OSTDA
     C                   ELSE
     C     OFSETD        LOOKUP    RYD(OSTMO)                           30
     C   30OFSETD        SUB       RYD(OSTMO)    OSTDA                          YEAR IS A
     C                   ENDIF                                                   REG. YEAR
      *
     CSR   #OFSET        ENDSR
      *
**    *  RYD - NUMBER OF DAYS TO BE ADDED FOR MONTH OF YEAR
000031059090120151181212243273304334
**    *  LYD - NUMBER OF DAYS TO BE ADDED FOR LEAP YEAR
000031060091121152182213244274305335
