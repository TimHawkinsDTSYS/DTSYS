      /TITLE Utility, UnParse Values
      *PARMS OPTION(*NOXREF) USRPRF(*OWNER)
      ************************************************************************
      *
      *   PROGRAMMER:    TIM HAWKINS
      *   CREATION DATE: 01/01/89
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
      *   *  Property of Bogar Incorporated               *
      *   *  18800 Cox Avenue                             *
      *   *  Saratoga, California  95070                  *
      *   *                                               *
      *   *                                               *
      *   *                                               *
      *   *                                               *
      *   *                                               *
      *   * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *
      ************************************************************************
      /EJECT
      *
     D PAR             S            128    DIM(128)                             PARSED ENTRIES
      *
     D PGMDS         ESDS                  EXTNAME(DSPGM)
      /EJECT
      *
     C                   EXSR      $UNPAR
      *
     C                   RETURN
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * UNPARSE VALUE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $UNPAR        BEGSR
      *
     C                   Z-ADD     1             Y
     C                   CLEAR                   PAR
     C                   MOVE      *OFF          LODENT            1
      *
     C                   DO        256           X
     C                   SUBST(P)  PARVAL:X      WK256A          256
     C     WK256A        IFEQ      *BLANKS
     C                   LEAVE
     C                   ENDIF
      *
     C                   SUBST     PARVAL:X      WK001A            1
      *
     C     WK001A        IFNE      *BLANKS
     C     WK001A        ANDNE     ','
     C     WK001A        ANDNE     '/'
     C                   MOVE      *ON           LODENT
     C                   CAT       WK001A:0      PAR(Y)
     C                   ELSE
     C     LODENT        IFEQ      *ON
     C     WK001A        IFEQ      *BLANKS
     C     WK001A        OREQ      ','
     C     WK001A        OREQ      '/'
     C                   MOVE      *OFF          LODENT
     C                   ADD       1             Y
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
      *
     CSR   #UNPAR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  INITIALIZE PROGRAM VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   CLEAR                   X                 5 0
     C                   CLEAR                   Y                 5 0
      *
     C     *ENTRY        PLIST                                                  UnParse Value
     C                   PARM                    PARVAL          256            Value for parsing
     C                   PARM                    PAR                            Array of values
      *
     CSR   #INZSR        ENDSR
