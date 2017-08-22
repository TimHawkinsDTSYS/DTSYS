      /TITLE Edit Variable
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
      *   * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      ************************************************************************
      *
      /copy qcpysrc,Hspec
      *
     D AY2             S              1    DIM(22)                              WORK ARRAY 2
      *
      /copy qcpysrc,Dspec
      *
     C                   EXSR      $EDIT
     C                   EXSR      $EDVAR
      *
     C                   RETURN
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  EDIT FOR ERRORS.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $EDIT         BEGSR
      *
     C     PLedtcde      IFEQ      'W'                                          CANNOT HAVE
     C     PLedtcde      OREQ      'Y'                                           ANY DECIMALS.
     C     PLedtcde      OREQ      'Z'
     C     PLnbrdec      IFNE      *ZERO
     C                   MOVE      'GNL0063'     MSGID
     C                   MOVE      ZZPGM         TOPGM
     C                   MOVEL     '*PRV'        TOREL
     C                   EXSR      $PMSND
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
     C     PLedtcde      IFEQ      'K'
     C     PLedtcde      OREQ      'M'
     C     PLedtcde      OREQ      'O'
     C     PLedtcde      OREQ      'Q'
     C     PLedtcde      OREQ      'Z'
     C     NUMINP        IFEQ      *ZERO
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
     CSR   #EDIT         ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  EDIT VARIABLE.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $EDVAR        BEGSR
      *
     C                   CLEAR                   NUMINC
     C                   CLEAR                   CHRVAR
     C                   MOVE      *OFF          PRTSW
     C                   Z-ADD     1             X
     C     PLnbrdec      ADD       1             Z
     C                   MOVE      NUMINP        NUMIN2
      *
     C     NUMINP        IFLT      *ZERO
     C                   Z-SUB     NUMINP        NUMIN2
     C                   ENDIF
      *
     C                   MOVE      NUMIN2        NUMINC
      *
     C     LDGSYM        IFEQ      '*YES'
     C                   CAT       CURSYM:0      CHRVAR
     C                   ENDIF
      *
     C     NUMINP        IFLT      *ZERO
     C     PLedtcde      IFEQ      'N'
     C     PLedtcde      OREQ      'O'
     C     PLedtcde      OREQ      'P'
     C     PLedtcde      OREQ      'Q'
     C                   CAT       '-':0         CHRVAR
     C                   ENDIF
     C                   ENDIF
      *
     C     X             DOUEQ     DEC_LEN_1
     C     DEC_LEN_1     SUB       X             WK030N
     C     WK030N        IFEQ      PLnbrdec
     C                   CAT       DECCHR:0      CHRVAR
     C                   MOVE      *ON           PRTSW
     C                   ENDIF
      *
     C     Z             IFEQ      25
     C     PLedtcde      IFEQ      'W'
     C     PLedtcde      OREQ      'Y'
     C                   MOVE      *ON           PRTSW
     C                   ENDIF
     C                   ENDIF
      *
     C                   SUBST     NUMINC:X      WK001A
     C     PRTSW         IFEQ      *ON
     C     WK001A        ORNE      '0'
     C                   CAT       WK001A:0      CHRVAR
     C                   MOVE      *ON           PRTSW
      *
     C     PLedtcde      IFEQ      'J'
     C     PLedtcde      OREQ      'K'
     C     PLedtcde      OREQ      'N'
     C     PLedtcde      OREQ      'O'
     C     Z             IFEQ      18
     C     Z             OREQ      21
     C     Z             OREQ      24
     C     Z             OREQ      27
     C                   CAT       SEPCHR:0      CHRVAR
     C                   ENDIF
     C                   ENDIF
      *
     C     Z             IFEQ      26
     C     Z             OREQ      28
     C     PLedtcde      IFEQ      'W'
     C                   CAT       ':':0         CHRVAR
     C                   ENDIF
     C     PLedtcde      IFEQ      'Y'
     C                   CAT       '/':0         CHRVAR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ADD       1             Z
     C                   ADD       1             X
      *
     C     X             IFEQ      DEC_LEN
     C                   MOVE      *ON           PRTSW
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     NUMINP        IFLT      *ZERO
     C     PLedtcde      IFEQ      'J'
     C     PLedtcde      OREQ      'K'
     C     PLedtcde      OREQ      'L'
     C     PLedtcde      OREQ      'M'
     C                   CAT       '-':0         CHRVAR
     C                   ENDIF
     C                   ENDIF
      *
     CSR   #EDVAR        ENDSR
      /SPACE 4
      /COPY QCPYSRC,$PMSND
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *   INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   MOVE      '$'           CURSYM            1
     C                   MOVE      '.'           DECCHR            1
     C                   MOVE      ','           SEPCHR            1
     C                   CLEAR                   WK030N            3 0
     C                   CLEAR                   WK001A            1
      *
     C                   EVAL      DEC_LEN   = 30
     C                   EVAL      DEC_LEN_1 = 31
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *   DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    CHRVAR           22
     C                   PARM                    NUMINP           30 0
     C                   PARM                    PLnbrdec          1 0
     C                   PARM                    PLedtcde          1
     C                   PARM                    LDGSYM            4
      *
     C                   CLEAR                   WK030N            3 0
     C                   CLEAR                   NUMIN2           30 0
     C                   CLEAR                   NUMINC           30
     C                   CLEAR                   DEC_LEN           5 0
     C                   CLEAR                   DEC_LEN_1         5 0
     C                   MOVE      *OFF          PRTSW             1
     C                   CLEAR                   X                 3 0
     C                   CLEAR                   Y                 3 0
     C                   CLEAR                   Z                 3 0
      *
     CSR   #DEFN         ENDSR
