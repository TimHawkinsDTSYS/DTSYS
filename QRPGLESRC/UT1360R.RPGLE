      /TITLE Utility, Concatenate Values
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
     C                   EXSR      $CAT
      *
     C                   RETURN
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * CONCATENATE VALUES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CAT          BEGSR
      *
     C                   CLEAR                   CATVAL
      *
     C                   DO        128           X
     C     PAR(X)        IFEQ      *BLANKS
     C                   LEAVE
     C                   ENDIF
      *
     C     CATVAL        IFNE      *BLANKS
     C                   CAT       DLIMIT:0      CATVAL
     C                   ENDIF
      *
     C                   CAT       PAR(X):0      CATVAL
     C                   ENDDO
      *
     CSR   #CAT          ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  INITIALIZE PROGRAM VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   CLEAR                   X                 5 0
     C                   CLEAR                   Y                 5 0
      *
     C     *ENTRY        PLIST                                                  Concatenante val
     C                   PARM                    PAR                            Array of values
     C                   PARM                    DLIMIT            1            Delimiter
     C                   PARM                    CATVAL          256            Concatenated val
      *
     CSR   #INZSR        ENDSR
