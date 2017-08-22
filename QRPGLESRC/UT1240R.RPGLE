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
     FFILE      IF   F  256        DISK    USROPN
      *
     D CMD             S             80    DIM(6) CTDATA PERRCD(1)              Commands
      *
     IFILE      NS
     I                                  1  256  FILDTA
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
     C                   EXSR      $OVRDB
     C                   CALL      'QCMDEXC'                                    OVRDBF
     C                   PARM                    WK256A
     C                   PARM      256           CMDLEN           15 5
      *
     C                   CALL      'QCMDEXC'                                    CHGJOB
     C                   PARM                    CMD(3)
     C                   PARM      80            CMDLEN
      *
     C                   CLEAR                   WK256A
     C                   MOVEL     CMD(4)        WK256A
     C     WK256A        CAT       OQSLCT:1      WK256A
     C                   CALL      'QCMDEXC'                                    QPNQRYF
     C                   PARM                    WK256A
     C                   PARM      256           CMDLEN
      *
     C                   OPEN      FILE                                         READ
     C                   READ      FILE                                   99     RECORD.
     C                   CLOSE     FILE
      *
     C     *IN99         IFEQ      *OFF
     C                   MOVE      *ON           OQREAD
     C                   ELSE
     C                   MOVE      *OFF          OQREAD
     C                   ENDIF
      *
     C                   CALL      'QCMDEXC'                                    CLOF
     C                   PARM                    CMD(5)
     C                   PARM      80            CMDLEN
      *
     C                   CALL      'QCMDEXC'                                    CHGJOB
     C                   PARM                    CMD(6)
     C                   PARM      80            CMDLEN
      *
     CSR   #OQSLT        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *   BUILD OVERRIDE DATABASE FILE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $OVRDB        BEGSR
      *
     C                   CLEAR                   WK256A          256
     C                   MOVEL     CMD(1)        WK256A
     C     WK256A        CAT       OQLBNM:0      WK256A
     C     WK256A        CAT       '/':0         WK256A
     C     WK256A        CAT       OQOBNM:0      WK256A
     C     WK256A        CAT       ') MBR(':0    WK256A
     C     WK256A        CAT       OQMBNM:0      WK256A
     C     WK256A        CAT       CMD(2):0      WK256A
      *
     CSR   #OVRDB        ENDSR
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
     C     *ENTRY        PLIST
     C                   PARM                    OQOBNM           10            FILE NAME
     C                   PARM                    OQLBNM           10            LIBRARY NAME
     C                   PARM                    OQMBNM           10            MEMBER NAME
     C                   PARM                    OQSLCT          256            SELECT STRING
     C                   PARM                    OQREAD            1            1=READ, 0=EOF
      *
     C                   CLEAR                   X                 3 0
      *
     CSR   #DEFN         ENDSR
**
OVRDBF  FILE(FILE) TOFILE(
) SHARE(*YES)
CHGJOB  STSMSG(*NONE)
OPNQRYF FILE(FILE) OPTIMIZE(*FIRSTIO) TYPE(*PERM)
CLOF    OPNID(FILE)
CHGJOB  STSMSG(*USRPRF)
