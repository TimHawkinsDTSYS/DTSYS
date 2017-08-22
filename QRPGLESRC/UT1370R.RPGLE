      /TITLE Utility, Concatenate with Length limit
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
     C     ENDPOS        DOULE     LENLMT
     C     ' '           CHECKR    CATVAL        ENDPOS            5 0
      *
     C     ENDPOS        IFGT      LENLMT
     C     DLIMIT        SCAN      CATVAL        STR               5 0
     C                   ADD       1             STR
     C                   SUBST(P)  CATVAL:STR    WK256A          256
     C                   MOVE      WK256A        CATVAL
     C                   ENDIF
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
     C     *ENTRY        PLIST                                                  Cat with LenLmt
     C                   PARM                    CATVAL          256            Concatenated val
     C                   PARM                    DLIMIT            1            Delimiter
     C                   PARM                    LENLMT            5 0          Result len limit
      *
     CSR   #INZSR        ENDSR
