      /TITLE Concatenate Query Select
      *PARMS OPTION(*NOXREF) USRPRF(*OWNER)
      ************************************************************************
      *
      *   PROGRAMMER:    TIM HAWKINS
      *   CREATION DATE: MM/DD/YY
      *   REMARKS:       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *                   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      *   CALLED BY:     XX9999X - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      *   REVISED:       MM/DD/YY  BY XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *   REVISED DESC:                XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *                                 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *                                  XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
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
      ************************************************************************
      /EJECT
      *
     D QRYSLT          DS           512
      *
     C                   EXSR      $QRYSL
      *
     C                   RETURN
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  CONCATENATE QUERY SELECT.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $QRYSL        BEGSR
      *
     C     QRYSLT        IFNE      *BLANKS
     C     QSREL         ANDNE     *BLANKS
     C     QRYSLT        CAT       QSREL:1       QRYSLT                         RELATIONSHIP
     C                   ENDIF
      *
     C     QSFLD         IFNE      *BLANKS
     C     QRYSLT        CAT       QSFLD:1       QRYSLT                         FIELD NAMES
     C                   ENDIF
      *
     C     QSVAL         IFNE      *BLANKS
     C     QRYSLT        CAT       QSVAL:0       QRYSLT                         VALUE(S)
     C                   ENDIF
      *
     C     QSQUO         IFEQ      *ON
     C     QRYSLT        CAT       '"':0         QRYSLT                         ENDING QUOTE
     C                   ENDIF
      *
     C     QSPAR         IFEQ      *ON
     C     QRYSLT        CAT       ')':0         QRYSLT                         ENDING PAREN
     C                   ENDIF
      *
     CSR   #QRYSL        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   CLEAR                   X                 3 0
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM      *OFF          QSQUO             1             ENDING QUOTE
     C                   PARM      *OFF          QSPAR             1             ENDING PAREN
     C                   PARM      *BLANKS       QSREL            50             REL *AND/*OR
     C                   PARM      *BLANKS       QSFLD            80             FIELD
     C                   PARM      *BLANKS       QSVAL           256             VALUE(S)
     C                   PARM                    QRYSLT                          RESULTANT STRING
      *
     CSR   #DEFN         ENDSR
