      /TITLE Open Query File with Select
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
      *
     D CMD             S             80    DIM(3) CTDATA PERRCD(1)              Commands
      *
     C                   EXSR      $OQSLT
      *
     C                   RETURN
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  OPEN QUERY FILE SELECT.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $OQSLT        BEGSR
      *
     C                   MOVEA     CMD           OQSLCT                         SELECT STRING
      *
     C                   CALL      'UT1240R'                            95
     C                   PARM      'BKGMAP01'    OQOBNM           10            FILE NAME
     C                   PARM      '*LIBL'       OQLBNM           10            LIBRARY NAME
     C                   PARM      '*FIRST'      OQMBNM           10            MEMBER NAME
     C                   PARM                    OQSLCT          256            SELECT STRING
     C                   PARM      *OFF          OQREAD            1            1=READ, 0=EOF
      *
     CSR   #OQSLT        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *   INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *   DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     CSR   #DEFN         ENDSR
**
QRYSLT('BMBKGN *EQ 50268 *AND (BMGTYP *EQ "F" *OR BMTDUE *LE 2.00)')


